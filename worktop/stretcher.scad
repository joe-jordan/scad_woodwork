include<config.scad>
include<lumber_dimensions.scad>

module stretcher(length, tenon_length, tenon_thickness, groove_depth, panel_thickness) {
    if (verbose) {
        echo("Stretchers have a tenon at each end.");
        echo("They also have (as do all parts) a dado for the ply panel.");
        echo("the tenon is flush with the edges of the mortice on the leg.");
    }

    should_crop_tenon = true;

    // These stretchers are sideways on compared to the worktop, and run along the X axis (plane Y=0 is the wall.)
    lumber_height = two_by;
    lumber_thickness = four_by;

    // Cheeks:
    tenon_cheek_depth = (lumber_thickness-tenon_thickness)/2;

    fcheek_x_off = -delta;
    bcheek_x_off = length - tenon_length;

    lcheek_y_off = -delta;
    rcheek_y_off = lumber_thickness - tenon_cheek_depth;
    
    // Same for all cheeks:
    cheek_zoff = -delta;
    cheek_depth = tenon_cheek_depth + delta;
    cheek_length = tenon_length + delta;
    cheek_height = lumber_height+(2*delta);

    // dado for ply panel.
    groove_z_off = lumber_height - groove_depth;
    groove_z = groove_depth + delta;
    groove_y_off = (lumber_thickness - panel_thickness)/2;
    groove_x_off = tenon_length + (should_crop_tenon ? -delta : 0);
    groove_x = length - 2 * tenon_length + (should_crop_tenon ? 2*delta : 0);

    btecrop_x_off = -delta;
    ftecrop_x_off = length - tenon_length;
    tecrop_y_off = tenon_cheek_depth - delta;
    tecrop_z_off = (lumber_height - groove_depth) + delta;

    tecrop_x = tenon_length + delta;
    tecrop_y = tenon_thickness + 2*delta;
    tecrop_z = lumber_height - groove_depth;


    echo("CUT LIST: bottom trestle, CLS stock (assumed 63/38mm)", length = length);

    if (verbose) {
        echo("at each end:");
        echo(" TENON: cut first, on each end, full width",length = tenon_length, depth = tenon_cheek_depth, final_thickness=tenon_thickness);
    }

    color("#9D6638")
    difference() {
        union() {
            cube([length, lumber_thickness, lumber_height], center = false);

        }
        union() { // cuts out of board
            // four tenon cheeks
            translate([fcheek_x_off,lcheek_y_off,cheek_zoff]) {
                cube([cheek_length,cheek_depth,cheek_height], center=false);
            };
            translate([bcheek_x_off,lcheek_y_off,cheek_zoff]) {
                cube([cheek_length,cheek_depth,cheek_height], center=false);
            };
            translate([fcheek_x_off,rcheek_y_off,cheek_zoff]) {
                cube([cheek_length,cheek_depth,cheek_height], center=false);
            };
            translate([bcheek_x_off,rcheek_y_off,cheek_zoff]) {
                cube([cheek_length,cheek_depth,cheek_height], center=false);
            };
            // groove for panel:
            translate([groove_x_off, groove_y_off, groove_z_off]) {
                cube([groove_x,panel_thickness,groove_z], center=false);
            };
            // crop tenons to groove height, if requested.
            if (should_crop_tenon) {
                translate([btecrop_x_off, tecrop_y_off, tecrop_z_off]) {
                    cube([tecrop_x,tecrop_y,tecrop_z], center=false);
                };
                translate([ftecrop_x_off, tecrop_y_off, tecrop_z_off]) {
                    cube([tecrop_x,tecrop_y,tecrop_z], center=false);
                };
            }
        }
    }
}
