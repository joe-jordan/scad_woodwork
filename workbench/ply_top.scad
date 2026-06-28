
module top(length, depth, thickness) {
    echo("CUT LIST: Top. Two layers of 18mm ply,", width=depth, length=length);

        color("#F7F1DE")
        cube([length, depth, thickness], center = false);
}