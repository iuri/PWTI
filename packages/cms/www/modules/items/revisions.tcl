# Display a list of revisions for the item

# page variables
template::request create -params {
  item_id -datatype integer
  mount_point -datatype keyword -optional -value sitemap
}

permission::require_permission -party_id [auth::require_login] \
    -object_id $item_id -privilege read

# add content html
set content_type [db_string get_content_type ""]

# get item info
db_1row get_iteminfo ""

template::list::create \
    -name revisions \
    -multirow revisions \
    -actions [list "Add revision via File Upload" \
		  [export_vars -base revision-add-2?content_method=file_upload {item_id content_type}] \
		  "Add revision via File Upload" \
		  "via Text Entry" \
    		  [export_vars -base revision-add-2?content_method=text_entry {item_id content_type}] \
		  "Add revision via Text Entry" \
		  "via No Content" \
		  [export_vars -base revision-add-2?content_method=no_content {item_id content_type}] \
		  "Add revision without content" \
		  "via XML Import" \
    		  [export_vars -base revision-add-2?content_method=xml_import {item_id content_type}] \
		  "Add revision via XML Import"] \
    -elements {
	revision_number {
	    label "\#"
	}
	title {
	    label "Title"
	}
	description {
	    label "Description"
	}
	pretty_date {
	    label "Date"
	}
	view {
	    display_template "<a href=\"@revisions.revision_id_url;noquote@\" title=\"View revision\">view</a>"
	}
    }    

db_multirow -extend { pretty_date revision_id_url view } revisions get_revisions "" {
    if {[template::util::is_nil $description]} {
	set description "-"
    }
    set pretty_date [lc_time_fmt $publish_date "%Q %X"]
    set revision_id_url "revision?revision_id=$revision_id"
}
