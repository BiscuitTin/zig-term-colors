const std = @import("std");
const consts = @import("consts.zig");
const enums = @import("enums.zig");

const CSI = consts.CSI;
const COLOR_16_FORMAT_STRING = consts.COLOR_16_FORMAT_STRING;

const Color = enums.Color;
const TextColor = enums.TextColor;

pub const ComptimeColors = struct {
    pub fn color16(comptime color: Color, comptime text: TextColor) []const u8 {
        const color_number = @intFromEnum(color);
        const color_code: u7 = switch (text) {
            .foreground => color_number,
            .background => color_number + 10,
        };

        return std.fmt.comptimePrint(COLOR_16_FORMAT_STRING, .{color_code});
    }

    pub fn default(comptime text: TextColor) []const u8 {
        return switch (text) {
            .foreground => CSI ++ "39m",
            .background => CSI ++ "49m",
        };
    }
};
