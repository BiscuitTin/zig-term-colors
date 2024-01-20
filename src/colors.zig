const std = @import("std");
const enums = @import("enums.zig");

const CSI: []const u8 = "\x1b[";

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
                try std.fmt.format(writer, "{s}{d}m", .{ CSI, color_code });
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

    pub fn reset(conf: Colors, writer: anytype) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => {
                const str: []const u8 = CSI ++ "0m";
                try writer.writeAll(str);
            },
        };
    }

    inline fn style(conf: Colors, writer: anytype, set: bool, comptime open: []const u8, comptime close: []const u8) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => {
                const str: []const u8 = if (set) open else close;
                try std.fmt.format(writer, "{s}{s}", .{ CSI, str });
            },
        };
    }
    pub fn bold(conf: Colors, writer: anytype, set: bool) !void {
        return style(conf, writer, set, "1m", "22m");
    }
    pub fn dim(conf: Colors, writer: anytype, set: bool) !void {
        return style(conf, writer, set, "2m", "22m");
    }
    pub fn italic(conf: Colors, writer: anytype, set: bool) !void {
        return style(conf, writer, set, "3m", "23m");
    }
    pub fn underline(conf: Colors, writer: anytype, set: bool) !void {
        return style(conf, writer, set, "4m", "24m");
    }
    pub fn blink(conf: Colors, writer: anytype, set: bool) !void {
        return style(conf, writer, set, "5m", "25m");
    }
    pub fn inverse(conf: Colors, writer: anytype, set: bool) !void {
        return style(conf, writer, set, "7m", "27m");
    }
    pub fn hidden(conf: Colors, writer: anytype, set: bool) !void {
        return style(conf, writer, set, "8m", "28m");
    }
    pub fn strikethrough(conf: Colors, writer: anytype, set: bool) !void {
        return style(conf, writer, set, "9m", "29m");
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
            return std.fmt.comptimePrint("{s}{d}m", .{ CSI, color_code });
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

    // 16 colors
    pub inline fn black(comptime text: TextColor) []const u8 {
        comptime return color16(.black, text);
    }
    pub inline fn brightBlack(comptime text: TextColor) []const u8 {
        comptime return color16(.bright_black, text);
    }
    pub inline fn red(comptime text: TextColor) []const u8 {
        comptime return color16(.red, text);
    }
    pub inline fn brightRed(comptime text: TextColor) []const u8 {
        comptime return color16(.bright_red, text);
    }
    pub inline fn green(comptime text: TextColor) []const u8 {
        comptime return color16(.green, text);
    }
    pub inline fn brightGreen(comptime text: TextColor) []const u8 {
        comptime return color16(.bright_green, text);
    }
    pub inline fn yellow(comptime text: TextColor) []const u8 {
        comptime return color16(.yellow, text);
    }
    pub inline fn brightYellow(comptime text: TextColor) []const u8 {
        comptime return color16(.bright_yellow, text);
    }
    pub inline fn blue(comptime text: TextColor) []const u8 {
        comptime return color16(.blue, text);
    }
    pub inline fn brightBlue(comptime text: TextColor) []const u8 {
        comptime return color16(.bright_blue, text);
    }
    pub inline fn magenta(comptime text: TextColor) []const u8 {
        comptime return color16(.magenta, text);
    }
    pub inline fn brightMagenta(comptime text: TextColor) []const u8 {
        comptime return color16(.bright_magenta, text);
    }
    pub inline fn cyan(comptime text: TextColor) []const u8 {
        comptime return color16(.cyan, text);
    }
    pub inline fn brightCyan(comptime text: TextColor) []const u8 {
        comptime return color16(.bright_cyan, text);
    }
    pub inline fn white(comptime text: TextColor) []const u8 {
        comptime return color16(.white, text);
    }
    pub inline fn brightWhite(comptime text: TextColor) []const u8 {
        comptime return color16(.bright_white, text);
    }

    pub inline fn reset() []const u8 {
        comptime return CSI ++ "0m";
    }

    // font styles
    inline fn style(comptime set: bool, comptime open: []const u8, comptime close: []const u8) []const u8 {
        comptime return CSI ++ if (set) open else close;
    }
    pub inline fn bold(comptime set: bool) []const u8 {
        comptime return style(set, "1m", "22m");
    }
    pub inline fn dim(comptime set: bool) []const u8 {
        comptime return style(set, "2m", "22m");
    }
    pub inline fn italic(comptime set: bool) []const u8 {
        comptime return style(set, "3m", "23m");
    }
    pub inline fn underline(comptime set: bool) []const u8 {
        comptime return style(set, "4m", "24m");
    }
    pub inline fn blink(comptime set: bool) []const u8 {
        comptime return style(set, "5m", "25m");
    }
    pub inline fn inverse(comptime set: bool) []const u8 {
        comptime return style(set, "7m", "27m");
    }
    pub inline fn hidden(comptime set: bool) []const u8 {
        comptime return style(set, "8m", "28m");
    }
    pub inline fn strikethrough(comptime set: bool) []const u8 {
        comptime return style(set, "9m", "29m");
    }
};

pub fn createColors(config: Config) Colors {
    nosuspend switch (config) {
        .no_color => return .no_color,
        .escape_codes => return .escape_codes,
        else => return .no_color,
    };
}
