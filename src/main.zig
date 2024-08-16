const std = @import("std");

const json = @import("json.zig");

/// Returns a Gltf top level struct with extensions specified
pub const Gltf = @import("gltf.zig").Gltf;

pub const extensions = @import("extensions.zig");

const util = @import("util.zig");
pub const Index = util.Index;
pub const NullableIndex = util.NullableIndex;

/// Parses a .glb file
pub const parseGlb = @import("glb.zig").parse;

/// Parses a .gltf file
pub fn parseGltf(
    comptime TopLevel: type,
    reader: anytype,
    allocator: std.mem.Allocator,
    tmp_allocator: std.mem.Allocator,
) !TopLevel {
    return try json.parse(
        TopLevel,
        reader,
        allocator,
        tmp_allocator,
    );
}
