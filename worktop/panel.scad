include<config.scad>
include<../general/sheet.scad>

module panel(height, width, thickness) {
    if (verbose) {
        echo("panel made to fit inside trestle.");
    }

    echo("CUT LIST: Panel, one layer of 12mm ply,", width=width, length=height);

    if ((width > height && (width > 80 || height > 60)) || (width < height && (width > 60 || height > 80))) {
        echo("DIMENSION WARNING: not easy to cut panels out of ply sheets.");
    }

    sheet(height, width, thickness, "z", "x");
}