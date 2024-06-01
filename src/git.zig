const cmd = @import("command_utils.zig");

pub const Git = struct {
    pub fn IsInstalled() !bool {
        const git_installed = try cmd.runCommandCheckOutput("git", "usage: git [-v | --version]");

        return git_installed;
    }
};
