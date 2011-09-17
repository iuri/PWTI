ad_library {
    XoWiki - www procs. These procs are the methods called on xowiki pages via 
    the web interface.

    @creation-date 2006-04-10
    @author Gustaf Neumann
    @cvs-id $Id: xowiki-www-procs.tcl,v 1.199.2.3 2009/01/08 15:38:33 gustafn Exp $
}


namespace eval ::xowiki {
  
  Page instproc htmlFooter {{-content ""}} {
    my instvar package_id

    if {[my exists __no_footer]} {return ""}

    set footer ""
    set description [my get_description $content]
    
    if {[ns_conn isconnected]} {
      set url         "[ns_conn location][::xo::cc url]"
      set package_url "[ns_conn location][$package_id package_url]"
    }

    if {[$package_id get_parameter "with_tags" 1] && 
        ![my exists_query_parameter no_tags] &&
        [::xo::cc user_id] != 0
      } {
      set tag_content [my include my-tags]
      set tag_includelet [my set __last_includelet]
      set tags [$tag_includelet set tags]
    } else {
      set tag_content ""
      set tags ""
    }

    if {[$package_id get_parameter "with_digg" 0] && [info exists url]} {
      append footer "<div style='float: right'>" \
          [my include [list digg -description $description -url $url]] "</div>\n"
    }

    if {[$package_id get_parameter "with_delicious" 0] && [info exists url]} {
      append footer "<div style='float: right; padding-right: 10px;'>" \
          [my include [list delicious -description $description -url $url -tags $tags]] \
          "</div>\n"
    }

    if {[$package_id get_parameter "with_yahoo_publisher" 0] && [info exists package_url]} {
      set publisher [$package_id get_parameter "my_yahoo_publisher" \
                         [::xo::get_user_name [::xo::cc user_id]]]
      append footer "<div style='float: right; padding-right: 10px;'>" \
          [my include [list my-yahoo-publisher \
                                   -publisher $publisher \
                                   -rssurl "$package_url?rss"]] \
          "</div>\n"
    }

    append footer [my include my-references] 
    
    if {[$package_id get_parameter "show_per_object_categories" 1]} {
      set html [my include my-categories]
      if {$html ne ""} {
	append footer $html <br>
      }
      set categories_includelet [my set __last_includelet]
    }

    append footer $tag_content

    if {[$package_id get_parameter "with_general_comments" 0] &&
        ![my exists_query_parameter no_gc]} {
      append footer [my include my-general-comments] 
    }

    if {$footer ne ""} {
      # make sure, the 
      append footer "<div class='visual-clear'><!-- --></div>"
    }

    return  "<div class='item-footer'>$footer</div>\n"
  }

}

namespace eval ::xowiki {
  
  Page instproc view {{content ""}} {
    # The method "view" is used primarily for the toplevel call, when
    # the xowiki page is viewed.  It is not intended for e.g. embedded
    # wiki pages (see include), since it contains full framing, etc.
    my instvar package_id item_id 
    $package_id instvar folder_id  ;# this is the root folder
    ::xowiki::Page set recursion_count 0

    set template_file [my query_parameter "template_file" \
                           [::$package_id get_parameter template_file view-default]]

    if {[my isobject ::xowiki::$template_file]} {
      $template_file before_render [self]
    }
    
    # the content may be passed by other methods (e.g. edit) to 
    # make use of the same templating machinery below.
    if {$content eq ""} {
      set content [my render]
      #my log "--after render"
    }

    set footer [my htmlFooter -content $content]
    set top_includelets ""
    set vp [string trim [$package_id get_parameter "top_includelet" ""]]
    if {$vp ne ""} {
      set top_includelets [my include $vp]
    }

    if {[$package_id get_parameter "with_user_tracking" 1]} {
      my record_last_visited
    }

    # Deal with the views package (many thanks to Malte for this snippet!)
    if {[$package_id get_parameter with_views_package_if_available 1] 
	&& [apm_package_installed_p "views"]} {
      views::record_view -object_id $item_id -viewer_id [::xo::cc user_id]
      array set views_data [views::get -object_id $item_id]
    }

    # import title, name and text into current scope
    my instvar title name text

    if {[my exists_query_parameter return_url]} {
      set return_url [my query_parameter return_url]
    }
    
    if {[$package_id get_parameter "with_notifications" 1]} {
      if {[::xo::cc user_id] != 0} { ;# notifications require login
        set notifications_return_url [expr {[info exists return_url] ? $return_url : [ad_return_url]}]
        set notification_type [notification::type::get_type_id -short_name xowiki_notif]
        set notification_text "Subscribe the XoWiki instance"
        set notification_subscribe_link \
            [export_vars -base /notifications/request-new \
                 {{return_url $notifications_return_url}
                   {pretty_name $notification_text} 
                   {type_id $notification_type} 
                   {object_id $package_id}}]
        set notification_image \
           "<img style='border: 0px;' src='/resources/xowiki/email.png' \
	    alt='$notification_text' title='$notification_text'>"
      }
    }
    #my log "--after notifications [info exists notification_image]"

    set master [$package_id get_parameter "master" 1]
    #if {[my exists_query_parameter "edit_return_url"]} {
    #  set return_url [my query_parameter "edit_return_url"]
    #}
    #my log "--after options master=$master"

    if {$master} {
      set context [list $title]
      ::xo::Page set_property doc title "[$package_id instance_name] - $title"
      set autoname    [$package_id get_parameter autoname 0]
      set object_type [$package_id get_parameter object_type [my info class]]
      set rev_link    [$package_id make_link -with_entities 0 [self] revisions]
      if {[$package_id query_parameter m ""] eq "edit"} {
        set view_link   [$package_id make_link -with_entities 0 [self] view return_url]
      } else {
        set edit_link   [$package_id make_link -with_entities 0 [self] edit return_url]
      }
      set delete_link [$package_id make_link -with_entities 0 [self] delete return_url]
      if {[my exists __link(new)]} {
        set new_link [my set __link(new)]
      } else {
        if {[my istype ::xowiki::FormPage]} {
          set template_id [my page_template]
          set form      [$package_id pretty_link [$template_id name]]
          set new_link  [$package_id make_link -with_entities 0 -link $form $template_id create-new return_url]
        } else {
          set new_link  [$package_id make_link -with_entities 0 $package_id edit-new object_type return_url autoname] 
        }
      }
      set admin_link  [$package_id make_link -privilege admin -link admin/ $package_id {} {}] 
      set index_link  [$package_id make_link -privilege public -link "" $package_id {} {}]
      set create_in_req_locale_link ""

      if {[$package_id get_parameter use_connection_locale 0]} {
        $package_id get_lang_and_name -path [$package_id set object] req_lang req_local_name
        set default_lang [$package_id default_language]
        if {$req_lang ne $default_lang} {
          set l [Link create new -destroy_on_cleanup \
                     -page [self] -type language -stripped_name $req_local_name \
                     -name ${default_lang}:$req_local_name -lang $default_lang \
                     -label $req_local_name -parent_id $folder_id \
                     -package_id $package_id -init \
                     -return_only undefined]
          $l render
        }
      }

      #my log "--after context delete_link=$delete_link "
      set template [$folder_id get_payload template]
      set page [self]

      if {$template ne ""} {
        set __including_page $page
        set __adp_stub [acs_root_dir]/packages/xowiki/www/view-default
        set template_code [template::adp_compile -string $template]
        if {[catch {set content [template::adp_eval template_code]} errmsg]} {
          ns_return 200 text/html "Error in Page $name: $errmsg<br />$template"
        } else {
          ns_return 200 text/html $content
        }
      } else {
        # use adp file
        #my log "use adp"
        foreach css [$package_id get_parameter extra_css ""] {::xo::Page requireCSS -order 10 $css}
        # refetch it, since it might have been changed via set-parameter
        set template_file [my query_parameter "template_file" \
                               [::$package_id get_parameter template_file view-default]]

	# if the template_file does not have a path, assume it in xowiki/www
        if {![regexp {^[./]} $template_file]} {
          set template_file /packages/xowiki/www/$template_file
        }
	
        set header_stuff [::xo::Page header_stuff]
	if {[info command ::template::head::add_meta] ne ""} {
	  template::head::add_meta -name language -content [my lang]
	  template::head::add_meta -name description -content [my description]
	  template::head::add_meta -name keywords -content [$package_id get_parameter keywords ""]
	}

        #
        # pass variables for properties doc and body
        # example: ::xo::Page set_property body class "yui-skin-sam"
        #
        array set property_body [::xo::Page get_property body]
        array set property_doc  [::xo::Page get_property doc]
        # ns_log notice "XOWIKI body=[::xo::Page get_property body]"
        $package_id return_page -adp $template_file -variables {
          name title item_id context header_stuff return_url
          content footer package_id
          rev_link edit_link delete_link new_link admin_link index_link view_link
          notification_subscribe_link notification_image 
          top_includelets page
          views_data property_body property_doc
        }
      }
    } else {
      ns_return 200 [::xo::cc get_parameter content-type text/html] $content
    }
  }
}


