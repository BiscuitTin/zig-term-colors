pub const Colors = @import("colors.zig").Colors;
pub const createColors = @import("colors.zig").createColors;

pub const ComptimeColors = @import("comptime_colors.zig").ComptimeColors;

pub const utils = @import("utils.zig");

test {
    _ = @import("tests/comptime_colors_test.zig");
    _ = @import("tests/utils_test.zig");
}
