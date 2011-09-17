template::list::create \
    -name template_revisions \
    -multirow revisions \
    -has_checkboxes \
    -key item_id \
    -elements {
	revision_number {
	    label "\#"
	}
	file_size {
	    label "Size"
	}
	modified {
	    label "Last Modified"
	}	
	modified_by {
	    label "Author"
	}
	msg {
	    label "Comment"
	}
	status {
	    label "Status"
	}
	publish_revert {
	    display_template "<a href=\"@revisions.publish_url@\" title=\"Publish template\">publish</a><if @revisions.revision_number@ ne @revisions.revision_total@> \
                              &nbsp; | &nbsp; <a href=\"@revisions.revert_url@\" title=\"Revert\">revert</a></if>" 
	}
    }


# template ID is passed to included template

set live_revision [db_string get_live_revision ""]

# first count all revisions

set revision_count [db_string get_revision_count ""]

set counter $revision_count

db_multirow -extend { revision_number publish_url revert_url status publish_revert revision_total } revisions get_revisions "" {
    set revision_number $counter
    incr counter -1
    set edit_revision $revision_id
    set revision_total $revision_count
    set publish_url [export_vars -base publish { revision_id }]
    set revert_url [export_vars -base edit { template_id edit_revision }]
    if { $revision_id == $live_revision } {
	set status "live"
    }
}
