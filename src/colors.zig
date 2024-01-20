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

    pub fn print(conf: Colors, writer: anytype, color: ColorParams, comptime format: []const u8, args: anytype) !void {
        try color16(conf, writer, color[0], color[1]);
        try std.fmt.format(writer, format, args);
        try default(conf, writer, color[1]);
    }

    pub fn setColor(conf: Colors, out_stream: anytype, color: Color, text: TextColor) !void {
        return color16(conf, out_stream, color, text);
    }

    pub fn fg(conf: Colors, writer: anytype, color: Color) !void {
        return color16(conf, writer, color, .foreground);
    }

    pub fn bg(conf: Colors, writer: anytype, color: Color) !void {
        return color16(conf, writer, color, .background);
    }

    // 16 colors
    pub fn black(conf: Colors, writer: anytype, text: TextColor) !void {
        return color16(conf, writer, .black, text);
    }
    pub fn brightBlack(conf: Colors, writer: anytype, text: TextColor) !void {
        return color16(conf, writer, .bright_black, text);
    }
    pub fn red(conf: Colors, writer: anytype, text: TextColor) !void {
        return color16(conf, writer, .red, text);
    }
    pub fn brightRed(conf: Colors, writer: anytype, text: TextColor) !void {
        return color16(conf, writer, .bright_red, text);
    }
    pub fn green(conf: Colors, writer: anytype, text: TextColor) !void {
        return color16(conf, writer, .green, text);
    }
    pub fn brightGreen(conf: Colors, writer: anytype, text: TextColor) !void {
        return color16(conf, writer, .bright_green, text);
    }
    pub fn yellow(conf: Colors, writer: anytype, text: TextColor) !void {
        return color16(conf, writer, .yellow, text);
    }
    pub fn brightYellow(conf: Colors, writer: anytype, text: TextColor) !void {
        return color16(conf, writer, .bright_yellow, text);
    }
    pub fn blue(conf: Colors, writer: anytype, text: TextColor) !void {
        return color16(conf, writer, .blue, text);
    }
    pub fn brightBlue(conf: Colors, writer: anytype, text: TextColor) !void {
        return color16(conf, writer, .bright_blue, text);
    }
    pub fn magenta(conf: Colors, writer: anytype, text: TextColor) !void {
        return color16(conf, writer, .magenta, text);
    }
    pub fn brightMagenta(conf: Colors, writer: anytype, text: TextColor) !void {
        return color16(conf, writer, .bright_magenta, text);
    }
    pub fn cyan(conf: Colors, writer: anytype, text: TextColor) !void {
        return color16(conf, writer, .cyan, text);
    }
    pub fn brightCyan(conf: Colors, writer: anytype, text: TextColor) !void {
        return color16(conf, writer, .bright_cyan, text);
    }
    pub fn white(conf: Colors, writer: anytype, text: TextColor) !void {
        return color16(conf, writer, .white, text);
    }
    pub fn brightWhite(conf: Colors, writer: anytype, text: TextColor) !void {
        return color16(conf, writer, .bright_white, text);
    }
};

pub const comptime_colors = struct {
    pub inline fn default(comptime text: TextColor) []const u8 {
        comptime return switch (text) {
            .foreground => CSI ++ "39m",
            .background => CSI ++ "49m",
        };
    }

    pub inline fn color16(comptime color: Color, comptime text: TextColor) []const u8 {
        comptime {
            const color_number = @intFromEnum(color);
            const color_code: u7 = switch (text) {
                .foreground => color_number,
                .background => color_number + 10,
            };
            return std.fmt.comptimePrint(COLOR_16_FORMAT_STRING, .{color_code});
        }
    }

    pub inline fn print(comptime color: Color, comptime text: TextColor, comptime format: []const u8, args: anytype) []const u8 {
        comptime {
            const color_str = color16(color, text);
            const str: []const u8 = std.fmt.comptimePrint(format, args);
            const default_str = default(text);
            return std.fmt.comptimePrint("{s}{s}{s}", .{ color_str, str, default_str });
        }
    }

    pub inline fn fg(comptime color: Color) []const u8 {
        comptime return color16(color, .foreground);
    }

    pub inline fn bg(comptime color: Color) []const u8 {
        comptime return color16(color, .background);
    }
};

pub fn createColors(config: Config) Colors {
    nosuspend switch (config) {
        .no_color => return .no_color,
        .escape_codes => return .escape_codes,
        else => return .no_color,
    };
}
