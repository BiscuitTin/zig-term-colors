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

    /// Example:
    /// ```zig
    /// // set text color to red
    /// try colors.setColor(writer, .red);
    /// ```
    pub fn setColor(conf: Colors, out_stream: anytype, color: Color) !void {
        return color16(conf, out_stream, color, .foreground);
    }

    /// Example:
    /// ```zig
    /// // set background color to red
    /// try colors.setBackgroundColor(writer, .red);
    /// ```
    pub fn setBackgroundColor(conf: Colors, out_stream: anytype, color: Color) !void {
        return color16(conf, out_stream, color, .background);
    }

    /// Example:
    /// ```zig
    /// // set text color to red
    /// try colors.fg(writer, .red);
    /// ```
    pub fn fg(conf: Colors, writer: anytype, color: Color) !void {
        return color16(conf, writer, color, .foreground);
    }

    /// Example:
    /// ```zig
    /// // set background color to red
    /// try colors.bg(writer, .red);
    /// ```
    pub fn bg(conf: Colors, writer: anytype, color: Color) !void {
        return color16(conf, writer, color, .background);
    }

    /// Example:
    /// ```zig
    /// // set text color to terminal default
    /// try colors.default(writer, .foreground);
    /// ```
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

    /// Example:
    /// ```zig
    /// // reset all colors and styles
    /// try colors.reset(writer);
    /// ```
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

    /// Example:
    /// ```zig
    /// // set bold font
    /// try colors.bold(writer, true);
    /// ```
    pub fn bold(conf: Colors, writer: anytype, set: bool) !void {
        return style(conf, writer, set, "1m", "22m");
    }

    /// Example:
    /// ```zig
    /// // set dim(faint) font
    /// try colors.dim(writer, true);
    /// ```
    pub fn dim(conf: Colors, writer: anytype, set: bool) !void {
        return style(conf, writer, set, "2m", "22m");
    }

    /// Example:
    /// ```zig
    /// // set italic font
    /// try colors.italic(writer, true);
    /// ```
    pub fn italic(conf: Colors, writer: anytype, set: bool) !void {
        return style(conf, writer, set, "3m", "23m");
    }

    /// Example:
    /// ```zig
    /// // add underline to text
    /// try colors.underline(writer, true);
    /// ```
    pub fn underline(conf: Colors, writer: anytype, set: bool) !void {
        return style(conf, writer, set, "4m", "24m");
    }

    /// Example:
    /// ```zig
    /// // blink the text
    /// try colors.blink(writer, true);
    /// ```
    pub fn blink(conf: Colors, writer: anytype, set: bool) !void {
        return style(conf, writer, set, "5m", "25m");
    }

    /// Example:
    /// ```zig
    /// // swap foreground and background colors
    /// try colors.inverse(writer, true);
    /// ```
    pub fn inverse(conf: Colors, writer: anytype, set: bool) !void {
        return style(conf, writer, set, "7m", "27m");
    }

    /// Example:
    /// ```zig
    /// // hide text
    /// try colors.hidden(writer, true);
    /// ```
    pub fn hidden(conf: Colors, writer: anytype, set: bool) !void {
        return style(conf, writer, set, "8m", "28m");
    }

    /// Example:
    /// ```zig
    /// // add strikethrough to text
    /// try colors.strikethrough(writer, true);
    /// ```
    pub fn strikethrough(conf: Colors, writer: anytype, set: bool) !void {
        return style(conf, writer, set, "9m", "29m");
    }
};

pub const comptime_colors = struct {
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

    pub inline fn default(comptime text: TextColor) []const u8 {
        comptime return switch (text) {
            .foreground => CSI ++ "39m",
            .background => CSI ++ "49m",
        };
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

/// Example:
/// ```zig
/// const stderr_file = std.io.getStdErr();
/// const stderr_writer = stderr_file.writer();
/// var bw = std.io.bufferedWriter(stderr_writer);
/// const stderr = bw.writer();
///
/// const tty_config = std.io.tty.detectConfig(stderr_file);
/// const colors = createColors(tty_config);
/// try colors.setColor(stderr, .red);
/// try stderr.print("This is a red text", .{});
///
/// try bw.flush();
/// ```
pub fn createColors(config: Config) Colors {
    nosuspend switch (config) {
        .no_color => return .no_color,
        .escape_codes => return .escape_codes,
        else => return .no_color,
    };
}
