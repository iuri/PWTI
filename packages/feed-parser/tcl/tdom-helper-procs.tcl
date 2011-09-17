ad_library {
    Various procs to make using tDOM a bit easier.
    
    @creation-date 2003-12-28
    @author Guan Yang (guan@unicast.org)
    @author Simon Carstensen (simon@bcuni.net)
}

namespace eval feed_parser::dom {}

ad_proc -private feed_parser::dom::set_child_text {
    {-node:required}
    {-child:required}
} {
    If node contains a child node named child,
    the variable child is set to the text of that node
    in the caller's stack frame. If the node doesn't
    exist, set the text to an emptry string in the
    caller's stack frame.

    @author Guan Yang
    @creation-date 2003-07-03
    @param node A tDOM node which is supposed to contain the child
    @param child The name of the child
    @return Nothing
} {
    if { [$node hasChildNodes] } {
        set child_nodes [$node selectNodes "*\[local-name()='$child'\]"]
        upvar $child var
        if { [llength $child_nodes] == 1 } {
            set child_node [lindex $child_nodes 0]
            set var [$child_node text]
        } else {
            set var ""
        }
    }
}
