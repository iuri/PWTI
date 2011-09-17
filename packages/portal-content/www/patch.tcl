ad_page_contract {
    Page for viewing and editing one patch.

    @author Peter Marklund (peter@collaboraid.biz)
    @date 2002-09-04
    @cvs-id $Id: patch.tcl,v 1.13 2005/03/01 00:01:26 jeffd Exp $
} {
    patch_number:integer,notnull
    mode:optional
    cancel_edit:optional    
    edit:optional
    accept:optional
    refuse:optional
    delete:optional    
    reopen:optional
    comment:optional
    download:optional
}

# Assert read permission (should this check be in the request processor?)
ad_require_permission [ad_conn package_id] read

# Initialize variables related to the request that we'll need
set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
# Does the user have write privilege on the project?
set write_p [ad_permission_p $package_id write]

set submitter_id [portal_content::get_patch_submitter -patch_number $patch_number]

set user_is_submitter_p [expr { ![empty_string_p $submitter_id] && $user_id == $submitter_id }]
set write_or_submitter_p [expr $write_p || $user_is_submitter_p]
set project_name [portal_content::conn project_name]
set package_key [ad_conn package_key]
set view_patch_url "[ad_conn url]?[export_vars -url { patch_number }]"
set patch_status [db_string patch_status {}]

# Is this project using multiple versions?
set versions_p [portal_content::versions_p]

# Abort editing and return to view mode if the user hit cancel on the edit form
if { [exists_and_not_null cancel_edit] } {
    ad_returnredirect $view_patch_url
    ad_script_abort
}

# If the download link was clicked - return the text content of the patch
if { [exists_and_not_null download] } {
    
    set patch_content [db_string get_patch_content {}]

    doc_return 200 "text/plain" $patch_content
    ad_script_abort
}

# Initialize the page mode variable
# We are in view mode per default
if { ![info exists mode] } {
    if { [exists_and_not_null edit] } {
        set mode edit
    } elseif { [exists_and_not_null accept] } {        
        set mode accept
    } elseif { [exists_and_not_null refuse] } {
        set mode refuse
    } elseif { [exists_and_not_null delete] } {
        set mode delete
    } elseif { [exists_and_not_null reopen] } {
        set mode reopen
    } elseif { [exists_and_not_null comment] } {
        set mode comment
    } else {
        set mode view
    }
}

# Specify which fields in the form are editable
# And check that the user is permitted to take the chosen action
switch -- $mode {
    edit {
        if { ![expr $write_p || $user_is_submitter_p] } {
            ad_return_forbidden "[_ portal-content.Permission]" "[_ portal-content.You_2]"
            ad_script_abort
        }

        set edit_fields {component_id summary generated_from_version apply_to_version}
    }
    accept {
        ad_require_permission $package_id write

        # The user should indicate which version the patch is applied to
        set edit_fields { applied_to_version }
    }
    refuse {
        ad_require_permission $package_id write

        set edit_fields {}
    }
    reopen {
        # User must have write permission to reopen a refused patch
        if { [string equal $patch_status "refused"] && !$write_p } {
            ad_return_forbidden "[_ portal-content.Permission]" "[_ portal-content.You_3]"
            ad_script_abort
        } elseif { [string equal $patch_status "deleted"] && !($user_is_submitter_p || $write_p)} {
            ad_return_forbidden "[_ portal-content.Permission]" "[_ portal-content.You_4]"
            ad_script_abort
        }

        set edit_fields {}
    }
    delete {
        # Only the submitter can delete a patch (admins can refuse it)
        if { !$user_is_submitter_p } {
            ad_return_forbidden "[_ portal-content.Permission]" "[_ portal-content.You_5]"
            ad_script_abort
        }
        set edit_fields {}
    }
    comment {
        set edit_fields {}
    }
    view {
        set edit_fields {}
    }
}

foreach field $edit_fields {
    set field_editable_p($field) 1
}

if { ![string equal $mode "view"] } {
    auth::require_login
}    

# XXX FIXME TODO editing a patch invokes filename::validate, which is too paranoid...

