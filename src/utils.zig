const consts = @import("consts.zig");

const CSI = consts.CSI;

pub inline fn reset() []const u8 {
    return CSI ++ "0m";
}

pub inline fn bold(set: bool) []const u8 {
    return if (set) CSI ++ "1m" else CSI ++ "22m";
}

pub inline fn dim(set: bool) []const u8 {
    return if (set) CSI ++ "2m" else CSI ++ "22m";
}

pub inline fn italic(set: bool) []const u8 {
    return if (set) CSI ++ "3m" else CSI ++ "23m";
}

pub inline fn underline(set: bool) []const u8 {
    return if (set) CSI ++ "4m" else CSI ++ "24m";
}

pub inline fn blink(set: bool) []const u8 {
    return if (set) CSI ++ "5m" else CSI ++ "25m";
}

pub inline fn inverse(set: bool) []const u8 {
    return if (set) CSI ++ "7m" else CSI ++ "27m";
}

pub inline fn hidden(set: bool) []const u8 {
    return if (set) CSI ++ "8m" else CSI ++ "28m";
}

pub inline fn strikethrough(set: bool) []const u8 {
    return if (set) CSI ++ "9m" else CSI ++ "29m";
}
