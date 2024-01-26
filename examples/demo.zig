const std = @import("std");
const term_colors = @import("term-colors");

const comptime_colors_demo = struct {
    fn printColorCodeCells(comptime style: []const u8, id: comptime_int, comptime name: []const u8) void {
        const colors = term_colors.comptime_colors;

        std.debug.print("{s}", .{style});

        inline for (@typeInfo(term_colors.Color).Enum.fields) |c| {
            const color: term_colors.Color = @enumFromInt(c.value);
            const str = colors.print(color, .foreground, " {d} ", .{c.value});
            std.debug.print("{s}", .{str});
        }

        std.debug.print("{s} - ({d}) {s}\r\n", .{ colors.reset(), id, name });
    }

    fn printColorCells(id: comptime_int, comptime name: []const u8) void {
        const colors = term_colors.comptime_colors;

        inline for (@typeInfo(term_colors.Color).Enum.fields) |c| {
            if (id == 3) if (c.value > 40) break;
            if (id == 9) if (c.value < 40) continue;

            const color: term_colors.Color = @enumFromInt(c.value);
            std.debug.print("{s}{d:^8}{s}", .{ colors.bg(color), c.value, colors.default(.background) });
        }

        std.debug.print("{s} - ({d}x) {s}\r\n", .{ colors.reset(), id, name });
    }

    pub fn print() void {
        std.debug.print("{s:-^64}\r\n", .{"foreground text colors and font styles"});

        const colors = term_colors.comptime_colors;
        printColorCodeCells("", 0, "normal");
        printColorCodeCells(colors.bold(true), 1, "bold");
        printColorCodeCells(colors.dim(true), 2, "dim");
        printColorCodeCells(colors.italic(true), 3, "italic");
        printColorCodeCells(colors.underline(true), 4, "underline");
        printColorCodeCells(colors.blink(true), 5, "blink");
        printColorCodeCells(colors.inverse(true), 7, "inverse");
        printColorCodeCells(colors.hidden(true), 8, "hidden");
        printColorCodeCells(colors.strikethrough(true), 9, "strikethrough");

        std.debug.print("\r\n{s:-^64}\r\n", .{"normal and bright background colors"});

        printColorCells(3, "normal");
        printColorCells(9, "bright");
    }
};

const runtime_colors_demo = struct {
    fn printColorCodeCells(colors: term_colors.Colors, writer: anytype, id: u8, name: []const u8) !void {
        inline for (@typeInfo(term_colors.Color).Enum.fields) |c| {
            const color: term_colors.Color = @enumFromInt(c.value);
            try colors.setColor(writer, color);
            try writer.print(" {d} ", .{c.value});
            try colors.default(writer, .foreground);
        }

        try colors.reset(writer);
        try writer.print(" - ({d}) {s}\r\n", .{ id, name });
    }

    fn printColorCells(colors: term_colors.Colors, writer: anytype, id: comptime_int, name: []const u8) !void {
        inline for (@typeInfo(term_colors.Color).Enum.fields) |c| {
            if (id == 3) if (c.value > 40) break;
            if (id == 9) if (c.value < 40) continue;

            const color: term_colors.Color = @enumFromInt(c.value);
            try colors.print(writer, .{ color, .background }, "{d:^8}", .{c.value});
        }

        try colors.reset(writer);
        try writer.print(" - ({d}x) {s}\r\n", .{ id, name });
    }

    pub fn print() !void {
        const stderr_file = std.io.getStdErr();
        const stderr_writer = stderr_file.writer();
        var bw = std.io.bufferedWriter(stderr_writer);
        const stderr = bw.writer();
        const tty_config = std.io.tty.detectConfig(stderr_file);
        const colors = term_colors.createColors(tty_config);

        try stderr.print("{s:-^64}\r\n", .{"foreground text colors and font styles"});

        try printColorCodeCells(colors, stderr, 0, "normal");
        try colors.bold(stderr, true);
        try printColorCodeCells(colors, stderr, 1, "bold");
        try colors.dim(stderr, true);
        try printColorCodeCells(colors, stderr, 2, "dim");
        try colors.italic(stderr, true);
        try printColorCodeCells(colors, stderr, 3, "italic");
        try colors.underline(stderr, true);
        try printColorCodeCells(colors, stderr, 4, "underline");
        try colors.blink(stderr, true);
        try printColorCodeCells(colors, stderr, 5, "blink");
        try colors.inverse(stderr, true);
        try printColorCodeCells(colors, stderr, 7, "inverse");
        try colors.hidden(stderr, true);
        try printColorCodeCells(colors, stderr, 8, "hidden");
        try colors.strikethrough(stderr, true);
        try printColorCodeCells(colors, stderr, 9, "strikethrough");

        try stderr.print("\r\n{s:-^64}\r\n", .{"normal and bright background colors"});

        try printColorCells(colors, stderr, 3, "normal");
        try printColorCells(colors, stderr, 9, "bright");

        try bw.flush();
    }
};

pub fn main() !void {
    std.debug.print("\r\n{s:=^64}\r\n\r\n", .{" Comptime "});

    comptime_colors_demo.print();

    std.debug.print("\r\n{s:=^64}\r\n\r\n", .{" Runtime "});

    try runtime_colors_demo.print();

    std.debug.print("\r\n", .{});
}
