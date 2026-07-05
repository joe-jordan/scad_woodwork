include<functions.scad>

// TENON - cut away tenon cheeks on a child, symmetrically about one axis.
// Note: tenon width is assumed to be the whole board width. Manupulating the 
// children_bounds to reduce the width of the tenon will result in an error, because 
// of renderer compensation delta factor.
// children_bounds - must be an array either [xmax, ymax, zmax] or 
//   [xmin, xmax, ymin, ymax, zmin, zmax]. The shorter list assumes min values are all 0.
// d_along, foo_da: 
//   d_along = "x", "y" or "z" - the long dimension _along which_ the tenon should be placed.
//   tenon_length_da: the length of the tenon (in units of d_along).
//   both_ends_da = true, "+" or "-". + indicates the end where d_along coord is larger.
// d_across, foo_dt:
//   d_across = "x", "y", "z" - the dimension perpendicular to d_along, but still parallel 
//     to the tenon's cheek.
//   tenon_thickness_dt = the thickness, (in units of the remaining dimension) of the tenon after cutting.

module tenon(children_bounds, d_along, tenon_length_da, both_ends_da, d_across, tenon_thickness_dt) {

    delta = 0.01;

    if (d_along != d_across && valid_dimension(d_along) && valid_dimension(d_across)) {

        // d_through without the +/-.
        known_ds = [d_along, d_across];
        d_symmetry = !in("x", known_ds) ? "x" : (!in("y", known_ds) ? "y" : "z");
        echo("debug", d_along=d_along, d_across=d_across, d_symmetry=d_symmetry);

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
                d_across == "x" ? xmin : (d_across == "y" ? ymin : zmin),
                d_across == "x" ? xmax : (d_across == "y" ? ymax : zmax),
                d_symmetry == "x" ? xmin : (d_symmetry == "y" ? ymin : zmin),
                d_symmetry == "x" ? xmax : (d_symmetry == "y" ? ymax : zmax),
            ];

            d_along_min_tenon = (both_ends_da == true || both_ends_da == "-");
            d_along_max_tenon = (both_ends_da == true || both_ends_da == "+");

            echo("debug", d_along_min_tenon=d_along_min_tenon, d_along_max_tenon=d_along_max_tenon);

            // for each possible tenon, compute the cuts:
            // Possible Tenon cuts:
            // X     | -along | +along
            // -symm |   A    |   B
            // +symm |   C    |   D

            child_along_size = frame_bounds[1] - frame_bounds[0];
            child_across_size = frame_bounds[3] - frame_bounds[2];
            child_symmetry_size = frame_bounds[5] - frame_bounds[4];

            // All cuts share the same size.
            along_size = tenon_length_da + delta;
            across_size = child_across_size + 2*delta;
            symmetry_size = (child_symmetry_size - tenon_thickness_dt) / 2 + delta;

            // Use size in ternary expressions to turn cuts on/off:
            common_size = [
                d_along == "x" ? along_size : (d_across == "x" ? across_size : symmetry_size),
                d_along == "y" ? along_size : (d_across == "y" ? across_size : symmetry_size),
                d_along == "z" ? along_size : (d_across == "z" ? across_size : symmetry_size)
            ];
            zero_size = [0, 0, 0];

            // A offsets:
            A_along_off = -delta;
            A_across_off = -delta;
            A_symmetry_off = -delta;

            // B offsets:
            B_along_off = child_along_size + delta - along_size;
            B_across_off = -delta;
            B_symmetry_off = -delta;

            // C offsets:
            C_along_off = -delta;
            C_across_off = -delta;
            C_symmetry_off = child_symmetry_size + delta - symmetry_size;

            // D offsets:
            D_along_off = child_along_size + delta - along_size;
            D_across_off = -delta;
            D_symmetry_off = child_symmetry_size + delta - symmetry_size;

            A_size = d_along_min_tenon ? common_size : zero_size;
            B_size = d_along_max_tenon ? common_size : zero_size;
            C_size = d_along_min_tenon ? common_size : zero_size;
            D_size = d_along_max_tenon ? common_size : zero_size;

            A_off = [
                d_along == "x" ? A_along_off : (d_across == "x" ? A_across_off : A_symmetry_off),
                d_along == "y" ? A_along_off : (d_across == "y" ? A_across_off : A_symmetry_off),
                d_along == "z" ? A_along_off : (d_across == "z" ? A_across_off : A_symmetry_off),
            ];
            B_off = [
                d_along == "x" ? B_along_off : (d_across == "x" ? B_across_off : B_symmetry_off),
                d_along == "y" ? B_along_off : (d_across == "y" ? B_across_off : B_symmetry_off),
                d_along == "z" ? B_along_off : (d_across == "z" ? B_across_off : B_symmetry_off),
            ];
            C_off = [
                d_along == "x" ? C_along_off : (d_across == "x" ? C_across_off : C_symmetry_off),
                d_along == "y" ? C_along_off : (d_across == "y" ? C_across_off : C_symmetry_off),
                d_along == "z" ? C_along_off : (d_across == "z" ? C_across_off : C_symmetry_off),
            ];
            D_off = [
                d_along == "x" ? D_along_off : (d_across == "x" ? D_across_off : D_symmetry_off),
                d_along == "y" ? D_along_off : (d_across == "y" ? D_across_off : D_symmetry_off),
                d_along == "z" ? D_along_off : (d_across == "z" ? D_across_off : D_symmetry_off),
            ];

            echo("debug A", A_size=A_size, A_off=A_off);
            echo("debug B", B_size=B_size, B_off=B_off);
            echo("debug C", C_size=C_size, C_off=C_off);
            echo("debug D", D_size=D_size, D_off=D_off);

            difference() {
                union() {
                    children();
                }
                union() {
                    translate(A_off)
                        cube(A_size);
                    translate(B_off)
                        cube(B_size);
                    translate(C_off)
                        cube(C_size);
                    translate(D_off)
                        cube(D_size);
                }
            }
        }
        else {
            echo("WARNING: invalid bounds passed to tenon():", children_bounds=children_bounds);
        }
    }
    else {
        echo("WARNING: invalid dimensions passed to tenon():", d_along=d_along, d_through=d_through);
    }
}