namespace eval ::xowiki {

  Page instproc edit {
    {-new:boolean false} 
    {-autoname:boolean false}
    {-validation_errors ""}
  } {
    my instvar package_id item_id revision_id
    $package_id instvar folder_id  ;# this is the root folder

    #my msg "--edit new=$new autoname=$autoname, valudation_errors=$validation_errors"

    # set some default values if they are provided
    foreach key {name title page_order last_page_id} {
      if {[$package_id exists_query_parameter $key]} {
        my set $key [$package_id query_parameter $key]
      }
    }
    # the following is handled by new-request of the wiki form
    #if {$new} {
      #my set creator [::xo::get_user_name [::xo::cc user_id]]
      #my set nls_language [ad_conn locale]
    #}

    set object_type [my info class]
    if {!$new && $object_type eq "::xowiki::Object" && [my set name] eq "::$folder_id"} {
      # if we edit the folder object, we have to do some extra magic here, 
      # since  the folder object has slightly different naming conventions.
      # ns_log notice "--editing folder object ::$folder_id, FLUSH $page"
      ::xo::clusterwide ns_cache flush xotcl_object_cache [self]
      ::xo::clusterwide ns_cache flush xotcl_object_cache ::$folder_id
      my move ::$folder_id
      set page ::$folder_id
      #ns_log notice "--move page=$page"
    } 

    #
    # setting up folder id for file selector (use community folder if available)
    #
    set fs_folder_id ""
    if {[info commands ::dotlrn_fs::get_community_shared_folder] ne ""} {
      # ... we have dotlrn installed
      set cid [::dotlrn_community::get_community_id]
      if {$cid ne ""} {
        # ... we are inside of a community, use the community folder
        set fs_folder_id [::dotlrn_fs::get_community_shared_folder -community_id $cid]
      }
    }

    # the following line is like [$package_id url], but works as well with renamed objects
    # set myurl [$package_id pretty_link [my form_parameter name]]

    if {[my exists_query_parameter "return_url"]} {
      set submit_link [my query_parameter "return_url" "."]
      set return_url $submit_link
    } else {
      set submit_link "."
    }
    #my log "--u submit_link=$submit_link qp=[my query_parameter return_url]"

    # We have to do template mangling here; ad_form_template writes
    # form variables into the actual parselevel, so we have to be in
    # our own level in order to access an pass these.
    variable ::template::parse_level
    lappend parse_level [info level]    
    set action_vars [expr {$new ? "{edit-new 1} object_type return_url" : "{m edit} return_url"}]
    #my log "--formclass=[$object_type getFormClass -data [self]] ot=$object_type"

    #
    # Determine the package_id of some mounted xowiki instance to find
    # the directory + URL, from where the scripts called from xinha
    # can be used.
    if {[$package_id info class] eq "::xowiki::Package"} {
      # The actual instance is a plain xowiki instance, we can use it
      set folder_spec [list script_dir [$package_id package_url]]
    } else {
      # The actual instance is not a plain xowiki instance, so, we try
      # to find one, where the current user has at least read
      # permissions.  This act is required for sub-packages, which
      # might not have the script dir.
      set first_instance_id [::xowiki::Package first_instance -party_id [::xo::cc user_id] -privilege read]
      if {$first_instance_id ne ""} {
        ::xowiki::Package require $first_instance_id
        set folder_spec [list script_dir [$first_instance_id package_url]]
      }
    }

    if {$fs_folder_id ne ""} {lappend folder_spec folder_id $fs_folder_id}
    
    [$object_type getFormClass -data [self]] create ::xowiki::f1 -volatile \
        -action  [export_vars -base [$package_id url] $action_vars] \
        -data [self] \
        -folderspec $folder_spec \
        -submit_link $submit_link \
        -autoname $autoname

    if {[info exists return_url]} {
      ::xowiki::f1 generate -export [list [list return_url $return_url]]
    } else {
      ::xowiki::f1 generate
    }

    ::xowiki::f1 instvar edit_form_page_title context formTemplate
    
    if {[info exists item_id]} {
      set rev_link    [$package_id make_link [self] revisions]
      set view_link   [$package_id make_link [self] view]
    }
    if {[info exists last_page_id]} {
      set back_link [$package_id url]
    }

    set index_link  [$package_id make_link -privilege public -link "" $package_id {} {}]
    ::xo::Page set_property doc title "[$package_id instance_name] - $edit_form_page_title"

    array set property_doc [::xo::Page get_property doc]
    set html [$package_id return_page -adp /packages/xowiki/www/edit \
                  -form f1 \
                  -variables {item_id edit_form_page_title context formTemplate
                    view_link back_link rev_link index_link property_doc}]
    template::util::lpop parse_level
    #my log "--edit html length [string length $html]"
    return $html
  }

  Page instproc find_slot {-start_class name} {
    if {![info exists start_class]} {
      set start_class [my info class]
    }
    foreach cl [concat $start_class [$start_class info heritage]] {
      set slotobj ${cl}::slot::$name
      if {[my isobject $slotobj]} {
        #my msg $slotobj
        return $slotobj
      }
    }
    return ""
  }
  
  Page instproc create_raw_form_field {
    -name 
    {-slot ""} 
    {-spec ""} 
    {-configuration ""}
  } {
    set save_slot $slot
    if {$slot eq ""} {
      # We have no slot, so create a minimal slot. This should only happen for instance attributes
      set slot [::xo::Attribute new -pretty_name $name -datatype text -volatile -noinit]
    }

    set spec_list [list]
    if {[$slot exists spec]} {lappend spec_list [$slot set spec]}
    if {$spec ne ""}         {lappend spec_list $spec}
    #my msg "[self args] spec_list $spec_list"
    #my msg "$name, spec_list = '[join $spec_list ,]'"

    if {[$slot exists pretty_name]} {
      set label [$slot set pretty_name]
    } else {
      set label $name
      my log "no pretty_name for variable $name in slot $slot"
    }

    if {[$slot exists default]} {
      #my msg "setting ff $name default = [$slot default]"
      set default [$slot default] 
    } else {
      set default ""
    }
    set f [::xowiki::formfield::FormField new -name $name \
               -id        [::xowiki::Includelet html_id F.[my name].$name] \
               -locale    [my nls_language] \
               -label     $label \
               -type      [expr {[$slot exists datatype]  ? [$slot set datatype]  : "text"}] \
               -help_text [expr {[$slot exists help_text] ? [$slot set help_text] : ""}] \
               -validator [expr {[$slot exists validator] ? [$slot set validator] : ""}] \
               -required  [expr {[$slot exists required]  ? [$slot set required]  : "false"}] \
               -default   $default \
               -spec      [join $spec_list ,] \
               -object    [self] \
               -slot      $save_slot \
              ]

    $f destroy_on_cleanup
    eval $f configure $configuration
    return $f
  }

