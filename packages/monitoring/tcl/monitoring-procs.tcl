# /packages/monitoring/tcl/monitoring-procs.tcl
ad_library {
     
    @author jbank@arsdigita.com [jbank@arsdigita.com]
    @creation-date Mon Jan 29 16:50:23 2001
    @cvs-id $Id: monitoring-procs.tcl,v 1.1.1.2 2006/08/24 14:41:37 alessandrol Exp $
}

if { [llength [info proc apm_package_id_from_key]] == 0 } {
    proc apm_package_id_from_key {package_key} {
        return [db_string apm_package_id_from_key {
            select package_id from apm_packages where package_key = :package_key
        } -default 0]
    }
}

ad_proc monitoring_pkg_id {} {
    Return the monitoring package id
} {
    return [apm_package_id_from_key monitoring]
}

ad_proc ad_monitor_format_kb { num } {
    format_kb takes in an integer, assumed to be a size value in
    kilobytes, and returns a prettily formatted value followed by
    a descriptive quantifier. 
} {
    if {$num < 0} {
        return [format "%5.1f Kb" [util_commify_number $num]]
    } else {
        switch [expr {([string length $num] - 1) / 3}] {
            0   { return [append num  " Kb"] }
            1   { return [format "%5.1f Mb" [expr {$num / 1000.0}]] }
            default { return [format "%5.1f Gb" [util_commify_number [expr {$num / 1000000.0}]]] }
        }   
    }   
}


