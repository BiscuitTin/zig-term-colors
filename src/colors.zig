const std = @import("std");
const enums = @import("enums.zig");
const utils = @import("utils.zig");

const Config = std.io.tty.Config;
const Color = enums.Color;
const TextColor = enums.TextColor;
const ColorParams = enums.ColorParams;

pub const Colors = union(enum) {
    no_color,
    escape_codes,

    pub fn setColor(conf: Colors, out_stream: anytype, color: Color, text: TextColor) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => try utils.color16(out_stream, color, text),
        };
    }

    pub fn print(conf: Colors, writer: anytype, color: ColorParams, comptime format: []const u8, args: anytype) !void {
        nosuspend switch (conf) {
            .no_color => try std.fmt.format(writer, format, args),
            .escape_codes => {
                try utils.color16(writer, color[0], color[1]);
                try std.fmt.format(writer, format, args);
                try writer.writeAll(utils.default(color[1]));
            },
        };
    }

    pub fn default(conf: Colors, writer: anytype, text: TextColor) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => try writer.writeAll(utils.default(text)),
        };
    }

    // 16 colors
    pub fn black(conf: Colors, writer: anytype, text: TextColor) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => try utils.color16(writer, .black, text),
        };
    }
    pub fn brightBlack(conf: Colors, writer: anytype, text: TextColor) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => try utils.color16(writer, .bright_black, text),
        };
    }
    pub fn red(conf: Colors, writer: anytype, text: TextColor) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => try utils.color16(writer, .red, text),
        };
    }
    pub fn brightRed(conf: Colors, writer: anytype, text: TextColor) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => try utils.color16(writer, .bright_red, text),
        };
    }
    pub fn green(conf: Colors, writer: anytype, text: TextColor) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => try utils.color16(writer, .green, text),
        };
    }
    pub fn brightGreen(conf: Colors, writer: anytype, text: TextColor) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => try utils.color16(writer, .bright_green, text),
        };
    }
    pub fn yellow(conf: Colors, writer: anytype, text: TextColor) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => try utils.color16(writer, .yellow, text),
        };
    }
    pub fn brightYellow(conf: Colors, writer: anytype, text: TextColor) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => try utils.color16(writer, .bright_yellow, text),
        };
    }
    pub fn blue(conf: Colors, writer: anytype, text: TextColor) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => try utils.color16(writer, .blue, text),
        };
    }
    pub fn brightBlue(conf: Colors, writer: anytype, text: TextColor) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => try utils.color16(writer, .bright_blue, text),
        };
    }
    pub fn magenta(conf: Colors, writer: anytype, text: TextColor) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => try utils.color16(writer, .magenta, text),
        };
    }
    pub fn brightMagenta(conf: Colors, writer: anytype, text: TextColor) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => try utils.color16(writer, .bright_magenta, text),
        };
    }
    pub fn cyan(conf: Colors, writer: anytype, text: TextColor) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => try utils.color16(writer, .cyan, text),
        };
    }
    pub fn brightCyan(conf: Colors, writer: anytype, text: TextColor) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => try utils.color16(writer, .bright_cyan, text),
        };
    }
    pub fn white(conf: Colors, writer: anytype, text: TextColor) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => try utils.color16(writer, .white, text),
        };
    }
    pub fn brightWhite(conf: Colors, writer: anytype, text: TextColor) !void {
        nosuspend switch (conf) {
            .no_color => return,
            .escape_codes => try utils.color16(writer, .bright_white, text),
        };
    }
};

pub fn createColors(config: Config) Colors {
    nosuspend switch (config) {
        .no_color => return .no_color,
        .escape_codes => return .escape_codes,
        else => return .no_color,
    };
}
