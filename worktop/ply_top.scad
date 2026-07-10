include<config.scad>
include<../general/sheet.scad>

module top(length, depth, thickness) {
    if (verbose) {
        echo("One layer, made of several sections which join on top of trestles.");
    }

    echo("CUT LIST: Top. One layer of 18mm ply,", width=depth, length=length);

    color("#F7F1DE")
    sheet(length, depth, thickness, "y", "x");
}