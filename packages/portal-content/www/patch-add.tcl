ad_page_contract {
    Page with a form for adding a patch. If the page
    is requested without a content number then the user
    will optionally be taken to a page where contents
    that the patch covers can be chosen.

    @author Peter Marklund (peter@collaboraid.biz)
    @date 2002-09-10
    @cvs-id $Id: patch-add.tcl,v 1.13 2005/03/01 00:01:26 jeffd Exp $
} {
    content_number:integer,optional
    component_id:optional
    {return_url ""}
}

ad_require_permission [ad_conn package_id] create

if { [empty_string_p $return_url] } {
    if { [exists_and_not_null content_number] } {
        set return_url "content?[export_vars { content_number }]"
    } else {
        set return_url "patch-list"
    }
}

# User needs to be logged in here
auth::require_login

# Set some common portal-content variables
set project_name [portal_content::conn project_name]
set package_id [ad_conn package_id]
set package_key [ad_conn package_key]
set page_title [_ portal-content.New_2]
set context [list $page_title]
set user_id [ad_conn user_id]

# Is this project using multiple versions?
set versions_p [portal_content::versions_p]

# Create the form
form create patch -html { enctype multipart/form-data } -cancel_url $return_url

element create patch patch_id \
        -datatype integer \
        -widget hidden

element create patch component_id \
        -datatype integer \
        -widget select \
        -label "[_ portal-content.Component]" \
        -options [portal_content::components_get_options]

element create patch summary  \
        -datatype text \
        -label "[_ portal-content.Summary]" \
        -html { size 50 }

element create patch description  \
        -datatype text \
        -widget textarea \
        -label "[_ portal-content.Description]" \
        -html { cols 50 rows 10 } \
        -optional

element create patch description_format \
                -datatype text \
                -widget select \
                -label "[_ portal-content.Description_1]" \
    -options [list [list [_ portal-content.Plain] plain] [list [_ portal-content.HTML] html] [list [_ portal-content.Preformatted] pre ]]

element create patch version_id \
        -datatype text \
        -widget select \
        -label "[_ portal-content.Generated]" \
        -options [portal_content::version_get_options -include_unknown] \
        -optional
    
element create patch patch_file \
        -datatype file \
        -widget file \
        -label "[_ portal-content.Patch]" \

if { [exists_and_not_null content_number] } {
    # Export the content number
    element create patch content_number \
        -datatype integer \
        -widget hidden

} else {
    # There is no content number.
    # Let the user indicate if he wants to select contents that this
    # patch covers if no content number was supplied
    element create patch select_contents_p \
            -datatype text \
            -widget radio \
            -label "[_ portal-content.Choose_1]" \
            -options { {Yes 1} {No 0} } \
            -values { 1 }
}


if { [form is_request patch] } {
    # Form requested

    if { [exists_and_not_null content_number] } {
        element set_properties patch content_number -value $content_number
    }

    element set_properties patch patch_id -value [db_nextval "acs_object_id_seq"]

    element set_properties patch version_id \
            -value [portal_content::conn user_version_id]

    if { !$versions_p } {
        element set_properties patch version_id -widget hidden
    }

    if { [info exists component_id] } {
        element set_properties patch component_id -value $component_id
    }    
}

if { [form is_valid patch] } {
    # Form submitted

    db_transaction {

        form get_values patch patch_id component_id summary description description_format version_id patch_file

        # Get the file contents as a string
        set content [portal_content::get_uploaded_patch_file_content]

        set ip_address [ns_conn peeraddr]
        
        db_exec_plsql new_patch {}

        set patch_number [db_string patch_number_for_id {}]

        # Redirect to the view page for the created patch by default
        if { [empty_string_p $return_url] } {
            set redirect_url "patch?[export_vars { patch_number }]"
        } else {
            set redirect_url $return_url
        }
        
        # Fetch any provided content id to map the patch to
        catch {set content_number [element get_value patch content_number]}
        if { [info exists content_number] } {
            # There is a content id provided - map it to the patch
            set content_id [portal_content::get_content_id -content_number $content_number -project_id $package_id]
            portal_content::map_patch_to_content -patch_id $patch_id -content_id $content_id

        } else {
            # No content id provided so redirect to page for selecting contents if the
            # user wishes to go there
            set select_contents_p [element get_value patch select_contents_p]
            
            if { $select_contents_p } {
                set redirect_url "map-patch-to-contents?[export_vars -url { return_url patch_number component_id }]"
            }
        }
    }

    ad_returnredirect $redirect_url
    ad_script_abort
}

ad_return_template