  PageInstance instproc create_raw_form_field {
    -name 
    {-slot ""}
    {-spec ""} 
    {-configuration ""}
  } {
    set short_spec [my get_short_spec $name]
    #my msg "create form-field '$name', short_spec = '$short_spec', slot=$slot"
    set spec_list [list]
    if {$spec ne ""}       {lappend spec_list $spec}
    if {$short_spec ne ""} {lappend spec_list $short_spec}
    #my msg "$name: short_spec '$short_spec', spec_list 1 = '[join $spec_list ,]'"
    set f [next -name $name -slot $slot -spec [join $spec_list ,] -configuration $configuration]
    #my msg "created form-field '$name' $f [$f info class] validator=[$f validator]" ;#p=[$f info precedence] 
    return $f
  }

}

namespace eval ::xowiki {

  FormPage proc get_table_form_fields {
     -base_item 
     -field_names 
     -form_constraints
   } {

    array set __att [list publish_status 1]
    foreach att [::xowiki::FormPage array names db_slot] {set __att($att) 1}
    foreach att [list last_modified creation_user] {
      set __att($att) 1
    }
    
    # set cr_field_spec [::xowiki::PageInstance get_short_spec_from_form_constraints \
    #                            -name @cr_fields \
    #                            -form_constraints $form_constraints]
    # if some fields are hidden in the form, there might still be values (creation_user, etc)
    # maybe filter hidden? ignore for the time being.

    set cr_field_spec ""
    set field_spec [::xowiki::PageInstance get_short_spec_from_form_constraints \
			-name @fields \
			-form_constraints $form_constraints]

    foreach field_name $field_names {
      set short_spec [::xowiki::PageInstance get_short_spec_from_form_constraints \
                          -name $field_name \
                          -form_constraints $form_constraints]

      switch -glob -- $field_name {
        __* {error not_allowed}
        _* {
          set varname [string range $field_name 1 end]
          if {![info exists __att($varname)]} {
            error "unknown attribute $field_name"
          }
          set f [$base_item create_raw_form_field \
                     -name $field_name \
                     -slot [$base_item find_slot $varname] \
                     -spec $cr_field_spec,$short_spec]
          $f set __base_field $varname
        }
        default {
          set f [$base_item create_raw_form_field \
                     -name $field_name \
                     -slot "" \
                     -spec $field_spec,$short_spec]
        }
      }
      lappend form_fields $f
    }
    return $form_fields
  }

