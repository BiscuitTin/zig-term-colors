pub const Colors = @import("colors.zig").Colors;
pub const comptime_colors = @import("colors.zig").comptime_colors;
pub const createColors = @import("colors.zig").createColors;

pub const utils = @import("utils.zig");

test {
    _ = @import("tests/colors_test.zig");
    _ = @import("tests/utils_test.zig");
}