ad_proc ad_monitor_top {} { 
    ad_monitor_top parses the output from
    "top" and stores the results in a table. This is useful to later
    create reports of load averages and memory usage in a time-sensitive
    way.

    Required Parameters in the monitoring section:
      * TopLocation: Full path to execute top

    Optional Parameters:
      * LoadAverageAlertThreshold: Minimum load average before emailing
        persons to notify that the machine is overloaded

} {
    
    # list indicating the order in which top outputs data
    set proc_var_list [list pid username threads priority nice proc_size resident_memory state cpu_total_time cpu_pct command]
    # location of the desired top function
    set top_location [ad_parameter -package_id [monitoring_pkg_id] TopLocation monitoring "/usr/bin/top"]
    set top_options [ad_parameter -package_id [monitoring_pkg_id] TopOptions monitoring "-bn 1"]
    
    # make sure we have a path to top and that the file exists
    if { [empty_string_p $top_location] } {
        ns_log Error "ad_monitor_top: cannot find top; TopLocation parameter in monitoring is not defined"
        return
    } elseif { ![file exists $top_location] } {
        ns_log Error "ad_monitor_top: Specified location for top ($top_location) does not exist"
        return
    }
    
    
    if [catch { set top_output [eval "exec $top_location $top_options"] } errmsg] {
        
	# couldn't exec top at TopLocation
        if { ![file exists $top_location] } {
            ns_log Error "ad_monitor_top: top not found $top_location: $errmsg"
            return
        }
	
	
	#TEKNE o comando eval exec retorna algo por causa da saida de dados, mas nao e erro, comparo se foi a mensagem "child process exited abnormally"
	if { [regexp "child process exited abnormally" $errmsg]  } {
        # this error means there was nothing on stderr (which makes sense) and
        # there was a non-zero exit code - this is OK as we intentionally send
        # stderr to stdout, so we just do nothing here (and return the output)
	set top_output $errmsg
	# ns_log Error "ad_monitor_top: ok #### top_output: $top_output"

        } else {
	
        ns_log Error "ad_monitor_top: top could not be run - $errmsg "
        # return
       }
       
       
    }
    
    
    
    
    # else top execution went ok
    set top_list [split $top_output "\n"]

    ## Run through the output of top, grab header lines and leave the rest. 
    # number of header lines grabbed
    set ctr 0       
 
    # id for this iteration of top-parsing
    set top_id [db_nextval ad_monitoring_top_top_id]

    # have we reached the list of process info yet?    
    set procflag 0  
    foreach line $top_list {
        if { $procflag > 0 } {
            #compress multiple spaces
            regsub -all {[ ]+} [string trim $line] " " line    
            set proc_list [split $line]

            #skip blank lines
            if { [llength $proc_list] < 2 } { continue } 
            if { [llength $proc_list] < 11 } { 
                ns_log Debug "skipping top process line: $line\nelement list shorter than variable list."
                continue 
            }
        
            #set proc-related vars
            #vinodk: top (procps v.2.0.7 has different columns)
            #set pid       [lindex $proc_list 0]
            #set username  [lindex $proc_list 1]
            #set threads   [lindex $proc_list 2]
            #set priority  [lindex $proc_list 3]
            #set nice      [lindex $proc_list 4]
            #set proc_size [lindex $proc_list 5]
            #set resident_memory [lindex $proc_list 6]
            #set state           [lindex $proc_list 7]
            #set cpu_total_time  [lindex $proc_list 8]
            #set cpu_pct   [lindex $proc_list 9]
            #set command   [lindex $proc_list 10]

            set pid       [lindex $proc_list 0]
            set username  [lindex $proc_list 1]
            set threads   0
            set priority  [lindex $proc_list 2]
            set nice      [lindex $proc_list 3]
            set proc_size [lindex $proc_list 4]
            set resident_memory [lindex $proc_list 5]
            set state           [lindex $proc_list 7]
            set cpu_total_time  [lindex $proc_list 10]
            set cpu_pct   [lindex $proc_list 8]
            set command   [lindex $proc_list 11]

            if {$priority == "RT"} {
                 set priority 0
            }  
           	   	    
            set proc_id [db_nextval ad_monitoring_top_proc_proc_id]

            db_dml top_proc_info_insert "*SQL*"

            continue   

        } elseif { [regexp -nocase {(.*PID.USER.*)} $line match top_header] } {
            ## this is the start of proc info lines
            incr procflag

            continue

        } elseif { [regexp -nocase {load av[a-z]*: (.*)} $line match load] } {
            ## this is the load header 
            incr ctr

            # remove commas, multiple spaces
            regsub -all {,} [string trim $load] "" load   
            regsub -all {[ ]+} $load " " load             

            set load_list [split $load " "]

            # We keep all three load avgs, ignore the time at the end of the line
            set load_1  [lindex $load_list 0]
            set load_5  [lindex $load_list 1]
            set load_15 [lindex $load_list 2]

            # send out any high-load alerts
            if { $load_5 > [ad_parameter -package_id [monitoring_pkg_id] LoadAverageAlertThreshold monitoring 2.0] } {
                wd_email_notify_list "High Load Average on [ad_url]" \
                        "The load average over the last 5 minutes for [ad_url] was $load_5"
            } 

        } elseif { [regexp -nocase {mem[a-z]*: (.*)} $line match memory] } {
            ## this is the memory header 
            foreach mem [split $memory ","] {
                regexp {^ *([^ ]*) (.*)} $mem match amount type
                set amount [string trim [string toupper $amount]]
                # convert all mem values to Kilobytes 
                regsub {K$} $amount "" amount
                regsub {M$} $amount "000" amount

                set type [string trim [string tolower $type]]
                switch $type {
                    "real" { set memory_real $amount }
                    "free" { set memory_free $amount }
                    "swap free" { set memory_swap_free $amount }
                    "swap in use" { set memory_swap_in_use $amount }
                    "total" { set memory_real $amount }                 
                }
            } 

            # my version of top has Mem and Swap on different lines
            # don't increment ctr until we get both
            if {[info exists memory_real] && [info exists memory_swap_free]} {
                incr ctr
            }
        } elseif { [regexp -nocase {swa[a-z]*: (.*)} $line match memory] } {
            ## this is the swap header 
            foreach mem [split $memory ","] {
                regexp {^ *([^ ]*) (.*)} $mem match amount type
                set amount [string trim [string toupper $amount]]
                # convert all mem values to Kilobytes 
                regsub {K$} $amount "" amount
                regsub {M$} $amount "000" amount

                set type [string trim [string tolower $type]]
                switch $type {
                    "free" { set memory_swap_free $amount }
                    "used" { set memory_swap_in_use $amount }
                }
            } 

            # my version of top has Mem and Swap on different lines
            # don't increment ctr until we get both
            if {[info exists memory_real] && [info exists memory_swap_free]} {
                incr ctr
            }
        } elseif { [regexp -nocase {tasks[a-z]*: (.*)} $line match tasks_line] } {
            
	    ns_log notice "top - outras informacoes $tasks_line"
	    
	    ## this is the task header 
            foreach task [split $tasks_line ","] {
                regexp {^ *([^ ]*) (.*)} $task match amount type
                set amount [string trim [string toupper $amount]]
            
                set type [string trim [string tolower $type]]
		
		#sample of task line on DEBIAN
		#Tasks:  83 total,   1 running,  82 sleeping,   0 stopped,   0 zombie

		
                switch $type {
                    "total"    { set procs_total    $amount }
                    "running"  { set procs_on_cpu   $amount }
		    "sleeping" { set procs_sleeping $amount }
		    "stopped"  { set procs_stopped  $amount }
		    "zombie"   { set procs_zombie   $amount }
		    
                }
		
		
		ns_log notice "$type $amount"
            } 

           
                    
        } elseif { [regexp -nocase {Cpu[^ ]*: (.*)} $line match cpu_lines] } {

            ns_log notice "top - outras informacoes $line"
 
            ## this is the task header
            foreach task [split $cpu_lines ","] {
                regexp {^ *([0-99.99]*)(.*)} $task match amount type
                regsub " " $type "" type
                
                set type [string trim [string tolower $type]]
                
                #sample of task line on DEBIAN
                #Cpu(s): 10.9% us,  1.3% sy,  0.0% ni, 87.4% id,  0.0% wa,  0.3% hi,  0.0% si

                
                switch $type {
                    "%us"   { set cpu_user    	$amount }
                    "%sy"   { set cpu_system    $amount }
                    "%ni"   { set cpu_nice  	$amount }
                    "%id"   { set cpu_idle  	$amount }
                    "%wa"   { set cpu_wa   	$amount }
                    "%hi"   { set cpu_hi  	$amount }
                    "%si"   { set cpu_si   	$amount }
                }
              
           }
        }

        
        if {$ctr == 2 } {
            ## we have all the header information we currently store.
            ## we should also store the rest of top's output... 
            ## some of it can be gotten from the zoom package. 
            db_dml top_misc_info_insert "*SQL"
            incr ctr
        }
        # end of the foreach loop
    }

    if { $ctr < 2 } {
        # didn't even get load and memory lines from top
        ns_log Error "ad_monitor_top: Cannot parse output from top"
        return
    }
}



