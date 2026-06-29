// ALL UNITS IN centimetres.
include<workbench/lumber_dimensions.scad>

include<workbench/leg.scad>
include<workbench/ply_top.scad>
include<workbench/top_trestle.scad>
include<workbench/bottom_trestle.scad>
include<workbench/stretcher.scad>

// table dimensions
tt_width = 145; // x
tt_height = 100; // z
tt_depth = 70; // y
// two-layers of ply.
tt_thickness = ply_thickness*2; // in z

// bench config constants:
stretcher_z_off = 13; // from floor to bottom of x-oriented stretchers.
overhang = two_by/2;
trestle_groove_depth = 1;
ttrestle_tenon_drop = 2.5;

// derived shared vars:
shelf_thickness = ply_thickness;
shelf_height = stretcher_z_off + four_by;
leg_thickness = four_by;
leg_mortice_tenon_thickness = leg_thickness / 3;
leg_mortice_tenon_offset = (leg_thickness - leg_mortice_tenon_thickness)/2;

// Shared trestle dimensions:
trestle_thickness = two_by;
trestle_height = four_by;
lttrestle_x_off = overhang + (leg_thickness - trestle_thickness)/2;
rttrestle_x_off = tt_width - lttrestle_x_off - trestle_thickness;

module add_legs() {
    length = tt_height - tt_thickness;

    z_offset = 0;
    lleg_x_off = overhang;
    rleg_x_off = tt_width - overhang - leg_thickness;

    fleg_y_off = overhang;
    bleg_y_off = tt_depth - overhang - leg_thickness;

    btrestle_z_off = stretcher_z_off + trestle_height / 2;

    translate([lleg_x_off,fleg_y_off,z_offset]) {
        leg(length, stretcher_z_off, btrestle_z_off, ttrestle_tenon_drop, leg_mortice_tenon_thickness, leg_mortice_tenon_offset, trestle_height);
    }
    translate([lleg_x_off,bleg_y_off,z_offset]) {
        leg(length, stretcher_z_off, btrestle_z_off, ttrestle_tenon_drop, leg_mortice_tenon_thickness, leg_mortice_tenon_offset, trestle_height);
    }
    //rotate and compensate with the translate.
    translate([rleg_x_off+leg_thickness,fleg_y_off+leg_thickness,z_offset]) {
        rotate(a = [0, 0, 180]) {
            leg(length, stretcher_z_off, btrestle_z_off, ttrestle_tenon_drop, leg_mortice_tenon_thickness, leg_mortice_tenon_offset, trestle_height);
        }
    }
    //rotate and compensate with the translate.
    translate([rleg_x_off+leg_thickness,bleg_y_off+leg_thickness,z_offset]) {
        rotate(a = [0, 0, 180]) {
            leg(length, stretcher_z_off, btrestle_z_off, ttrestle_tenon_drop, leg_mortice_tenon_thickness, leg_mortice_tenon_offset, trestle_height);
        }
    }
}

module add_top() {
    translate([0, 0, tt_height-tt_thickness]) {
        top(tt_width, tt_depth, tt_thickness);
    }
}

// all trestles are y axis oriented.
// A trestle is a 2x4 between two legs, that has a 2.966 thickness tenon sticking out the end (this is 1/3 of 4x.)
// Top and Bottom trestles have slightly different cuts into this tenon.



module add_top_trestles() {
    // Top trestle dimensions:
    ttrestle_length = tt_depth - 2 * overhang;
    ttrestle_tenon_length = leg_thickness;
    

    // and positions:
    ttrestle_y_off = overhang; // flush with leg for apron.
    ttrestle_z_off = tt_height - trestle_height - tt_thickness;

    translate([lttrestle_x_off, ttrestle_y_off, ttrestle_z_off]) {
        top_trestle(ttrestle_length, ttrestle_tenon_length, ttrestle_tenon_drop, leg_mortice_tenon_thickness);
    };
    translate([rttrestle_x_off, ttrestle_y_off, ttrestle_z_off]) {
        top_trestle(ttrestle_length, ttrestle_tenon_length, ttrestle_tenon_drop, leg_mortice_tenon_thickness);
    };
}

module add_bottom_trestles() {
    // Bottom trestle dimensions:
    btrestle_length = tt_depth;
    btrestle_tenon_length = leg_thickness + overhang;

    // and internal offsets:
    mortice_top_and_groove_bottom_height = trestle_height/2; // (relative to bottom of trestle.)

    // and positions:
    lbtrestle_x_off = lttrestle_x_off;
    // (this one differs from the top right trestle, because of the rotation.)
    rbtrestle_x_off = rttrestle_x_off;
    btrestle_y_off = 0;
    btrestle_z_off = stretcher_z_off + trestle_height/2;

    translate([lbtrestle_x_off, btrestle_y_off, btrestle_z_off]) {
        bottom_trestle(btrestle_length,
        btrestle_tenon_length,
        leg_mortice_tenon_thickness,
        mortice_top_and_groove_bottom_height,
        trestle_groove_depth,
        shelf_thickness);
    };

    // a bit hacky, but we translate the trestle its length +y and thickness +x after rotate, because it will rotate around the Z axis (not the center of the object).
    translate([rbtrestle_x_off+trestle_thickness, btrestle_y_off+btrestle_length, btrestle_z_off]) {
        rotate(a = [0, 0, 180]) {
            bottom_trestle(btrestle_length,
            btrestle_tenon_length,
            leg_mortice_tenon_thickness,
            mortice_top_and_groove_bottom_height,
            trestle_groove_depth,
            shelf_thickness);
        }
    };
}

module add_stretchers() {
    // Stretcher dimensions:
    stretcher_length = tt_width - 2*(overhang + leg_thickness/3);
    stretcher_tenon_length = 2*leg_thickness/3;
    stretcher_thickness = two_by;

    // and positions:
    stretcher_x_off = overhang + (leg_thickness-stretcher_tenon_length);
    fstretcher_y_off = overhang + (leg_thickness - stretcher_thickness)/2;
    bstretcher_y_off = tt_depth - fstretcher_y_off - stretcher_thickness;

    // front stretcher:
    translate([stretcher_x_off,fstretcher_y_off,stretcher_z_off]) {
        stretcher(stretcher_length, stretcher_tenon_length, leg_mortice_tenon_thickness);
    }
    // back stretcher:
    translate([stretcher_x_off,bstretcher_y_off,stretcher_z_off]) {
        stretcher(stretcher_length, stretcher_tenon_length, leg_mortice_tenon_thickness);
    }
}




// TODO CLI

module whole_table() {
    echo("ALL CUT LIST measurements are in cm.");

    add_legs();
    add_top();
    add_top_trestles();
    add_bottom_trestles();
    add_stretchers();
    // add_aprons();
    // add_key();
}

whole_table();