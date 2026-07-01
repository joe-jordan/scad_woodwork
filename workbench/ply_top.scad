include<config.scad>

module top(length, depth, thickness) {
    if (verbose) {
        echo("screw/countersink first layer onto (apron, top trestles and key), and then glue second layer on top of that.");
    }

    echo("CUT LIST: Top. Two layers of 18mm ply,", width=depth, length=length);

    color("#F7F1DE")
    cube([length, depth, thickness], center = false);
}