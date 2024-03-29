set title [[$package_id folder_id] title]
set toc   [$page include [list toc -ajax 0 -open_page $name -decoration plain -remove_levels 1]]
set i     [$page set __last_includelet]
#my log "--last includelet = $i, class=[$i info class] [$page exists __is_book_page]"

# prevent recursive books
if {$i ne "" && ![$page exists __is_book_page]} {
  set p     [$i position]
  set count [$i count]

  if {$count > 0} {
    set book_relpos [format %.2f%% [expr {100.0 * $p / $count}]]
    if {$p>1}      {set book_prev_link [$package_id pretty_link [$i page_name [expr {$p - 1}]]]}
    if {$p<$count} {set book_next_link [$package_id pretty_link [$i page_name [expr {$p + 1}]]]}
    set page_title "<h2>[$i current] $title</h2>"
  } else {
    set book_relpos 0.0%
    set page_title "<h2>$title</h2>"    
  }
}
set header_stuff [::xo::Page header_stuff]