# Create the form
switch -- $mode {
      view {
          form create patch -has_submit 1 -cancel_url "[ad_conn url]?[export_vars -url { patch_number }]"
      } 
      default {
          form create patch -html { enctype multipart/form-data } -cancel_url "[ad_conn url]?[export_vars -url { patch_number }]"
      }
}

# Create the elements of the form
element create patch patch_number \
        -datatype integer \
        -widget   hidden

element create patch patch_number_i \
        -datatype integer \
        -widget   inform \
        -label    "[_ portal-content.Patch_1]"

element create patch component_id \
        -datatype text \
        -widget [ad_decode [info exists field_editable_p(component_id)] 1 select inform] \
        -label "[_ portal-content.Component]" \
        -options [portal_content::components_get_options]

if { [string equal $mode "view"] } {
    element create patch fixes_contents \
        -datatype text \
        -widget inform \
        -label "[_ portal-content.Fix_2]"
}

element create patch summary  \
        -datatype text \
        -widget [ad_decode [info exists field_editable_p(summary)] 1 text inform] \
        -label "[_ portal-content.Summary]" \
        -html { size 50 }

element create patch submitter \
        -datatype text \
        -widget inform \
        -label "[_ portal-content.Submitted]"

element create patch status \
        -widget inform \
        -datatype text \
        -label "[_ portal-content.Status]"

element create patch generated_from_version \
        -datatype text \
        -widget [ad_decode [info exists field_editable_p(generated_from_version)] 1 select inform] \
        -label "[_ portal-content.Generated]" \
        -options [portal_content::version_get_options -include_unknown] \
        -optional

element create patch apply_to_version \
        -datatype text \
        -widget [ad_decode [info exists field_editable_p(apply_to_version)] 1 select inform] \
        -label "[_ portal-content.Apply_2]" \
        -options [portal_content::version_get_options -include_undecided] \
        -optional

element create patch applied_to_version \
        -datatype text \
        -widget [ad_decode [info exists field_editable_p(applied_to_version)] 1 select inform] \
        -label "[_ portal-content.Applied]" \
        -options [portal_content::version_get_options -include_undecided] \
        -optional

switch -- $mode {
    edit - comment - accept - refuse - reopen - delete {
        element create patch description  \
                -datatype text \
                -widget comment \
                -label "[_ portal-content.Description]" \
                -html { cols 60 rows 13 } \
                -optional
        
        element create patch desc_format \
                -datatype text \
                -widget select \
                -label "[_ portal-content.Description_1]" \
	    -options { { "[_ portal-content.Plain]" plain } { "[_ portal-content.HTML]" html } { "[_ portal-content.Preformatted]" pre } }

    }
    default {
        # View mode
        element create patch description \
                -datatype text \
                -widget inform \
                -label "[_ portal-content.Description]"
    }
}

# In accept mode - give the user the ability to select associated
# contents to be resolved
if { [string equal $mode "accept"] } {

    element create patch resolve_contents \
            -datatype integer \
            -widget checkbox \
            -label "[_ portal-content.Resolve_1]" \
            -options [portal_content::get_mapped_contents -patch_number $patch_number -only_open_p 1] \
            -optional
}

if { [string equal $mode "edit"] } {
    # Edit mode - display the file upload widget for patch content
    element create patch patch_file \
          -datatype file \
          -widget file \
          -label "[_ portal-content.Patch_2]" \
          -optional
} 

element create patch mode \
        -datatype text \
        -widget hidden \
        -value $mode

set page_title [_ portal-content.Patch_3]
set Patches_name [portal_content::conn Patches]
set context [list [list "patch-list" "$Patches_name"] $page_title]

