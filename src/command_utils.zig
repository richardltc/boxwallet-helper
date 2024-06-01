const std = @import("std");

pub fn runCommandCheckOutput(cmd: []const u8, output_str: []const u8) !bool {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = std.heap.page_allocator;

    var child_process = std.ChildProcess.init(&[_][]const u8{cmd}, allocator);

    // Redirect stdout and stderr to capture them
    child_process.stdout_behavior = .Pipe;
    child_process.stderr_behavior = .Pipe;

    try child_process.spawn();

    const stdout_buf = try allocator.alloc(u8, 1024);
    defer allocator.free(stdout_buf);
    const stderr_buf = try allocator.alloc(u8, 1024);
    defer allocator.free(stderr_buf);

    if (child_process.stdout) |stdout| {
        while (true) {
            const n = try stdout.read(stdout_buf);
            if (n == 0) break;
            const contains_str = std.mem.containsAtLeast(u8, stdout_buf, 1, output_str);
            if (contains_str) {
                // std.debug.print("Found {s}", .{output_str});
                return true;
            }
        }
    }

    if (child_process.stderr) |stderr| {
        while (true) {
            const n = try stderr.read(stderr_buf);
            if (n == 0) break;
        }
    }

    _ = try child_process.wait();
    // std.debug.print("exit code: {}\n", .{exit_status});

    return false;
}

pub fn runCommandDisplayOutput(cmd: []const u8) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = std.heap.page_allocator;

    var child_process = std.ChildProcess.init(&[_][]const u8{cmd}, allocator);

    // Redirect stdout and stderr to capture them
    child_process.stdout_behavior = .Pipe;
    child_process.stderr_behavior = .Pipe;

    try child_process.spawn();

    var stdout_buf = try allocator.alloc(u8, 1024);
    defer allocator.free(stdout_buf);
    var stderr_buf = try allocator.alloc(u8, 1024);
    defer allocator.free(stderr_buf);

    if (child_process.stdout) |stdout| {
        while (true) {
            const n = try stdout.read(stdout_buf);
            if (n == 0) break;
            std.debug.print("{s}", .{stdout_buf[0..n]});
        }
    }

    if (child_process.stderr) |stderr| {
        while (true) {
            const n = try stderr.read(stderr_buf);
            if (n == 0) break;
            std.debug.print("{s}", .{stderr_buf[0..n]});
        }
    }

    const exit_status = try child_process.wait();
    std.debug.print("exit code: {}\n", .{exit_status});

    return false;
}
