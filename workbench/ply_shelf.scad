include<lumber_dimensions.scad>

module shelf(length, depth, thickness, cutout_x, cutout_y) {
    echo("CUT LIST: Shelf. One layer of 18mm ply (maybe as two sections, for ease of installation?)", width=depth, length=length);

    left_x_off = -delta;
    right_x_off = length - cutout_x;
    front_y_off = -delta;
    back_y_off = depth - cutout_y;

    z_off = -delta;
    z_dist = 2*delta + thickness;

    actual_x = cutout_x + delta;
    actual_y = cutout_y + delta;

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