if { [form is_request patch] } {
    # The form was requested

    db_1row patch {} -column_array patch
    set patch(generated_from_version_name) [ad_decode $patch(generated_from_version) "" "[_ portal-content.Unknown]" [portal_content::version_get_name -version_id $patch(generated_from_version)]]
    set patch(apply_to_version_name) [ad_decode $patch(apply_to_version) "" "[_ portal-content.Undecided]" [portal_content::version_get_name -version_id $patch(apply_to_version)]]
    set patch(applied_to_version_name) [portal_content::version_get_name -version_id $patch(applied_to_version)]

    if {$user_id != 0} {
	set submitter_email_display "(<a href=\"mailto:$patch(submitter_email)\">$patch(submitter_email)</a>)"
    } else {
	set submitter_email_display ""
    }

    # When the user is taking an action that should change the status of the patch
    # - update the status (the new status will show up in the form)
    switch -- $mode {
        accept {
            set patch(status) accepted
        }
        refuse {
            set patch(status) refused
        }
        delete {
            set patch(status) deleted
        }
        reopen {
            set patch(status) open
        }
    }

    element set_properties patch patch_number \
            -value $patch(patch_number)
    element set_properties patch patch_number_i \
            -value $patch(patch_number)
    element set_properties patch component_id \
            -value [ad_decode [info exists field_editable_p(component_id)] 1 $patch(component_id) $patch(component_name)]
    if { [string equal $mode "view"] } {
        set contents_name [portal_content::conn contents]
	set map_to_contents [_ portal-content.Map] 
        set map_new_content_link [ad_decode $write_or_submitter_p "1" "\[ <a href=\"map-patch-to-contents?patch_number=$patch(patch_number)\">$map_to_contents</a> \]" ""]
        element set_properties patch fixes_contents \
            -value "[portal_content::get_content_links -patch_id $patch(patch_id) -patch_number $patch(patch_number) -write_or_submitter_p $write_or_submitter_p] <br>$map_new_content_link"
    }
    element set_properties patch summary \
            -value [ad_decode [info exists field_editable_p(summary)] 1 $patch(summary) "<b>$patch(summary)</b>"]
    element set_properties patch submitter \
            -value "
    [acs_community_member_link -user_id $patch(submitter_user_id) \
            -label "$patch(submitter_first_names) $patch(submitter_last_name)"] $submitter_email_display"

    element set_properties patch status \
            -value [ad_decode [info exists field_editable_p(status)] 1 $patch(status) [portal_content::patch_status_pretty $patch(status)]]
    element set_properties patch generated_from_version \
            -value [ad_decode [info exists field_editable_p(generated_from_version)] 1 $patch(generated_from_version) $patch(generated_from_version_name)]
    element set_properties patch apply_to_version \
            -value [ad_decode [info exists field_editable_p(apply_to_version)] 1 $patch(apply_to_version) $patch(apply_to_version_name)]
    element set_properties patch applied_to_version \
            -value [ad_decode [info exists field_editable_p(applied_to_version)] 1 $patch(applied_to_version) $patch(applied_to_version_name)]

    set deleted_p [string equal $patch(status) deleted]

    if { ( [string equal $patch(status) open] && ![string equal $mode accept]) || [string equal $patch(status) refused] } {
        element set_properties patch applied_to_version -widget hidden
    }

    # Description/Actions/History
    set patch_id $patch(patch_id)
    set action_html ""
    db_foreach actions {} {
        set comment $comment_text
        append action_html "<b>$action_date_pretty [portal_content::patch_action_pretty $action] by $actor_first_names $actor_last_name</b>
        <blockquote>[portal_content::content_convert_comment_to_html -comment $comment -format $comment_format]</blockquote>"
    }

    if { [string equal $mode "view"] } {
        element set_properties patch description -value $action_html
    } else {

	set patch_pretty_name $patch(now_pretty)
	set patch_action_pretty_mode [portal_content::patch_action_pretty $mode]
	set bt_user_first_names [portal_content::conn user_first_names]
	set bt_user_last_name [portal_content::conn user_last_name]

        element set_properties patch description \
            -history $action_html \
            -header [_ portal-content.Patch_Header ] \
            -value ""
    }

    # Now that we have the patch summary we can make the page title more informative

    set Patch_name [portal_content::conn Patch]
    set patch_summary $patch(summary)
    set page_title [_ portal-content.Patch_Page_Title]

    # Create the buttons
    # If the user has submitted the patch he gets full write access on the patch
    set user_is_submitter_p [expr $patch(submitter_user_id) == [ad_conn user_id]]
    if { [string equal $mode "view"] } {
        set button_form_export_vars [export_vars -form { patch_number }]
        multirow create button name label

        if { $write_p || $user_is_submitter_p } {
            multirow append button "comment" "[_ portal-content.Comment]"
            multirow append button "edit" "[_ portal-content.Edit]"
        }

        switch -- $patch(status) {
            open {
                if { $write_p } {
                    multirow append button "accept" "[_ portal-content.Accept]"
                    multirow append button "refuse" "[_ portal-content.Refuse]"
                }

                # Only the submitter can cancel the patch
                if { $user_is_submitter_p } {
                    multirow append button "delete" "[_ portal-content.Delete]"
                }
            }
            accepted {
                if { $write_p } {
                    multirow append button "reopen" "[_ portal-content.Reopen]"
                }
            }
            refused {
                if { $write_p } {
                    multirow append button "reopen" "[_ portal-content.Reopen]"    
                }
            }
            deleted {
                if { $write_p || $user_is_submitter_p } {
                    multirow append button "reopen" "[_ portal-content.Reopen]"
                }
            }
        }
    }    

    # Check that the user is permitted to change the patch
    if { ![string equal $mode "view"] && !$write_p && !$user_is_submitter_p } {
        ns_log notice "$patch(submitter_user_id) doesn't have write on object $patch(patch_id)"
        ad_return_forbidden "[_ portal-content.Permission]" "<blockquote>
        [_ portal-content.You_6]
        </blockquote>"
        ad_script_abort
    }    

    if { !$versions_p } {
        element set_properties patch generated_from_version -widget hidden
    }
}

