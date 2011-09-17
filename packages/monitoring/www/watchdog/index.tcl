# /admin/monitoring/watchdog/index.tcl

ad_page_contract {
    @cvs-id $Id: index.tcl,v 1.2 2006/11/11 22:01:18 alessandrol Exp $
} {
    kbytes:integer,optional
    num_minutes:integer,optional
}

if { [info exists num_minutes] && ![empty_string_p $num_minutes] } {
    set kbytes ""
    set bytes ""
} else {
    set num_minutes ""
    if { ![info exists kbytes] || [empty_string_p $kbytes] } {
    set kbytes 200
    }
    set bytes [expr $kbytes * 1000]
}

set title "WatchDog"
set context [list "$title"]

set whole_page "



<FORM ACTION=index>    
#monitoring.Errors_from_the_last# <INPUT NAME=kbytes SIZE=4 value=\"$kbytes\"> #monitoring.Kbytes_of_error_log#. 
<INPUT TYPE=SUBMIT VALUE=\"#monitoring.Search_again#\">
</FORM>

<FORM ACTION=index>
#monitoring.Errors_from_the_last# <INPUT NAME=num_minutes SIZE=4 value=\"$num_minutes\"> 
#monitoring.minutes_of_error_log#. <INPUT TYPE=SUBMIT VALUE=\"#monitoring.Search_again#\">
</FORM>

<PRE>
[ns_quotehtml [wd_errors -external_parser_p 1 -num_minutes "$num_minutes" -num_bytes "$bytes"]]
</PRE>


"
