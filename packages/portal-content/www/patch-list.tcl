ad_page_contract {
    Page that lists patches in this Portal Content
    project.

    @author Peter Marklund (peter@collaboraid.biz)
    @date 2002-09-10
    @cvs-id $Id: patch-list.tcl,v 1.8 2004/03/29 15:07:34 peterm Exp $
} {
    {component_id:integer,optional}
    {apply_to_version:integer,optional}
    {status:trim,optional}
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

set Patches_name [portal_content::conn Patches]
set Patch_name [portal_content::conn Patch]

set page_title "$Patches_name" 
set context [list $page_title]

# TODO: Use portal_content::patch_status_pretty for pretty state (problem with the filter, but it can be done)

template::list::create \
    -name patches \
    -multirow patches \
    -elements {
        patch_number {
            label "[portal_content::conn Patch]"
            display_template {\#@patches.patch_number@}
            html { align right }
        }
        summary {
            label "[_ portal-content.Summary]"
            link_url_eval {[export_vars -base patch { patch_number }]}
        }
        status {
            label "[_ portal-content.Status]"
            display_eval {[string totitle $status]}
        }
        apply_to_version_name {
            label "[_ portal-content.Apply]"
            display_template {
                <if @patches.apply_to_version_name@ not nil>@patches.apply_to_version_name@</if>
                <else><i>Undecided</i></else>
            }
        }
        component_name {
            label "[_ portal-content.Component]"
        }
        creation_date_pretty {
            label "[_ portal-content.Submitted]"
        }
    } -filters {
        status {
            label "[_ portal-content.Status]"
            values {[db_list_of_lists select_states {}]}
            where_clause {[db_map states_where_clause]}
        }
        apply_to_version {
            label "[_ portal-content.Apply_1]"
            values {[db_list_of_lists select_versions {}]}
            where_clause {[db_map apply_to_version_where_clause]}
            null_where_clause {[db_map apply_to_version_null_where_clause]}
            null_label {Undecided}
        }
        component_id {
            label "[_ portal-content.Component]"
            values {[db_list_of_lists select_components {
            }]}
            where_clause {[db_map component_where_clause]}
        }
    }


db_multirow patches select_patches {} 

