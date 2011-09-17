ad_library {
    XoWiki - Callback procs

    @creation-date 2006-08-08
    @author Gustaf Neumann
    @cvs-id $Id: xowiki-callback-procs.tcl,v 1.52 2008/11/17 17:58:54 gustafn Exp $
}

namespace eval ::xowiki {

  ad_proc -private ::xowiki::after-install {} {
    ::xowiki::sc::register_implementations
    ::xowiki::notifications-install
  }

  ad_proc -private ::xowiki::before-uninstall {} {
    ::xowiki::sc::unregister_implementations
    ::xowiki::notifications-uninstall

    # Unregister all types from all folders 
    ::xowiki::Page folder_type_unregister_all 

    # Delete object types
    foreach type [::xowiki::Page object_types -subtypes_first true] {
      ::xo::db::sql::content_type drop_type -content_type $type \
          -drop_children_p t -drop_table_p t -drop_objects_p t
    }
  }

  ad_proc -public ::xowiki::before-uninstantiate {
    {-package_id:required}
  } {
    Callback to be called whenever a package instance is deleted.
    
    @author Gustaf Neumann
  } {
    ns_log notice "Executing before-uninstantiate"
    ::xowiki::delete_gc_messages -package_id $package_id
    ns_log notice "          before-uninstantiate DONE"
  }


