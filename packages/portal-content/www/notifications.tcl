ad_page_contract {
    Manage portal-content notifications
} {
    content_number:integer,optional
}

set page_title [_ portal-content.Notifications]
set context [list $page_title]

set workflow_id [portal_content::content::get_instance_workflow_id]
if { [exists_and_not_null content_number] } {
    set content_id [portal_content::get_content_id \
                    -content_number $content_number \
                    -project_id [ad_conn package_id]]

    set case_id [workflow::case::get_id \
                     -object_id $content_id \
                     -workflow_short_name [portal_content::content::workflow_short_name]]
} else {
    set case_id {}
}

set user_id [ad_conn user_id]
set return_url [ad_return_url]

multirow create notifications url label title subscribed_p

set contents_name [portal_content::conn contents]

foreach type { 
    workflow_assignee workflow_my_cases workflow
} {
    set object_id [workflow::case::get_notification_object \
                       -type $type \
                       -workflow_id $workflow_id \
                       -case_id $case_id]

    if { ![empty_string_p $object_id] } {
        switch $type {
            workflow_assignee {
                set pretty_name [_ portal-content.All_2]
            }
            workflow_my_cases {
                set pretty_name [_ portal-content.All_3]
            }
            workflow {
                set pretty_name [_ portal-content.All_4]
            }
            default {
                error "[_ portal-content.Unknown_1]"
            }
        }

        # Get the type id
        set type_id [notification::type::get_type_id -short_name $type]

        # Check if subscribed
        set request_id [notification::request::get_request_id \
                            -type_id $type_id \
                            -object_id $object_id \
                            -user_id $user_id]

        set subscribed_p [expr ![empty_string_p $request_id]]
        
        if { $subscribed_p } {
            set url [notification::display::unsubscribe_url -request_id $request_id -url $return_url]
        } else {
            set url [notification::display::subscribe_url \
                         -type $type \
                         -object_id $object_id \
                         -url $return_url \
                         -user_id $user_id \
                         -pretty_name $pretty_name]
        }

        if { ![empty_string_p $url] } {
            multirow append notifications \
                $url \
                [string totitle $pretty_name] \
                [ad_decode $subscribed_p 1 "[_ portal-content.Unsubscribe_1]" "[_ portal-content.Subscribe_1]"] \
                $subscribed_p
        }
    }
}

set manage_url "[apm_package_url_from_key [notification::package_key]]manage"
