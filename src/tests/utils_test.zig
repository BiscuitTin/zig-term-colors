const std = @import("std");
const utils = @import("../utils.zig");

const testing = std.testing;

test "utils reset" {
    const expected = "\x1b[0m";
    const actual = utils.reset();
    try testing.expectEqualStrings(expected, actual);
}

test "utils font styles" {
    {
        // bold text
        const expected = "\x1b[1m";
        const actual = utils.bold(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // dim text
        const expected = "\x1b[2m";
        const actual = utils.dim(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // italic text
        const expected = "\x1b[3m";
        const actual = utils.italic(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // underline text
        const expected = "\x1b[4m";
        const actual = utils.underline(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // blink text
        const expected = "\x1b[5m";
        const actual = utils.blink(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // inverse text
        const expected = "\x1b[7m";
        const actual = utils.inverse(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // hidden text
        const expected = "\x1b[8m";
        const actual = utils.hidden(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // strikethrough text
        const expected = "\x1b[9m";
        const actual = utils.strikethrough(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no bold text
        const expected = "\x1b[22m";
        const actual = utils.bold(false);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no dim text
        const expected = "\x1b[22m";
        const actual = utils.dim(false);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no italic text
        const expected = "\x1b[23m";
        const actual = utils.italic(false);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no underline text
        const expected = "\x1b[24m";
        const actual = utils.underline(false);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no blink text
        const expected = "\x1b[25m";
        const actual = utils.blink(false);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no inverse text
        const expected = "\x1b[27m";
        const actual = utils.inverse(false);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no hidden text
        const expected = "\x1b[28m";
        const actual = utils.hidden(false);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no strikethrough text
        const expected = "\x1b[29m";
        const actual = utils.strikethrough(false);
        try testing.expectEqualStrings(expected, actual);
    }
}
