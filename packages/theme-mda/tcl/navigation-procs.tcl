#
#  Copyright (C) 2001, 2002 MIT
#
#  This file is part of dotLRN.
#
#  dotLRN is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#

ad_library {

    MDA.

    @author Alessandro Landim (alessandro.landim@gmail.com)
    @creation-date May 2009

}

# DRB: This needs to be cleaned up to return multirows rather than includee HTML
# in Tcl.

namespace eval mda {

    ad_proc -public portal_navbar {
        
    } {
        A helper procedure that generates the Navbar, ie the tabs,
        for dotlrn. It is called from the zen-master template.
    } {

    }

    ad_proc -public portal_subnavbar {
    } {
        A helper procedure that generates the portal subnavbar (the thing
        with the portal pages on it) for dotlrn. It is called from the
        dotlrn-master template
    } {
                
    }
}
