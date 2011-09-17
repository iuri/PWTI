#TODO: JCD: EXTRACT QUERIES for patch (or really refactor patch.tcl so they both call patch::get)

ad_library {
    Bug tracker - Search Service Contracts

    @creation-date 2004-04-20
    @author Jeff Davis davis@xarg.net
    @cvs-id $Id: content-search-procs.tcl,v 1.3 2005/12/01 13:25:27 eduardop Exp $
}

namespace eval portal_content::search {}
namespace eval portal_content::search::content {}
namespace eval portal_content::search::patch {}

ad_proc -private portal_content::search::content::datasource { content_id } {
    returns a datasource for the search package this is the content 
    that will be indexed by the full text search engine.

    @param content_id

    @author Jeff Davis davis@xarg.net
} {
    portal_content::content::get -content_id $content_id -array row

    set case_id [workflow::case::get_id \
                     -object_id $content_id \
                     -workflow_short_name [portal_content::content::workflow_short_name]]

    workflow::case::get -case_id $case_id -array case

    template::multirow -local create roles role_pretty email user_id user_name user_url
    foreach role_id [workflow::get_roles -workflow_id $case(workflow_id)] {
        workflow::role::get -role_id $role_id -array role 
        foreach assignee [workflow::case::role::get_assignees -case_id $case_id -role_id $role_id] {
            array set ass $assignee
            template::multirow -local append roles \
                $role(pretty_name) $ass(email) $ass(party_id) $ass(name) \
                "[ad_url][acs_community_member_url -user_id $ass(party_id)]"
            array unset ass
        }
        array unset role
    }

    set comments [workflow::case::get_activity_html -case_id $case_id]

    set title "Bug $row(content_number_display) - $row(summary) \[$row(component_name)\]"
    set base [apm_package_url_from_id $row(project_id)]
    set full "[ad_url]$base"

    set body [template::adp_include /packages/portal-content/lib/one-content [list &content "row" & roles base $full & comments style feed]]

    return [list object_id $content_id \
                title $title \
                content $body \
                keywords $row(component_name) \
                storage_type text \
                mime text/plain \
                syndication [list link "${full}content?content_number=$row(content_number)" \
                                 description $title \
                                 author XXX \
                                 category contents \
                                 guid "[ad_url]/o/$content_id" \
                                 pubDate "2004-04-20 12:01:34" \
                                 ] \
                ]
}

ad_proc -private portal_content::search::content::url { content_id } {
    returns a url for a given content_id

    @param content_id
    @author Jeff Davis davis@xarg.net
} {
    if {[db_0or1row get {select project_id, content_number from bt_contents where content_id = :content_id}]} {
        return "[ad_url][apm_package_url_from_id $project_id]content?content_number=$content_number"
    } else {
        error "content_id $content_id not found"
    }
}


ad_proc -private portal_content::search::patch::datasource { patch_id } {
    returns a datasource for the search package this is the content 
    that will be indexed by the full text search engine.

    @param patch_id

    @author Jeff Davis davis@xarg.net
} {
    db_1row patch {
        select bt_patches.patch_id,
            bt_patches.patch_number,
            bt_patches.project_id,
            bt_patches.component_id,
            bt_patches.summary,
            bt_patches.content,
            bt_patches.generated_from_version,
            bt_patches.apply_to_version,
            bt_patches.applied_to_version,
            bt_patches.status,
            bt_components.component_name,
            acs_objects.creation_user as submitter_user_id,
            submitter.first_names as submitter_first_names,
            submitter.last_name as submitter_last_name,
            submitter.email as submitter_email,
            acs_objects.creation_date,
            to_char(acs_objects.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date_pretty,
            to_char(now(), 'YYYY-MM-DD HH24:MI:SS') as now_pretty
     from bt_patches,
          acs_objects,
          cc_users submitter,
          bt_components
     where bt_patches.patch_id = :patch_id
       and bt_patches.patch_id = acs_objects.object_id
       and bt_patches.component_id = bt_components.component_id
       and submitter.user_id = acs_objects.creation_user
    } -column_array patch

    set title "Patch $patch(patch_number) - $patch(summary) \[$patch(component_name)\]"
    set content "Patch $patch(patch_number) - $patch(summary) \[$patch(component_name)\]
 submitted by $patch(submitter_first_names) $patch(submitter_last_name) $patch(submitter_email)
 Created $patch(creation_date_pretty) 
 Applies to $patch(generated_from_version) - $patch(apply_to_version)
 Status $patch(status)

"
    # Description/Actions/History
    db_foreach actions { 
        select bt_patch_actions.action_id,
               bt_patch_actions.action,
               bt_patch_actions.actor as actor_user_id,
               actor.first_names as actor_first_names,
               actor.last_name as actor_last_name,
               actor.email as actor_email,
               bt_patch_actions.action_date,
               to_char(bt_patch_actions.action_date, 'YYYY-MM-DD HH24:MI:SS') as action_date_pretty,
               bt_patch_actions.comment_text,
               bt_patch_actions.comment_format
        from   bt_patch_actions,
               cc_users actor
        where  bt_patch_actions.patch_id = :patch_id
        and    actor.user_id = bt_patch_actions.actor
        order  by action_date
    } {
        append content "$action_date_pretty [portal_content::patch_action_pretty $action] by $actor_first_names $actor_last_name
 [portal_content::content_convert_comment_to_text -comment $comment_text -format $comment_format]\n"
    }

    append content "PATCH CONTENT:\n\n$patch(content)\n"

    return [list object_id $patch_id \
                title $title \
                content $content \
                keywords $patch(component_name) \
                storage_type text \
                mime text/plain ]
}


ad_proc -private portal_content::search::patch::url { patch_id } {
    returns a url for a given patch_id

    @param patch_id
    @author Jeff Davis davis@xarg.net
} {
    if {[db_0or1row get {select project_id, patch_number from bt_patches where patch_id = :patch_id}]} {
        return "[ad_url][apm_package_url_from_id $project_id]patch?patch_number=$patch_number"
    } else {
        error "content_id $content_id not found"
    }
}

ad_proc -private portal_content::search::register_implementations {} {
    Register the forum_forum and forum_message content type fts contract
} {
    db_transaction {
        portal_content::search::register_content_fts_impl
        portal_content::search::register_patch_fts_impl
    }
}

ad_proc -private portal_content::search::unregister_implementations {} {
    db_transaction { 
        acs_sc::impl::delete -contract_name FtsContentProvider -impl_name bt_content
        acs_sc::impl::delete -contract_name FtsContentProvider -impl_name bt_patch
    }
}

ad_proc -private portal_content::search::register_content_fts_impl {} {
    set spec {
        name "bt_content"
        aliases {
            datasource portal_content::search::content::datasource
            url portal_content::search::content::url
        }
        contract_name FtsContentProvider
        owner portal-content
    }

    acs_sc::impl::new_from_spec -spec $spec
}

ad_proc -private portal_content::search::register_patch_fts_impl {} {
    set spec {
        name "bt_patch"
        aliases {
            datasource portal_content::search::patch::datasource
            url portal_content::search::patch::url
        }
        contract_name FtsContentProvider
        owner portal-content
    }

    acs_sc::impl::new_from_spec -spec $spec
}


