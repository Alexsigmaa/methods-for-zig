// methods/build.zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    // Standard build options allow the user of your package to choose them.
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Create the static library artifact. This is what other projects will use.
    const lib = b.addStaticLibrary(.{
        .name = "methods", // Corresponds to the name in build.zig.zon
        .root_source_file = b.path("src/lib.zig"),
        .target = target,
        .optimize = optimize,
    });

    // This command makes the library available to other packages.
    b.installArtifact(lib);

    // --- Tests ---
    // Create a test runner for our library.
    const lib_tests = b.addTest(.{
        .root_source_file = b.path("src/lib.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_lib_tests = b.addRunArtifact(lib_tests);

    // Create a `zig build test` step to run the tests.
    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&run_lib_tests.step);
}
