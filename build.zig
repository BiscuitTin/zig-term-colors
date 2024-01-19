const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // const lib = b.addStaticLibrary(.{
    //     .name = "term-colors",
    //     .root_source_file = .{ .path = "src/lib.zig" },
    //     .target = target,
    //     .optimize = optimize,
    // });
    // b.installArtifact(lib);

    const lib_unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/lib.zig" },
        .target = target,
        .optimize = optimize,
    });
    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);

    const lib_docs = b.addInstallDirectory(.{
        .source_dir = lib_unit_tests.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "../docs",
    });
    const gen_docs_step = b.step("docs", "Generate documentation");
    gen_docs_step.dependOn(&lib_docs.step);

    const lib_module = b.createModule(.{
        .root_source_file = .{ .path = "src/lib.zig" },
        .target = target,
        .optimize = optimize,
    });

    const demo_app = b.addExecutable(.{
        .name = "demo",
        .root_source_file = .{ .path = "examples/demo.zig" },
        .target = target,
        .optimize = optimize,
    });
    demo_app.root_module.addImport("term-colors", lib_module);
    const run_demo_app = b.addRunArtifact(demo_app);
    run_demo_app.step.dependOn(b.getInstallStep());
    const run_demo_app_step = b.step("demo", "Run the demo app");
    run_demo_app_step.dependOn(&run_demo_app.step);
}
