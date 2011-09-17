request create -params {
  mount_point -datatype text -optional
}

set url [ad_conn url]
set package_url [ad_conn package_url]

if {[template::util::is_nil mount_point]} {
    
    #default (needed?)
    set section sitemap
    
    if {[string match *sitemap* $url]} {
	set section sitemap
    } elseif {[string match *templates* $url]} {
	set section templates
    } elseif {[string match *types* $url]} {
	set section types
    } elseif {[string match *search* $url]} {
	set section search
    } elseif {[string match *workflow* $url]} {
	set section workflow
    } elseif {[string match *workspace* $url]} {
	set section workspace
    } elseif {[string match *clipboard* $url]} {
	set section clipboard
    } elseif {[string match *categories* $url]} {
	set section categories
    } elseif {[string match *users* $url]} {
	set section users
    }
} else {
    set section $mount_point
}


set clipboard_js "${package_url}modules/clipboard/clipboard.js"