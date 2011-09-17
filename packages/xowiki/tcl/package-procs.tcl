ad_library {
    XoWiki - package specific methods

    @creation-date 2006-10-10
    @author Gustaf Neumann
    @cvs-id $Id: package-procs.tcl,v 1.151.2.5 2011/02/11 08:13:35 gustafn Exp $
}

namespace eval ::xowiki {

  ::xo::PackageMgr create ::xowiki::Package \
      -superclass ::xo::Package \
      -pretty_name "XoWiki" \
      -package_key xowiki \
      -parameter {
	{folder_id 0}
	{force_refresh_login false}
      }
  # {folder_id "[::xo::cc query_parameter folder_id 0]"}

  Package ad_proc instantiate_page_from_id {
    {-revision_id 0} 
    {-item_id 0}
    {-user_id -1}
    {-parameter ""}
  } {
    Instantiate a page in situations, where the context is not set up
    (e.g. we have no package object or folder obect). This call is convenient
    when testing e.g. from the developer shell
  } {
    #TODO can most probably further simplified
    set page [::xo::db::CrClass get_instance_from_db -item_id $item_id -revision_id $revision_id]

    #my log "--I get_instance_from_db i=$item_id revision_id=$revision_id page=$page"

    set folder_id [$page set parent_id] 
    if {[apm_version_names_compare [ad_acs_version] 5.2] <= -1} {
      set package_id [db_string [my qn get_pid] \
                          "select package_id from cr_folders where folder_id = $folder_id"]
      $page package_id $package_id
    } else {
      set package_id [$page set package_id]
    }
    ::xowiki::Package initialize \
	-package_id $package_id -user_id $user_id \
	-parameter $parameter -init_url false -actual_query ""
    ::$package_id set_url -url [::$package_id pretty_link [$page name]]
    return $page
  }

  Package ad_proc get_url_from_id {{-item_id 0} {-revision_id 0}} {
    Get the full URL from a page in situations, where the context is not set up.
    @see instantiate_page_from_id
  } {
    set page [::xowiki::Package instantiate_page_from_id \
                  -item_id $item_id -revision_id $revision_id]
    $page volatile
    return [::[$page package_id] url] 
  }

  #
  # URL and naming management
  #
  Package instproc normalize_name {string} {
    set string [string trim $string]
    regsub -all \# $string _ string
    # if subst_blank_in_name is turned on, turn spaces into _
    if {[my get_parameter subst_blank_in_name 1] != 0} {
      regsub -all { +} $string "_" string
    }
      return [ns_urldecode $string]
  }

  Package instproc default_locale {} {
    if {[my get_parameter use_connection_locale 0]} {
      # we return the connection locale (if not connected the system locale)
      set locale [::xo::cc locale]
    } else {
      # return either the package locale or the site-wide locale
      set locale [lang::system::locale -package_id [my id]]
    }
    return $locale
  }
  
  Package instproc default_language {} {
    return [string range [my default_locale] 0 1]
  }

  Package array set www-file {
    admin 1
    diff 1
    doc 1
    edit 1
    error-template 1
    portlet 1     portlet-ajax 1  portlets 1
    prototypes 1 
    ressources 1
    revisions 1 
    view-default 1 view-links 1 view-plain 1 oacs-view 1 oacs-view2 1 oacs-view3 1
    download 1
  }
  
  Package instproc get_lang_and_name {-path -name {-default_lang ""} vlang vlocal_name} {
    my upvar $vlang lang $vlocal_name local_name 
    if {[info exists path]} {
      # 
      # Determine lang and name from a path with slashes
      #
      if {[regexp {^pages/(..)/(.*)$} $path _ lang local_name]} {
      } elseif {[regexp {^(..)/(.*)$} $path _ lang local_name]} {
      } elseif {[regexp {^(..):(.*)$} $path _ lang local_name]} {
      } elseif {[regexp {^(file|image|swf|download/file|tag)/(.*)$} $path _ lang local_name]} {
      } else {
        set local_name $path
        if {$default_lang eq ""} {set default_lang [my default_language]}
        set lang $default_lang
      }
    } elseif {[info exists name]} {
      # 
      # Determine lang and name from a names as it stored in the database
      #
      if {![regexp {^(..):(.*)$} $name _ lang local_name]} {
        if {![regexp {^(file|image|swf):(.*)$} $name _ lang local_name]} {
          set local_name $name
          if {$default_lang eq ""} {set default_lang [my default_language]}
          set lang $default_lang
        }
      }
    }
  }
  
  Package instproc get_parent_and_name {-path -folder_id vparent vlocal_name} {
    my upvar $vparent parent $vlocal_name local_name 

    if {[regexp {^([^/]+)/(.*)$} $path _ parent local_name]} {
      set p [::xo::db::CrClass lookup -name $parent -parent_id $folder_id]
      if {$p != 0} { return $p }
    }
    set parent ""
    set local_name $path
    return $folder_id
  }

  Package instproc folder_path {{-parent_id ""}} {
    #
    # handle different parent_ids
    #
    if {$parent_id ne "" && $parent_id != [my folder_id]} {
      if {[::xo::db::sql::content_folder is_folder -item_id $parent_id]} {
        return ""
      } else {
        ::xo::db::CrClass get_instance_from_db -item_id $parent_id
        return [$parent_id name]/
      }
    } else {
      return ""
    }
  }
    

  Package ad_instproc external_name {
    {-parent_id ""}
    name 
  } {
    Generate a name with a potentially inserted parent name

    @param parent_id parent_id (for now just for download)
    @param name name of the wiki page
  } {
    if {[regexp {^::[0-9]+$} $name]} {
      # Special rule for folder objects. Folder object will be most
      # probably removed in future releases.
      return $name
    } 
    set folder [my folder_path -parent_id $parent_id]
    if {$folder ne ""} {
      # Return the stripped name for sub-items, the parent has already
      # the language prefix
      my get_lang_and_name -name $name lang stripped_name
      return $folder$stripped_name
    }
    return $name

  }

