const std = @import("std");
const consts = @import("consts.zig");
const enums = @import("enums.zig");

const CSI = consts.CSI;
const COLOR_16_FORMAT_STRING = consts.COLOR_16_FORMAT_STRING;

const Config = std.io.tty.Config;
const Color = enums.Color;
const TextColor = enums.TextColor;
const ColorParams = enums.ColorParams;

pub const Colors = union(enum) {
    no_color,
    escape_codes,

    pub fn default(conf: Colors, writer: anytype, text: TextColor) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => {
                const str: []const u8 = switch (text) {
                    .foreground => CSI ++ "39m",
                    .background => CSI ++ "49m",
                };
                try writer.writeAll(str);
            },
        };
    }

    pub fn color16(conf: Colors, writer: anytype, color: Color, text: TextColor) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => {
                const color_number = @intFromEnum(color);
                const color_code: u7 = switch (text) {
                    .foreground => color_number,
                    .background => color_number + 10,
                };
                try std.fmt.format(writer, COLOR_16_FORMAT_STRING, .{color_code});
            },
        };
    }

    pub fn print(writer: anytype, color: ColorParams, comptime format: []const u8, args: anytype) !void {
        try color16(writer, color[0], color[1]);
        try std.fmt.format(writer, format, args);
        try default(color[1]);
    }

    pub fn setColor(out_stream: anytype, color: Color, text: TextColor) !void {
        return color16(out_stream, color, text);
    }

    // 16 colors
    pub fn black(writer: anytype, text: TextColor) !void {
        return color16(writer, .black, text);
    }
    pub fn brightBlack(writer: anytype, text: TextColor) !void {
        return color16(writer, .bright_black, text);
    }
    pub fn red(writer: anytype, text: TextColor) !void {
        return color16(writer, .red, text);
    }
    pub fn brightRed(writer: anytype, text: TextColor) !void {
        return color16(writer, .bright_red, text);
    }
    pub fn green(writer: anytype, text: TextColor) !void {
        return color16(writer, .green, text);
    }
    pub fn brightGreen(writer: anytype, text: TextColor) !void {
        return color16(writer, .bright_green, text);
    }
    pub fn yellow(writer: anytype, text: TextColor) !void {
        return color16(writer, .yellow, text);
    }
    pub fn brightYellow(writer: anytype, text: TextColor) !void {
        return color16(writer, .bright_yellow, text);
    }
    pub fn blue(writer: anytype, text: TextColor) !void {
        return color16(writer, .blue, text);
    }
    pub fn brightBlue(writer: anytype, text: TextColor) !void {
        return color16(writer, .bright_blue, text);
    }
    pub fn magenta(writer: anytype, text: TextColor) !void {
        return color16(writer, .magenta, text);
    }
    pub fn brightMagenta(writer: anytype, text: TextColor) !void {
        return color16(writer, .bright_magenta, text);
    }
    pub fn cyan(writer: anytype, text: TextColor) !void {
        return color16(writer, .cyan, text);
    }
    pub fn brightCyan(writer: anytype, text: TextColor) !void {
        return color16(writer, .bright_cyan, text);
    }
    pub fn white(writer: anytype, text: TextColor) !void {
        return color16(writer, .white, text);
    }
    pub fn brightWhite(writer: anytype, text: TextColor) !void {
        return color16(writer, .bright_white, text);
    }
};

pub const ComptimeColors = struct {
    pub inline fn default(comptime text: TextColor) []const u8 {
        return switch (text) {
            .foreground => CSI ++ "39m",
            .background => CSI ++ "49m",
        };
    }

    pub inline fn color16(comptime color: Color, comptime text: TextColor) []const u8 {
        const color_number = @intFromEnum(color);
        const color_code: u7 = switch (text) {
            .foreground => color_number,
            .background => color_number + 10,
        };
        return std.fmt.comptimePrint(COLOR_16_FORMAT_STRING, .{color_code});
    }

    pub inline fn print(comptime color: Color, comptime text: TextColor, comptime format: []const u8, args: anytype) []const u8 {
        const color_str = color16(color, text);
        const str: []const u8 = std.fmt.comptimePrint(format, args);
        const default_str = default(text);
        return std.fmt.comptimePrint("{s}{s}{s}", .{ color_str, str, default_str });
    }

    pub inline fn fg(comptime color: Color) []const u8 {
        return color16(color, .foreground);
    }

    pub inline fn bg(comptime color: Color) []const u8 {
        return color16(color, .background);
    }
};

pub fn createColors(config: Config) Colors {
    nosuspend switch (config) {
        .no_color => return .no_color,
        .escape_codes => return .escape_codes,
        else => return .no_color,
    };
}
