# Workbench Builder

module conventions:
* Each plank needs a file.
* Parts in their own module exist using 0,0 as a plank origin (they may have a tenon, so may not actually arrive at (0,0).)
 * NOTE: since planks know their own dimensions, we can't assume their dimensions in the outer script. This makes computing offsets from the back of the table tricky. Instead, if we "center=true" the parts, then the offsets become centre<->centre, and that is calculable from the table constants without knowing the board dimensions.
 * BUT: plenty of offsets are calculated to be registered _on the dimensions_ of the boards, e.g. the tenon offsets inside the legs must be centred. The offset of the centre of the leg is overhang (which itself is calculated based on a board dimension, so aprons are flush) plus half the dimension of the leg. The dimensions of some of the boards detemines the posisions of other boards. which means the dimensions of the boards must also be inputs to the modules.
* z is vertical, and x is the long direction of the bench. All parts know if they are x, y or z grain oriented and appear in that orientation.
* faces that face "inwards" to the centre of the bench are always in modules facing the +x or +y direction.
* Constants about lumber dimensions live in their own module and are exported.
* Constants about the size of the workbench, or the height of shelves, live in the main workbench scad at top level.
* Plank modules accept necessary bench dimensions as arguments, do not pull in globals.


