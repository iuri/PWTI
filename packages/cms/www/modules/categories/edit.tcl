# Edit a subject category

template::request create
template::request set_param id -datatype keyword
template::request set_param parent_id -datatype keyword -optional
request set_param mount_point -datatype keyword -optional -value categories

# Get existing data
db_1row get_info "" -column_array info

form create edit_keyword

element create edit_keyword keyword_id \
  -label "Keyword ID" -datatype integer -widget hidden -value $id

element create edit_keyword heading \
  -label "Heading" -datatype text -widget text -html { size 30 } \
  -value $info(heading) \

element create edit_keyword description -optional \
  -label "Description" -datatype text -widget textarea -html { rows 5 cols 60 } \
  -value $info(description)

if { [form is_valid edit_keyword] } {

  form get_values edit_keyword keyword_id heading description

  db_transaction {
      db_exec_plsql edit_keyword {}
  }

  set id $keyword_id
  ad_returnredirect [export_vars -base index { id parent_id mount_point }]
}


  
