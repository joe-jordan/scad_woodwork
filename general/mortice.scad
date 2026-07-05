include<functions.scad>

// MORTICE - cut a mortice into a child object, centrally in one dimension (the one you don't specify in args).
// children_bounds - must be an array either [xmax, ymax, zmax] or 
//   [xmin, xmax, ymin, ymax, zmin, zmax]. The shorter list assumes min values are all 0.
// rule: a constant which helps specify which moritce coordinates to use.
//   rule can be a string from {"thirds" (more rules?)}, or can be a number 0<x<1 being the 
//   fraction of the child that should be cut away (e.g. "thirds" would be 0.333..).
// d_along, foo_da: 
//   d_along = "x", "y" or "z" - the long dimension _along which_ the mortice should be placed.
//   offset_da: the offset (in units of +d_along) where the start of the mortice cut should be.
//   length_da: the length of the mortice cut (in units of d_along) along d_along.
// d_through, foo_dt:
//   d_through = "x", "y", "z", "-x", "-y", "-z" - the dimension along which to cut through the 
//     child. Negative dimensions means you cut from the side where d_through is a larger coord 
//     value (this is only needed if depth_dt is less than all the way through the child.)
//   depth_dt = the depth, (in units of +d_through) of the mortice. if undefined or zero or 
//     negative then it is assumed 100% depth.
module mortice(children_bounds, rule, d_along, offset_da, length_da, d_through, depth_dt) {

    delta = 0.01;

    if (d_along != d_through && valid_dimension(d_along) && valid_edimension(d_through)) {

        // d_through without the +/-.
        d_depth = in(d_through, ["x", "-x"]) ? "x" : (in(d_through, ["y", "-y"]) ? "y" : "z");
        depth_is_positive = valid_dimension(d_through);
        known_ds = [d_along, d_depth];
        d_symmetry = !in("x", known_ds) ? "x" : (!in("y", known_ds) ? "y" : "z");

        xmin = len(children_bounds) == 6 ? children_bounds[0] : 0;
        ymin = len(children_bounds) == 6 ? children_bounds[2] : 0;
        zmin = len(children_bounds) == 6 ? children_bounds[4] : 0;

        xmax = len(children_bounds) == 6 ? children_bounds[1] : children_bounds[0];
        ymax = len(children_bounds) == 6 ? children_bounds[3] : children_bounds[1];
        zmax = len(children_bounds) == 6 ? children_bounds[5] : children_bounds[2];

        child_size = [xmax-xmin, ymax-ymin, zmax-zmin];

        if (len([for (i = child_size) if (i <= 0) i]) == 0) {
            // create a 6-len "children_bounds" modified so that it reads (along, through, depth) by dimensions. We use this to calculate the mortice offset and size.
            frame_bounds = [
                d_along == "x" ? xmin : (d_along == "y" ? ymin : zmin),
                d_along == "x" ? xmax : (d_along == "y" ? ymax : zmax),
                d_depth == "x" ? xmin : (d_depth == "y" ? ymin : zmin),
                d_depth == "x" ? xmax : (d_depth == "y" ? ymax : zmax),
                d_symmetry == "x" ? xmin : (d_symmetry == "y" ? ymin : zmin),
                d_symmetry == "x" ? xmax : (d_symmetry == "y" ? ymax : zmax),
            ];

            along_off = offset_da + frame_bounds[0];
            along_size = length_da;

            child_depth_size = frame_bounds[3] - frame_bounds[2];
            depth_specified = (depth_dt != undef) && (depth_dt > 0);

            depth_size = depth_specified ? depth_dt + delta : child_depth_size + 2*delta;
            depth_off = depth_is_positive ?  frame_bounds[2] -delta : frame_bounds[2] + child_depth_size + delta - depth_size;

            symmetry_fraction = (rule == "thirds") ? 1/3 : rule;
            child_symmetry_size = frame_bounds[5] - frame_bounds[4];
            symmetry_size = child_symmetry_size * symmetry_fraction;
            symmetry_off = (child_symmetry_size - symmetry_size) / 2 + frame_bounds[4];
            
            mortice_size = [
                d_along == "x" ? along_size : (d_depth == "x" ? depth_size : symmetry_size),
                d_along == "y" ? along_size : (d_depth == "y" ? depth_size : symmetry_size),
                d_along == "z" ? along_size : (d_depth == "z" ? depth_size : symmetry_size),
            ];

            mortice_offset = [
                d_along == "x" ? along_off : (d_depth == "x" ? depth_off : symmetry_off),
                d_along == "y" ? along_off : (d_depth == "y" ? depth_off : symmetry_off),
                d_along == "z" ? along_off : (d_depth == "z" ? depth_off : symmetry_off),
            ];

            echo("mortice_params", mortice_size=mortice_size, mortice_offset=mortice_offset);

            difference() {
                union() {
                    children();
                }
                union() {
                    translate(mortice_offset)
                        cube(mortice_size);
                }
            }
        }
        else {
            echo("WARNING: invalid bounds passed to mortice():", children_bounds=children_bounds);
        }
    }
    else {
        echo("WARNING: invalid dimensions passed to mortice():", d_along=d_along, d_through=d_through);
    }
}