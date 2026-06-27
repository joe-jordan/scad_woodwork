// ALL UNITS IN centimetres.

// Position enum
pos_fl = 0;
pos_fr = 1;
pos_br = 2;
pos_bl = 3;
// other positions:
pos_f  = 4;
pos_b  = 5;
pos_r  = 6;
pos_l  = 7;

pos_ft  = 8;
pos_bt  = 9;
pos_rt  = 10;
pos_lt  = 11;
pos_fb  = 12;
pos_bb  = 13;
pos_rb  = 14;
pos_lb  = 15;

// for differences:
delta = 0.1;

// lumber dimensions
ply_thickness = 1.8;
two_by = 3.8;
four_by = 8.9;
six_by = 14;

// table top dimensions
tt_width = 145; // x
tt_height = 100; // z
tt_depth = 70; // y
// two-layers of ply.
tt_thickness = ply_thickness*2; // in z

// placement variables
stretcher_lift = 13; // from floor to bottom of x-oriented stretchers.
overhang = two_by/2;
bottom_trestle_lift = stretcher_lift + four_by/2;
trestle_groove_depth = 1;
shelf_thickness = ply_thickness;
shelf_height = stretcher_lift + four_by;


module leg(position) {
    // This is half an apron thickness.
    thickness=four_by;
    height = tt_height - tt_thickness;

    small_offset = overhang;
    x_offset = (position == pos_fl || position == pos_bl) ? small_offset : tt_width - small_offset - thickness;
    y_offset = (position == pos_fr || position == pos_fl) ? small_offset : tt_depth - small_offset - thickness;

    stretcher_mortice_x_offset = (position == pos_fl || position == pos_bl) ? four_by/3 : -delta ;

    echo ("CUT LIST: Leg. 4x4 stock (assumed 89mm^2)", length=height);
    translate([x_offset, y_offset, 0]) {
        color("#4E220F")
        difference() {
            cube([thickness, thickness, height], center = false);
            union() {// cuts to make for mortices.
                // lower trestles:
                translate([four_by/3,-delta,bottom_trestle_lift]) {
                    cube([four_by/3, four_by+(2*delta), four_by], center=false);
                };
                // stretchers:
                translate([stretcher_mortice_x_offset,four_by/3,stretcher_lift]) {
                    cube([2*four_by/3+delta,four_by/3,four_by], center=false);
                };
            }
        }
    }
    
}

module top() {
    echo("CUT LIST: Top. Two layers of 18mm ply,", width=tt_width, length=tt_depth);
    %translate([0, 0, tt_height-tt_thickness]) {
        color("#F7F1DE")
        cube([tt_width, tt_depth, tt_thickness], center = false);
    }
}

module bottom_trestle(position, x_offset) {
    // Bottom tresles have a through-mortice cut into the face of the tenon, which is the same size as the mortice (2.966), starting at the midpoint and going down.
    // Bottom tresles also have a dado/groove from midpoint to 1.8 above, depth matches the tenon cheek.
    // the tenon also sticks out 2_by/2.
    y_offset = 0; // the end of the tenon is flush with the benchtop
    y_length = tt_depth;

    lumber_height = four_by;
    lumber_thickness = two_by;
    tenon_cheek_depth = (two_by-(four_by/3))/2;

    interior_y_length = y_length - 2*(overhang+four_by);

    // groove position:
    groove_x_offset = position == pos_lb ? lumber_thickness - trestle_groove_depth + delta : -delta ;

    echo("CUT LIST: bottom trestle, 2x4 stock (assumed 89/38mm)", length = y_length)
    translate([x_offset, y_offset, bottom_trestle_lift]) {
        color("#9D6638")
        difference() {
            union() {
                cube([two_by, y_length, four_by], center = false);

            }
            union() { // cuts out of board
                // four tenon cheeks
                translate([(two_by+(four_by/3))/2,-delta,-delta]) {
                    cube([tenon_cheek_depth+delta,overhang+four_by+delta,four_by+(2*delta)], center=false);
                };
                translate([-delta,-delta,-delta]) {
                    cube([tenon_cheek_depth+delta,overhang+four_by+delta,four_by+(2*delta)], center=false);
                };
                translate([(two_by+(four_by/3))/2,y_length-(overhang+four_by),-delta]) {
                    cube([tenon_cheek_depth+delta,overhang+four_by+delta,four_by+(2*delta)], center=false);
                };
                translate([-delta,y_length-(overhang+four_by),-delta]) {
                    cube([tenon_cheek_depth+delta,overhang+four_by+delta,four_by+(2*delta)], center=false);
                };
                // half-mortice for stretchers:
                translate([0, overhang + (four_by/3), -delta]) {
                    cube([two_by, (four_by/3), (four_by/2)+delta], center=false);
                };
                translate([0, y_length-(overhang + (2*four_by/3)), -delta]) {
                    cube([two_by, (four_by/3), (four_by/2)+delta], center=false);
                };
                // groove for shelf:
                translate([groove_x_offset, overhang+four_by, (lumber_height)/2]) {
                    cube([trestle_groove_depth+delta,interior_y_length,shelf_thickness], center=false);
                };
            }
        }
    }
}

module top_trestle(x_offset) {
}

module trestle(position) {
    // all trestles are y axis oriented.
    // A trestle is a 2x4 between two legs, that has a 2.966 thickness tenon sticking out the end (this is 1/3 of 4x.)
    // Top and Bottom tresles have slightly different cuts into this tenon.
    
    // overhang + half-thickness of leg - half-thickness of trestle. Since overhang = half-thickness of trestle...
    offset_from_x_boundary = four_by/2;

    if (position == pos_rt) {
        top_trestle(tt_width - offset_from_x_boundary - two_by);
    } else if (position == pos_lt) {
        top_trestle(offset_from_x_boundary);
    } else if (position == pos_rb) {
        bottom_trestle(position, tt_width - offset_from_x_boundary - two_by);
    } else if (position == pos_lb) {
        bottom_trestle(position, offset_from_x_boundary);
    }
}


echo("ALL CUT LIST measurements are in cm.")
leg(position = pos_fl);
leg(position = pos_fr);
leg(position = pos_bl);
leg(position = pos_br);

top();

//trestle(pos_rt);
//trestle(pos_lt);
trestle(pos_rb);
trestle(pos_lb);

