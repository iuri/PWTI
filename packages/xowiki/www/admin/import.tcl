::xowiki::Package initialize -ad_doc {
  import objects in xotcl format

  @author Gustaf Neumann (gustaf.neumann@wu-wien.ac.at)
  @creation-date Aug 11, 2006
  @cvs-id $Id: import.tcl,v 1.15 2008/09/04 11:57:38 gustafn Exp $
} -parameter {
  {create_user_ids 0}
  {replace 0}
}

set msg ""
ad_form \
    -name upload_form \
    -mode edit \
    -html { enctype multipart/form-data } \
    -form {
      {upload_file:file(file) {html {size 30}} {label "Import file for upload"} }
      {create_user_ids:integer(radio),optional {options {{yes 1} {no 0}}} {value 0} 
        {label "Create user_ids"}
        {help_text "If checked, import will create new user_ids if necessary"}
      }
      {replace:integer(radio),optional {options {{yes 1} {no 0}}} {value 0} 
        {label "Replace objects"}
        {help_text "If checked, import will delete the object if it exists and create it new, otherwise import just adds a revision"}
      }
      {ok_btn:text(submit) {label "[_ acs-templating.HTMLArea_SelectUploadBtn]"}
      }
    } \
    -on_submit {
      # check file name
      if {$upload_file eq ""} {
        template::form::set_error upload_form upload_file \
            [_ acs-templating.HTMLArea_SpecifyUploadFilename]
        break
      }

      set upload_tmpfile [template::util::file::get_property tmp_filename $upload_file]
      set f [open $upload_tmpfile]; 
      # if we do not set translation binary,
      # backslashes at the end of the lines might be lost
      fconfigure $f -translation binary -encoding utf-8; 
      set content [read $f]; close $f

      foreach o [::xowiki::Page allinstances] { 
        set preexists($o) 1
      }
      if {[catch {namespace eval ::xo::import $content} error]} {
        set msg "Error: $error"
      } else {
        set objects [list]
        foreach o [::xowiki::Page allinstances] {
          if {![info exists preexists($o)]} {lappend objects $o}
        }
        set msg [$package_id import -replace $replace -create_user_ids $create_user_ids \
                     -objects $objects]
      }
      namespace delete ::xo::import
    }


set title "Import XoWiki Pages"
set context .
ad_return_template
