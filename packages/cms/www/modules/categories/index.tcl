ad_page_contract {
    Index page for keywords

    @author Michael Steigman
    @creation-date April 2005
} {
    { id:integer,optional ""}
    { mount_point "categories" }
    { parent_id:integer,optional ""}
    { orderby "title,asc" }
    { page:optional }
}

set original_id $id

set root_id [cm::modules::${mount_point}::getRootFolderID [ad_conn package_id]]
if { [util::is_nil id] || [string equal $id _all_] } {
    set where_clause "k.parent_id is null"
} else {
    set where_clause "k.parent_id = :id"
}

# Get self
if { ![util::is_nil id] && ![string equal $id _all_] } {
    db_1row get_info "" -column_array info
} else {
    set info(is_leaf) "f"
    set info(heading) "Root"
    set info(description) "You can create content categories here in order to classify content items."
}

# Get the parent id if it is missing
if { [util::is_nil parent_id] && ![util::is_nil id] } {
     db_0or1row get_parent_info {}
#     set parent_url "index?id=$parent_id&mount_point=categories"
}
# else {
#     if {$parent_id == $root_id} {
# 	set parent_url ""
#     }
# }

set actions "
\"Create new keyword\" create?mount_point=categories&parent_id=$id \"Create new keyword within this category\"
\"Move marked keywords\" move?mount_point=categories&target_id=$id \"Move marked keywords into this category\"
"

if { [string equal $info(is_leaf) t] } {
    append actions "
\"Edit keyword\" [export_vars -base edit?mount_point=categories {id parent_id}] \"Edit keyword\"
\"Delete keyword\" [export_vars -base delete?mount_point=categories {id parent_id}] \"Delete keyword\"
"
  set what "keyword"
} else {
    append actions "
\"Edit category\" [export_vars -base edit?mount_point=categories {id parent_id}] \"Edit category\"
"
  set what "category"
}

set page_title "$info(heading) $what"
set clip [clipboard::parse_cookie]

template::list::create \
    -name items \
    -multirow items \
    -has_checkboxes \
    -actions $actions \
    -no_data "No subcategories" \
    -key item_id \
    -elements {
	copy {
	    label "Clipboard"
	    display_template "<center>@items.copy;noquote@</center>"
	}
	heading {
	    label "Name"
	    link_html { title "View this item"}
	    link_url_col keyword_url
	}
	type {
	    label "Type"
	}
	item_count {
	    label "Assigned Items"
	}
    }

# Get children
db_multirow -extend { copy keyword_url type } items get_items {} {
    if { [string match $is_leaf t] } {
	set type Keyword
    } else {
	set type Category
    }
    set id $keyword_id
    set keyword_url [export_vars -base index?mount_point=categories { id parent_id }]
    set copy [clipboard::render_bookmark categories $keyword_id [ad_conn package_url]]
}
