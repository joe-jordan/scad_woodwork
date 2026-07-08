// ALL UNITS IN centimetres.
include<worktop/config.scad>
include<worktop/lumber_dimensions.scad>

include<worktop/stretcher.scad>
include<worktop/leg.scad>
include<worktop/panel.scad>
include<worktop/runner.scad>


wt_height = 95;
wt_depth = 70;
wt_width = 300;

leg_v2_x = two_by;
leg_x = two_by;

tenon_thickness = four_by / 3;

groove_depth = 1;

bstretcher_z_off = 10;

trestle_setback = 3;

module solo_stretcher() {
    stretcher_length = wt_depth - leg_v2_x - trestle_setback;
    stretcher_tenon_length = leg_x;
    
    stretcher(stretcher_length, stretcher_tenon_length, tenon_thickness, groove_depth, ply_thickness_panel);
}

module solo_trestle_leg() {
    length = wt_height - ply_thickness_top;

    leg(length, bstretcher_z_off, tenon_thickness, groove_depth);
}

module solo_panel() {
    frame_thickness = two_by - groove_depth;
    height = wt_height - ply_thickness_top - 2*frame_thickness - bstretcher_z_off;
    width = wt_depth - leg_v2_x - 2*frame_thickness - trestle_setback;

    panel(height, width, ply_thickness_panel);
}

module completed_trestle() {

    // Two stretchers, two legs and a panel.
    stretcher_length = wt_depth - leg_v2_x - trestle_setback;
    stretcher_tenon_length = leg_x;

    tstretcher_z_off = wt_height - ply_thickness_top - two_by;
    y_off = 0;
    stretcher_x_off = leg_v2_x;

    translate([stretcher_x_off,y_off,bstretcher_z_off]) {
        stretcher(stretcher_length, stretcher_tenon_length, tenon_thickness, groove_depth, ply_thickness_panel);
    }
    //rotate and compensate with the translate.
    translate([stretcher_x_off,y_off+four_by,tstretcher_z_off+two_by]) {
        rotate(a = [180, 0, 0]) {
            stretcher(stretcher_length, stretcher_tenon_length, tenon_thickness, groove_depth, ply_thickness_panel);
        }
    }

    leg_length = wt_height - ply_thickness_top;
    leg_z_off = 0;
    bleg_x_off = leg_v2_x;
    fleg_x_off = wt_depth - trestle_setback - leg_x;

    translate([bleg_x_off,y_off,leg_z_off]) {
        leg(leg_length, bstretcher_z_off, tenon_thickness, groove_depth);
    }

    translate([fleg_x_off + leg_x,y_off+four_by,leg_z_off]) {
        rotate(a = [0, 0, 180]) {
            leg(leg_length, bstretcher_z_off, tenon_thickness, groove_depth);
        }
    }

    frame_thickness = two_by - groove_depth;
    panel_height = wt_height - ply_thickness_top - 2*frame_thickness - bstretcher_z_off;
    panel_width = wt_depth - leg_v2_x - 2*frame_thickness - trestle_setback;

    panel_x_off = leg_v2_x + leg_x - groove_depth;
    panel_y_off = (four_by - ply_thickness_panel) / 2;
    panel_z_off = bstretcher_z_off + two_by - groove_depth;
    translate([panel_x_off,panel_y_off,panel_z_off]) {
        panel(panel_height, panel_width, ply_thickness_panel);
    }
}

module solo_runner() {
    room_length = wt_width;

    runner(room_length, wt_height, wt_depth, ply_thickness_top, trestle_setback);
}

module whole_room() {
    // TODO
}

module component(which) {
    verbose = true; // does this work? no!
    echo("rendering component", c=which);
    if (which == "trestle_leg") {
        echo("LEG, build ??.");
        solo_trestle_leg();
    }
    else if (which == "stretcher") {
        echo("stretcher, build ??.");
        solo_stretcher();
    }
    else if (which == "panel") {
        echo("panel, build ??");
        solo_panel();
    }
    else if (which == "trestle") {
        echo("trestle, build ??");
        completed_trestle();
    }
    else if (which == "extra_leg") {
        echo("LEG, build ??.");
        solo_extra_leg();
    }
    else if (which == "top") {
        echo("TOP, one layer of 18mm ply.");
        //top(tt_width, tt_depth, tt_thickness);
    }
    else if (which == "runner") {
        echo("RUNNER!");
        solo_runner();
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