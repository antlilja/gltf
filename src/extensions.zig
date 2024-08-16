const std = @import("std");

const util = @import("util.zig");
const Index = util.Index;
const NullableIndex = util.NullableIndex;

// Top level extensions
pub const KhrLightsPunctualTopLevel = struct {
    pub const name = "KHR_lights_punctual";

    pub const Light = struct {
        pub const Type = enum {
            directional,
            point,
            spot,
        };

        pub const Spot = struct {
            inner_cone_angle: f32 = 0.0,
            outer_cone_angle: f32 = std.math.pi / 4.0,
        };

        name: []const u8 = &.{},
        color: [3]f32 = .{ 1.0, 1.0, 1.0 },
        intensity: f32 = 1.0,
        type: Type = undefined,
        range: ?f32 = null,
        spot: Spot = .{},
    };

    lights: []const Light = &.{},
};

// Buffer view extensions
pub const ExtMeshoptCompression = struct {
    pub const name = "EXT_meshopt_compression";

    pub const Mode = enum {
        pub const lookup = std.StaticStringMap(Mode).initComptime(.{
            .{ "ATTRIBUTES", .attributes },
            .{ "TRIANGLES", .triangles },
            .{ "INDICES", .indices },
        });

        attributes,
        triangles,
        indices,
    };

    pub const Filter = enum {
        pub const lookup = std.StaticStringMap(Filter).initComptime(.{
            .{ "NONE", .none },
            .{ "OCTAHEDRAL", .octahedral },
            .{ "QUATERNION", .quaternion },
            .{ "EXPONENTIAL", .exponential },
        });

        none,
        octahedral,
        quaternion,
        exponential,
    };

    buffer: Index = .undefined,
    byte_offset: usize = 0,
    byte_length: usize = undefined,
    byte_stride: usize = undefined,
    count: usize = undefined,
    mode: Mode = undefined,
    filter: Filter = .none,
};

// Texture extensions
pub const KhrTextureTransform = struct {
    pub const name = "KHR_texture_transform";

    offset: [2]f32 = .{ 0.0, 0.0 },
    rotation: f32 = 0.0,
    scale: [2]f32 = .{ 1.0, 1.0 },
    tex_coord: Index = .undefined,
};

pub const KhrTextureBasisu = struct {
    pub const name = "KHR_texture_basisu";

    source: Index = .undefined,
};

// Node extensions
pub const KhrLightsPunctualNode = struct {
    pub const name = "KHR_lights_punctual";

    light: Index = .undefined,
};
