include<functions.scad>

module sheet(length, width, thickness, d_len, d_wid, colour) {
    // We need to define a sheet (cube), and ensure that length is used as the d_len (x, y, or z) dimension.
    // and that width is used as the d_wid (x, y, or z) dimension.

    if (d_len != d_wid && valid_dimension(d_len) && valid_dimension(d_wid)) {
        as_vec = [length, width, thickness];

        x_index = d_len == "x" ? 0 : d_wid == "x" ? 1 : 2;
        y_index = d_len == "y" ? 0 : d_wid == "y" ? 1 : 2;
        z_index = d_len == "z" ? 0 : d_wid == "z" ? 1 : 2;

        colour_val = colour == undef ? "#F7F1DE" : colour;

        color(colour_val)
        cube([as_vec[x_index], as_vec[y_index], as_vec[z_index]], center=false);
    }
    else {
        echo("WARNING: invalid sheet() call with ", d_len=d_len, d_wid=d_wid);
    }
}