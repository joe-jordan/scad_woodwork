include<config.scad>
include<lumber_dimensions.scad>

module shelf(length, depth, thickness, cutout_x, cutout_y) {
    if (verbose) {
        echo("install with screws into stretchers and slot into bottom trestle groove without glue.");
        echo("If in two parts, can be installed at the end. If one part, must be installed with the stretchers when two trestles are joined.");
        echo("If installed as one part with stretchers, you could glue it to avoid countersinking all those screws. You could also glue in the grooves.");
    }
    left_x_off = -delta;
    right_x_off = length - cutout_x;
    front_y_off = -delta;
    back_y_off = depth - cutout_y;

    z_off = -delta;
    z_dist = 2*delta + thickness;

    actual_x = cutout_x + delta;
    actual_y = cutout_y + delta;

    echo("CUT LIST: Shelf. One layer of 18mm ply (maybe as two sections, for ease of installation?)", width=depth, length=length);
    if (verbose) {
        echo("CORNERS: cut a square out of each corner, to fit around the legs.", lengthways_cut=cutout_x, widthways_cut=cutout_y);
    }

    color("#F7F1DE")
    difference() {
        union() {
            cube([length, depth, thickness], center = false);
        }
        union() { // cuts out of board
            // four identical cutouts to fit in around legs.
            translate([left_x_off,front_y_off,z_off]) {
                cube([actual_x,actual_y,z_dist], center=false);
            };
            translate([left_x_off,back_y_off,z_off]) {
                cube([actual_x,actual_y,z_dist], center=false);
            };
            translate([right_x_off,front_y_off,z_off]) {
                cube([actual_x,actual_y,z_dist], center=false);
            };
            translate([right_x_off,back_y_off,z_off]) {
                cube([actual_x,actual_y,z_dist], center=false);
            };
        }
    } 
}