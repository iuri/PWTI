# /packages/portal-content/tcl/portal-content-scheduled-init.tcl


ad_library {
    
    Scheduled procs for closing contents that have not been
    treated. 
    
    @author Victor Guerra (guerra@galileo.edu)
    @creation-date 2005-02-07
    @arch-tag: 0a081603-3a9e-449f-a6d5-d5962c7f681f
    @cvs-id $Id: portal-content-scheduled-init.tcl,v 1.2 2005/07/26 15:53:40 victorg Exp $
}

ad_schedule_proc -thread t -schedule_proc ns_schedule_daily [list 03 20] portal_content::scheduled::close_contents
