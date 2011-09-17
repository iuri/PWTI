array set config $cf

set url [site_node::get_url_from_object_id -object_id $config(package_id)]
#regsub {/[^/]+$} [ad_conn url] "/xowiki/$config(page_name)" url

set url "${url}${config(page_name)}"
