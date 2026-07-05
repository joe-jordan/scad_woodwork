// PRIVATE
// (private) returns a comparitor function that searches for a value.
function _equals(a) = function (b) a == b;

__valid_dimensions = ["x", "y", "z"];
__valid_extended_dimensions = ["x", "y", "z", "-x", "-y", "-z"];

// PUBLIC (general)
// true if the test function passes for any item in the `set` list.
function any(set, test) = len([for (i = set) if (test(i)) i]) > 0;

// All seems to be buggy...
// // true if the test function passes for all items in the `set` list.
function all(set, test) = len([for (i = set) if (!test(i)) i]) == 0;

// true if items is contained within the list `set`.
function in(item, set) = any(set, _equals(item));

// test function which is true if x > 0, good for composing with any and all.
function positive(num) = num > 0;


// APP-SPECIFIC
// application-specific functions
function valid_dimension(val) = in(val, __valid_dimensions);
function valid_edimension(val) = in(val, __valid_extended_dimensions);