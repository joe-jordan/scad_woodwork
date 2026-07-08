include<general/functions.scad>
include<general/plank.scad>
include<general/sheet.scad>
include<general/mortice.scad>
include<general/tenon.scad>
include<general/half_lap.scad>

module demo() {
    xoff = 25;
    translate([xoff*0, 0, 0]) {
        sheet(100, 75, 1.8, "y", "z");
    }
    translate([xoff*1, 0, 0]) {
        plank(150, 8.5, 3.8, "y", "x");
    }
    translate([xoff*2, 0, 0]) {
        mortice([8.5, 150, 3.8], 0.25, "y", 85, 8.5, "x") {
            mortice([8.5, 150, 3.8], "thirds", "y", 35, 8.5, "z") {
                plank(150, 8.5, 3.8, "y", "x");
            }
        }
    }
    translate([xoff*3, 0, 0]) {
        mortice([8.5, 150, 3.8], 0.05, "x", -0.01, 2.01, "z") {
            mortice([8.5, 150, 3.8], "thirds", "y", 150-8.5, 8.6, "z") {
                plank(150, 8.5, 3.8, "y", "x");
            }
        }
    }
    translate([xoff*4, 0, 0]) {
        tenon([8.5, 150, 3.8], "y", 7.2, true, "x", 8.5/3) {
            plank(150, 8.5, 3.8, "y", "x");
        }
    }
    translate([xoff*5, 0, 0]) {
        mortice([8.5, 150, 3.8], "thirds", "y", 35, 8.5, "z") {
            tenon([8.5, 150, 3.8], "y", 7.2, "-", "x", 8.5/3) {
                plank(150, 8.5, 3.8, "y", "x");
            }
        }
    }
    translate([xoff*6, 0, 0]) {
        half_lap([3.8, 8.5, 150], "z", 8.5, "-", "x", "+") {
            plank(150, 8.5, 3.8, "z", "y");
        }
    }
    translate([xoff*7, 0, 0]) {
        sheet(100, 75, 1.8, "x", "y");
    }
}

demo();