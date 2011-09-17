# $Id: lrn-master.tcl,v 1.1.2.22 2007/06/21 19:42:26 emmar Exp $

set user_id [ad_get_user_id] 
set untrusted_user_id [ad_conn untrusted_user_id]
set community_id [dotlrn_community::get_community_id]
#----------------------------------------------------------------------
# Display user messages
#----------------------------------------------------------------------

util_get_user_messages -multirow "user_messages"
ah::requires -sources "jquery,superfish"

# Get system name
set system_name [ad_system_name]
set system_url [ad_url]
if { [string equal [ad_conn url] "/"] } {
    set system_url ""
}

# Logo
array set attributes [parameter::get_from_package_key -package_key "theme-zen" -parameter logoImageAttributes]
set img_attrib ""
foreach name [array names attributes] {
    append img_attrib " $name=\"$attributes($name)\""
}

set new_portal_url [site_node::get_package_url -package_key new-portal]
set package_id [ad_conn package_id]
set page_title [apm_instance_name_from_id $package_id]

## Private Message
set user_private_msg [pm::new_msg_count -user_id $user_id]

set return_url [ad_return_url]

# Get user information
set sw_admin_p [acs_user::site_wide_admin_p -user_id $untrusted_user_id]
if { $untrusted_user_id != 0 } {
    set user_name [person::name -person_id $untrusted_user_id]
    set pvt_home_url [ad_pvt_home]
    set pvt_home_name [ad_pvt_home_name]
    if [empty_string_p $pvt_home_name] {
        set pvt_home_name [_ acs-subsite.Your_Account]
    }
    set logout_url [ad_get_logout_url]

    # Site-wide admin link
    set admin_url {}

    if { $sw_admin_p } {
        set admin_url "/acs-admin/"
        set devhome_url "/acs-admin/developer"
        set locale_admin_url "/acs-lang/admin"
    } else {
        set subsite_admin_p [permission::permission_p \
                                 -object_id [subsite::get_element -element object_id] \
                                 -privilege admin \
                                 -party_id $untrusted_user_id]

        if { $subsite_admin_p  } {
            set admin_url "[subsite::get_element -element url]admin/"
        }
    }
} 


#subsite info
subsite::get -array subsite_info
set subsite_url [site_node::get_url_from_object_id -object_id $subsite_info(package_id)]

# Who's Online
set num_users_online [lc_numeric [whos_online::num_users]]
set whos_online_url [subsite::get_element -element url]shared/whos-online

if {[dotlrn::user_p -user_id $user_id]} {
    set portal_id [dotlrn::get_portal_id -user_id $user_id]
}

if { ![info exists header_stuff] } {
    set header_stuff ""
}

if {![info exists link_all]} {
    set link_all 0
}

if {![info exists return_url]} {
    set link [ad_conn -get extra_url]
} else {
    set link $return_url
}

if { ![string equal [ad_conn package_key] [dotlrn::package_key]] } {
    # Peter M: We are in a package (an application) that may or may not be under a dotlrn instance 
    # (i.e. in a news instance of a class)
    # and we want all links in the navbar to be active so the user can return easily to the class homepage
    # or to the My Space page
    set link_all 1
}

set control_panel_text [_ acs-subsite.Admin]

if {![exists_and_not_null portal_page_p]} {
		set portal_page_p 0
}
		

# Set up some basic stuff
if { [ad_conn untrusted_user_id] == 0 } {
    set user_name {}
} else {
    set user_name [acs_user::get_element -user_id [ad_conn untrusted_user_id] -element name]
}

if {![exists_and_not_null title]} {
    set title [ad_system_name]
}

if {[empty_string_p [dotlrn_community::get_parent_community_id -package_id [ad_conn package_id]]]} {
    set parent_comm_p 0
} else {
    set parent_comm_p 1
}


# DRB: Hack to ensure that subgroups keep the same color as their ultimate club or
# class parent.  A top-level community that's not a class or club will keep the
# top-level Selva colors.



