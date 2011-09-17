# /admin/monitoring/configuration/index.tcl

ad_page_contract { 
    Displays some basic information about this installation of AOLServer:
    IP Address, System Name, and System Owner.

    @cvs-id $Id: index.tcl,v 1.2 2006/11/11 22:01:18 alessandrol Exp $
} {
}

set title "[ad_system_name] #monitoring.Configuration#"
set context [list "$title"]


set whole_page "

<ul>
<li>#monitoring.IP_Address#: [ns_conn peeraddr]
<li>#monitoring.System_Name#: [ad_system_name]
<li>#monitoring.System_Owner#: <a href=mailto:[ad_system_owner]>[ad_system_name]</a>
</ul>

"
