include<config.scad>
include<lumber_dimensions.scad>

module key(length, key_height, key_thickness, key_tenon_length, key_tenon_height) {
    if (verbose) {

        echo("board oriented in Y, with two cuts at the bottom that are (height - tenon_height tall).");
    }

    lap_x_off = -delta;
    flap_y_off = -delta;
    blap_y_off = length - key_tenon_length;
    lap_z_off = -delta;

    lap_x = key_thickness + 2*delta;
    lap_y = key_tenon_length + delta;
    lap_z = key_height - key_tenon_height + delta;

    echo("CUT LIST: key, 2x4 stock (assumed 89/38mm)", length = length);
    if (verbose) {
        echo("TENONS - cut two corners off, ", length = key_tenon_length, width = key_tenon_height);
    }

    color("#9D6638")
    difference() {
        union() {
            cube([key_thickness, length, key_height], center = false);

        }
        union() { // cuts out of board
            // two key laps:
            translate([lap_x_off,flap_y_off,lap_z_off]) {
                cube([lap_x,lap_y,lap_z], center=false);
            };
            translate([lap_x_off,blap_y_off,lap_z_off]) {
                cube([lap_x,lap_y,lap_z], center=false);
            };
        }
    }

}