if { [form is_valid patch] } {
    # A valid submit of the form

    set update_exprs [list]

    form get_values patch patch_number

    foreach column $edit_fields {
        set $column [element get_value patch $column]
        lappend update_exprs "$column = :$column"
        if {[string equal $column summary]} { 
            set new_title "Patch \#$patch_number: $summary"
        }
    }
    
    switch -- $mode {
        accept {
            set status accepted
            lappend update_exprs "status = :status"
        }
        refuse {
            set status refused
            lappend update_exprs "status = :status"            
        }
        reopen {
            set status open
            lappend update_exprs "status = :status"
        }
        edit {
            # Get the contents of any new uploaded patch file
            set content [portal_content::get_uploaded_patch_file_content]

            if { ![empty_string_p $content] } {
                lappend update_exprs "content = :content"
            } 
        }
        delete {
            set status deleted
            lappend update_exprs "status = :status"            
        }
    }

    db_transaction {
        set patch_id [db_string patch_id {}]

        if { [llength $update_exprs] > 0 } {
            db_dml update_patch {}
        }
        if {[info exists new_title] && ![empty_string_p $new_title]} { 
            db_dml update_patch_title {update acs_objects set title = :new_title where object_id = :patch_id}
        }
        set action_id [db_nextval "acs_object_id_seq"]

        foreach column { description desc_format } {
            set $column [element get_value patch $column]
        }

        set action $mode
        db_dml patch_action {}

        if { [string equal $mode "accept"] } {
            # Resolve any contents that the user selected
            set resolve_contents [element get_values patch resolve_contents]

            foreach content_number $resolve_contents {

                set resolve_description "[_ portal-content.Fixed_2]"                
                set workflow_id [portal_content::content::get_instance_workflow_id]
                set content_id [portal_content::get_content_id -content_number $content_number -project_id $package_id]
                set case_id [workflow::case::get_id \
                                 -workflow_short_name "[portal_content::content::workflow_short_name]" \
                                 -object_id $content_id]
                set action_id [workflow::action::get_id -workflow_id $workflow_id -short_name "resolve"]
                set enabled_action_id [db_string get_enabled_action_id ""]
                         
                portal_content::content::edit \
                    -content_id $content_id \
                    -enabled_action_id $enabled_action_id \
                    -description $resolve_description \
                    -desc_format "text/html" \
                    -array content_row
            }
        }
    }

    ad_returnredirect $view_patch_url
    ad_script_abort
}

ad_return_template
