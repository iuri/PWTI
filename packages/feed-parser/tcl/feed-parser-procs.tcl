ad_library {
    The procs that make up our Feed Parser.
    
    @creation-date 2003-12-28
    @author Guan Yang (guan@unicast.org)
    @author Simon Carstensen (simon@bcuni.net)
}

namespace eval feed_parser {}

ad_proc -public feed_parser::http_get_xml {
    {-max_redirect 4}
    -url:required
    {-headers ""}
} {
    Retrieves a document through HTTP GET in a way that's useful
    for RSS feeds. Tries to preserve encoding.
    
    @author Guan Yang (guan@unicast.org)
    @creation-date 2004-05-30
} {
    package require http
    ::http::config -accept "text/xml, application/xml, application/rss+xml, application/atom+xml, application/rss, application/atom" -useragent "OpenACS"
    set http [::http::geturl $url -headers $headers]
}

ad_proc -public feed_parser::sort_result {
    {-result:required}
} {
    @author Simon Carstensen
} {
    set sorted [list]
    for {set i 0} {$i < [llength $result]} {incr i} {
	lappend sorted [lindex $result end-$i]
    }
    return $sorted
}

ad_proc -private feed_parser::items_fetch {
    {-doc_node:required}
} {
    Takes a tDOM document node which is supposed to be some
    form of RSS. Returns a list with the item nodes. Returns
    an empty list if none could be found.

    @author Guan Yang (guan@unicast.org)
    @creation-date 2003-07-03
} {
    set items [$doc_node selectNodes {//*[local-name()='item' or local-name()='entry']}]
    return $items
}

ad_proc -private feed_parser::item_parse {
    {-item_node:required}
} {
    Takes a tDOM node which is supposed to represent an RSS item,
    and returns a list with the RSS/RDF elements of that node.

    @author Simon Carstensen
    @author Guan Yang (guan@unicast.org)
} {
    set title ""
    set link ""
    set guid ""
    set permalink_p false
    set description ""
    set content_encoded ""
    set comments ""
    set author ""

    feed_parser::dom::set_child_text -node $item_node -child title
    feed_parser::dom::set_child_text -node $item_node -child link
    feed_parser::dom::set_child_text -node $item_node -child guid
    feed_parser::dom::set_child_text -node $item_node -child description
    feed_parser::dom::set_child_text -node $item_node -child comments
    feed_parser::dom::set_child_text -node $item_node -child author
    feed_parser::dom::set_child_text -node $item_node -child pubDate
    
    set pub_date_rfc822 $pubDate
    feed_parser::dom::set_child_text -node $item_node -child pubDate
    if { $pub_date_rfc822 eq "" || 
         [catch {set pub_date [clock scan $pub_date_rfc822]}] } {
        set pub_date {}
    } 
        
    set maybe_atom_p 0
    
    # Try to handle Atom link
    if { [string equal $link ""] } {
        set link_attr [$item_node selectNodes {*[local-name()='link']/@href}]
        if { [llength $link_attr] == 1 } {
            set link [lindex [lindex $link_attr 0] 1]
            set maybe_atom_p 1
        }
    }

    set encoded_nodes [$item_node selectNodes {*[local-name()='encoded' and namespace-uri()='http://purl.org/rss/1.0/modules/content/']}]
    if { [llength $encoded_nodes] == 1 } {
        set encoded_node [lindex $encoded_nodes 0]
	    set content_encoded [$encoded_node text]
    }

    if { [llength [$item_node selectNodes "*\[local-name()='guid'\]"]] } {
        # If guid exists, we assume that it's a permalink
        set permalink_p true
    }

    # Retrieve isPermaLink attribute
    set isPermaLink_nodes [$item_node selectNodes "*\[local-name()='guid'\]/@isPermaLink"]
    if { [llength isPermaLink_nodes] == 1} {
        set isPermaLink_node [lindex $isPermaLink_nodes 0]
    	set isPermaLink [lindex $isPermaLink_node 1]
	if { [string equal $isPermaLink false] } {
	    set permalink_p false
	}
    }

    if { [empty_string_p $link] } {
        if { [exists_and_not_null guid] } {
            set link $guid
            set permalink_p true
        } elseif { [empty_string_p $guid] && ![string equal $link $guid] } {
            set permalink_p true
        }
    }
    
    # Try to handle Atom guid
    if { [empty_string_p $guid] && $maybe_atom_p } {
        feed_parser::dom::set_child_text -node $item_node -child id
        if { [info exists id] } {
            # We don't really know if it's an URL
            set guid $id
            if { [util_url_valid_p $id] } {
                set permalink_p true
            } else {
                set permalink_p false
            }
        }
    }
    
    # For Atom, description is summary, content is content_encoded
    if { $maybe_atom_p } {
        feed_parser::dom::set_child_text -node $item_node -child summary
        if { [info exists summary] } {
            set description $summary
        }
        
        feed_parser::dom::set_child_text -node $item_node -child content
        if { [info exists content] } {
            set content_encoded $content
        }
    }

    #remove unsafe html
    set description [feed_parser::remove_unsafe_html -html $description]

    return [list title $title link $link guid $guid permalink_p $permalink_p description $description content_encoded $content_encoded author $author comments $comments pub_date $pub_date]
}

ad_proc -private feed_parser::channel_parse {
    {-channel_node:required}
} {
    Takes a tDOM node which is supposed to represent an RSS
    channel, and returns a list with the RSS/RDF elements
    of that node. This proc should later be extended to
    support Dublin Core elements and other funk.

    @author Guan Yang (guan@unicast.org)
    @creation-date 2003-07-03
} {
    set properties [list title link description language copyright lastBuildDate docs generator managingEditor webMaster]

    foreach property $properties {
        set $property ""
	    feed_parser::dom::set_child_text -node $channel_node -child $property
        set channel($property) [set $property]
    }
    
    set channel_name [$channel_node nodeName]
    
    # Do weird Atom-like stuff
    if { [string equal $channel_name "feed"] } {
        # link
        if { [string equal $link ""] } {
            # Link is in a href
            set link_node [$channel_node selectNodes {*[local-name()='link' and @rel = 'alternate' and @type = 'text/html']/@href}]
            if { [llength $link_node] == 1 } {
                set link_node [lindex $link_node 0]
                set channel(link) [lindex $link_node 1]
            }
        }
        
        # author
        set author_node [$channel_node selectNodes {*[local-name()='author']}]
        if { [llength $author_node] == 1 } {
            set author_node [lindex $author_node 0]
            feed_parser::dom::set_child_text -node $author_node -child name
            feed_parser::dom::set_child_text -node $author_node -child email
            if { [info exists email] && [info exists name] } {
                set channel(managingEditor) "$email ($name)"
            }
        }
        
        # tagline
        feed_parser::dom::set_child_text -node $channel_node -child tagline
        if { [info exists tagline] } {
            set channel(tagline) $tagline
        }
    }

    return [array get channel]
}

ad_proc -private feed_parser::remove_unsafe_html { 
    -html:required
} {
    Make sure we are consuming RSS safely by removing unsafe tags.

    See http://diveintomark.org/archives/2003/06/12/how_to_consume_rss_safely.html.

    @author Simon Carstensen
    @creation-date 2003-07-06
    @param html An HTML string that we need to clean up
    @return The cleaned-up HTML string
} {
    set unsafe_tags {
        script
        embed
        object
        frameset
        frame
        iframe
        meta
        link
        style
    }

    foreach tag $unsafe_tags {
        regsub -all "(<$tag\[^>\]*>(\[^<\]*</$tag>)?)+"  $html {} html
    }

    return $html
}

ad_proc -public feed_parser::parse_feed {
    -xml:required
    {-autodiscover:boolean 1}
} {
    Parse a string believed to be a syndication feed.
    
    @author Guan Yang (guan@unicast.org)
    @creation-date 2003-12-28
    @param xml A string containing an XML document.
    @param autodiscover If true, this procedure will, if the string turns at
                first glance not to be an XML document, treat it as an HTML
                document and attempt to extract an RSS autodiscovery element.
                If such an element is found, the URL will be retrieved using
                ad_httpget and this procedure will be applied to the content
                of that URL.
    @return A Tcl array-list data structure.
} {
    # Unless we have explicit encoding information, we'll assume UTF-8
    if { [regexp {^[[:space:]]*<\?xml[^>]+encoding="([^"]*)"} $xml match encoding] } {
        set encoding [string tolower $encoding]
        set tcl_encoding [ns_encodingforcharset $encoding]
        if { $tcl_encoding ne "" } {
            set xml [encoding convertfrom $tcl_encoding $xml]
        }
    }

    # Prefill these slots for errors
    set result(channel) ""
    set result(items) ""

    if { [catch {
        # Pre-process the doc and remove any processing instruction
        regsub {^<\?xml [^\?]+\?>} $xml {<?xml version="1.0"?>} xml
        set doc [dom parse $xml]
        set doc_node [$doc documentElement]
        set node_name [$doc_node nodeName]
    
        # feed is the doc-node name for Atom feeds
        if { [lsearch {rdf RDF rdf:RDF rss feed} $node_name] == -1 } {
            ns_log Debug "feed_parser::parse_feed: doc node name is not rdf, RDF, rdf:RDF or rss"
            set rss_p 0
        } else {
            set rss_p 1
        }
    } errmsg] } {
        ns_log Debug "feed_parser::parse_feed: error in initial itdom parse, errmsg = $errmsg"
        set rss_p 0
    }
    
    if { !$rss_p } {
        # not valid xml, let's try autodiscovery
        ns_log Debug "feed_parser::parse_feed: not valid xml, we'll try autodiscovery"
        
        set doc [dom parse -html $xml]
        set doc_node [$doc documentElement]
        
        set link_path {/html/head/link[@rel='alternate' and @title='RSS' and @type='application/rss+xml']/@href}
        set link_nodes [$doc_node selectNodes $link_path]
      
        $doc delete
    
        if { [llength $link_nodes] == 1} {
            set link_node [lindex $link_nodes 0]
            set feed_url [lindex $link_node 1]
            array set f [ad_httpget -url $feed_url]
            return [feed_parser::parse_feed -xml $f(page)]
        }
        
        set result(status) "error"
        set result(error) "Not RSS and contained no autodiscovery element"
        return [array get result]
    }
    
    if { [catch {
        set doc_name [$doc_node nodeName]
        
        if { [string equal $doc_name "feed"] } {
            # It's an Atom feed
            set channel [feed_parser::channel_parse \
                           -channel_node $doc_node]
        } else {
            # It looks RSS/RDF'fy
            set channel [feed_parser::channel_parse \
                -channel_node [$doc_node getElementsByTagName channel]]
        }    
            
        set item_nodes [feed_parser::items_fetch -doc_node $doc_node]
        set item_nodes [feed_parser::sort_result -result $item_nodes]
        set items [list]
        
        foreach item_node $item_nodes {
            lappend items [feed_parser::item_parse -item_node $item_node]
        }
        
        $doc delete
    } err] } {
        set result(status) "error"
        set result(error) "Parse error: $err"
        return [array get result]
    } else {
        set result(status) "ok"
        set result(error) ""
        set result(channel) $channel
        set result(items) $items
        return [array get result]
    }
}
