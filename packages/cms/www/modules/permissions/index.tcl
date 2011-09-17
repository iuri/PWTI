# ad_page_contract {
#     Permissions

#     @author Michael Steigman
#     @creation-date October 2004
# } {
#     { object_id:integer }
#     { mount_point:optional "sitemap" }
#     { parent_id:integer ""}
#     { return_url:optional }
#     { passthrough:optional }
# }

request create
request set_param object_id -datatype integer
request set_param mount_point -datatype keyword -optional -value sitemap
request set_param parent_id -datatype keyword -optional
request set_param return_url -datatype text -optional
request set_param passthrough -datatype text -optional

#set passthrough "id=$object_id&mount_point=$mount_point&parent_id=$parent_id"

set perms_url_extra "return_url=$return_url&passthrough=$passthrough&object_id=$object_id"

set user_id [auth::require_login]

# Determine if the user can modify permissions on this object
# Should it dump a user to an error page if no access ?
#content::check_access $id "cm_perm" -db $db -user_id $user_id \
#  -parent_id $parent_id -mount_point $mount_point

# Determine if the user is the site wide admin, and if he has the rights to \
# modify permissions at all
content::check_access $object_id "cm_examine" \
  -user_id $user_id -mount_point $mount_point -parent_id $parent_id

if { ![string equal $user_permissions(cm_perm) t] } {
  return
}

template::list::create \
    -name permissions \
    -multirow permissions \
    -key item_id \
    -actions [list "Grant more permissions to a marked user" \
		  "../permissions/permission-grant?$perms_url_extra" \
		  "Grant more permissions to a marked user"] \
    -elements {
	grantee_name {
	    label "User"
	}
	grantee_email {
	    label "Email"
	}
	pretty_name {
	    label "Privilege(s)"
	}
	edit_url {
	    display_template "@permissions.edit_url;noquote@"
	}
    }    

# Get a list of permissions that users have on the item
db_multirow -extend { grantee_email edit_url } permissions get_permissions "" {
    set grantee_email $email
    set edit_url "<a href=\"../permissions/permission-alter?$perms_url_extra&grantee_id=$grantee_id\">edit</a>"
}
		  
