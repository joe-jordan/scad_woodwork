include<functions.scad>

// HALF LAP - cut away half-width on the child, from one side only.
// children_bounds - must be an array either [xmax, ymax, zmax] or 
//   [xmin, xmax, ymin, ymax, zmin, zmax]. The shorter list assumes min values are all 0.
// d_along, foo_da: 
//   d_along = "x", "y" or "z" - the long dimension _along which_ the tenon should be placed.
//   lap_length_da: the length of the lap (in units of d_along).
//   which_end_da: "+" or "-". + => the end where d_along is larger, - => the end where it's smaller.
// d_cut, foo_dc:
//   d_cut = "x", "y", "z" - the dimension perpendicular to d_along, and to the face of the cut.
//   which_side_dc = "+" or "-". + => the end where d_cut is larger, - => the end where it's smaller.
module half_lap(children_bounds, d_along, lap_length_da, which_end_da, d_cut, which_side_dc) {
    delta = 0.01;

    if (d_along != d_cut && valid_dimension(d_along) && valid_dimension(d_cut)) {

        // this dimension isn't actually an axis of symmetry after a half lap, but the 
        // but does fall along it.
        known_ds = [d_along, d_cut];
        d_symmetry = !in("x", known_ds) ? "x" : (!in("y", known_ds) ? "y" : "z");

        xmin = len(children_bounds) == 6 ? children_bounds[0] : 0;
        ymin = len(children_bounds) == 6 ? children_bounds[2] : 0;
        zmin = len(children_bounds) == 6 ? children_bounds[4] : 0;

        xmax = len(children_bounds) == 6 ? children_bounds[1] : children_bounds[0];
        ymax = len(children_bounds) == 6 ? children_bounds[3] : children_bounds[1];
        zmax = len(children_bounds) == 6 ? children_bounds[5] : children_bounds[2];

        child_size = [xmax-xmin, ymax-ymin, zmax-zmin];

        if (len([for (i = child_size) if (i <= 0) i]) == 0) {
            echo("performing half-lap cuts.");
            // create a 6-len "children_bounds" modified so that it reads (along, through, depth) by dimensions.
            // We use this to calculate the lap cut offset and size.
            frame_bounds = [
                d_along == "x" ? xmin : (d_along == "y" ? ymin : zmin),
                d_along == "x" ? xmax : (d_along == "y" ? ymax : zmax),
                d_cut == "x" ? xmin : (d_cut == "y" ? ymin : zmin),
                d_cut == "x" ? xmax : (d_cut == "y" ? ymax : zmax),
                d_symmetry == "x" ? xmin : (d_symmetry == "y" ? ymin : zmin),
                d_symmetry == "x" ? xmax : (d_symmetry == "y" ? ymax : zmax),
            ];

            child_along_size = frame_bounds[1] - frame_bounds[0];
            child_cut_size = frame_bounds[3] - frame_bounds[2];
            child_symmetry_size = frame_bounds[5] - frame_bounds[4];

            along_size = lap_length_da + delta;
            cut_size = (child_cut_size / 2) + delta;
            symmetry_size = child_symmetry_size + 2*delta;

            along_offset = which_end_da == "+" ? frame_bounds[0] + child_along_size - lap_length_da : frame_bounds[0] - delta;
            cut_offset = which_side_dc == "+" ? frame_bounds[2] + child_cut_size - (child_cut_size / 2) : frame_bounds[2] - delta;
            symmetry_offset = frame_bounds[4] - delta;

            lap_size = [
                d_along == "x" ? along_size : (d_cut == "x" ? cut_size : symmetry_size),
                d_along == "y" ? along_size : (d_cut == "y" ? cut_size : symmetry_size),
                d_along == "z" ? along_size : (d_cut == "z" ? cut_size : symmetry_size)
            ];
            lap_off = [
                d_along == "x" ? along_offset : (d_cut == "x" ? cut_offset : symmetry_offset),
                d_along == "y" ? along_offset : (d_cut == "y" ? cut_offset : symmetry_offset),
                d_along == "z" ? along_offset : (d_cut == "z" ? cut_offset : symmetry_offset)
            ];
            echo("lap params:", size=lap_size, off=lap_off);

            difference() {
                union() {
                    children();
                }
                union() {
                    translate(lap_off)
                        cube(lap_size);
                }
            }
        }
        else {
            echo("WARNING: invalid bounds passed to half_lap():", children_bounds=children_bounds);
        }
    }
    else {
        echo("WARNING: invalid dimensions passed to half_lap():", d_along=d_along, d_through=d_cut);
    }
}