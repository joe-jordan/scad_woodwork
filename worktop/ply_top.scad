include<config.scad>

module top(length, depth, thickness) {
    if (verbose) {
        echo("One layer, made of several sections which join on top of trestles.");
    }

    echo("CUT LIST: Top. Two layers of 18mm ply,", width=depth, length=length);

    color("#F7F1DE")
    cube([length, depth, thickness], center = false);
}