  FormPage proc h_double_quote {value} {
    if {[regexp {[ ,\"\\=>]} $value]} {
      set value \"[string map [list \" \\\\\" \\ \\\\ ' \\\\'] $value]\"
    }
    return $value
  }

  FormPage proc filter_expression {
    input_expr
    logical_op
  } {
    array set tcl_op {= eq < < > > >= >= <= <=}
    array set sql_op {= =  < < > > >= >= <= <=}
    array set op_map {contains,sql {$lhs_var like '%$rhs%'} contains,tcl {[lsearch $lhs_var {$rhs}] > -1}}
    #my msg unless=$unless
    #example for unless: wf_current_state = closed|accepted || x = 1
    set tcl_clause [list]
    set h_clause [list]
    set vars [list]
    set sql_clause [list]
    foreach clause [split [string map [list $logical_op \x00] $input_expr] \x00] {
      if {[regexp {^(.*[^<>])\s*([=<>]|<=|>=|contains)\s*([^=]?.*)$} $clause _ lhs op rhs_expr]} {
        set lhs [string trim $lhs]
        if {[string range $lhs 0 0] eq "_"} {
          set lhs_var [string range $lhs 1 end]
	  set rhs [split $rhs_expr |] 
	  if {[info exists op_map($op,sql)]} {
	    lappend sql_clause [subst -nocommands $op_map($op,sql)]
	    if {[my exists $lhs_var]} {
	      set lhs_var "\[my set $lhs_var\]"
	      lappend tcl_clause [subst -nocommands $op_map($op,tcl)]
	    } else {
	      my msg "ignoring unknown variable $lhs_var in expression"
	    }
	  } elseif {[llength $rhs]>1} {
	    lappend sql_clause "$lhs_var in ('[join $rhs ',']')"
	  } else {
            lappend sql_clause "$lhs_var $sql_op($op) '$rhs'"
	  }
        } else {
          set hleft [my h_double_quote $lhs]
          lappend vars $lhs ""
	  if {$op eq "contains"} {
	    #make approximate query
	    set lhs_var instance_attributes
	    set rhs $rhs_expr
	    lappend sql_clause [subst -nocommands $op_map($op,sql)]
	  }
          set lhs_var "\$__ia($lhs)"
          foreach rhs [split $rhs_expr |] {
	    if {[info exists op_map($op,tcl)]} {
	      lappend tcl_clause [subst -nocommands $op_map($op,tcl)]
	    } else {
	      lappend tcl_clause "$lhs_var $tcl_op($op) {$rhs}"
	    }
            if {$op eq "="} {
              # TODO: think about a solution for other operators with
              # hstore maybe: extracting it by a query via hstore and
              # compare in plain SQL
              lappend h_clause "$hleft=>[my h_double_quote $rhs]"
            }
          }
        }
      } else {
        my msg "ignoring $clause"
      }
    }
    if {[llength $tcl_clause] == 0} {set tcl_clause [list true]}
    #my msg sql=$sql_clause,tcl=$tcl_clause
    return [list tcl [join $tcl_clause $logical_op] h [join $h_clause ,] \
                vars $vars sql $sql_clause]
    #my msg $expression
  }

  FormPage instproc create_category_fields {} {
    set category_spec [my get_short_spec @categories]
    # Per default, no category fields in FormPages, since the can be 
    # handled in more detail via form-fields.
    if {$category_spec eq ""} {return [list]}

    # a value of "off" turns the off as well
    foreach f [split $category_spec ,] {
      if {$f eq "off"} {return [list]}
    }
    
    set category_fields [list]
    set container_object_id [my package_id]
    set category_trees [category_tree::get_mapped_trees $container_object_id]
    set category_ids [category::get_mapped_categories [my item_id]]
    #my msg "mapped category ids=$category_ids"

    foreach category_tree $category_trees {
      foreach {tree_id tree_name subtree_id assign_single_p require_category_p} $category_tree break

      set options [list] 
      #if {!$require_category_p} {lappend options [list "--" ""]}
      set value [list]
      foreach category [::xowiki::Category get_category_infos \
                            -subtree_id $subtree_id -tree_id $tree_id] {
        foreach {category_id category_name deprecated_p level} $category break
        if {[lsearch $category_ids $category_id] > -1} {lappend value $category_id}
        set category_name [ad_quotehtml [lang::util::localize $category_name]]
        if { $level>1 } {
          set category_name "[string repeat {&nbsp;} [expr {2*$level-4}]]..$category_name"
        }
        lappend options [list $category_name $category_id]
      }
      set f [::xowiki::formfield::FormField new \
                 -name "__category_${tree_name}_$tree_id" \
                 -locale [my nls_language] \
                 -label $tree_name \
                 -type select \
                 -value $value \
                 -required $require_category_p]
      #my msg "category field [my name] created, value '$value'"
      $f destroy_on_cleanup
      $f options $options
      $f multiple [expr {!$assign_single_p}]
      lappend category_fields $f
    }
    return $category_fields
  }

  FormPage instproc get_form_value {att} {
    my instvar root item_id
    set fields [$root selectNodes "//form//*\[@name='$att'\]"] 
    if {$fields eq ""} {return ""}
    foreach field $fields {
      set type [expr {[$field hasAttribute type] ? [$field getAttribute type] : "text"}]
      switch $type {
	checkbox {
	  #my msg "get_form_value not implemented for $type"
	}
	radio {
	  #my msg "get_form_value not implemented for $type"
	}
	hidden -
	password -
	text { 
	  if {[$field hasAttribute value]} {
	    return [$field getAttribute value]
	  }
	}
	default {
          #my msg "can't handle $type so far $att=$value"
        }
      }
    }
    return ""
  }

  FormPage instproc set_form_value {att value} {
    #my msg "set_form_value $att $value"
    my instvar root item_id
    set fields [$root selectNodes "//form//*\[@name='$att'\]"]
    #my msg "found field = $fields xp=//*\[@name='$att'\]"
    foreach field $fields {
      # TODO missing: textarea
      if {[$field nodeName] ne "input"} continue
      set type [expr {[$field hasAttribute type] ? [$field getAttribute type] : "text"}]
      # the switch should be really different objects ad classes...., but thats HTML, anyhow.
      switch $type {
        checkbox {
          #my msg "$att: CHECKBOX value='$value', [$field hasAttribute checked], [$field hasAttribute value]"
          if {[$field hasAttribute value]} {
            set form_value [$field getAttribute value]
            #my msg "$att: form_value=$form_value, my value=$value"
            if {[lsearch -exact $value $form_value] > -1} {
              $field setAttribute checked true
            } elseif {[$field hasAttribute checked]} {
              $field removeAttribute checked
            }
          } else {
            #my msg "$att: CHECKBOX entry has no value"
            if {[catch {set f [expr {$value ? 1 : 0}]}]} {set f 1}
            if {$value eq "" || $f == 0} {
              if {[$field hasAttribute checked]} {
                $field removeAttribute checked
              }
            } else {
              $field setAttribute checked true
            }
          }
        }
        radio {
          set inputvalue [$field getAttribute value]
          #my msg "radio: compare input '$inputvalue' with '$value'"
          if {$inputvalue eq $value} {
            $field setAttribute checked true
          }
        }
        hidden -
        password -
        text {  $field setAttribute value $value}
        default {my msg "can't handle $type so far $att=$value"}
      }
    }
  }
}


namespace eval ::xowiki {

  FormPage ad_instproc set_form_data {form_fields} {
    Store the instance attributes or default values in the form.
  } {
    #my msg "set_form_value instance attributes = [my instance_attributes]"
    array set __ia [my instance_attributes]
    foreach f $form_fields {
      set att [$f name]
      # just handle fields of the form entry 
      if {![my exists __field_in_form($att)]} continue
      #my msg "set form_value to form-field $att __ia($att)"
      if {[info exists __ia($att)]} {
        #my msg "my set_form_value from ia $att $__ia($att)"
        my set_form_value $att [$f convert_to_external $__ia($att)]
      } else {
        # do we have a value in the form? If yes, keep it.
        set form_value [my get_form_value $att]
        #my msg "no instance attribute, set form_value $att '[$f value]' form_value=$form_value"
        if {$att eq ""} {
          # we have no instance attributes, use the default value from the form field
          my set_form_value $att [$f convert_to_external [$f value]]
        }
      }
    }
  }
}


namespace eval ::xowiki {

  Page ad_instproc get_form_data {-field_names form_fields} {
    Get the values from the form and store it as
    instance attributes.
  } {
    set validation_errors 0
    set category_ids [list]
    array set containers [list]
    if {[my exists instance_attributes]} {
      array set __ia [my set instance_attributes]
    }
    if {![info exists field_names]} {
      set field_names [::xo::cc array names form_parameter]
    }
    #my msg "fields [::xo::cc array get form_parameter]"

    # we have a form and get all form variables
    
    foreach att $field_names {
      #my msg "getting att=$att"
      set processed($att) 1
      switch -glob -- $att {
        __category_* {
          set f [my lookup_form_field -name $att $form_fields]
          set value [$f value [::xo::cc form_parameter $att]]
          foreach v $value {lappend category_ids $v}
        }
        __* {
          # other internal variables (like __object_name) are ignored
        }
         _* {
           # instance attribute fields
           set f     [my lookup_form_field -name $att $form_fields]
           set value [$f value [string trim [::xo::cc form_parameter $att]]]
           set varname [string range $att 1 end]
           # get rid of strange utf-8 characters hex C2AD (firefox bug?)
           # ns_log notice "FORM_DATA var=$varname, value='$value' s=$s"
           if {$varname eq "text"} {regsub -all "­" $value "" value}
           # ns_log notice "FORM_DATA var=$varname, value='$value' s=$s"
           if {![string match *.* $att]} {my set $varname $value}
         }
        default {
           # user form content fields
          if {[regexp {^(.+)[.](tmpfile|content-type)} $att _ file field]} {
            set f [my lookup_form_field -name $file $form_fields]
            $f $field [string trim [::xo::cc form_parameter $att]]
          } else {
            set f     [my lookup_form_field -name $att $form_fields]
            set value [$f value [string trim [::xo::cc form_parameter $att]]]
            #my msg "value of $att ($f) = '$value'" 
            if {![string match *.* $att]} {set __ia($att) $value}
            if {[$f exists is_category_field]} {foreach v $value {lappend category_ids $v}}
          }
        }
      }
      if {[string match *.* $att]} {
        foreach {container component} [split $att .] break
         lappend containers($container) $component
      }
    }
    
    #my msg "containers = [array names containers]"
    #my msg "ia=[array get __ia]"
    #
    # In a second iteration, combine the values from the components 
    # of a container to the value of the container.
    #
    foreach c [array names containers] {
      switch -glob -- $c {
        __* {}
        _* {
          set f  [my lookup_form_field -name $c $form_fields]
          set processed($c) 1
          my set [string range $c 1 end] [$f value]
        }
        default {
          set f  [my lookup_form_field -name $c $form_fields]
          set processed($c) 1
          #my msg "compute value of $c"
          set __ia($c) [$f value]
          #my msg "__ia($c) is set to '[$f value]'"
        }
      }
    }
    
    #
    # The first round was a processing based on the transmitted input
    # fields of the forms. Now we use the formfields to complete the
    # data and to validate it.
    #
    foreach f $form_fields {
      #my msg "validate $f [$f name] [info exists processed([$f name])]"
      set att [$f name]
 
      # Certain form field types (e.g. checkboxes) are not transmitted, if not
      # checked. Therefore, we have not processed these fields above and
      # have to do it now.
      
      if {![info exists processed($att)]} {
	#my msg "form field $att not yet processed"
	switch -glob -- $att {
	  __* {
	    # other internal variables (like __object_name) are ignored
	  }
	  _* {
	    # instance attribute fields
	    set varname [string range $att 1 end]
            set preset ""
            if {[my exists $varname]} {set preset [my set $varname]}
            set v [$f value_if_nothing_is_returned_from_from $preset]
            set value [$f value $v]
            if {$v ne $preset} {
              if {![string match *.* $att]} {my set $varname $value}
            }
	  }
	  default {
	    # user form content fields
            set preset ""
            if {[info exists __ia($att)]} {set preset $__ia($att)}
            set v [$f value_if_nothing_is_returned_from_from $preset]
            set value [$f value $v]
            if {$v ne $preset} {
              if {![string match *.* $att]} {set __ia($att) $value}
            }
	  }
         }
      }
      
      #
      # Run validators
      #
      set validation_error [$f validate [self]]
      #my msg "validation of [$f name] with value '[$f value]' returns '$validation_error'"
      if {$validation_error ne ""} {
        $f error_msg $validation_error
        incr validation_errors
      }
    }
    
    if {$validation_errors == 0} {
      #
      # Postprocess based on form fields based on form-fields methods.
      # Postprocessing might force to refresh some values in __ia()
      #
      foreach f $form_fields {
        $f convert_to_internal
        if {[$f exists __refresh_instance_attributes]} {
          #my msg "refresh [$f set __refresh_instance_attributes]"
          foreach {att val} [$f set __refresh_instance_attributes] {
            set __ia($att) $val
          }
        }
      }
    }

    #my msg "--set instance attributes to [array get __ia]"
    my instance_attributes [array get __ia]
    my array set __ia [my instance_attributes]
    #my msg category_ids=$category_ids
    return [list $validation_errors [lsort -unique $category_ids]]
  }

  FormPage instproc form_field_as_html {{-mode edit} before name form_fields} {
    set found 0
    foreach f $form_fields {
      if {[$f name] eq $name} {set found 1; break}
    } 
    if {!$found} {
      set f [my create_raw_form_field -name $name -slot [my find_slot $name]]
    }

    #my msg "$found $name mode=$mode type=[$f set type] value=[$f value] disa=[$f exists disabled]"
    if {$mode eq "edit" || [$f display_field]} {
      set html [$f asHTML]
    } else {
      set html @$name@
    }
    #my msg "$name $html"
    return ${before}$html
  }
}

namespace eval ::xowiki {

  Page instproc create_form_field {{-cr_field_spec ""} {-field_spec ""} field_name} {
    switch -glob -- $field_name {
      __* {}
      _* {
        set varname [string range $field_name 1 end]
        return [my create_raw_form_field -name $field_name \
                    -spec $cr_field_spec \
                    -slot [my find_slot $varname]]
      }
      default {
        return [my create_raw_form_field -name $field_name \
                    -spec $field_spec \
                    -slot [my find_slot $field_name]]
      }
    }
  }

  Page instproc create_form_fields {field_names} {
    set form_fields [my create_category_fields]
    foreach att $field_names {
      if {[string match "__*" $att]} continue
      lappend form_fields [my create_form_field $att]
    }
    return $form_fields
  }

  FormPage instproc create_form_field {{-cr_field_spec ""} {-field_spec ""} field_name} {
    if {$cr_field_spec eq ""} {set cr_field_spec [my get_short_spec @cr_fields]}
    if {$field_spec eq ""} {set field_spec [my get_short_spec @fields]}
    return [next -cr_field_spec $cr_field_spec -field_spec $field_spec $field_name]
  }
  FormPage instproc create_form_fields {field_names} {
    set form_fields   [my create_category_fields]
    foreach att $field_names {
      if {[string match "__*" $att]} continue
      lappend form_fields [my create_form_field \
                               -cr_field_spec [my get_short_spec @cr_fields] \
                               -field_spec [my get_short_spec @fields] $att]
    }
    return $form_fields
  }

  FormPage instproc field_names {{-form ""}} {
    my instvar package_id
    foreach {form_vars needed_attributes} [my field_names_from_form -form $form] break
    #my msg "form_vars=$form_vars needed_attributes=$needed_attributes"
    my array unset __field_in_form
    my array unset __field_needed
    if {$form_vars} {foreach v $needed_attributes {my set __field_in_form($v) 1}}
    foreach v $needed_attributes {my set __field_needed($v) 1}
    
    # 
    # Remove the fields already included in auto_fields form the needed_attributes.
    # The final list field_names determines the order of the fields in the form.
    #
    set auto_fields [list _name _page_order _creator _title _text _description _nls_language]
    set reduced_attributes $needed_attributes

    foreach f $auto_fields {
      set p [lsearch $reduced_attributes $f]
      if {$p > -1} {
	#if {$form_vars} {
	  #set auto_field_in_form($f) 1
	#}
        set reduced_attributes [lreplace $reduced_attributes $p $p]
      } 
    }
    #my msg reduced_attributes=$reduced_attributes 
    #my msg fields_from_form=[my array names __field_in_form]

    set field_names [list _name]
    if {[$package_id show_page_order]}  { lappend field_names _page_order }
    lappend field_names _title _creator
    foreach fn $reduced_attributes                     { lappend field_names $fn }
    foreach fn [list _text _description _nls_language] { lappend field_names $fn }
    #my msg field_names=$field_names
    return $field_names
  }

  Page instproc field_names {{-form ""}} {
    array set dont_modify [list item_id 1 revision_id 1 object_id 1 object_title 1 page_id 1 name 1]
    set field_names [list]
    foreach field_name [[my info class] array names db_slot] {
      if {[info exists dont_modify($field_name)]} continue
      lappend field_names _$field_name
    }
    #my msg field_names=$field_names
    return $field_names
  }

  Page instproc save_attributes {} {
    my instvar package_id
    set field_names [my field_names]
    set form_fields [list]
    set query_field_names [list]

    set validation_errors 0
    foreach field_name $field_names {
      if {[::xo::cc exists_form_parameter $field_name]} {
        lappend form_fields [my create_form_field $field_name]
        lappend query_field_names $field_name
      }
    }
    #my show_fields $form_fields
    foreach {validation_errors category_ids} \
        [my get_form_data -field_names $query_field_names $form_fields] break
    if {$validation_errors == 0} {
      #
      # we have no validation erros, so we can save the content
      #
      set update_without_revision [$package_id query_parameter replace 0]

      foreach form_field $form_fields {
        # fix richtext content in accordance with oacs conventions
        if {[$form_field istype ::xowiki::formfield::richtext]} {
          $form_field value [list [$form_field value] text/html]
        }
      }
      if {$update_without_revision} {
        # field-wise update without revision
        set update_instance_attributes 0
        foreach form_field $form_fields {
          set s [$form_field slot]
          if {$s eq ""} {
            # empty slot means that we have an instance_attribute; 
            # we save all in one statement below
            set update_instance_attributes 1
          } else {
            error "Not implemented yet"
            my update_attribute_from_slot $s [$form_field value]
          }
        }
        if {$update_instance_attributes} {
          set s [my find_slot instance_attributes]
          my update_attribute_from_slot $s [my instance_attributes]
        }
      } else {
        #
        # perform standard update (with revision)
        # 
        my save_data \
            -use_given_publish_date [expr {[lsearch $field_names _publish_date] > -1}] \
            [::xo::cc form_parameter __object_name ""] $category_ids
      }
      $package_id returnredirect \
          [my query_parameter "return_url" [$package_id pretty_link [my name]]]
      return
    } else {
      # todo: handle errors in a user friendly way
      my log "we have $validation_errors validation_errors"
    }
    $package_id returnredirect \
        [my query_parameter "return_url" [$package_id pretty_link [my name]]]
  }


  FormPage instproc load_values_into_form_fields {form_fields} {
    array set __ia [my set instance_attributes]
    foreach f $form_fields {
      set att [$f name]
      switch -glob $att {
        __* {}
        _* {
          set varname [string range $att 1 end]
          $f value [$f convert_to_external [my set $varname]]
        }
        default {
          if {[info exists __ia($att)]} {
            #my msg "setting $f ([$f info class]) value $__ia($att)"
            $f value [$f convert_to_external $__ia($att)]
          }
        }
      }
    }
  }

  FormPage instproc render_form_action_buttons {{-CSSclass ""}} {
    ::html::div -class form-button {
      set f [::xowiki::formfield::submit_button new -destroy_on_cleanup \
                 -name __form_button_ok \
                 -CSSclass $CSSclass]
      $f render_input
    }
  }
  
  FormPage instproc form_fields_sanity_check {form_fields} {
    foreach f $form_fields {
      if {[$f exists disabled]} {
        # don't mark disabled fields as required
        if {[$f required]} {
          $f required false
        }
        #don't show the help-text, if you cannot input
        if {[$f help_text] ne ""} {
          $f help_text ""
        }
      }
    }
  }

  FormPage instproc edit {
    {-validation_errors ""}
    {-disable_input_fields 0}
    {-view true}
  } {
    my instvar page_template doc root package_id
    ::xowiki::Form requireFormCSS

    set form [my get_form]
    set anon_instances [my get_from_template anon_instances f]
    #my msg form=$form
    #my msg anon_instances=$anon_instances
    
    # The following code should be obsolete
    # set form_id [my get_form_id]
    # if {![$form_id istype ::xowiki::Form]} {
    #   set form "<FORM>[lindex [$form_id set text] 0]</FORM>"
    # }

    set field_names [my field_names -form $form]
    set form_fields [my create_form_fields $field_names]

    if {$form eq ""} {
      #
      # Since we have no form, we create it on the fly
      # from the template variables and the form field specifications.
      #
      set form "<FORM></FORM>"
      set formgiven 0
    } else {
      set formgiven 1
    }

    # check name field: 
    #  - if it is for anon instances, hide it,
    #  - if it is required but hidden, show it anyway 
    #    (might happen, when e.g. set via @cr_fields ... hidden)
    set name_field [my lookup_form_field -name _name $form_fields]
    if {$anon_instances} {
      #$name_field config_from_spec hidden
    } else {
      if {[$name_field istype ::xowiki::formfield::hidden] && [$name_field required] == true} {
        $name_field config_from_spec text,required
        $name_field type text
      }
    }

    # include _text only, if explicitly needed (in form needed(_text)]"

    if {![my exists __field_needed(_text)]} {
      #my msg "setting text hidden"
      set f [my lookup_form_field -name _text $form_fields]
      $f config_from_spec hidden
    }

    #my show_fields $form_fields
    #my msg "__form_action [my form_parameter __form_action {}]"

    if {[my form_parameter __form_action ""] eq "save-form-data"} {
      #my msg "we have to validate"
      #
      # we have to valiate and save the form data
      #
      foreach {validation_errors category_ids} [my get_form_data $form_fields] break

      if {$validation_errors != 0} {
        #my msg "$validation_errors errors in $form_fields"
        #foreach f $form_fields { my log "$f: [$f name] '[$f set value]' err: [$f error_msg] " }
        #
        # In case we are triggered internally, we might not have a 
        # a connection, so we don't present the form with the 
        # error messages again, but we return simply the validation
        # problems.
        #
        if {[$package_id exists __batch_mode]} {
          set errors [list]
          foreach f $form_fields { 
            if {[$f error_msg] ne ""} {
              lappend errors [list field [$f name] value [$f set value] error [$f error_msg]]
            }
          }
	  set evaluation_errors ""
	  if {[$package_id exists __evaluation_error]} {
	    set evaluation_errors "\nEvaluation error: [$package_id set __evaluation_error]"
	    $package_id unset __evaluation_error
	  }
          error "[llength $errors] validation error(s): $errors $evaluation_errors"
        }
        # reset the name in error cases to the original one
        my set name [my form_parameter __object_name]
      } else {
        #
        # we have no validation erros, so we can save the content
        #
        my save_data \
            -use_given_publish_date [expr {[lsearch $field_names _publish_date] > -1}] \
            [::xo::cc form_parameter __object_name ""] $category_ids

        # The data might have references. We render do the rendering here
        # instead on every view (which would be safer, but slower). This is
        # roughly the counterpart to edit_data and save_data in ad_forms.
        set content [my render  -update_references]
        #my msg "after save refs=[expr {[my exists references]?[my set references] : {NONE}}]"

	set redirect_method [my form_parameter __form_redirect_method "view"]
#my msg "__form_redir=$redirect_method" 
#my msg "__form params= [::xo::cc array get form_parameter]"
	if {$redirect_method eq "__none"} {
	  return
	} else {
	  set url [$package_id pretty_link -lang en [my name]]?m=$redirect_method
	  set return_url [$package_id get_parameter return_url $url]
	  # we had query_parameter here. however, to be able to
	  # process the output of ::xo::cc set_parameter ...., we
	  # changed it to "parameter".
	  #my msg "return_url=$return_url"
	  $package_id returnredirect $return_url
          return
	}
      }
    } else {
      # 
      # display the current values
      #

      if {[my is_new_entry [my name]]} {
	my set creator [::xo::get_user_name [::xo::cc user_id]]
	my set nls_language [ad_conn locale]
	#my set name [$package_id query_parameter name ""]
	# TODO: maybe use __object_name to for POST url to make code 
	# more straightworward
        #set n [$package_id query_parameter name \
	#	   [::xo::cc form_parameter __object_name ""]]
        #if {$n ne ""} { 
        #  my name $n 
        #}
      }

      array set __ia [my set instance_attributes]
      my load_values_into_form_fields $form_fields
      foreach f $form_fields {set ff([$f name]) $f }

      # for named entries, just set the entry fields to empty,
      # without changing the instance variables
      if {[my is_new_entry [my name]]} {
        if {$anon_instances} {
          set name [autoname new -name [$page_template name] -parent_id $page_template]
          #my msg "generated name=$name, page_template-name=[$page_template name]"
          $ff(_name) value $name
        } else {
          $ff(_name) value ""
        }
        if {![$ff(_title) istype ::xowiki::formfield::hidden]} {
	  $ff(_title) value ""
	}
        foreach var [list title detail_link text description] {
          if {[my exists_query_parameter $var]} {
            set value [my query_parameter $var]
            switch -- $var {
              detail_link {
                set f [my lookup_form_field -name $var $form_fields]
                $f value [$f convert_to_external $value]
              }
              title - text - description {
                set f [my lookup_form_field -name _$var $form_fields]
              }
            }
            $f value [$f convert_to_external $value]
          }
        }
      }
    }

    # some final sanity checks
    my form_fields_sanity_check $form_fields
    my post_process_form_fields $form_fields

    # The following command would be correct, but does not work due to a bug in 
    # tdom.
    # set form [my regsub_eval  \
    #              [template::adp_variable_regexp] $form \
    #              {my form_field_as_html -mode edit "\\\1" "\2" $form_fields}]
    # Due to this bug, we program around and replace the at-character 
    # by \x003 to avoid conflict withe the input and we replace these
    # magic chars finally with the fields resulting from tdom.

    set form [string map [list @ \x003] $form]
    #my msg form=$form

    dom parse -simple -html $form doc
    $doc documentElement root

    ::require_html_procs
    $root firstChild fcn
    #
    # prepend some fields above the HTML contents of the form
    #
    $root insertBeforeFromScript {
      ::html::input -type hidden -name __object_name -value [my name]
      ::html::input -type hidden -name __form_action -value save-form-data

      # insert automatic form fields on top 
      foreach att $field_names {
        #if {$formgiven && ![string match _* $att]} continue
        if {[my exists __field_in_form($att)]} continue
        set f [my lookup_form_field -name $att $form_fields]
	#my msg "insert auto_field $att"
        $f render_item
      }
    } $fcn
    #
    # append some fields after the HTML contents of the form 
    #
    set submit_button_class ""
    set has_file 0
    $root appendFromScript {    
      # append category fields
      foreach f $form_fields {
        #my msg "[$f name]: is wym? [$f has_instance_variable editor wym]"
        if {[string match "__category_*" [$f name]]} {
          $f render_item
        } elseif {[$f has_instance_variable editor wym]} {
          set submit_button_class "wymupdate"
        }
        if {[$f has_instance_variable type file]} {
          set has_file 1
        }
      }

      # insert unreported errors 
      foreach f $form_fields {
        if {[$f set error_msg] ne "" && ![$f exists error_reported]} {
          $f render_error_msg
        }
      }
      # add a submit field(s) at bottom
      my render_form_action_buttons -CSSclass $submit_button_class
    }

    set form [lindex [$root selectNodes //form] 0]
    if {$form eq ""} {
      my msg "no form found in page [$page_template name]"
    } else {
      if {[my exists_query_parameter "return_url"]} {
	set return_url [my query_parameter "return_url"]
      }
      set url [export_vars -base [$package_id pretty_link [my name]] {{m "edit"} return_url}] 
      $form setAttribute action $url method POST
      if {$has_file} {$form setAttribute enctype multipart/form-data}
      Form add_dom_attribute_value $form class "margin-form"
    }
    my set_form_data $form_fields
    if {$disable_input_fields} {
      # (a) disable explicit input fields
      foreach f $form_fields {$f disabled disabled}
      # (b) disable input in HTML-specified fields
      Form dom_disable_input_fields $root
    }
    my post_process_dom_tree $doc $root $form_fields
    set html [$root asHTML]
    set html [my regsub_eval  \
                  {(^|[^\\])\x003([a-zA-Z0-9_:]+)\x003} $html \
                  {my form_field_as_html -mode edit "\\\1" "\2" $form_fields}]

    #my log "calling VIEW with HTML [string length $html]"
    if {$view} {
      my view $html
    } else {
      return $html
    }
  }


  FormPage instproc post_process_form_fields {form_fields} {
    # We offer here the possibility to iterate over the form fields before it
    # before they are rendered
  }

  FormPage instproc post_process_dom_tree {dom_doc dom_root form_fields} {
    # Part of the input fields comes from HTML, part comes via $form_fields
    # We offer here the possibility to iterate over the dom tree before it
    # is presented; can be overloaded
  }

  File instproc download {} {
    my instvar mime_type package_id
    $package_id set mime_type $mime_type
    set use_bg_delivery [expr {![catch {ns_conn contentsentlength}] && 
                               [info command ::bgdelivery] ne ""}]
    $package_id set delivery \
        [expr {$use_bg_delivery ? "ad_returnfile_background" : "ns_returnfile"}]
    if {[my exists_query_parameter filename]} {
      set filename [my query_parameter filename]
      ns_set put [ns_conn outputheaders] Content-Disposition "attachment;filename=$filename"
    }
    #my log "--F FILE=[my full_file_name]"
    return [my full_file_name]
  }

  Page instproc revisions {} {
    my instvar package_id name item_id
    set context [list [list [$package_id url] $name ] [_ xotcl-core.revisions]]
    set title "[_ xotcl-core.revision_title] '$name'"
    ::xo::Page set_property doc title $title
    set content [next]
    array set property_doc [::xo::Page get_property doc]
    $package_id return_page -adp /packages/xowiki/www/revisions -variables {
      content context {page_id $item_id} title property_doc
    }
  }

  Page instproc make-live-revision {} {
    my instvar revision_id item_id package_id
    #my log "--M set_live_revision($revision_id)"
    ::xo::db::sql::content_item set_live_revision -revision_id $revision_id
    set page_id [my query_parameter "page_id"]
    ::xo::clusterwide ns_cache flush xotcl_object_cache ::$item_id
    ::$package_id returnredirect [my query_parameter "return_url" \
              [export_vars -base [$package_id url] {{m revisions}}]]
  }
  

  Page instproc delete-revision {} {
    my instvar revision_id package_id item_id 
    db_1row [my qn get_revision] "select latest_revision,live_revision from cr_items where item_id = $item_id"
    # do real deletion via package
    $package_id delete_revision -revision_id $revision_id -item_id $item_id
    # Take care about UI specific stuff....
    set redirect [my query_parameter "return_url" \
                      [export_vars -base [$package_id url] {{m revisions}}]]
    if {$live_revision == $revision_id} {
      # latest revision might have changed by delete_revision, so we have to fetch here
      db_1row [my qn get_revision] "select latest_revision from cr_items where item_id = $item_id"
      if {$latest_revision eq ""} {
        # we are out of luck, this was the final revision, delete the item
        my instvar package_id name
        $package_id delete -name $name -item_id $item_id
      } else {
        ::xo::db::sql::content_item set_live_revision -revision_id $latest_revision
      }
    }
    if {$latest_revision ne ""} {
      # otherwise, "delete" did already the redirect
      ::$package_id returnredirect [my query_parameter "return_url" \
                                      [export_vars -base [$package_id url] {{m revisions}}]]
    }
  }

  Page instproc delete {} {
    my instvar package_id item_id name

    # delete always via package
    $package_id delete -item_id $item_id -name $name

    #[my info class] delete -item_id $item_id
    #::$package_id flush_references -item_id $item_id -name $name
    #::$package_id returnredirect \
#	[my query_parameter "return_url" [$package_id package_url]]
  }

  Page instproc save-tags {} {
    my instvar package_id item_id revision_id
    ::xowiki::Page save_tags \
	-user_id [::xo::cc user_id] \
	-item_id $item_id \
	-revision_id $revision_id \
        -package_id $package_id \
	[my form_parameter new_tags]

    ::$package_id returnredirect \
        [my query_parameter "return_url" [$package_id url]]
  }

  Page instproc popular-tags {} {
    my instvar package_id item_id parent_id
    set limit       [my query_parameter "limit" 20]
    set weblog_page [$package_id get_parameter weblog_page weblog]
    set href        [$package_id pretty_link $weblog_page]?summary=1

    set entries [list]
    db_foreach [my qn get_popular_tags] \
        [::xo::db::sql select \
	     -vars "count(*) as nr, tag" \
	     -from "xowiki_tags" \
	     -where "item_id=$item_id" \
	     -groupby "tag" \
	     -orderby "nr" \
	     -limit $limit] {
           lappend entries "<a href='$href&ptag=[ad_urlencode $tag]'>$tag ($nr)</a>"
         }
    ns_return 200 text/html "[_ xowiki.popular_tags_label]: [join $entries {, }]"
  }

  Page instproc diff {} {
    my instvar package_id

    set compare_id [my query_parameter "compare_revision_id" 0]
    if {$compare_id == 0} {
      return ""
    }
    ::xo::Page requireCSS /resources/xowiki/xowiki.css
    set my_page [::xowiki::Package instantiate_page_from_id -revision_id [my revision_id]]
    $my_page volatile

    if {[catch {set html1 [$my_page render]} errorMsg]} {
      set html2 "Error rendering [my revision_id]: $errorMsg"
    }
    set text1 [ad_html_text_convert -from text/html -to text/plain -- $html1]
    set user1 [::xo::get_user_name [$my_page set creation_user]]
    set time1 [$my_page set creation_date]
    set revision_id1 [$my_page set revision_id]
    regexp {^([^.]+)[.]} $time1 _ time1

    set other_page [::xowiki::Package instantiate_page_from_id -revision_id $compare_id]
    $other_page volatile
    #$other_page absolute_links 1

    if {[catch {set html2 [$other_page render]} errorMsg]} {
      set html2 "Error rendering $compare_id: $errorMsg"
    }
    set text2 [ad_html_text_convert -from text/html -to text/plain -- $html2]
    set user2 [::xo::get_user_name [$other_page set creation_user]]
    set time2 [$other_page set creation_date]
    set revision_id2 [$other_page set revision_id]
    regexp {^([^.]+)[.]} $time2 _ time2

    set title "Differences for [my set name]"
    set context [list $title]
    
    # try util::html diff if it is available and works
    if {[catch {set content [::util::html_diff -old $html2 -new $html1 -show_old_p t]}]} {
      # otherwise, fall back to proven text based diff
      set content [::xowiki::html_diff $text2 $text1]
    }

    ::xo::Page set_property doc title $title
    array set property_doc [::xo::Page get_property doc]
    set header_stuff [::xo::Page header_stuff]

    $package_id return_page -adp /packages/xowiki/www/diff -variables {
      content title context header_stuff
      time1 time2 user1 user2 revision_id1 revision_id2 property_doc
    }
  }

  proc html_diff {doc1 doc2} {
    set out ""
    set i 0
    set j 0
    
    #set lines1 [split $doc1 "\n"]
    #set lines2 [split $doc2 "\n"]
    
    regsub -all \n $doc1 " <br />" doc1
    regsub -all \n $doc2 " <br />" doc2
    set lines1 [split $doc1 " "]
    set lines2 [split $doc2 " "]
    
    foreach { x1 x2 } [list::longestCommonSubsequence $lines1 $lines2] {
      foreach p $x1 q $x2 {
        while { $i < $p } {
          set l [lindex $lines1 $i]
          incr i
          #puts "R\t$i\t\t$l"
          append out "<span class='removed'>$l</span>\n"
        }
        while { $j < $q } {
          set m [lindex $lines2 $j]
          incr j
          #puts "A\t\t$j\t$m"
          append out "<span class='added'>$m</span>\n"
        }
        set l [lindex $lines1 $i]
        incr i; incr j
        #puts "B\t$i\t$j\t$l"
      append out "$l\n"
      }
    }
    while { $i < [llength $lines1] } {
      set l [lindex $lines1 $i]
      incr i
      puts "$i\t\t$l"
      append out "<span class='removed'>$l</span>\n"
    }
    while { $j < [llength $lines2] } {
      set m [lindex $lines2 $j]
      incr j
      #puts "\t$j\t$m"
      append out "<span class='added'>$m</span>\n"
    }
    return $out
  }


#   Page instproc new_name {name} {
#     if {$name ne ""} {
#       my instvar package_id
#       set name [my complete_name $name]
#       set name [::$package_id normalize_name $name]
#       set suffix ""; set i 0
#       set folder_id [my parent_id]
#       while {[::xo::db::CrClass lookup -name $name$suffix -parent_id $folder_id] != 0} {
#         set suffix -[incr i]
#       }
#       set name $name$suffix
#     }
#     return $name
#   }

  PageTemplate instproc delete {} {
    my instvar package_id item_id name
    set count [my count_usages -all true]
    #my msg count=$count
    if {$count > 0} {
      append error_msg \
          [_ xowiki.error-delete_entries_first [list count $count]] \
          <p> \
          [my include [list form-usages -all true -form_item_id [my item_id]]] \
          </p>
      $package_id error_msg $error_msg
    } else {
      next
    }
  }

  Page instproc default_instance_attributes {} {
    #
    # Provide the default list of instance attributes to derived
    # FormPages.
    #
    # We want to be able to create FormPages from all pages.
    # by defining this method, we allow derived applications
    # to provide their own set of instance attributes
    return [list]
  }

  Page instproc create-new {{-view_method edit}} {
    my instvar package_id
    set instance_attributes [my default_instance_attributes]
    set original_package_id $package_id

    if {[my exists_query_parameter "package_instance"]} {
      set package_instance [my query_parameter "package_instance"]
      #
      # Initialize the target package and set the local
      # variable package_id.
      #
      if {[catch {
        ::xowiki::Package initialize \
            -url $package_instance -user_id [::xo::cc user_id] \
            -actual_query ""} errorMsg]} {
        ns_log error "$errorMsg\n$::errorInfo"
        return [$original_package_id error_msg \
                    "Page <b>'[my name]'</b> invalid provided package instance=$package_instance<p>$errorMsg</p>"]
      }
      my parent_id [$package_id folder_id]
    }
    set f [FormPage new -destroy_on_cleanup \
               -name "" \
               -package_id $package_id \
               -parent_id [my parent_id] \
               -nls_language [my nls_language] \
               -publish_status "production" \
               -instance_attributes $instance_attributes \
               -page_template [my item_id]]

    if {[my exists state]} {
      $f set state [my set state]
    }

    # Call the application specific initialization, when a FormPage is
    # initially created. This is used to control the life-cycle of
    # FormPages.
    $f initialize

    #
    # if we copy an item, we use source_item_id to provide defaults
    #
    set source_item_id [my query_parameter source_item_id ""]
    if {$source_item_id ne ""} {
      set source [FormPage get_instance_from_db -item_id $source_item_id]
      $f copy_content_vars -from_object $source
      set name "[::xowiki::autoname generate -parent_id $source_item_id -name [my name]]"
      $package_id get_lang_and_name -name $name lang name
      $f set name $name
      #my msg nls=[$f nls_language],source-nls=[$source nls_language]
    } else {
      #
      # set some default values from query parameters
      #
      foreach key {name title page_order last_page_id} {
	if {[my exists_query_parameter $key]} {
	  $f set $key [my query_parameter $key]
	}
      }
    }
    $f set __title_prefix [my title]

    $f save_new
    if {[my exists_query_parameter "return_url"]} {
      set return_url [my query_parameter "return_url"]
    }
    if {[my exists_query_parameter "template_file"]} {
      set template_file [my query_parameter "template_file"]
    }
    foreach var {return_url template_file title detail_link text} {
      if {[my exists_query_parameter $var]} {
        set $var [my query_parameter $var]
      }
    }

    $package_id returnredirect \
        [export_vars -base [$package_id pretty_link [$f name]] \
	     [list [list m $view_method] return_url name template_file title detail_link text]]

  }


  if {[apm_version_names_compare [ad_acs_version] 5.3.0] == 1} {
    ns_log notice "Zen-state: 5.3.2 or newer"
    Form set extraCSS ""
  } else {
    ns_log notice "Zen-state: pre 5.3.1, use backward compatible form css file"
    Form set extraCSS "zen-forms-backward-compatibility.css"
  }
  Form proc requireFormCSS {} {
    #my msg requireFormCSS
    set css [my set extraCSS]
    if {$css ne ""} {
      ::xo::Page requireCSS $css
    }
  }

}
