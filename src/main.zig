const std = @import("std");
const app = @import("app.zig");
const cmd = @import("command_utils.zig");
const git = @import("git.zig");

pub fn main() !void {
    const out = std.io.getStdOut().writer();
    const green = "\x1b[32m";
    const red = "\x1b[31m";
    const reset = "\x1b[0m";
    const tick = "✔";
    const cross = "X";
    // const cross = "✖";

    try out.print("{s} {s} starting...\t\t\t\t\t[{s}{s}{s}]\n", .{ app.app.name, app.app.version, green, tick, reset });

    const git_installed = try git.Git.IsInstalled(); //cmd.runCommandCheckOutput("git", "usage: git [-v | --version]2");
    if (git_installed) {
        try out.print("Checking for Git...\t\t\t\t\t\t\t[{s}{s}{s}]\n", .{ green, tick, reset });
    } else {
        try out.print("Checking for Git...\t\t\t\t\t\t\t[{s}{s}{s}]\n", .{ red, cross, reset });
    }

    try out.print("{s} {s} finished!...\n", .{ app.app.name, app.app.version });
}