ad_proc ad_monitoring_analyze_tables {} {

    This procedure analyzes all the tables in the database. New tables
    are automatically added to the table "ad_monitoring_tables_estimated."
    If you want, you can disable estimates on particular tables by going
    to /www/admin/monitoring/analyze.

    The Parameter NumDaysToEstAllRows is used to specify how many days
    it should take to estimate statistics for all tables. For example, the
    default setting of 7 days means that each night, we will estimate
    statistics for 1/7th of the tables in the database.

    Written by kschmidt@arsdigita.com, 6/28/2000

} {

    # Are we even doing this?
    if {[ad_parameter -package_id [monitoring_pkg_id] AutoAnalyzeP monitoring 0]==0} {
        ns_log debug "ad_monitoring_analyze_tables: Not Analyzing Tables"
        return
    }
    
    #how many days should a complete scan take
    set numdays [ad_parameter -package_id [monitoring_pkg_id] NumDaysToEstAllRows monitoring 7]
    if {$numdays < 1} {
        ns_log error "ad_monitoring_analyze_tables: Parameter NumDaysToEstAllRows cannot be less than 1."
        return
    }
    
    # grab a handle
    #set db [ns_db gethandle subquery]
    
    # This is used to update the list of tables which should be analyzed
    # by checking to see if any new tables have been added to the database
    db_dml new_tables_to_be_analyzed_insert "insert into ad_monitoring_tables_estimated 
                   (table_entry_id, table_name)
                   select ad_monitoring_tab_est_seq.nextval,table_name 
                   from user_tables ut 
                   where not exists (select 1 
                      from ad_monitoring_tables_estimated amte
                      where upper(amte.table_name)=upper(ut.table_name))"

    # Grab the first fraction of rows, organized by the last time they 
    # were analyzed

    set alltables [db_list_of_lists tables_to_analayze_select_fraction "
        select table_name, percent_estimating, table_entry_id
        from (select amte.*
              from ad_monitoring_tables_estimated amte 
              where enabled_p='t'
              order by nvl(last_estimated, sysdate-100) asc)
        where rownum < (select count(*)/:numdays from ad_monitoring_tables_estimated)
    "]
    
    # Now we go through each item
    foreach table_item  $alltables {
        # Variables to be used JAva

        set entry_id [lindex $table_item 2]
        set table_name [lindex $table_item 0]
        set percent [lindex $table_item 1]
        
        #The string to execute.  Don't use bind vars since you can't bind on table name.
        set execstr "analyze table $table_name estimate statistics sample $percent percent"
    
        # for some reason this failed.. probably cause the table doesn't exists
        # anymore
        ns_log debug "Analyzing $table_name.."
        if {[catch {db_dml table_analyze $execstr} errmsg]} {
            # Look up the table in user_tables
            if { ![db_table_exists $table_name] } {
                # The table wasn't listed.. so we disable this entry
                db_dml one_table_entry_disable_monitoring "update ad_monitoring set enabled_p='f' 
                where table_entry_id=:entry_id" 
            } else {
                ns_log error "ad_monitoring_analyze_tables: Error while executing: $execstr"
            }
        } else {
            #Change the last estimated, and continue looping
            db_dml one_table_entry_update_last_estimated "
              update ad_monitoring_tables_estimated
              set last_estimated=sysdate, 
                  last_percent_estimated=percent_estimating 
              where table_entry_id=:entry_id"
        } 
    } 
    db_release_unused_handles
}

ad_proc ad_monitor_db_pgsql {} { 

    ad_monitor_db show db size of database postgresql

} {


set version_db [ad_parameter -package_id [monitoring_pkg_id] VersionDB monitoring "7.4"]
set database_name [db_get_database]
 

	ns_log notice "version_db == $version_db"
    if { $version_db == "8.1" } {
  
            
            if { [catch {set db_size [db_string db_size_sql8 {*SQL*}]} errmsg]} {
               
               	ad_return_error "#monitoring.Error_in_version_db#" "
        	#monitoring.The_database_version_is_incorrect#:
        	#monitoring.Change_the_database_version_in_parameters_of_monitoring#"
        	return
            }
                            
     } else {

           if { [catch {set db_size [db_string db_size_sql {*SQL*}]} errmsg]} {

                ad_return_error "#monitoring.Error_in_version_db#" "
                #monitoring.The_database_version_is_incorrect_or_not_instaled#:
                #monitoring.Change_the_database_version_in_parameters_of_monitoring_or_if#"
                return
            }

    }

 set size_content_repository  [lindex [split [exec du -bs [acs_root_dir]/content-repository-content-files] "\t "] 0]
 set db_id [db_nextval ad_monitoring_db_db_id]
 db_dml db_misc_size_insert "*SQL"

} 

ad_proc img_color { 
   -value:required
} {
    color
} {

    if { $value <= 20 } {

    	set image_color vp.png

    } elseif { $value > 20 && $value <= 70} {

    	set image_color vk.png

    } elseif { $value > 70 } {

    	set image_color vu.png

    }

   return $image_color

}
