# expects folder_id, parent_id, actions, orderby, page, mount_point

template::list::create \
    -name folder_items \
    -multirow folder_contents \
    -has_checkboxes \
    -key item_id \
    -no_data "There are no items in this folder" \
    -page_size 20 \
    -page_query_name get_folder_contents_paginate \
    -actions $actions \
    -elements {
	copy {
	    label "Clipboard"
	    display_template "<center>@folder_contents.copy;noquote@</center>"
	}
	title {
	    label "Name"
	    link_html { title "View this item"}
	    link_url_col item_url
	    orderby title
	}
	file_size {
	    label "Size"
	}
	publish_date {
	    label "Publish Date"
	    display_eval {
		[ad_decode $publish_status "live" \
		     [lc_time_fmt $publish_date "%q %r"] \
		     "-"]
	    }
	}
	pretty_content_type {
	    label "Type"
	}
	last_modified {
	    label "Last Modified"
	    orderby last_modified
	    display_eval {[lc_time_fmt $last_modified "%q %r"]}
	}
    } \
    -filters {
	folder_id {}
	parent_id {} 
	mount_point {}
    }

db_multirow -extend { item_url copy file_size } folder_contents get_folder_contents "" {
    switch $content_type {
	content_folder {
	    set folder_id $item_id
	    set item_url [export_vars -base index { folder_id parent_id mount_point}]
	}
	content_template {
	    set item_url [export_vars -base ../templates/properties { item_id folder_id parent_id mount_point}]
	}
	default {
	    set item_url [export_vars -base ../items/index { item_id revision_id parent_id mount_point}]
	}
    }

    if { ![ template::util::is_nil content_length ] } {
	set file_size [lc_numeric [expr $content_length / 1000.00] "%.2f"]
    } else {
	set file_size "-"
    }

    set copy [clipboard::render_bookmark $mount_point $item_id [ad_conn package_url]]
}
