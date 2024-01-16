const std = @import("std");
const Tuple = std.meta.Tuple;

pub const Color = enum(u7) {
    black = 30,
    red = 31,
    green = 32,
    yellow = 33,
    blue = 34,
    magenta = 35,
    cyan = 36,
    white = 37,
    bright_black = 90,
    bright_red = 91,
    bright_green = 92,
    bright_yellow = 93,
    bright_blue = 94,
    bright_magenta = 95,
    bright_cyan = 96,
    bright_white = 97,
};

pub const TextColor = enum {
    foreground,
    background,
};

pub const ColorParams = Tuple(&[_]type{ Color, TextColor });