  Package ad_instproc pretty_link {
    {-anchor ""} 
    {-absolute:boolean false} 
    {-siteurl ""}
    {-lang ""} 
    {-parent_id ""}
    {-download false} 
    name 
  } {
    Generate a (minimal) link to a wiki page with the specified name.
    Pratically all links in the xowiki systems are generated through this
    function. 

    @param anchor anchor to be added to the link
    @param absolute make an absolute link (including protocol and host)
    @param lang use the specified 2 character language code (rather than computing the value)
    @param download create download link (without m=download)
    @param parent_id parent_id (for now just for download)
    @param name name of the wiki page
  } {
    #my msg "input name=$name, lang=$lang"
    set default_lang [my default_language]
    
    my get_lang_and_name -default_lang $lang -name $name lang name

    set host [expr {$absolute ? ($siteurl ne "" ? $siteurl : [ad_url]) : ""}]
    if {$anchor ne ""} {set anchor \#$anchor}
    #my log "--LINK $lang == $default_lang [expr {$lang ne $default_lang}] $name"
    set package_prefix [my get_parameter package_prefix [my package_url]]
    if {$package_prefix eq "/" && [string length $lang]>2} {
      # don't compact the the path for images etc. to avoid conflicts
      # with e.g. //../image/*
      set package_prefix [my package_url]
    }
    #my msg "lang=$lang, default_lang=$default_lang, name=$name"

    set encoded_name [string map [list %2d - %5f _ %2e .] [ns_urlencode $name]]
    set folder [my folder_path -parent_id $parent_id]

    #my msg "h=${host}, prefix=${package_prefix}, folder=$folder, name=$encoded_name anchor=$anchor"
    if {$download} {
      #
      # use the special download (file) syntax
      #
      set url ${host}${package_prefix}download/file/$folder$encoded_name$anchor
    } elseif {$lang ne $default_lang || [[self class] exists www-file($name)]} {
      #
      # If files are physical files in the www directory, add the
      # language prefix
      #
      set url ${host}${package_prefix}$folder${lang}/$encoded_name$anchor
    } else {
      #
      # Use the short notation without language prefix
      #
      set url ${host}${package_prefix}$folder$encoded_name$anchor
    }
    #my msg "final url=$url"
    return $url
  }

  Package instproc init {} {
    #my log "--R creating + folder_object"
    next
    my require_folder_object
    my set policy [my get_parameter -check_query_parameter false security_policy ::xowiki::policy1]
    #my proc destroy {} {my log "--P "; next}
  }

  Package ad_instproc get_parameter {{-check_query_parameter true} attribute {default ""}} {
    resolves configurable parameters according to the following precedence:
    (1) values specifically set per page {{set-parameter ...}}
    (2) query parameter
    (3) form fields from the parameter_page FormPage
    (4) per instance parameters from the folder object (computable)
    (5) standard OpenACS package parameter
  } {
    set value [::xo::cc get_parameter $attribute]
    if {$check_query_parameter && $value eq ""} {set value [my query_parameter $attribute]}
    if {$value eq "" && $attribute ne "parameter_page"} {
      #
      # Try to get the parameter from the parameter_page.  We have to
      # be very cautious here to avoid recursive calls (e.g. when
      # resolve_page_name needs as well parameters such as
      # use_connection_locale or subst_blank_in_name, etc.).
      #
      set pp [my get_parameter parameter_page ""]
      if {$pp ne ""} {
        if {![regexp {/?..:} $pp]} {
          my log "Error: Name of parameter page '$pp' of package [my id] must contain a language prefix"
        } else {
          set page [::xo::cc cache [list [self] resolve_page_name $pp]]
          if {$page eq ""} {
            my log "Error: Could not resolve parameter page '$pp' of package [my id]."
          }
          if {$page ne "" && [$page exists instance_attributes]} {
            array set __ia [$page set instance_attributes]
            if {[info exists __ia($attribute)]} {
              set value $__ia($attribute)
              #my log "got value='$value'"
            }
          }
        }
      }
    }
    if {$value eq ""} {set value [::[my folder_id] get_payload $attribute]}
    if {$value eq ""} {set value [next $attribute $default]}
    #my log "           $attribute returns '$value'"
    return $value
  }

  Package instproc resolve_page_name {page_name} {
    #
    # This is a very simple version for resolving page names in an
    # package instance.  It can be called either a plain page name
    # with a language prefix (as stored in the CR) for the current
    # package, or with a path (starting with a //) pointing to an
    # xowiki instance followed by the page name.
    #
    # Examples
    #    ... resolve_page_name en:index
    #    ... resolve_page_name //xowiki/en:somepage
    #
    # The method returns either the page object or empty ("").
    #
    set package_id [my id]
    if {[regexp {^/(/[^/]+/)(.*)$} $page_name _ url page_name]} {
      array set "" [site_node::get_from_url -url $url]
      if {$(package_id) eq ""} {return ""}
      set package_id $(package_id)
      ::xowiki::Package require $package_id
    }
    #my log "final resolve $package_id '$page_name'"
    return [$package_id resolve_request -simple true -path $page_name method_var]
  }

  Package instproc resolve_page_name_and_init_context {{-lang} page_name} {
    set page ""
    #
    # take a local copy of the package_id, since it is possible
    # that the variable package_id might changed to another instance.
    #
    set package_id [my id]
    if {[regexp {^/(/.+)$} $page_name _ url]} {
      #
      # Handle cross package resolve requests
      #
      # Note, that package::initialize might change the package id.
      # Preserving the package-url is just necessary, if for some
      # reason the same package is initialized here with a different 
      # url. This could be done probably with a flag to initialize,
      # but we get below the object name from the package_id...
      #
      #my log "cross package request $page_name"
      #
      set last_package_id $package_id
      set last_url [my url]
      #
      # TODO: We assume here that the package is an xowiki package.
      #       The package might be as well a subclass of xowiki...
      #       For now, we fixed the problem to perform reclassing in
      #       ::xo::Package init and calling a per-package instance 
      #       method "initialize"
      #
      ::xowiki::Package initialize -parameter {{-m view}} -url $url \
          -actual_query ""
      #my log "url=$url=>[$package_id serialize]"
      
      if {$package_id != 0} {
        #
        # For the resolver, we create a fresh context to avoid recursive loops, when
        # e.g. revision_id is set through a query parameter...
        #
        set last_context [expr {[$package_id exists context] ? [$package_id context] : "::xo::cc"}]
        $package_id context [::xo::Context new -volatile]
        set object_name [$package_id set object]
        #my log "cross package request got object=$object_name"
        #
        # A user might force the language by preceding the
        # name with a language prefix.
        #
        #my log "check '$object_name' for lang prefix"
        if {![regexp {^..:} $object_name]} {
          if {![info exists lang]} {
            set lang [my default_language]
          }
          set object_name ${lang}:$object_name
        }
        set page [$package_id resolve_page -simple true $object_name __m]
        $package_id context $last_context
      }
      $last_package_id set_url -url $last_url
      
    } else {
      # It is not a cross package request
      set last_context [expr {[$package_id exists context] ? [$package_id context] : "::xo::cc"}]
      $package_id context [::xo::Context new -volatile]
      set page [$package_id resolve_page -lang $lang $page_name __m]
      $package_id context $last_context
    }
    #my log "returning $page"
    return $page
  }


  Package instproc show_page_order {} {
    return [my get_parameter display_page_order 1]
  }

  #
  # conditional links
  #
  Package ad_instproc make_link {{-with_entities 0} -privilege -link object method args} {
    Creates conditionally a link for use in xowiki. When the generated link 
    will be activated, the specified method of the object will be invoked.
    make_link checks in advance, wether the actual user has enough 
    rights to invoke the method. If not, this method returns empty.
       
    @param Object The object to which the link refers to. If it is a package_id it will base \
        to the root_url of the package_id. If it is a page, it will base to the page_url
    @param method Which method to use. This will be appended as "m=method" to the url. 

    Examples for methods:
     <ul>
     <li>view: To view and existing page</li>
     <li>edit: To edit an existing page</li>
     <li>revisions: To view the revisions of an existing page</li>
    </ul>

    @param args List of attributes to be append to the link. Every element 
    can be an attribute name, or a "name value" pair. Behaves like export_vars.

    @return The link or empty
    @see export_vars
  } {
    my instvar id

    set computed_link ""
    if {[$object istype ::xowiki::Package]} {
      set base  [my package_url]
      if {[info exists link]} {
        set computed_link [uplevel export_vars -base [list $base$link] [list $args]]
      } else {
        lappend args [list $method 1]
        set computed_link [uplevel export_vars -base [list $base] [list $args]]
        }
    } elseif {[$object istype ::xowiki::Page]} {
      if {[info exists link]} {
        set base $link
      } else {
        set base [my url]
      }
      lappend args [list m $method]
      set computed_link [uplevel export_vars -base [list $base] [list $args]]
    }
    if {$with_entities} {
      regsub -all & $computed_link "&amp;" computed_link
    }

    #set party_id [::xo::cc user_id]
    set party_id [::xo::cc set untrusted_user_id]
    if {[info exists privilege]} {
      #my log "-- checking priv $privilege for [self args]"
      set granted [expr {$privilege eq "public" ? 1 :
                         [::xo::cc permission -object_id $id -privilege $privilege -party_id $party_id] }]
    } else {
      # determine privilege from policy
      if {[catch {
	set granted [my check_permissions \
			 -user_id $party_id \
			 -package_id $id \
			 -link $computed_link $object $method]
      } errorMsg ]} {
	my log "error in check_permissions: $errorMsg"
	set granted 0
      }
      #my msg "--p $id check_permissions $object $method ==> $granted"
    }
    #my log "granted=$granted $computed_link"
    if {$granted} {
      return $computed_link
    }
    return ""
  }

  Package instproc create_new_snippet {
    {-object_type ::xowiki::Page}
    provided_name
  } {
    my get_lang_and_name -path $provided_name lang local_name
    set name ${lang}:$local_name
    set new_link [my make_link [my id] edit-new object_type return_url name] 
    if {$new_link ne ""} {
      return "<p>Do you want to create page <a href='$new_link'>$name</a> new?"
    } else {
      return ""
    }
  }


  Package instproc invoke {-method {-error_template error-template} {-batch_mode 0}} {
    set page [my resolve_page [my set object] method]
    #my log "--r resolve_page returned $page"
    if {$page ne ""} {
      if {[$page procsearch $method] eq ""} {
	return [my error_msg "Method <b>'$method'</b> is not defined for this object"]
      } else {
        #my msg "--invoke [my set object] id=$page method=$method" 
        if {$batch_mode} {[my id] set __batch_mode 1}
	set r [my call $page $method ""]
        if {$batch_mode} {[my id] unset __batch_mode}
        return $r
      }
    } else {
      # the requested page was not found, provide an error message and 
      # an optional link for creating the page
      set path [::xowiki::Includelet html_encode [my set object]]
      set edit_snippet [my create_new_snippet $path]
      return [my error_msg -template_file $error_template \
		  "Page <b>'$path'</b> is not available. $edit_snippet"]
    }
  }

  Package instproc error_msg {{-template_file error-template} error_msg} {
    my instvar id
    if {![regexp {^[./]} $template_file]} {
      set template_file /packages/xowiki/www/$template_file
    }
    set context [list [$id instance_name]]
    set title Error
    set header_stuff [::xo::Page header_stuff]
    set index_link [my make_link -privilege public -link "" $id {} {}]
    set link [my query_parameter "return_url" ""]
    if {$link ne ""} {set back_link $link}
    set top_includelets ""; set content $error_msg
    $id return_page -adp $template_file -variables {
      context title index_link back_link header_stuff error_msg 
      top_includelets content
    }
  }

  Package instproc resolve_page {{-simple false} -lang object method_var} {
    my log "resolve_page '$object'"
    upvar $method_var method
    my instvar folder_id id policy

    # get the default language if not specified
    if {![info exists lang]} {
      set lang [my default_language]
    }
    #
    # first, resolve package level methods
    #
    if {$object eq ""} {
      set exported [$policy defined_methods Package]
      foreach m $exported {
	#my log "--QP my exists_query_parameter $m = [my exists_query_parameter $m]"
        if {[my exists_query_parameter $m]} {
          set method $m  ;# determining the method, similar file extensions
          return [self]
        }
      }
    }
    
    if {[string match "//*" $object]} {
        # we have a reference to another instance, we cant resolve this from this package.
      # Report back not found
      return ""
    }

    #my log "--o object is '$object'"
    if {$object eq ""} {
      # we have no object, but as well no method callable on the package
      set object [$id get_parameter index_page "index"]
      #my log "--o object is now '$object'"
    }
    #
    # second, resolve object level methods
    #
    set page [my resolve_request -default_lang $lang -simple $simple -path $object method]
    #my msg "--o try '$object' -default_lang $lang -simple $simple returns '$page'"
    if {$simple || $page ne ""} {
      if {$page ne ""} {
      }
      return $page
    }
    #
    # Make a second attempt in the default language, if it is diffent
    # from the connection language. This is not optimal, since it is
    # just relevant for the cases, where the language was not
    # explicitely given. It would be nice to have e.g. a list of
    # language preferences which could be checked, but this would
    # require a different structure. The underlying methods are used
    # for two different cases: (a) complete an non-fully specified
    # entry, and (b) search whether such an entry exists. Not
    # undoable, but this should wait for the next release.
#     if {[::xo::cc lang] ne [my default_language]} {
#       set page [my resolve_request -default_lang [my default_language] -simple $simple -path $object method]
#       if {$simple || $page ne ""} {
#         if {$page ne ""} {
#         }
#         return $page
#       }
#     }

    # stripped object is the object without a language prefix
    set stripped_object $object
    regexp {^..:(.*)$} $object _ stripped_object

    # try standard page
    set standard_page [$id get_parameter ${object}_page]
    #my msg "--o standard_page '$standard_page'"
    if {$standard_page ne ""} {
      set page [my resolve_request -default_lang [::xo::cc lang] -path $standard_page method]
      if {$page ne ""} {
        return $page
      }

      # maybe we are calling from a different language, but the
      # standard page with en: was already instantiated
      set standard_page "en:$stripped_object"
      set page [my resolve_request -default_lang en -path $standard_page method]
      #my msg "resolve -default_lang en -path $standard_page returns --> $page"
      if {$page ne ""} {
        return $page
      }
    }

    # Maybe, a prototype page was imported with language en:, but the current language is different
    if {$lang ne "en"} {
      set page [my resolve_request -default_lang en -path $stripped_object method]
      #my msg "resolve -default_lang en -path $stripped_object returns --> $page"
      if {$page ne ""} {
	return $page
      }
    }

    #my msg "we have to import a prototype page for $stripped_object"
    set page [my import_prototype_page $stripped_object]
    if {$page eq ""} {
      my log "no prototype for '$object' found"
    }
    return $page
  }

  Package instproc import_prototype_page {{prototype_name ""}} {
    set page ""
    if {$prototype_name eq ""} {
      set prototype_name [my query_parameter import_prototype_page ""]
      set via_url 1
    }
    if {$prototype_name eq ""} {
      error "No name for prototype given"
    }
    set fn [get_server_root]/packages/[my package_key]/www/prototypes/$prototype_name.page
    #my log "--W check $fn"
    if {[file readable $fn]} {
      my instvar folder_id id
      # We have the file. We try to create an item or revision from 
      # definition in the file system.
      if {[regexp {^(..):(.*)$} $prototype_name _ lang local_name]} {
        set name $prototype_name
      } else {
        set name en:$prototype_name
      }
      #my log "--sourcing page definition $fn, using name '$name'"
      set page [source $fn]
      $page configure -name $name \
          -parent_id $folder_id -package_id $id 
      if {![$page exists title]} {
        $page set title $object
      }
      $page destroy_on_cleanup
      $page set_content [string trim [$page text] " \n"]
      $page initialize_loaded_object
      set item_id [::xo::db::CrClass lookup -name $name -parent_id $folder_id]
      if {$item_id == 0} {
        $page save_new
      } else {
        # get the page from the CR with all variables
        set p [::xo::db::CrClass get_instance_from_db -item_id $item_id]
        # copy all scalar variables from the prototype page 
        # into the instantiated page 
        foreach v [$page info vars] {
          if {[$page array exists $v]} continue ;# don't copy arrays
          $p set $v [$page set $v]
        }
        $p save
        set page $p
      }
    }
    if {[info exists via_url] && [my exists_query_parameter "return_url"]} {
      my returnredirect [my query_parameter "return_url" [my package_url]]
    }
    return $page
  }

  Package instproc call {object method options} {
    my instvar policy id
    set allowed [$policy enforce_permissions \
                     -package_id $id -user_id [::xo::cc user_id] \
                     $object $method]
    if {$allowed} {
      #my msg "--p calling $object ([$object info class]) '$method'"
      eval $object $method $options
    } else {
      my log "not allowed to call $object $method"
    }
  }
  Package instforward check_permissions {%my set policy} %proc

  Package instproc resolve_request {{-default_lang ""} {-simple false} -path method_var} {
    my instvar folder_id
    #my log "--u [self args]"
    [self class] instvar queryparm
    set item_id 0
    set parent_id $folder_id

    if {$path ne ""} {
      #
      # Try first a direct lookup of whatever we got
      #
      set item_id [::xo::db::CrClass lookup -name $path -parent_id $parent_id]
      if {$simple} {
        if {$item_id != 0} {
          return [::xo::db::CrClass get_instance_from_db -item_id $item_id]
        }
        return ""
      }

      #my log "--try $path ($folder_id/$parent_id) -> $item_id"
      if {$item_id == 0} {
        set nname [my normalize_name $path]
        
        my get_lang_and_name -default_lang $default_lang -path $nname lang stripped_name
        set name ${lang}:$stripped_name
        #my log "--setting name to '$name', stripped_name='$stripped_name'"

        if {$lang eq "download/file" || $lang eq "file"} { 
          # handle subitems, currently only for files
          set parent_id [my get_parent_and_name \
                             -path $stripped_name -folder_id $folder_id \
                             parent local_name]
	  set item_id [::xo::db::CrClass lookup -name file:$local_name -parent_id $parent_id]

	  if {$item_id != 0 && $lang eq "download/file"} {
	    upvar $method_var method
	    set method download
	  }
        } elseif {$lang eq "tag"} {
	  set tag $stripped_name
	  set summary [::xo::cc query_parameter summary 0]
	  set popular [::xo::cc query_parameter popular 0]
	  set tag_kind [expr {$popular ? "ptag" :"tag"}]
	  set weblog_page [my get_parameter weblog_page]
	  my get_lang_and_name -default_lang $default_lang -path $weblog_page lang stripped_name
	  set name $lang:$stripped_name
	  my set object $weblog_page
	  ::xo::cc set actual_query $tag_kind=$tag&summary=$summary
	}

        if {$item_id == 0} {
          set parent_id [my get_parent_and_name \
                             -path $name -folder_id $folder_id \
                             parent local_name]
          my get_lang_and_name -default_lang $default_lang -path $local_name lang stripped_name
          set item_id [::xo::db::CrClass lookup -name ${lang}:$stripped_name -parent_id $parent_id]
          #my log "--try  ${lang}:$stripped_name ($folder_id/$parent_id) -> $item_id"
        }

        if {$item_id == 0} {
          set item_id [::xo::db::CrClass lookup -name $stripped_name -parent_id $parent_id]
          #my log "--try $stripped_name ($folder_id/$parent_id) -> $item_id"
        }
       
      } 
    }

    if {$item_id != 0} {
      set revision_id [my query_parameter revision_id 0]
      set [expr {$revision_id ? "item_id" : "revision_id"}] 0
      #my log "--instantiate item_id $item_id revision_id $revision_id"
      set r [::xo::db::CrClass get_instance_from_db -item_id $item_id -revision_id $revision_id]
      #my log "--instantiate done  CONTENT\n[$r serialize]"
      $r set package_id [namespace tail [self]]
      return $r
    } else {
      return ""
    }
  }

  Package instproc require_folder_object { } {
    my instvar id folder_id
    #my msg "--f [my isobject ::$folder_id] folder_id=$folder_id"

    if {$folder_id == 0} {
      # TODO: we should make a parameter allowed_page_types (see content_types), 
      # but the package admin should not have necessarily the rights to change it
      set folder_id [::xowiki::Page require_folder \
			 -name xowiki -package_id $id \
			 -content_types ::xowiki::Page* ]
    }

    if {![::xotcl::Object isobject ::$folder_id]} {
      # if we can't get the folder from the cache, create it
      if {[catch {eval [nsv_get xotcl_object_cache ::$folder_id]}]} {
        while {1} {
          set item_id [ns_cache eval xotcl_object_type_cache item_id-of-$folder_id {
            set myid [::xo::db::CrClass lookup -name ::$folder_id -parent_id $folder_id]
            if {$myid == 0} break; # don't cache ID if invalid
            return $myid
          }]
          break
        }
        if {[info exists item_id]} {
          # we have a valid item_id and get the folder object
          #my log "--f fetch folder object -object ::$folder_id -item_id $item_id"
          ::xowiki::Object fetch_object -object ::$folder_id -item_id $item_id
        } else {
          # we have no folder object yet. so we create one...
          ::xowiki::Object create ::$folder_id
          ::$folder_id set text "# this is the payload of the folder object\n\n\
                #set index_page \"index\"\n"
          ::$folder_id set parent_id $folder_id
          ::$folder_id set name ::$folder_id
          ::$folder_id set title ::$folder_id
          ::$folder_id set package_id $id
          ::$folder_id set publish_status "production"
          ::$folder_id save_new
          ::$folder_id initialize_loaded_object

          if {[my get_parameter "with_general_comments" 0]} {
            # Grant automatically permissions to registered user to 
            # add to general comments to objects under the folder.
            permission::grant -party_id -2 -object_id $folder_id \
                -privilege general_comments_create
          }
        }
      }
      #my msg "--f new folder object = ::$folder_id"
      #::$folder_id proc destroy {} {my log "--f "; next}
      ::$folder_id set package_id $id
      ::$folder_id destroy_on_cleanup
    } else {
      #my log "--f reuse folder object $folder_id [::Serializer deepSerialize ::$folder_id]"
    }
    
    my set folder_id $folder_id
  }


  ###############################################################
  #
  # user callable methods on package level
  #

  Package ad_instproc reindex {} {
    reindex all items of this package
  } {
    my instvar folder_id
    set pages [db_list [my qn get_pages] "select page_id from xowiki_page, cr_revisions r, cr_items ci \
      where page_id = r.revision_id and ci.item_id = r.item_id and ci.parent_id = $folder_id \
      and ci.live_revision = page_id"]
    #my log "--reindex returns <$pages>"
    foreach page_id $pages {
      #search::queue -object_id $page_id -event DELETE
      search::queue -object_id $page_id -event INSERT
    }
  }

  #
  # Package import
  #

  Package ad_instproc import {-user_id -folder_id {-replace 0} -objects {-create_user_ids 0}} {
    import the specified pages into the xowiki instance
  } {
    if {![info exists folder_id]}  {set folder_id  [my folder_id]}
    if {![info exists user_id]}    {set user_id    [::xo::cc user_id]}
    if {![info exists objects]}    {set objects    [::xowiki::Page allinstances]}

    set msg "processing objects: $objects<p>"
    set importer [Importer new -package_id [my id] -folder_id $folder_id -user_id $user_id]
    $importer import_all -replace $replace -objects $objects -create_user_ids $create_user_ids
    append msg [$importer report]
  }

  #
  # RSS 2.0 support
  #
  Package ad_instproc rss {
    -maxentries
    -name_filter
    -entries_of
    -title
    -days 
  } {
    Report content of xowiki folder in rss 2.0 format. The
    reporting order is descending by date. The title of the feed
    is taken from the title, the description
    is taken from the description field of the folder object.
    
    @param maxentries maximum number of entries retrieved
    @param days report entries changed in speficied last days
    
  } {
    set package_id [my id]
    set folder_id [$package_id folder_id]
    if {![info exists namefilter]} {
      set name_filter  [my get_parameter name_filter ""]
    }
    if {![info exists entries_of]} {
      set entries_of [my get_parameter entries_of ""]
    }
    if {![info exists title]} {
      set title [my get_parameter title ""]
      if {$title eq ""} {
        set title [::$folder_id set title]
      }
    }

    if {![info exists days] && 
        [regexp {[^0-9]*([0-9]+)d} [my query_parameter rss] _ days]} {
      # setting the variable days
    } else {
      set days 10
    }
    
    set r [RSS new -destroy_on_cleanup \
	       -package_id [my id] \
	       -name_filter $name_filter \
               -entries_of $entries_of \
	       -title $title \
	       -days $days]
    
    #set t text/plain
    set t text/xml
    ns_return 200 $t [$r render]
  }

  #
  # Google sitemap support
  #

  Package ad_instproc google-sitemap {
    {-max_entries ""}
    {-changefreq "daily"}
    {-priority "0.5"}
  } {
    Report content of xowiki folder in google site map format
    https://www.google.com/webmasters/sitemaps/docs/en/protocol.html
    
    @param maxentries maximum number of entries retrieved
    @param package_id to determine the xowiki instance
    @param changefreq changefreq as defined by google
    @param priority priority as defined by google
    
  } {
    set package_id [my id]
    set folder_id [::$package_id folder_id]
   
    set timerange_clause ""
    
    set content {<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.google.com/schemas/sitemap/0.84"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.google.com/schemas/sitemap/0.84
	http://www.google.com/schemas/sitemap/0.84/sitemap.xsd">
}

    set sql [::xo::db::sql select \
                 -vars "s.body, p.name, p.creator, p.title, p.page_id,\
                p.object_type as content_type, p.last_modified, p.description" \
                 -from "xowiki_pagex p, syndication s, cr_items ci" \
                 -where "ci.parent_id = $folder_id and ci.live_revision = s.object_id \
              and s.object_id = p.page_id $timerange_clause" \
                 -orderby "p.last_modified desc" \
                 -limit $max_entries]
    #my log $sql
    db_foreach [my qn get_pages] $sql {
      #my log "--found $name"
      if {[string match "::*" $name]} continue
      if {$content_type eq "::xowiki::PageTemplate::"} continue
      
      set time [::xo::db::tcl_date $last_modified tz]
      set time "[clock format [clock scan $time] -format {%Y-%m-%dT%T}]${tz}:00"

      append content <url> \n\
          <loc>[::$package_id pretty_link -absolute true $name]</loc> \n\
          <lastmod>$time</lastmod> \n\
          <changefreq>$changefreq</changefreq> \n\
          <priority>$priority</priority> \n\
          </url> \n
    }
    
    append content </urlset> \n

    #set t text/plain
    set t text/xml
    ns_return 200 $t $content
  }

  Package ad_proc google-sitemapindex {
    {-changefreq "daily"}
    {-priority "priority"}
  } {
    Provide a sitemap index of all xowiki instances in google site map format
    https://www.google.com/webmasters/sitemaps/docs/en/protocol.html
    
    @param maxentries maximum number of entries retrieved
    @param package_id to determine the xowiki instance
    @param changefreq changefreq as defined by google
    @param priority priority as defined by google
    
  } {
  
    set content {<?xml version="1.0" encoding="UTF-8"?>
<sitemapindex xmlns="http://www.google.com/schemas/sitemap/0.84">
}
    foreach package_id  [::xowiki::Package instances] {
      if {![::xo::parameter get -package_id $package_id \
	       -parameter include_in_google_sitemap_index -default 1]} {
	continue
      } 
      set last_modified [db_string [my qn get_newest_modification_date] \
                             "select last_modified from acs_objects where package_id = $package_id \
		order by last_modified desc limit 1"]

      set time [::xo::db::tcl_date $last_modified tz]
      set time "[clock format [clock scan $time] -format {%Y-%m-%dT%T}]${tz}:00"

      #my log "--site_node::get_from_object_id -object_id $package_id"
      array set info [site_node::get_from_object_id -object_id $package_id]

      append content <sitemap> \n\
          <loc>[ad_url]$info(url)sitemap.xml</loc> \n\
          <lastmod>$time</lastmod> \n\
          </sitemap> 
    }
    append content </sitemapindex> \n
    #set t text/plain
    set t text/xml
    ns_return 200 $t $content
  }

  Package instproc google-sitemapindex {} {
    [self class] [self proc]
  }

  Package instproc edit-new {} {
    my instvar folder_id id
    set object_type [my query_parameter object_type "::xowiki::Page"]
    set autoname [my get_parameter autoname 0]
    set page [$object_type new -volatile -parent_id $folder_id -package_id $id]

    if {$object_type eq "::xowiki::PageInstance"} {
      #
      # If we create a PageInstance via the ad_form based
      # PageInstanceForm, we have to provide the page_template here to
      # be able to validate the name, where "build_name" needs
      # access to the ::xowiki::PageTemplate of the
      # ::xowiki::PageInstance.
      #
      $page set page_template [my form_parameter page_template]
    }

    set source_item_id [$id query_parameter source_item_id ""]
    if {$source_item_id ne ""} {
      set source [$object_type get_instance_from_db -item_id $source_item_id]
      $page copy_content_vars -from_object $source
      set name "[::xowiki::autoname generate -parent_id $source_item_id -name [$source name]]"
      my get_lang_and_name -name $name lang name
      $page set name $name
      my msg nls=[$page nls_language],source-nls=[$source nls_language],page=$page,name=$name
    } else {
      $page set name ""
    }

    return [$page edit -new true -autoname $autoname]
  }

  Package instproc flush_references {-item_id:integer,required -name:required -parent_id} {
    my instvar folder_id id
    if {![info exists parent_id]} {set parent_id $folder_id}
    if {$name eq "::$folder_id"} {
      #my log "--D deleting folder object ::$folder_id"
      ::xo::clusterwide ns_cache flush xotcl_object_cache ::$folder_id
      ::xo::clusterwide ns_cache flush xotcl_object_type_cache item_id-of-$folder_id
      ::xo::clusterwide ns_cache flush xotcl_object_type_cache root_folder-$id
      ::$folder_id destroy
    }
    my flush_name_cache -name $name -parent_id $parent_id
  }

  Package instproc flush_name_cache {-name:required -parent_id:required} {
    # Different machines in the cluster might have different entries in their caches.
    # Since we use wild-cards to find these, it has to be done on every machine
    ::xo::clusterwide xo::cache_flush_all xowiki_cache link-*-$name-$parent_id
    ::xo::clusterwide ns_cache flush xotcl_object_type_cache $parent_id-$name
  }

  Package instproc delete_revision {-revision_id:required -item_id:required} {
    ::xo::clusterwide ns_cache flush xotcl_object_cache ::$item_id
    ::xo::clusterwide ns_cache flush xotcl_object_cache ::$revision_id
    ::xo::db::sql::content_revision del -revision_id $revision_id
  }

  Package instproc delete {-item_id -name} {
    #
    # This delete method does not require an instanantiated object,
    # while the class-specific delete methods in xowiki-procs need these.
    # If a (broken) object can't be instantiated, it cannot be deleted.
    # Therefore we need this package level delete method. 
    # While the class specific methods are used from the
    # application pages, the package_level method is used from the admin pages.
    #
    my instvar folder_id id
    #
    # if no item_id given, take it from the query parameter
    #
    if {![info exists item_id]} {
      set item_id [my query_parameter item_id]
      #my log "--D item_id from query parameter $item_id"
    }
    #
    # if name given, take it from the query parameter
    #
    if {![info exists name]} {
      set name [my query_parameter name]
    }
    if {$item_id eq "" && $name ne ""} {
      if {[set item_id [::xo::db::CrClass lookup -name $name -parent_id $folder_id]] == 0} {
        ns_log notice "lookup of '$name' failed"
        set item_id ""
      }
    }
    if {$item_id ne ""} {
      #my log "--D trying to delete $item_id $name"
      set object_type [::xo::db::CrClass get_object_type -item_id $item_id]
      # In case of PageTemplate and subtypes, we need to check
      # for pages using this template
      set classes [concat $object_type [$object_type info heritage]]
      if {[lsearch $classes "::xowiki::PageTemplate"] > -1} {
	set count [::xowiki::PageTemplate count_usages -item_id $item_id]
	if {$count > 0} {
	  return [$id error_msg \
		      [_ xowiki.error-delete_entries_first [list count $count]]]
	}
      }
      if {[my get_parameter "with_general_comments" 0]} {
        #
        # We have general comments. In a first step, we have to delete
        # these, before we are able to delete the item.
        #
        set comment_ids [db_list [my qn get_comments] \
                   "select comment_id from general_comments where object_id = $item_id"]
        foreach comment_id $comment_ids { 
          my log "-- deleting comment $comment_id"
          ::xo::db::sql::content_item del -item_id $comment_id 
        }
      }
      $object_type delete -item_id $item_id
      my flush_references -item_id $item_id -name $name
      my flush_page_fragment_cache -scope agg
    } else {
      my log "--D nothing to delete!"
    }
    my returnredirect [my query_parameter "return_url" [$id package_url]]
  }

  Package instproc flush_page_fragment_cache {{-scope agg}} {
    switch -- $scope {
      agg {set key PF-[my id]-agg-*}
      all {set key PF-[my id]-*}
      default {error "unknown cope for flushing page fragment cache"}
    }
    foreach entry [ns_cache names xowiki_cache $key] {
      ns_log notice "::xo::clusterwide ns_cache flush xowiki_cache $entry"
      ::xo::clusterwide ns_cache flush xowiki_cache $entry
    }
  }

  #
  # Perform per connection parameter caching.  Using the
  # per-connection cache speeds later lookups up by a factor of 15.
  # Repeated parameter lookups are quite likely
  #

  Class ParameterCache
  ParameterCache instproc get_parameter {{-check_query_parameter true} attribute {default ""}} {
    set key [list [my id] [self proc] $attribute]
    if {[::xo::cc cache_exists $key]} {
      return [::xo::cc cache_get $key]
    }
    return [::xo::cc cache_set $key [next]]
  }
  Package instmixin add ParameterCache


  #
  # policy management
  #

  Package instproc condition=has_class {query_context value} {
    return [expr {[$query_context query_parameter object_type ""] eq $value}]
  }
  Package instproc condition=has_name {query_context value} {
    return [regexp $value [$query_context query_parameter name ""]]
  }

  Class create Policy -superclass ::xo::Policy

  Policy policy1 -contains {
  
    Class Package -array set require_permission {
      reindex             swa
      import_prototype_page swa
      rss                 none
      google-sitemap      none
      google-sitemapindex none
      delete              {{id admin}}
      edit-new            {
	{{has_class ::xowiki::Object} swa} 
	{{has_class ::xowiki::FormPage} nobody} 
	{{has_name {[.](js|css)$}} id admin}
	{id create}
      }
    }
    
    Class Page -array set require_permission {
      view               none
      revisions          {{package_id write}}
      diff               {{package_id write}}
      edit               {
        {{regexp {name {(weblog|index)$}}} package_id admin} 
        {package_id write}
      }
      save-form-data     {{package_id write}}
      make-live-revision {{package_id write}}
      delete-revision    {{package_id admin}}
      delete             {{package_id admin}}
      save-tags          login
      popular-tags       login
      create-new        {{item_id write}}
    } -set default_permission {{package_id write}}

    Class Object -array set require_permission {
      edit               swa
    }
    Class File -array set require_permission {
      download           none
    }
    Class Form -array set require_permission {
      create-new        {{item_id write}}
      list              {{package_id read}}
    }
  }

  Policy policy2 -contains {
    #
    # we require side wide admin rights for deletions and code
    #

    Class Package -array set require_permission {
      reindex             {{id admin}}
      rss                 none
      google-sitemap      none
      google-sitemapindex none
      delete              swa
      edit-new            {
	{{has_class ::xowiki::Object} swa} 
	{{has_class ::xowiki::FormPage} nobody} 
	{{has_name {[.](js|css)$}} swa}
	{id create}
      }
    }
    
    Class Page -array set require_permission {
      view               {{package_id read}}
      revisions          {{package_id write}}
      diff               {{package_id write}}
      edit               {
        {{regexp {name {(weblog|index)$}}} package_id admin} 
        {package_id write}
      }
      make-live-revision {{package_id write}}
      delete-revision    swa
      delete             swa
      save-tags          login
      popular-tags       login
      create-new        {{item_id write}}
    }

    Class Object -array set require_permission {
      edit               swa
    }
    Class File -array set require_permission {
      download           {{package_id read}}
    }
    Class Form -array set require_permission {
      create-new        {{item_id write}}
      list              {{package_id read}}
    }
  }
  
  Policy policy3 -contains {
    #
    # we require side wide admin rights for deletions
    # we perform checking on item_ids for pages. 
    #

    Class Package -array set require_permission {
      reindex             {{id admin}}
      rss                 none
      google-sitemap      none
      google-sitemapindex none
      delete              swa
      edit-new            {
	{{has_class ::xowiki::Object} swa} 
	{{has_class ::xowiki::FormPage} nobody} 
	{{has_name {[.](js|css)$}} swa}
	{id create}
      }
    }
    
    Class Page -array set require_permission {
      view               {{item_id read}}
      revisions          {{item_id write}}
      diff               {{item_id write}}
      edit               {{item_id write}}
      make-live-revision {{item_id write}}
      delete-revision    swa
      delete             swa
      save-tags          login
      popular-tags       login
      create-new        {{item_id write}}
    }

    Class Object -array set require_permission {
      edit               swa
    }
    Class File -array set require_permission {
      download           {{package_id read}}
    }
    Class Form -array set require_permission {
      create-new        {{item_id write}}
      list              {{item_id read}}
    }
  }

  #Policy policy4 -contains {
  #  ::xotcl::Object function -array set require_permission {
  #    f none
  #  } -set default_permission login
  #}
  
  #my log "--set granted [policy4 check_permissions -user_id 0 -package_id 0 function f]"

  #
  # an example with in_state condition...
  #
  Policy policy5 -contains {

    Class Package -array set require_permission {
      reindex             {{id admin}}
      rss                 none
      google-sitemap      none
      google-sitemapindex none
      delete              swa
      edit-new            {
        {{has_class ::xowiki::Object} swa}
        {{has_class ::xowiki::FormPage} nobody}
        {{has_name {[.](js|css)$}} swa}
        {id create}
      }
    }
    
    Class Page -array set require_permission {
      view               {{item_id read}}
      revisions          {{item_id write}}
      diff               {{item_id write}}
      edit               {{item_id write}}
      make-live-revision {{item_id write}}
      delete-revision    swa
      delete             swa
      save-tags          login
      popular-tags       login
      create-new         {{item_id write}}
    }
    
    Class Object -array set require_permission {
      edit               swa
    }
    Class File -array set require_permission {
      download           {{package_id read}}
    }
    Class FormPage -array set require_permission {
      view               creator 
      edit               {
        {{in_state initial|suspended|working} creator} admin
      }
    }
    Class Form -array set require_permission {
      view              admin
      edit              admin
      list              admin
      create-new        {{item_id write}}
    }
  }


}



