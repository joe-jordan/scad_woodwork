include<config.scad>
include<lumber_dimensions.scad>
include<../general/plank.scad>
include<../general/mortice.scad>

module leg(length, btrestle_z_off, tenon_thickness, groove_depth) {
    lumber_thickness = two_by;
    lumber_width = four_by;

    mortice_rule = tenon_thickness / lumber_width;
    // Allowing for groove tidy up.
    tenon_height = two_by - groove_depth;

    groove_thickness = ply_thickness_panel;
    groove_offset = (lumber_width - groove_thickness) / 2;

    groo_x_off = lumber_thickness - groove_depth;
    groo_y_off = groove_offset;
    groo_z_off = btrestle_z_off + tenon_height - delta;

    groo_x = groove_depth + delta;
    groo_y = groove_thickness;
    groo_z = length - groo_z_off;

    echo ("CUT LIST: Leg. 4x4 stock (assumed 89mm^2)", length=length);

    if (verbose) {
        echo("All mortice widths are 1/3 the stock, set centrally. Measure off your cut tenons!")
        echo("MORTICE 1: for bottom trestle, through tenon.", position_z=btrestle_z_off, length_z=tenon_height);
        echo("MORTICE 2: for top trestle, through tenon, same orientation as MORTICE 1.", position_z_from_top=0, length_z=tenon_height);
    }
    color("#4E220F")
    difference() {
        union() {
            mortice([lumber_thickness, lumber_width, length], mortice_rule, "z", btrestle_z_off, tenon_height, "x")
                mortice([lumber_thickness, lumber_width, length], mortice_rule, "z", length - tenon_height, tenon_height, "x")
                    plank(length, lumber_width, lumber_thickness, "z", "y");
        }
        union() { // More cuts on top of the simple motices. TODO: General groove?
            // groove:
            translate([groo_x_off,groo_y_off,groo_z_off]) {
                cube([groo_x, groo_y, groo_z], center=false);
            };
        }
    }
}
