# Display a list of keywords for the item

# page variables
template::request create -params {
  item_id -datatype integer
  mount_point -datatype keyword -optional -value "sitemap"
}

permission::require_permission -party_id [auth::require_login] \
    -object_id $item_id -privilege read

set name [db_string get_name ""]

template::list::create \
    -name keywords \
    -multirow keywords \
    -key keyword_id \
    -actions [list "Assign marked keywords to this item" \
		  [export_vars -base ../categories/keyword-assign?mount_point=sitemap {item_id}] \
		  "Assign marked keywords to this item"] \
    -bulk_actions [list	"Unassign keyword" \
		       "[export_vars -base ../categories/keyword-unassign {item_id keyword_id mount_point}]" \
		       "Unassign keyword"] \
    -elements {
	heading {
	    label "Heading"
	    display_template "<a href=\"@keywords.keyword_url@\" title=\"View keyword\">@keywords.heading@</a>"
	}
	description {
	    label "Description"
	}
    }    

db_multirow -extend {keyword_url} keywords get_keywords "" {
    set keyword_url "../categories/index?id=$keyword_id&mount_point=categories"
}

set page_title "Content Keywords for $name"
