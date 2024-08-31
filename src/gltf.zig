const std = @import("std");

const util = @import("util.zig");
const Index = util.Index;
const NullableIndex = util.NullableIndex;

pub const Config = struct {
    extensions: struct {
        top_level: type = struct {},
        buffer: type = struct {},
        buffer_view: type = struct {},
        accessor: type = struct {},
        mesh: type = struct {},
        primitive: type = struct {},
        material: type = struct {},
        texture: type = struct {},
        image: type = struct {},
        sampler: type = struct {},
        scene: type = struct {},
        node: type = struct {},
        camera: type = struct {},
    } = .{},

    include: struct {
        scenes: bool = true,
        cameras: bool = true,
    } = .{},
    include_name_in: struct {
        buffer: bool = false,
        buffer_view: bool = false,
        accessor: bool = false,
        mesh: bool = false,
        material: bool = false,
        texture: bool = false,
        image: bool = false,
        sampler: bool = false,
        scene: bool = false,
        node: bool = false,
        camera: bool = false,
    } = .{},
};

pub fn Gltf(config: Config) type {
    return struct {
        pub const Buffer = struct {
            const Name = if (config.include_name_in.buffer) []const u8 else void;
            const name_default = if (config.include_name_in.buffer) &.{} else {};

            name: Name = name_default,
            byte_length: u32 = undefined,
            uri: []const u8 = &.{},
            extensions: config.extensions.buffer = .{},
        };

        pub const BufferView = struct {
            pub const Target = enum(u16) {
                array_buffer = 34962,
                element_array_buffer = 34963,
                not_specified = 0xffff,
                _,
            };

            const Name = if (config.include_name_in.buffer_view) []const u8 else void;
            const name_default = if (config.include_name_in.buffer_view) &.{} else {};

            name: Name = name_default,
            buffer: Index = .undefined,
            byte_offset: usize = 0,
            byte_length: usize = undefined,
            byte_stride: u8 = 0,
            target: Target = .not_specified,
            extensions: config.extensions.buffer_view = .{},
        };

        pub const Accessor = struct {
            pub const ComponentType = enum(u16) {
                signed_byte = 5120,
                unsigned_byte = 5121,
                signed_short = 5122,
                unsigned_short = 5123,
                unsigned_int = 5125,
                float = 5126,
                _,

                pub fn size(self: ComponentType) usize {
                    return switch (self) {
                        .signed_byte, .unsigned_byte => 1,
                        .signed_short, .unsigned_short => 2,
                        .unsigned_int, .float => 4,
                        else => unreachable,
                    };
                }
            };

            pub const Type = enum(u8) {
                pub const lookup = std.StaticStringMap(Type).initComptime(.{
                    .{ "SCALAR", .scalar },
                    .{ "VEC2", .vec2 },
                    .{ "VEC3", .vec3 },
                    .{ "VEC4", .vec4 },
                    .{ "MAT2", .mat2 },
                    .{ "MAT3", .mat3 },
                    .{ "MAT4", .mat4 },
                });

                scalar,
                vec2,
                vec3,
                vec4,
                mat2,
                mat3,
                mat4,

                pub fn count(self: Type) usize {
                    return switch (self) {
                        .scalar => 1,
                        .vec2 => 2,
                        .vec3 => 3,
                        .vec4 => 4,
                        .mat2 => 4,
                        .mat3 => 9,
                        .mat4 => 16,
                    };
                }
            };

            const Name = if (config.include_name_in.accessor) []const u8 else void;
            const name_default = if (config.include_name_in.accessor) &.{} else {};

            name: Name = name_default,
            buffer_view: NullableIndex = .null,
            byte_offset: usize = 0,
            count: u32 = undefined,
            component_type: ComponentType = undefined,
            type: Type = undefined,

            extensions: config.extensions.accessor = .{},
        };

        pub const Mesh = struct {
            const Name = if (config.include_name_in.mesh) []const u8 else void;
            const name_default = if (config.include_name_in.mesh) &.{} else {};

            name: Name = name_default,
            primitives: []const Primitive = &.{},
            extensions: config.extensions.mesh = .{},
        };

        pub const Primitive = struct {
            pub const Topology = enum(u8) {
                points = 0,
                line_strips = 1,
                line_loops = 2,
                lines = 3,
                triangles = 4,
                triangle_strips = 5,
                triangle_fans = 6,
                _,
            };

            pub const Attributes = struct {
                pub const field_name_lookup = std.StaticStringMap([]const u8).initComptime(.{
                    .{ "position", "POSITION" },
                    .{ "normal", "NORMAL" },
                    .{ "tangent", "TANGENT" },
                    .{ "texcoord_0", "TEXCOORD_0" },
                });

                position: NullableIndex = .null,
                normal: NullableIndex = .null,
                tangent: NullableIndex = .null,
                texcoord_0: NullableIndex = .null,
            };

            indices: NullableIndex = .null,
            attributes: Attributes = .{},
            material: NullableIndex = .null,
            mode: Topology = .triangles,

            extensions: config.extensions.primitive = .{},
        };

        pub const Material = struct {
            pub const TextureInfo = struct {
                index: Index = .undefined,
                tex_coord: u8 = 0,
            };

            pub const PbrMetallicRoughness = struct {
                base_color_factor: [4]f32 = .{ 1.0, 1.0, 1.0, 1.0 },
                base_color_texture: ?TextureInfo = null,

                metallic_factor: f32 = 1.0,
                roughness_factor: f32 = 1.0,
                metallic_roughness_texture: ?TextureInfo = null,
            };

            pub const AlphaMode = enum {
                pub const lookup = std.StaticStringMap(AlphaMode).initComptime(.{
                    .{ "OPAQUE", .@"opaque" },
                    .{ "MASK", .mask },
                    .{ "BLEND", .blend },
                });

                @"opaque",
                mask,
                blend,
            };

            const Name = if (config.include_name_in.material) []const u8 else void;
            const name_default = if (config.include_name_in.material) &.{} else {};

            name: Name = name_default,
            pbr_metallic_roughness: PbrMetallicRoughness = .{},

            normal_texture: ?TextureInfo = null,

            occlusion_texture: ?TextureInfo = null,

            emissive_factor: [3]f32 = .{ 0.0, 0.0, 0.0 },
            emissive_texture: ?TextureInfo = null,

            double_sides: bool = false,

            alpha_mode: AlphaMode = .@"opaque",
            alpha_cutoff: f32 = 0.5,

            extensions: config.extensions.material = .{},
        };

        pub const Texture = struct {
            const Name = if (config.include_name_in.texture) []const u8 else void;
            const name_default = if (config.include_name_in.texture) &.{} else {};

            name: Name = name_default,
            sampler: NullableIndex = .null,
            source: Index = .undefined,
            extensions: config.extensions.texture = .{},
        };

        pub const Image = struct {
            const Name = if (config.include_name_in.image) []const u8 else void;
            const name_default = if (config.include_name_in.image) &.{} else {};

            name: Name = name_default,
            uri: []const u8 = &.{},
            buffer_view: Index = .undefined,
            mime_type: []const u8 = &.{},
            extensions: config.extensions.image = .{},
        };

        pub const Sampler = struct {
            pub const Filter = enum(u16) {
                undefined = 0xffff,
                nearest = 9728,
                linear = 9729,
                nearest_mipmap_nearest = 9984,
                linear_mipmap_nearest = 9985,
                nearest_mipmap_linear = 9986,
                linear_mipmap_linear = 9987,
                _,
            };

            pub const Wrapping = enum(u16) {
                clamp_to_edge = 33071,
                mirrored_repeat = 33648,
                repeat = 10497,
                _,
            };

            const Name = if (config.include_name_in.sampler) []const u8 else void;
            const name_default = if (config.include_name_in.sampler) &.{} else {};

            name: Name = name_default,
            mag_filter: Filter = .undefined,
            min_filter: Filter = .undefined,
            wrap_s: Wrapping = .repeat,
            wrap_t: Wrapping = .repeat,

            extensions: config.extensions.sampler = .{},
        };

        pub const Camera = struct {
            pub const Type = enum {
                perspective,
                orthographic,
            };

            pub const Info = union {
                perspective: struct {
                    aspect_ratio: ?f32 = null,
                    yfov: f32 = undefined,
                    zfar: ?f32 = null,
                    znear: f32 = undefined,
                },
                orthographic: struct {
                    xmag: f32 = undefined,
                    ymag: f32 = undefined,
                    zfar: f32 = undefined,
                    znear: f32 = undefined,
                },
            };

            const Name = if (config.include_name_in.camera) []const u8 else void;
            const name_default = if (config.include_name_in.camera) &.{} else {};

            name: Name = name_default,
            type: Type = undefined,
            info: Info = undefined,

            extensions: config.extensions.camera = .{},
        };

        pub const Scene = struct {
            const Name = if (config.include_name_in.scene) []const u8 else void;
            const name_default = if (config.include_name_in.scene) &.{} else {};

            name: Name = name_default,
            nodes: []const u32 = &.{},
            extensions: config.extensions.scene = .{},
        };

        pub const Node = struct {
            const Name = if (config.include_name_in.node) []const u8 else void;
            const name_default = if (config.include_name_in.node) &.{} else {};

            name: Name = name_default,
            mesh: NullableIndex = .null,
            skins: NullableIndex = .null,
            translation: [3]f32 = .{ 0.0, 0.0, 0.0 },
            rotation: [4]f32 = .{ 0.0, 0.0, 0.0, 1.0 },
            scale: [3]f32 = .{ 1.0, 1.0, 1.0 },
            matrix: [16]f32 = .{ 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0 },
            children: []const u32 = &.{},
            extensions: config.extensions.node = .{},
        };

        const Cameras = if (config.include.scenes and config.include.cameras) []const Camera else void;
        const default_cameras = if (config.include.scenes and config.include.cameras) &.{} else {};

        const Scenes = if (config.include.scenes) []const Scene else void;
        const default_scenes = if (config.include.scenes) &.{} else {};
        const Nodes = if (config.include.scenes) []const Node else void;
        const default_nodes = if (config.include.scenes) &.{} else {};

        buffers: []const Buffer = &.{},
        buffer_views: []const BufferView = &.{},
        accessors: []const Accessor = &.{},

        meshes: []const Mesh = &.{},

        materials: []const Material = &.{},
        textures: []const Texture = &.{},
        images: []const Image = &.{},
        samplers: []const Sampler = &.{},

        cameras: Cameras = default_cameras,

        scene: if (config.include.scenes) NullableIndex else void = if (config.include.scenes) .null else {},
        scenes: Scenes = default_scenes,
        nodes: Nodes = default_nodes,

        extensions: config.extensions.top_level = .{},
        extensions_used: []const []const u8 = &.{},
        extensions_required: []const []const u8 = &.{},
    };
}
