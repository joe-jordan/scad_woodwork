include<config.scad>
include<lumber_dimensions.scad>

module leg(length, btrestle_z_off, tenon_thickness, groove_depth) {
    // This is half an apron thickness.
    lumber_x = two_by;
    lumber_y = four_by;
    lumber_z = length;

    tenon_height = two_by - groove_depth;
    tenon_cheek_depth = (lumber_y - tenon_thickness) / 2;
    groove_thickness = ply_thickness_panel;
    groove_offset = (lumber_y - groove_thickness) / 2;

    mor_x_off = -delta;
    mor_y_off = tenon_cheek_depth;
    bmor_z_off = btrestle_z_off;
    tmor_z_off = lumber_z - tenon_height;

    mor_x = lumber_x + 2*delta;
    mor_y = tenon_thickness;
    bmor_z = tenon_height;
    tmor_z = tenon_height + delta; // protrudes from top

    groo_x_off = lumber_x - groove_depth;
    groo_y_off = groove_offset;
    groo_z_off = btrestle_z_off + tenon_height - delta;

    groo_x = groove_depth + delta;
    groo_y = groove_thickness;
    groo_z = lumber_z - groo_z_off;

    echo ("CUT LIST: Leg. 4x4 stock (assumed 89mm^2)", length=length);

    if (verbose) {
        echo("All mortice widths are 1/3 the stock, set centrally.")
        echo("MORTICE 1: for bottom trestle, through tenon.", position_z=btrmor_z_off, length_z=btrmor_z_size);
        echo("MORTICE 2: for top trestle, through tenon, same orientation as MORTICE 1.", position_z_from_top=ttrestle_z_drop, length_z=ttrmor_z_size);
    }
    color("#4E220F")
    difference() {
        cube([lumber_x, lumber_y, lumber_z], center = false);
        union() {// cuts to make for mortices.
            // lower trestle:
            translate([mor_x_off,mor_y_off,bmor_z_off]) {
                cube([mor_x, mor_y, bmor_z], center=false);
            };
            // upper trestle:
            translate([mor_x_off,mor_y_off,tmor_z_off]) {
                cube([mor_x, mor_y, tmor_z], center=false);
            };
            // groove:
            translate([groo_x_off,groo_y_off,groo_z_off]) {
                cube([groo_x, groo_y, groo_z], center=false);
            };
        }
    }
}
