const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Paths and version
    const version = "2.1";
    const prefix = "/usr/local";
    // const manprefix = prefix ++ "/share/man";
    const libprefix = prefix ++ "/lib";
    const libdir = libprefix ++ "/surf";

    // surf build
    const surf = b.addExecutable(.{
        .name = "surf",
        .target = target,
        .optimize = optimize,
    });
    surf.addCSourceFile(.{
        .file = b.path("src/surf.c"),
        .flags = &.{
            "-fPIC",
            "-DVERSION=\"" ++ version ++ "\"",
            "-DGCR_API_SUBJECT_TO_CHANGE",
            "-DLIBPREFIX=\"" ++ libprefix ++ "\"",
            "-DWEBEXTDIR=\"" ++ libdir ++ "\"",
            "-D_DEFAULT_SOURCE",
        },
    });
    surf.linkSystemLibrary("gthread-2.0");
    // surf.linkSystemLibrary("x11");
    surf.linkSystemLibrary("wayland-client");
    surf.linkSystemLibrary("gtk-3");
    surf.linkSystemLibrary("gcr-3");
    surf.linkSystemLibrary("webkit2gtk-4.1");
    surf.linkLibC();
    surf.addIncludePath(b.path("."));
    b.installArtifact(surf);

    // webext-surf shared library
    const webext = b.addSharedLibrary(.{
        .name = "webext-surf",
        .target = target,
        .optimize = optimize,
        .version = .{ .major = 0, .minor = 0, .patch = 0 },
    });
    webext.addCSourceFile(.{
        .file = b.path("src/webext-surf.c"),
        .flags = &.{"-fPIC"},
    });
    webext.linkSystemLibrary("webkit2gtk-4.1");
    webext.linkSystemLibrary("webkit2gtk-web-extension-4.1");
    webext.linkSystemLibrary("gio-2.0");
    webext.addIncludePath(b.path("."));
    webext.linkLibC();
    b.installArtifact(webext);

    // Install man page
    // const man1 = b.addInstallFile(.{ .path = "surf.1" }, manprefix ++ "/man1/surf.1");
    // b.getInstallStep().dependOn(&man1.step);

    // add run step
    const run = b.step("run", "Run surf");
    const surfRun = b.addRunArtifact(surf);
    run.dependOn(&surfRun.step);
}
