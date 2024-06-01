const std = @import("std");
const app = @import("app.zig");
const cmd = @import("command_utils.zig");

pub fn main() !void {
    const out = std.io.getStdOut().writer();
    const green = "\x1b[32m";
    const red = "\x1b[31m";
    const reset = "\x1b[0m";
    const tick = "✔";
    const cross = "✖";
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    try out.print("{s} {s} starting...\t\t\t\t\t[{s}{s}{s}]\n", .{ app.app.name, app.app.version, green, tick, reset });

    const git_installed = try cmd.runCommandCheckOutput("git", "usage: git [-v | --version]2");
    if (git_installed) {
        try out.print("Checking for Git...\t\t\t\t\t\t\t[{s}{s}{s}]\n", .{ green, tick, reset });
    } else {
        try out.print("Checking for Git...\t\t\t\t\t\t\t[{s}{s}{s}]\n", .{ red, cross, reset });
    }

    try out.print("{s} {s} finished!...\n", .{ app.app.name, app.app.version });
}

// pub fn runCommandCheckOutput(cmd: []const u8, output_str: []const u8) !bool {
//     var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
//     defer arena.deinit();

//     const allocator = std.heap.page_allocator;

//     var child_process = std.ChildProcess.init(&[_][]const u8{cmd}, allocator);

//     // Redirect stdout and stderr to capture them
//     child_process.stdout_behavior = .Pipe;
//     child_process.stderr_behavior = .Pipe;

//     try child_process.spawn();

//     var stdout_buf = try allocator.alloc(u8, 1024);
//     defer allocator.free(stdout_buf);
//     var stderr_buf = try allocator.alloc(u8, 1024);
//     defer allocator.free(stderr_buf);

//     if (child_process.stdout) |stdout| {
//         while (true) {
//             const n = try stdout.read(stdout_buf);
//             if (n == 0) break;
//             const contains_str = std.mem.containsAtLeast(u8, stdout_buf, 1, output_str);
//             if (contains_str) {
//                 std.debug.print("{s}", .{"Yes!"});
//                 return true;
//             }
//             std.debug.print("{s}", .{stdout_buf[0..n]});
//         }
//     }

//     if (child_process.stderr) |stderr| {
//         while (true) {
//             const n = try stderr.read(stderr_buf);
//             if (n == 0) break;
//             std.debug.print("{s}", .{stderr_buf[0..n]});
//         }
//     }

//     const exit_status = try child_process.wait();
//     std.debug.print("exit code: {}\n", .{exit_status});

//     return false;
// }
