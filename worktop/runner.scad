include<config.scad>
include<lumber_dimensions.scad>
include<../general/plank.scad>
include<../general/half_lap.scad>

module runner(room_length, wt_height, wt_depth, wt_thickness, overhang) {
    // We assume that the wt_height and wt_depth are less than a board length (!!), but not the room length.
    lumber_width = three_by;
    lumber_thickness = two_by;
    max_board_length = 240;
    yy_lap_length = three_by; // arbitrary, but we need it for calculations.
    yx_lap_length = lumber_thickness;


    // num_y_planks
    num_y_planks = ceil(room_length / max_board_length);
    num_yy_laps = num_y_planks - 1;
    echo("going to use ", planks=num_y_planks, laps=num_yy_laps);
    length_y_planks_without_laps = (room_length - (num_yy_laps * yy_lap_length)) / num_y_planks;
    first_and_last_y_plank_length = length_y_planks_without_laps + yy_lap_length;
    middle_y_plank_length = length_y_planks_without_laps + 2*yy_lap_length;

    length_x_planks = wt_depth - overhang;
    length_z_planks = wt_height - wt_thickness - (lumber_width / 2);

    // x and y planks have half laps at each end. z planks only at the top.

    // each y plank is half-lapped z+ at the left(-y) and z- at the right(+y).
    for (y_plank_i = [0 : num_y_planks-1]) {
        echo("looping over number of runner planks along the wall length,", iteration=y_plank_i);

        first = y_plank_i == 0;
        last = y_plank_i + 1 == num_y_planks;
        middle = !first && !last;

        yi_x_size = lumber_thickness;
        yi_y_size = (first || last)? first_and_last_y_plank_length : middle_y_plank_length;
        yi_z_size = lumber_width;

        yi_x_off = 0;
        yi_y_off = (y_plank_i * length_y_planks_without_laps) + (max(0, y_plank_i-1) * yy_lap_length);
        yi_z_off = wt_height - wt_thickness - yi_z_size;

        // common half_lap params: children_bounds, d_along, lap_length_da, which_end_da, d_cut, which_side_dc
        // The translate happens after the half_lap calls, so we don't need to bake the offsets into the lap calculations.
        children_bounds = [yi_x_size, yi_y_size, yi_z_size];
        echo("half_lap args, ", child_bounds = children_bounds);
        d_along = "y";
        d_cut = "z";
        
        // Left (lower Y coord) lap params:
        l_lap_length = first ? yx_lap_length : yy_lap_length;
        l_which_end = "-";
        l_which_side = "-";

        // Right (larger Y coord) lap params:
        r_lap_length = last ? yx_lap_length : yy_lap_length;
        r_which_end = "+";
        r_which_side = "+";

        translate([yi_x_off, yi_y_off, yi_z_off]) {
            half_lap(children_bounds, d_along, l_lap_length, l_which_end, d_cut, l_which_side) {
                half_lap(children_bounds, d_along, r_lap_length, r_which_end, d_cut, r_which_side) {
                    plank(yi_y_size, yi_z_size, yi_x_size, "y", "z");
                }
            }
        }
    }

    // x planks.
    x_x_size = length_x_planks;
    x_y_size = lumber_thickness;
    x_z_size = lumber_width;

    x_plank_size = [x_x_size, x_y_size, x_z_size];

    x_x_off = 0;
    x_z_off = wt_height - wt_thickness - x_z_size;

    xl_y_off = 0;
    xr_y_off = room_length - x_y_size;

    translate([x_x_off, xl_y_off, x_z_off]) {
        half_lap(x_plank_size, "x", lumber_thickness, "-", "z", "+") {
            half_lap(x_plank_size, "x", lumber_width, "+", "z", "-") {
                plank(length_x_planks, lumber_width, lumber_thickness, "x", "z");
            }
        }
    }
    translate([x_x_off, xr_y_off, x_z_off]) {
        half_lap(x_plank_size, "x", lumber_thickness, "-", "z", "-") {
            half_lap(x_plank_size, "x", lumber_width, "+", "z", "-") {
                plank(length_x_planks, lumber_width, lumber_thickness, "x", "z");
            }
        }
    }

    // z planks

    z_x_size = lumber_width;
    z_y_size = lumber_thickness;
    z_z_size = length_z_planks;

    z_plank_size = [z_x_size, z_y_size, z_z_size];

    z_x_off = x_x_size - z_x_size;
    z_z_off = 0;

    zl_y_off = 0;
    zr_y_off = room_length - x_y_size;

    translate([z_x_off, zl_y_off, z_z_off]) {
        plank(length_z_planks, lumber_width, lumber_thickness, "z", "x");
    }
    translate([z_x_off, zr_y_off, z_z_off]) {
        plank(length_z_planks, lumber_width, lumber_thickness, "z", "x");
    }
}