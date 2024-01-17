const std = @import("std");
const consts = @import("consts.zig");
const enums = @import("enums.zig");

const CSI = consts.CSI;
const COLOR_16_FORMAT_STRING = consts.COLOR_16_FORMAT_STRING;

const Color = enums.Color;
const TextColor = enums.TextColor;

pub fn default(text: TextColor) []const u8 {
    return switch (text) {
        .foreground => CSI ++ "39m",
        .background => CSI ++ "49m",
    };
}

pub fn color16(writer: anytype, color: Color, text: TextColor) !void {
    const color_number = @intFromEnum(color);
    const color_code: u7 = switch (text) {
        .foreground => color_number,
        .background => color_number + 10,
    };

    return std.fmt.format(writer, COLOR_16_FORMAT_STRING, .{color_code});
}

pub fn reset() []const u8 {
    return CSI ++ "0m";
}

pub fn bold(set: bool) []const u8 {
    return if (set) CSI ++ "1m" else CSI ++ "22m";
}

pub fn dim(set: bool) []const u8 {
    return if (set) CSI ++ "2m" else CSI ++ "22m";
}

pub fn italic(set: bool) []const u8 {
    return if (set) CSI ++ "3m" else CSI ++ "23m";
}

pub fn underline(set: bool) []const u8 {
    return if (set) CSI ++ "4m" else CSI ++ "24m";
}

pub fn blink(set: bool) []const u8 {
    return if (set) CSI ++ "5m" else CSI ++ "25m";
}

pub fn inverse(set: bool) []const u8 {
    return if (set) CSI ++ "7m" else CSI ++ "27m";
}

pub fn hidden(set: bool) []const u8 {
    return if (set) CSI ++ "8m" else CSI ++ "28m";
}

pub fn strikethrough(set: bool) []const u8 {
    return if (set) CSI ++ "9m" else CSI ++ "29m";
}