append header_stuff [subst {

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="author" content="ASCOM" />
<meta name="description" content="" />
<meta name="keywords" content="" />
<meta name="robots" content="All" />
<link rel="shortcut icon" href="/resources/theme-mda/imagens/mdamain/favicon.ico"/>
<link rel="stylesheet" type="text/css" href="/resources/theme-mda/css/mdamain/skin.css"/>
<link rel="stylesheet" type="text/css" media="print" href="/resources/theme-mda/css/mdamain/print.css"/>
<link rel="stylesheet" type="text/css" href="/resources/theme-mda/css/mdamain/home.css"/>
<link rel="stylesheet" type="text/css" href="/resources/theme-mda/css/mdamain/menu_mda.css"/>
<link rel="stylesheet" type="text/css" href="/resources/acs-templating/fontsize/font-size.css" />
<link rel="stylesheet" type="text/css" href="/resources/acs-subsite/default-master.css" media="screen"/>
<link rel="alternate" type="application/rss+xml" title="Ministério do Desenvolvimento Agrário" href="${subsite_url}noticias/rss/"/>

<script type="text/javascript" src="/resources/theme-mda/js/dropdown.js"></script>
<script type="text/javascript" src="/resources/acs-templating/fontsize/font-size.js"></script>
<!--\[if lte IE 6\]>
	<style type="text/css">
		img, div { behavior:url(/resources/theme-mda/js/iepngfix.htc) }
	</style>
<!\[endif\]-->

<!--\[if IE 6\]>
	<link href="/resources/theme-mda/css/mdamain/estilos_ie6.css" rel="stylesheet" type="text/css" />
<!\[endif\]-->


}]


set doc(title) $title
if { [info exists text] } {
    set text [lang::util::localize $text]
}


# Focus
multirow create attribute key value

if { ![template::util::is_nil focus] } {
    # Handle elements wohse name contains a dot
    if { [regexp {^([^.]*)\.(.*)$} $focus match form_name element_name] } {

        # Add safety code to test that the element exists '
        append header_stuff "
          <script language=\"JavaScript\" type=\"text/javascript\">
            function acs_focus( form_name, element_name ){
                if (document.forms == null) return;
                if (document.forms\[form_name\] == null) return;
                if (document.forms\[form_name\].elements\[element_name\] == null) return;
                if (document.forms\[form_name\].elements\[element_name\].type == 'hidden') return;

                document.forms\[form_name\].elements\[element_name\].focus();
            }
          </script>
        "
        
        template::multirow append \
                attribute onload "javascript:acs_focus('${form_name}', '${element_name}')"
    }
}

# Developer-support support
set ds_enabled_p [parameter::get_from_package_key \
    -package_key acs-developer-support \
    -parameter EnabledOnStartupP \
    -default 0
]

if {$ds_enabled_p} {
    set ds_link [ds_link]
} else {
    set ds_link {}
}

set change_locale_url "/acs-lang/?[export_vars { { package_id "[ad_conn package_id]" } }]"

# Hack for title and context bar outside of dotlrn

set in_dotlrn_p [expr [string match "[dotlrn::get_url]/*" [ad_conn url]]]

# Context bar
if { [info exists context] } {
    set context_tmp $context
    unset context
} else {
    set context_tmp {}
}

ad_context_bar_multirow -- $context_tmp


# Context Bar Title
template::multirow create context_title label url nextelement

set context_node_list_all [ad_context_node_list [ad_conn node_id]]

for {set i 1} {$i < [llength $context_node_list_all]} {incr i} {
		set context_node_list [lindex $context_node_list_all $i]
		set context_title1 [lang::util::localize [lindex $context_node_list 1]]
		set context_url1 [lindex $context_node_list 0]

		template::multirow append context_title $context_title1 $context_url1 [expr $i + 1]
}


set random_top [expr [randomRange 4]  + 1]

set acs_lang_url [apm_package_url_from_key "acs-lang"]
set lang_admin_p [permission::permission_p \
                      -object_id [site_node::get_element -url $acs_lang_url -element object_id] \
                      -privilege admin \
                      -party_id [ad_conn untrusted_user_id]]
set toggle_translator_mode_url [export_vars -base "${acs_lang_url}admin/translator-mode-toggle" { { return_url [ad_return_url] } }]

# Curriculum bar
set curriculum_bar_p [llength [site_node::get_children -all -filters { package_key "curriculum" } -node_id $community_id]]

# Bring in header stuff from portlets, e.g. dhtml tree javascript
# from dotlrn-main-portlet.
global dotlrn_master__header_stuff
if { ![info exists dotlrn_master__header_stuff] } {
    set dotlrn_master__header_stuff ""
}

set url [ad_conn url]
set url_splited [split $url "/"]

