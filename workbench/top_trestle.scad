include<config.scad>
include<lumber_dimensions.scad>

module top_trestle(length, tenon_length, drop, tenon_thickness) {
    if (verbose) {
        echo("Top trestles have a tenon that's flush with the leg, and a bite out of them (drop) to ensure the top of the leg is whole.");
    }

    lumber_height = four_by;
    lumber_thickness = two_by;

    // cheek params

    tenon_cheek_depth = (lumber_thickness-tenon_thickness)/2;
    
    lcheek_x_off = -delta;
    rcheek_x_off = lumber_thickness-tenon_cheek_depth+delta;
    
    fcheek_y_off = -delta;
    bcheek_y_off = length-tenon_length+delta;
    
    // Same for all cheeks:
    cheek_zoff = -delta;
    cheek_depth = tenon_cheek_depth + delta;
    cheek_length = tenon_length + delta;
    cheek_height = lumber_height+(2*delta);

    // drop params:
    fdrop_y_off = fcheek_y_off;
    bdrop_y_off = bcheek_y_off;

    drop_x_off = -delta;
    drop_z_off = lumber_height - drop;
    drop_height = drop + delta;
    drop_length = tenon_length + delta;
    drop_depth = lumber_thickness+(2*delta);

    echo("CUT LIST: top trestle, 2x4 stock (assumed 89/38mm), allow extra length to plane flush with leg.", length = length);

    if (verbose) {
        echo("at each end:");
        echo(" TENON: full width at bottom, but cut out at the top:", drop=drop);
        echo(" tenon dimensions:", length=tenon_length, depth=tenon_cheek_depth, final_thickness=tenon_thickness);
    }

    color("#9D6638")
    difference() {
        union() {
            cube([two_by, length, four_by], center = false);
        }
        union() { // cuts out of board
            // four tenon cheeks
            translate([lcheek_x_off,fcheek_y_off,cheek_zoff]) {
                cube([cheek_depth,cheek_length,cheek_height], center=false);
            };
            translate([lcheek_x_off,bcheek_y_off,cheek_zoff]) {
                cube([cheek_depth,cheek_length,cheek_height], center=false);
            };
            translate([rcheek_x_off,fcheek_y_off,cheek_zoff]) {
                cube([cheek_depth,cheek_length,cheek_height], center=false);
            };
            translate([rcheek_x_off,bcheek_y_off,cheek_zoff]) {
                cube([cheek_depth,cheek_length,cheek_height], center=false);
            };
            // two tenon offsets (~an inch below the top):
            translate([drop_x_off,fdrop_y_off,drop_z_off]) {
                cube([drop_depth,drop_length,drop_height], center=false);
            };
            translate([drop_x_off,bdrop_y_off,drop_z_off]) {
                cube([drop_depth,drop_length,drop_height], center=false);
            };
        }
    }
}
