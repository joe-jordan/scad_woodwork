// ALL UNITS IN centimetres.
include<worktop/config.scad>
include<worktop/lumber_dimensions.scad>

include<worktop/trestle.scad>
include<worktop/leg.scad>


wt_height = 95;
wt_depth = 70;
wt_width = 300;

leg_v2_x = two_by;
leg_x = two_by;

tenon_thickness = four_by / 3;

groove_depth = 1;

btrestle_z_off = 13.5;

module solo_trestle() {
    btrestle_length = wt_depth - leg_v2_x;
    btrestle_tenon_length = leg_x;
    
    trestle(btrestle_length, btrestle_tenon_length, tenon_thickness, groove_depth, ply_thickness_panel);
}

module solo_trestle_leg() {
    length = wt_height - ply_thickness_top;
    leg(length, btrestle_z_off, tenon_thickness, groove_depth);
}


module whole_room() {
    // TODO
}

module component(which) {
    verbose = true; // does this work? no!
    if (which == "trestle_leg") {
        echo("LEG, build ??.");
        solo_trestle_leg();
    }
    else if (which == "extra_leg") {
        echo("LEG, build ??.");
        solo_extra_leg();
    }
    else if (which == "top") {
        echo("TOP, one layer of 18mm ply.");
        //top(tt_width, tt_depth, tt_thickness);
    }
    else if (which == "trestle") {
        echo("TRESTLE, build ??.");
        solo_trestle();
    }
}


module cli() {
    if (mode == "project") {
        whole_room();
    }
    else {
        component(which_component);
    }
}

cli();