set vertical_menu [menus::dropdown vertical $subsite_info(package_id)]
set horizontal_menu [menus::dropdown horizontal $subsite_info(package_id)]




switch $subsite_info(name) {
	saf {
		set info_html "
			<p class=\"secretaria\">Ministério do Desenvolvimento Agrário - Secretaria da Agricultura Familiar</p>
			<address>Setor Bancário Norte – Qd. 01 – BL D - Palácio do Desenvolvimento – 06º andar <br />
			CEP 70057-900 – Brasília – DF - Telefone: (61) 2020-0910 fax: (61) 2107-0909 </address>
			" 
	}
	sra {
		set info_html "
			<p class=\"secretaria\">Ministério do Desenvolvimento Agrário - Secretaria de Reordenamento Agrário</p>
			<address>Setor Bancário Norte – Qd. 01 – Palácio do Desenvolvimento – 10º andar<br/> CEP 70057-900 – Brasília – DF - Telefone: (61) 2020-0885/0707 - fax: (61) 2020-0508</address>
		"
	}
	default {
		set info_html ""
	}
}






# get region 5 of page. It's here because the webdesigner define one region in master, not in portal page. 
set portal_id [portal::get_mapped_portal -object_id $subsite_info(package_id)]

set subsite_admin_p [permission::permission_p -object_id $subsite_info(package_id) -party_id [ad_conn user_id] -privilege admin]

#programs banners

array set site_node [site_node::get_from_url -url ${subsite_url}programs]
set programs_package_id $site_node(package_id)

# banners

array set site_node [site_node::get_from_url -url ${subsite_url}banners]
set banners_package_id $site_node(package_id)





if {$portal_id != ""} {

	db_1row portal_select {
    	   select portals.name,
                   portals.portal_id,
                   portals.theme_id,
                   portal_layouts.layout_id,
                   portal_layouts.filename as layout_filename,
                   portal_layouts.resource_dir as layout_resource_dir,
                   portal_pages.page_id
            from portals,
                 portal_pages,
                 portal_layouts
            where portal_pages.sort_key = 0
            and portal_pages.portal_id = :portal_id
            and portal_pages.portal_id = portals.portal_id
            and portal_pages.layout_id = portal_layouts.layout_id
	} -column_array portal

	set page_id $portal(page_id)

	db_foreach element_select {
	          select portal_element_map.element_id,
    	             portal_element_map.region,
                     portal_element_map.sort_key
           	  from portal_element_map,
              	     portal_pages
              where portal_pages.portal_id = :portal_id
              and portal_element_map.page_id = :page_id
              and portal_element_map.page_id = portal_pages.page_id
              and portal_element_map.state != 'hidden'
              order by portal_element_map.region,
                     portal_element_map.sort_key
	} -column_array entry {
	   # put the element IDs into buckets by region...
	   lappend element_ids($entry(region)) $entry(element_id)
	} if_no_rows {
	   set element_ids {}
	}




	set element_list [array get element_ids]

	# set up the template, it includes the layout template,
	# which in turn includes the theme, then elements
	set element_src "/packages/new-portal/www/render_styles/individual/render-element"
}

if {$subsite_admin_p} {
	set portal_datasources [portal::list_datasources $portal_id]
	set all_datasources [portal::list_datasources]


	set subsite_node_id $subsite_info(node_id)

	db_multirow  -extend {available} applications select_applications {
    select p.package_id,
       	   p.instance_name,
           n.node_id, 
           n.name,
           p.package_key
	from   site_nodes n,
           apm_packages p,
           apm_package_types t
    where  n.parent_id = :subsite_node_id
    and    p.package_id = n.object_id
    and    t.package_key = p.package_key
    and    t.package_type = 'apm_application'
    and    exists (select 1 
                   from   all_object_party_privilege_map perm 
                   where  perm.object_id = p.package_id
                   and    perm.privilege = 'read'
                   and    perm.party_id = :user_id)
    order  by upper(instance_name)
	} {
		if {[acs_user::site_wide_admin_p]} {
			switch $package_key {
				file-storage {set package_key fs}
			}
		
			foreach datasource $all_datasources {
				set package_portlet_key [lindex [split $package_key "_"] 0]
				if {[lsearch [split $datasource "_"] $package_portlet_key] != -1 && [lsearch $portal_datasources $datasource] == -1} {
					set available "1"
				}
			}
		}

 	}
}