  ad_proc -public ::xowiki::delete_gc_messages {
    {-package_id:required}
  } {
    Deletes the messages of general comments to allow to
    uninstantiate the package without violating constraints.
    
    @author Gustaf Neumann
  } {
    set comment_ids [db_list get_comments "
      select g.comment_id
      from general_comments g, cr_items i,acs_objects o
      where i.item_id = g.object_id
      and o.object_id = i.item_id
      and o.package_id = $package_id"]
    foreach comment_id $comment_ids {
      ::xo::db::sql::acs_message delete -message_id $comment_id
    }
  }


  #
  # upgrade logic
  #

  ad_proc ::xowiki::upgrade_callback {
    {-from_version_name:required}
    {-to_version_name:required}
  } {

    Callback for upgrading

    @author Gustaf Neumann (neumann@wu-wien.ac.at)
  } {
    ns_log notice "-- UPGRADE $from_version_name -> $to_version_name"

    if {$to_version_name eq "0.13"} {
      ns_log notice "-- upgrading to 0.13"
      set package_id [::xo::package_id_from_package_key xowiki]
      set folder_id  [::xowiki::Page require_folder \
			  -package_id $package_id \
			  -content_types ::xowki::Page* \
			  -name xowiki]
      set r [::CrWikiPage get_instances_from_db -folder_id $folder_id]
      db_transaction {
        array set map {
          ::CrWikiPage      ::xowiki::Page
          ::CrWikiPlainPage ::xowiki::PlainPage
          ::PageTemplate    ::xowiki::PageTemplate
          ::PageInstance    ::xowiki::PageInstance
        }
        foreach e [$r children] {
          set oldClass [$e info class]
          if {[info exists map($oldClass)]} {
            set newClass $map($oldClass)
            #ns_log notice "-- old class [$e info class] -> $newClass, fetching [$e set item_id] "
            [$e info class] fetch_object -object $e -item_id [$e set item_id]
            set oldtitle [$e set title]
            $e append title " (old)"
            $e save
            $e class $newClass
            $e set title $oldtitle
            $e set name $oldtitle
            $e save_new
          } else {
            ns_log notice "-- no new class for $oldClass"
          }
        }       
      }
    }

    if {[apm_version_names_compare $from_version_name "0.19"] == -1 &&
        [apm_version_names_compare $to_version_name "0.19"] > -1} {
      ns_log notice "-- upgrading to 0.19"
      ::xowiki::sc::register_implementations
    }

    if {[apm_version_names_compare $from_version_name "0.21"] == -1 &&
        [apm_version_names_compare $to_version_name "0.21"] > -1} {
      ns_log notice "-- upgrading to 0.21"
      if {![attribute::exists_p ::xowiki::Page page_title]} {
        ::xo::db::sql::content_type create_attribute \
            -content_type ::xowiki::Page \
            -attribute_name page_title \
            -datatype text \
            -pretty_name "Page Title" \
            -column_spec text
      }
      if {![attribute::exists_p ::xowiki::Page creator]} {
        ::xo::db::sql::content_type create_attribute \
            -content_type ::xowiki::Page \
            -attribute_name creator \
            -datatype text \
            -pretty_name "Creator" \
            -column_spec text
      }
      ::xowiki::update_views
    }

    if {[apm_version_names_compare $from_version_name "0.22"] == -1 &&
        [apm_version_names_compare $to_version_name "0.22"] > -1} {
      ns_log notice "-- upgrading to 0.22"
      set folder_ids [list]
      set package_ids [list]
      foreach package_id [::xowiki::Package instances] {
        set folder_id [db_list get_folder_id "select f.folder_id from cr_items c, cr_folders f \
                where c.name = 'xowiki: $package_id' and c.item_id = f.folder_id"]
        if {$folder_id ne ""} {
          db_dml update_package_id {update cr_folders set package_id = :package_id
            where folder_id = :folder_id}
          lappend folder_ids $folder_id
          lappend package_ids $package_id
        }
      }
      foreach f $folder_ids p $package_ids {
        db_dml update_context_ids "update acs_objects set context_id = $p where object_id = $f"
      }
    }

    if {[apm_version_names_compare $from_version_name "0.25"] == -1 &&
        [apm_version_names_compare $to_version_name "0.25"] > -1} {
      ns_log notice "-- upgrading to 0.25"
      # Only run this if the PageInstance does not exist
      if {[catch {acs_sc::impl::get_id -owner xowiki -name ::xowiki::PageInstance}]} {
        acs_sc::impl::new_from_spec -spec {
          name "::xowiki::PageInstance"
          aliases {
            datasource ::xowiki::datasource
            url ::xowiki::url
          }
          contract_name FtsContentProvider
          owner xowiki
        }
      }
    }

    if {[apm_version_names_compare $from_version_name "0.27"] == -1 &&
        [apm_version_names_compare $to_version_name "0.27"] > -1} {
      ns_log notice "-- upgrading to 0.27"
      db_dml copy_page_title_into_title \
          "update cr_revisions set title = p.page_title from xowiki_page p \
                where page_title != '' and revision_id = p.page_id"

      db_list delete_deprecated_types_from_ancient_versions \
	  "select [::xo::db::sql map_function_name content_item__delete(i.item_id)] from cr_items i \
                where content_type in ('CrWikiPage', 'CrWikiPlainPage', \
                'PageInstance', 'PageTemplate','CrNote', 'CrSubNote')"
    }

    if {[apm_version_names_compare $from_version_name "0.30"] == -1 &&
        [apm_version_names_compare $to_version_name "0.30"] > -1} {
      ns_log notice "-- upgrading to 0.30"
      # delete orphan cr revisions, created automatically by content_item
      # new, when e.g. a title is specified....
      foreach class {::xowiki::Page ::xowiki::PlainPage ::xowiki::Object
        ::xowiki::PageTemplate ::xowiki::PageInstance} {
        db_dml delete_orphan_revisions "
          delete from cr_revisions where revision_id in (
                 select r.revision_id from cr_items i,cr_revisions r  
                 where i.content_type = '$class' and r.item_id = i.item_id 
                 and not r.revision_id in (select [$class id_column] from [$class table_name]))
        "
        db_dml delete_orphan_items "
         delete from acs_objects where object_type = '$class' 
             and not object_id in (select item_id from cr_items where content_type = '$class') 
             and not object_id in (select [$class id_column] from [$class table_name])
         "
      }
    }

    if {[apm_version_names_compare $from_version_name "0.31"] == -1 &&
        [apm_version_names_compare $to_version_name "0.31"] > -1} {
      ns_log notice "-- upgrading to 0.31"
      set folder_ids [list]
      set package_ids [list]
      foreach package_id [::xowiki::Package instances] {
        set folder_id [db_string get_folder_id "select f.folder_id from cr_items c, cr_folders f \
                where c.name = 'xowiki: $package_id' and c.item_id = f.folder_id"]
        if {$folder_id ne ""} {
          db_dml update_package_id {update acs_objects set package_id = :package_id where object_id in 
            (select item_id as object_id from cr_items where parent_id = :folder_id)}
          db_dml update_package_id {update acs_objects set package_id = :package_id where object_id in 
            (select r.revision_id as object_id from cr_revisions r, cr_items i where 
             i.item_id = r.item_id and i.parent_id = :folder_id)}
          ::xowiki::Package initialize -package_id $package_id -init_url false
          ::$package_id reindex
        }
      }
    }

    if {[apm_version_names_compare $from_version_name "0.34"] == -1 &&
        [apm_version_names_compare $to_version_name "0.34"] > -1} {
      ns_log notice "-- upgrading to 0.34"
      ::xowiki::notifications-install
    }

    if {[apm_version_names_compare $from_version_name "0.39"] == -1 &&
        [apm_version_names_compare $to_version_name "0.39"] > -1} {
      ns_log notice "-- upgrading to 0.39"
      catch {db_dml create-xowiki-last-visited-time-idx \
        "create index xowiki_last_visited_time_idx on xowiki_last_visited(time)"
      }
    }

    if {[apm_version_names_compare $from_version_name "0.42"] == -1 &&
        [apm_version_names_compare $to_version_name "0.42"] > -1} {
      ns_log notice "-- upgrading to 0.42"
      ::xowiki::add_ltree_order_column
      # get rid of obsolete column
      catch {
      ::xo::db::sql::content_type delete_attribute \
          -content_type ::xowiki::Page \
          -attribute_name page_title \
          -drop_column t
      }
      # drop old non-conformant indices
      foreach index { xowiki_ref_index 
        xowiki_last_visited_index_unique xowiki_last_visited_index
        xowiki_tags_index_tag xowiki_tags_index_user
      } {
        catch {db_dml drop_index "drop index $index"}
      }
      ::xowiki::update_views
    }

    if {[apm_version_names_compare $from_version_name "0.56"] == -1 &&
        [apm_version_names_compare $to_version_name "0.56"] > -1} {
      ns_log notice "-- upgrading to 0.56"
      db_dml add_integer_column \
	  "alter table xowiki_page_instance add npage_template \
		integer references cr_items(item_id)"
      db_dml copy_old_values \
	  "update xowiki_page_instance set npage_template = cast(page_template as integer)"
      db_dml rename_old_column \
	  "alter table xowiki_page_instance rename column page_template to old_page_template"
      db_dml rename_new_column \
	  "alter table xowiki_page_instance rename column npage_template to page_template"
      # a few releases later, drop old column
      if {[db_0or1row in_between_version \
	       "select 1 from acs_object_types where \
		object_type = '::xowiki::Form' and supertype = '::xowiki::Page'"]} {
	# we have a version with a type hierarchy not compatible with the new one.
	# this comes by updating often from head. 
	# The likelyhood to have such as version is rather low.
	ns_log notice "Deleting incompatible version of ::xowiki::Form"
	::xo::db::sql::content_type drop_type -content_type ::xowiki::FormInstance \
	    -drop_children_p t -drop_table_p t -drop_objects_p t
	::xo::db::sql::content_type drop_type -content_type ::xowiki::Form \
	    -drop_children_p t -drop_table_p t -drop_objects_p t
      }
      ::xowiki::update_views
    }

    if {[apm_version_names_compare $from_version_name "0.58"] == -1 &&
        [apm_version_names_compare $to_version_name "0.58"] > -1} {
      ns_log notice "-- upgrading to 0.58"

      if {[catch {acs_sc::impl::get_id -owner xowiki -name ::xowiki::FormPage}]} {
        acs_sc::impl::new_from_spec -spec {
          name "::xowiki::FormPage"
          aliases {
            datasource ::xowiki::datasource
            url ::xowiki::url
          }
          contract_name FtsContentProvider
          owner xowiki
        }
      }
    }

    if {[apm_version_names_compare $from_version_name "0.59"] == -1 &&
        [apm_version_names_compare $to_version_name "0.59"] > -1} {
      ns_log notice "-- upgrading to 0.59"
      # Remove all old objects of tyoe ::xowiki::FormInstance and the type
      # from the database.
      if {[catch {
        ::xo::db::sql::content_type drop_type -content_type ::xowiki::FormInstance \
            -drop_children_p t -drop_table_p t -drop_objects_p t
      } errorMsg]} {
        ns_log notice "--upgrade produced error: $errorMsg"
      }
    }

    if {[apm_version_names_compare $from_version_name "0.60"] == -1 &&
        [apm_version_names_compare $to_version_name "0.60"] > -1} {
      ns_log notice "-- upgrading to 0.60"
      # load for all xowiki package instances the weblog-portlet prototype page
      foreach package_id [::xowiki::Package instances] {
	::xowiki::Package initialize -package_id $package_id -init_url false
	$package_id import_prototype_page weblog-portlet
      }
    }

    set v 0.62
    if {[apm_version_names_compare $from_version_name $v] == -1 &&
        [apm_version_names_compare $to_version_name $v] > -1} {
      ns_log notice "-- upgrading to $v"

      # make sure, the page_order is added for the upgrade
      ::xowiki::add_ltree_order_column

      # for all xowiki package instances 
      foreach package_id [::xowiki::Package instances] {
	::xowiki::Package initialize -package_id $package_id -init_url false
	# rename swf:name and image:name to file:name
	db_dml change_swf \
	    "update cr_items set name = 'file' || substr(name,4) \
		where name like 'swf:%' and parent_id = [$package_id folder_id]"
	db_dml change_image \
	    "update cr_items set name = 'file' || substr(name,6) \
		where name like 'image:%' and parent_id = [$package_id folder_id]"
	# reload updated prototype pages
	$package_id import_prototype_page book
	$package_id import_prototype_page weblog
	# TODO check: jon.griffin
      }
    }

    set v 0.70
    if {[apm_version_names_compare $from_version_name $v] == -1 &&
        [apm_version_names_compare $to_version_name $v] > -1} {
      ns_log notice "-- upgrading to $v"
      # for all xowiki package instances 
      foreach package_id [::xowiki::Package instances] {
	::xowiki::Package initialize -package_id $package_id -init_url false
	$package_id import_prototype_page categories-portlet
      }
      # perform the upgrate of 0.62 for the s5 package as well
      if {[info command ::s5::Package] ne ""} {
	foreach package_id [::s5::Package instances] {
	  ::s5::Package initialize -package_id $package_id -init_url false
	  # rename swf:name and image:name to file:name
	  db_dml change_swf \
	      "update cr_items set name = 'file' || substr(name,4) \
		where name like 'swf:%' and parent_id = [$package_id folder_id]"
	  db_dml change_image \
	      "update cr_items set name = 'file' || substr(name,6) \
		where name like 'image:%' and parent_id = [$package_id folder_id]"
	}
      }
      catch {
	# for new installs, the old column might not exist, therefor the catch
	db_dml drop_old_column \
	    "alter table xowiki_page_instance drop column old_page_template cascade"
      }
      ::xowiki::update_views
    }

    set v 0.77
    if {[apm_version_names_compare $from_version_name $v] == -1 &&
        [apm_version_names_compare $to_version_name $v] > -1} {
      ns_log notice "-- upgrading to $v"
      # load for all xowiki package instances the weblog-portlet prototype page
      foreach package_id [::xowiki::Package instances] {
	::xowiki::Package initialize -package_id $package_id -init_url false
	$package_id import_prototype_page announcements
	$package_id import_prototype_page news
	$package_id import_prototype_page weblog-portlet
      }
      copy_parameter top_portlet top_includelet
    }

    set v 0.78
    if {[apm_version_names_compare $from_version_name $v] == -1 &&
        [apm_version_names_compare $to_version_name $v] > -1} {
      ns_log notice "-- upgrading to $v"
      # load for all xowiki package instances the weblog-portlet prototype page
      foreach package_id [::xowiki::Package instances] {
	::xowiki::Package initialize -package_id $package_id -init_url false
	$package_id import_prototype_page news
	$package_id import_prototype_page weblog-portlet
      }
      # To iterate over all kind of xowiki packages, we could do
      # foreach package [concat ::xowiki::Package [::xowiki::Package info subclass]] {
      #    foreach package_id [$package instances] {
      #       ...
      #    }
      # }
      copy_parameter top_portlet top_includelet
    }
    set v 0.79
    if {[apm_version_names_compare $from_version_name $v] == -1 &&
        [apm_version_names_compare $to_version_name $v] > -1} {
      ns_log notice "-- upgrading to $v"
      # load for all xowiki package instances the weblog-portlet prototype page
      foreach package_id [::xowiki::Package instances] {
	::xowiki::Package initialize -package_id $package_id -init_url false
	$package_id import_prototype_page news-item
      }
      copy_parameter top_portlet top_includelet
    }

    set v 0.83
    if {[apm_version_names_compare $from_version_name $v] == -1 &&
        [apm_version_names_compare $to_version_name $v] > -1} {
      ns_log notice "-- upgrading to $v"
      ::xowiki::add_ltree_order_column
    }

    set v 0.86
    if {[apm_version_names_compare $from_version_name $v] == -1 &&
        [apm_version_names_compare $to_version_name $v] > -1} {
      ns_log notice "-- upgrading to $v"
      foreach package_id [::xowiki::Package instances] {
	::xowiki::Package initialize -package_id $package_id -init_url false
	$package_id import_prototype_page weblog
	$package_id import_prototype_page weblog-portlet
      }
    }

    set v 0.90
    if {[apm_version_names_compare $from_version_name $v] == -1 &&
        [apm_version_names_compare $to_version_name $v] > -1} {
      ns_log notice "-- upgrading to $v"
      set dir [acs_package_root_dir xowiki]
      foreach file {
        tcl/xowiki-portlet-procs.tcl
        www/delete-revision.tcl www/delete.tcl www/edit.tcl www/revisions.tcl
        www/index.adp www/index.tcl 
        www/view.adp www/view.tcl
        www/make-live-revision.tcl www/popular_tags.tcl www/save_tags.tcl www/weblog.tcl
        www/portlets/categories-recent.adp
        www/portlets/categories-recent.tcl
        www/portlets/categories.adp
        www/portlets/categories.tcl
        www/portlets/last-visited.adp
        www/portlets/last-visited.tcl
        www/portlets/most-popular.adp
        www/portlets/most-popular.tcl
        www/portlets/recent.adp 
        www/portlets/recent.tcl 
        www/portlets/rss-button.adp
        www/portlets/rss-button.tcl
        www/portlets/tags.tcl
        www/portlets/weblog.adp
        www/portlets/weblog.tcl
        www/portlets/wiki.adp
        www/portlets/wiki.tcl
        www/prototypes/announcements.page 
        www/admin/regression_test.tcl
      } {
        if {[file exists $dir/$file]} {
          ns_log notice "Deleting obsolete file $dir/$file"
          file delete $dir/$file
        }
      }
    }

    set v 0.96
    if {[apm_version_names_compare $from_version_name $v] == -1 &&
        [apm_version_names_compare $to_version_name $v] > -1} {
      ns_log notice "-- upgrading to $v"
      foreach package_id [::xowiki::Package instances] {
	::xowiki::Package initialize -package_id $package_id -init_url false
	$package_id import_prototype_page ical
      }
    }
  }

  Object create tidy
  tidy proc clean {text} {
    if {[[::xo::cc package_id] get_parameter tidy 0] 
        && [info command ::util::which] ne ""} { 
      set tidycmd [::util::which tidy]
      if {$tidycmd ne ""} {
	set in_file [ns_tmpnam]
	::xowiki::write_file $in_file $text
	catch {exec $tidycmd -q -w 0 -ashtml < $in_file 2> /dev/null} output
	file delete $in_file
	#my msg o=$output
	regexp <body>\n(.*)\n</body> $output _ text
	#my msg o=$text
	return $text
      }
    }
    return $text
  }

  proc copy_parameter {from to} {
    set parameter_obj [::xo::parameter get_parameter_object \
                           -parameter_name $from -package_key xowiki]
    if {$parameter_obj eq ""} {error "no such parameter $from"}
    foreach package_id [::xowiki::Package instances] {
      set value [$parameter_obj get -package_id $package_id]
      parameter::set_value -package_id $package_id -parameter $to -value $value
    }
  }

  ad_proc fix_all_package_ids {} {
    earlier versions of openacs did not have the package_id set correctly
    in acs_objects; this proc updates the package_ids of all items
    and revisions in acs_objects
  } {
    set folder_ids [list]
    set package_ids [list]
    foreach package_id [::xowiki::Package instances] {
      ns_log notice "checking package_id $package_id"
      set folder_id [db_list get_folder_id "select f.folder_id from cr_items c, cr_folders f \
                where c.name = 'xowiki: $package_id' and c.item_id = f.folder_id"]
      if {$folder_id ne ""} {
        db_dml update_package_id {update acs_objects set package_id = :package_id 
          where object_id in 
          	(select item_id as object_id from cr_items where parent_id = :folder_id)
          and package_id is NULL}
        db_dml update_package_id {update acs_objects set package_id = :package_id 
          where object_id in 
                (select r.revision_id as object_id from cr_revisions r, cr_items i where 
                 i.item_id = r.item_id and i.parent_id = :folder_id)
          and package_id is NULL}
      }
    }
  }

  ad_proc update_views {} {
    update all automatic views of xowiki
  } {
    foreach object_type [::xowiki::Page object_types] {
      ::xo::db::sql::content_type refresh_view -content_type $object_type
    }

    catch {db_dml drop_live_revision_view "drop view xowiki_page_live_revision"}
    if {[db_driverkey ""] eq "postgresql"} {
      set sortkeys ", ci.tree_sortkey, ci.max_child_sortkey "
    } else {
      set sortkeys ""
    }
    ::xo::db::require view xowiki_page_live_revision \
	"select p.*, cr.*,ci.parent_id, ci.name, ci.locale, ci.live_revision, \
	  ci.latest_revision, ci.publish_status, ci.content_type, ci.storage_type, \
	  ci.storage_area_key $sortkeys \
          from xowiki_page p, cr_items ci, cr_revisions cr  \
          where p.page_id = ci.live_revision \
            and p.page_id = cr.revision_id  \
            and ci.publish_status <> 'production'"
  }

  ad_proc add_ltree_order_column {} {
    add page_order of type ltree, when ltree is configured (otherwise string)
  } {
    # catch sql statement to allow multiple runs
    catch {::xo::db::sql::content_type create_attribute \
	       -content_type ::xowiki::Page \
	       -attribute_name page_order \
	       -datatype text \
	       -pretty_name Order \
	       -column_spec [::xo::db::sql map_datatype ltree]}
    
    ::xo::db::require index -table xowiki_page -col page_order \
	-using [expr {[::xo::db::has_ltree] ? "gist" : ""}]
    ::xowiki::update_views
    return 1
  }

  ad_proc cr_thin_out {{-doit 0} -package_id -item_id} {
    delete unneded items
  } {
    set extra_cause ""
    if {[info exists package_id]} {
      append extra_clause " and o.package_id = $package_id"
    }
    if {[info exists item_id]} {
      append extra_clause " and i.item_id = $item_id"
    }

    # only delete revisions older than this date
    set older_than [clock scan "1 month ago"]
    # delete revisions which are less than 5 minutes apart
    set delete_interval [expr {60*5}]

    #
    # The first query removes widow entries, where a user pressed new, but
    # never saved it. We could check as well, if the item has exactly one revision.
    #
    set sql "
       select i.name, o.package_id, i.item_id, r.revision_id, o.last_modified
       from acs_objects o, xowiki_page p, cr_revisions r, cr_items i 
       where p.page_id = r.revision_id and r.item_id = i.item_id and o.object_id = r.revision_id 
       and i.publish_status = 'production' and i.name = r.revision_id::varchar
    "
    foreach tuple [db_list_of_lists get_revisions $sql] {
      #::xotcl::Object msg "tuple = $tuple"
      foreach {name package_id item_id revision_id last_modified} $tuple break 
      set time [clock scan [::xo::db::tcl_date $last_modified tz_var]]
      if {$time > $older_than} continue
      ::xotcl::Object msg "...will delete $name doit=$doit $last_modified"
      if {$doit} {
        ::xowiki::Package require $package_id
        $package_id delete -item_id $item_id -name $name
      }
    }
    
    #
    # The first query removes quick edits, where from a sequence of edits of the same user,
    # only the last edit is kept
    #
    set sql "
      select i.name, i.item_id, r.revision_id,  o.last_modified, o.creation_user, o.package_id
      from acs_objects o, xowiki_page p, cr_revisions r, cr_items i 
      where p.page_id = r.revision_id and r.item_id = i.item_id
      and o.object_id = r.revision_id  
      $extra_clause
      order by item_id, revision_id asc
    "
    set last_item ""
    set last_time 0
    set last_user ""
    set last_revision ""

    foreach tuple [db_list_of_lists get_revisions $sql] {
      #::xotcl::Object msg "tuple = $tuple"
      foreach {name item_id revision_id last_modified user package_id} $tuple break 
      set time [clock scan [::xo::db::tcl_date $last_modified tz_var]]
      if {$time > $older_than} continue
      #::xotcl::Object msg "compare time $time with $older_than => [expr {$time < $older_than}]"
      if {$last_user eq $user && $last_item == $item_id} {
        set timediff [expr {$time-$last_time}]
        #::xotcl::Object msg "   timediff=[expr {$time-$last_time}]"
        if {$timediff < $delete_interval && $timediff >= 0} {
          ::xotcl::Object msg "...will delete $name revision=$last_revision, doit=$doit $last_modified"
          if {$doit} {
            ::xowiki::Package require $package_id
            $package_id delete_revision -revision_id $last_revision -item_id $item_id
          }
        }
      }
      set last_user $user
      set last_time $time
      set last_item $item_id
      set last_revision $revision_id
    }
  }

  proc unmounted_instances {} {
    return [db_list unmounted_instances {
      select package_id from apm_packages p where not exists 
      (select 1 from site_nodes where object_id = p.package_id) 
      and p.package_key = 'xowiki'
    }]
  }

  proc form_upgrade {} {
    db_dml from_upgrade {
      update xowiki_form f set form = xowiki_formi.data from xowiki_formi 
      where f.xowiki_form_id = xowiki_formi.revision_id
    }
  }

  proc read_file {fn} {
    set F [open $fn]
    fconfigure $F -translation binary
    set content [read $F]
    close $F
    return $content
  }
  proc write_file {fn content} {
    set F [open $fn w]
    fconfigure $F -translation binary
    puts -nonewline $F $content
    close $F
  }

  ad_proc -public -callback subsite::url -impl apm_package {
    {-package_id:required}
    {-object_id:required}
    {-type ""}
  } {
    return the page_url for an object of type tasks_task
  } {
    ns_log notice "got package_id=$package_id, object_id=$object_id, type=$type"
    ::xowiki::Package initialize -package_id $package_id
    if {[::xotcl::Object isobject ::$package_id]} {
      return [$package_id package_url]
    } else {
      return ""
    }
  }
}