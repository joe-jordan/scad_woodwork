include<lumber_dimensions.scad>

module bottom_trestle(length, tenon_length, tenon_thickness, mortice_top_groove_bottom_height, groove_depth, shelf_thickness) {
    // Bottom tresles have a through-mortice cut into the face of the tenon, which is the same size as the mortice (2.966), starting at the midpoint and going down.
    // Bottom tresles also have a dado/groove from midpoint to 1.8 above, depth matches the tenon cheek.
    // the tenon also sticks out 2_by/2.
    lumber_height = four_by;
    lumber_thickness = two_by;

    // Cheeks:
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

    // half-mortice and groove position/dimensions:
    mortice_height = mortice_top_groove_bottom_height + delta;
    mortice_length = tenon_thickness; // the thickness of the stretcher tenon!
    fmortice_y_off = tenon_length - 2*mortice_length;
    bmortice_y_off = length - fmortice_y_off - mortice_length;

    groove_z_off = mortice_top_groove_bottom_height;
    groove_y_length = length - 2*tenon_length;
    groove_x_off = lumber_thickness - groove_depth;
    groove_y_off = tenon_length;
    groove_x_depth = groove_depth + delta;

    echo("CUT LIST: bottom trestle, 2x4 stock (assumed 89/38mm)", length = length)

    color("#9D6638")
    difference() {
        union() {
            cube([lumber_thickness, length, lumber_height], center = false);

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
            // half-mortice for stretchers:
            translate([0, fmortice_y_off, -delta]) {
                cube([lumber_thickness, tenon_thickness, mortice_height], center=false);
            };
            translate([0, bmortice_y_off, -delta]) {
                cube([lumber_thickness, tenon_thickness, mortice_height], center=false);
            };
            // groove for shelf:
            translate([groove_x_off, groove_y_off, groove_z_off]) {
                cube([groove_x_depth,groove_y_length,shelf_thickness], center=false);
            };
        }
    }
}
