include<config.scad>
include<lumber_dimensions.scad>

module leg(length, stretcher_z_off, btrestle_z_off, ttrestle_z_drop, mortice_thickness, mortice_offset, mortice_height) {
    // This is half an apron thickness.
    lumber_width = four_by;
    lumber_depth = four_by;

    // stretcher mortices:
    stremor_x_off = mortice_offset;
    stremor_y_off = mortice_offset;
    stremor_z_off = stretcher_z_off;

    stremor_x_size = mortice_thickness + mortice_offset + delta;
    stremor_y_size = mortice_thickness;
    stremor_z_size = mortice_height;

    // bottom trestle mortices:
    btrmor_x_off = mortice_offset;
    btrmor_y_off = -delta;
    btrmor_z_off = btrestle_z_off;

    btrmor_x_size = mortice_thickness;
    btrmor_y_size = lumber_depth + 2*delta;
    btrmor_z_size = mortice_height;

    // top trestle mortices:
    ttrmor_x_off = mortice_offset;
    ttrmor_y_off = -delta;
    ttrmor_z_off = length - mortice_height;

    ttrmor_x_size = mortice_thickness;
    ttrmor_y_size = lumber_depth + 2*delta;
    ttrmor_z_size = mortice_height - ttrestle_z_drop;

    echo ("CUT LIST: Leg. 4x4 stock (assumed 89mm^2)", length=length);

    if (verbose) {
        echo("All mortice widths are 1/3 the stock, set centrally.")
        echo("MORTICE 1: for bottom trestle, through tenon.", position_z=btrmor_z_off, length_z=btrmor_z_size);
        echo("MORTICE 2: for top trestle, through tenon, same orientation as MORTICE 1.", position_z_from_top=ttrestle_z_drop, length_z=ttrmor_z_size);
        echo("MORTICE 3: for stretcher. stop at back of MORTICE 1 (2/3 depth). Offset by 1/2 in z, below MORTICE 1.");
        echo("MORTICE 3 (cont): in the 90deg adjacent face to MORTICE 1 and 2.", position_z=stretcher_z_off, length_z=stremor_z_size);
    }
    color("#4E220F")
    difference() {
        cube([lumber_width, lumber_depth, length], center = false);
        union() {// cuts to make for mortices.
            // stretchers:
            translate([stremor_x_off,stremor_y_off,stremor_z_off]) {
                cube([stremor_x_size,stremor_y_size,stremor_z_size], center=false);
            };
            // lower trestles:
            translate([btrmor_x_off,btrmor_y_off,btrmor_z_off]) {
                cube([btrmor_x_size, btrmor_y_size, btrmor_z_size], center=false);
            };
            // upper trestles:
            translate([ttrmor_x_off,ttrmor_y_off,ttrmor_z_off]) {
                cube([ttrmor_x_size, ttrmor_y_size, ttrmor_z_size], center=false);
            };
        }
    }
}
