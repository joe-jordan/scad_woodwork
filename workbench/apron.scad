include<config.scad>
include<lumber_dimensions.scad>

module apron(length, lap_length, key_thickness, key_height) {
    if (verbose) {
        echo("Aprons run along the top underneath, at attach with half lap joints (with bolts?) to the top of the legs.");
        echo("We also cut out a hole at the centre for a key.");
    }
    // This board is long in X.
    
    lumber_height = six_by;
    lumber_thickness = two_by;
    half_lap_depth = lumber_thickness/2;
    
    llap_x_offset = -delta;
    rlap_x_offset = length - lap_length;
    lap_y_offset = lumber_thickness/2;

    lap_x = delta + lap_length;
    lap_y = delta + half_lap_depth;

    lap_z_off = -delta;
    lap_z = lumber_height + 2*delta;

    key_x_off = (length - key_thickness)/2;
    key_y_off = -delta;
    key_z_off = lumber_height - key_height;

    key_y = lumber_thickness + 2*delta;

    echo("CUT LIST: apron, 2x6 stock (assumed 140/38mm)", length = length);
    if (verbose) {
        echo("LAPS: half thickness, on each end one side. ", lap_length = lap_length);
        echo("KEY SLOT: positioned centre, all through the board.", offset_along_length = key_x_off, width = key_thickness, depth = key_height);
    }
    
    color("#9D6638")
    difference() {
        union() {
            cube([length, lumber_thickness, lumber_height], center = false);
        }
        union() { // cuts out of board
            // two laps:
            translate([llap_x_offset,lap_y_offset,lap_z_off]) {
                cube([lap_x,lap_y,lap_z], center=false);
            };
            translate([rlap_x_offset,lap_y_offset,lap_z_off]) {
                cube([lap_x,lap_y,lap_z], center=false);
            };
            // key:
            translate([key_x_off,key_y_off,key_z_off]) {
                cube([key_thickness,key_y,key_height + delta], center=false);
            };
        }
    }   
}
