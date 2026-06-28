include<lumber_dimensions.scad>

module stretcher(length, tenon_length, tenon_thickness) {
    // Stretchers run along the bottom of the front and back. they have a four_by/3 width tenon, like the trestles, but these only go 2/3 into the leg, interlocking with the lower trestle tenon's half-mortice.
    // This board is long in X.
    
    lumber_height = four_by;
    lumber_thickness = two_by;
    tenon_cheek_depth = (two_by-tenon_thickness)/2;
    
    lcheek_x_off = -delta;
    rcheek_x_off = length-tenon_length+delta;
    
    fcheek_y_off = -delta;
    bcheek_y_off = lumber_thickness-tenon_cheek_depth+delta;
    
    // Same for all cheeks:
    cheek_zoff = -delta;
    cheek_depth = tenon_cheek_depth + delta;
    cheek_length = tenon_length + delta;
    cheek_height = lumber_height+(2*delta);

    echo("CUT LIST: ankle stretcher, 2x4 stock (assumed 89/38mm)", length = length)
    
    color("#9D6638")
    difference() {
        union() {
            cube([length, lumber_thickness, lumber_height], center = false);
        }
        union() { // cuts out of board
            // four tenon cheeks
            translate([lcheek_x_off,fcheek_y_off,cheek_zoff]) {
                cube([cheek_length,cheek_depth,cheek_height], center=false);
            };
            translate([lcheek_x_off,bcheek_y_off,cheek_zoff]) {
                cube([cheek_length,cheek_depth,cheek_height], center=false);
            };
            translate([rcheek_x_off,fcheek_y_off,cheek_zoff]) {
                cube([cheek_length,cheek_depth,cheek_height], center=false);
            };
            translate([rcheek_x_off,bcheek_y_off,cheek_zoff]) {
                cube([cheek_length,cheek_depth,cheek_height], center=false);
            };
        }
    }   
}
