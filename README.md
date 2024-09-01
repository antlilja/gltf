# zglTF

zgltf is a glTF loader written in Zig.

## Dependencies
zgltf only depends on Zig version [0.13](https://ziglang.org/download/0.13.0/release-notes.html)

## Loading a glTF scene from a .glb file
```zig
const zgltf = @import("zgltf");
const Gltf = zgltf.Gltf(.{});

const file = try std.fs.cwd().openFile("scene.glb", .{});

const gltf = try gltf.parseGlb(
    Gltf,
    file.reader(),
    allocator,
    tmp_allocator,
);

```

Note that buffers and images are not automatically loaded through uris.

## Disable glTF features
Features of glTF can be selectivly disabled to ignore that features JSON data.

```zig
const gltf = @import("gltf");
const Gltf = gltf.Gltf(.{
    .include = .{
        .cameras = false,
    },
    .include_name_in = .{
        .node = true,
    },
});
```

## Extensions
Extensions can be enabled by providing structs which will be used as the type for the `extensions` field inside the respective glTF types (i.e `Buffer`, `BufferView` etc.)

```zig
const zgltf = @import("zgltf");
const Gltf = zgltf.Gltf(.{
    .extensions = .{
        .buffer_view = struct {
            meshopt_compression: ?gltf.extensions.ExtMeshoptCompression = null,
        },
        .texture = struct {
            basisu: ?gltf.extensions.KhrTextureBasisu = null,
        },
    },
});
```

### Custom extensions
Custom extensions can also be loaded with this system, the only requirement is that the provided struct has default values for all fields and has a `name` declaration with the name that will appear in the JSON.

```zig
const zgltf = @import("zgltf");

pub const KhrTextureTransform = struct {
    pub const name = "KHR_texture_transform";

    offset: [2]f32 = .{ 0.0, 0.0 },
    rotation: f32 = 0.0,
    scale: [2]f32 = .{ 1.0, 1.0 },
    tex_coord: zgltf.Index = .undefined,
};

const Gltf = zgltf.Gltf(.{
    .extensions = .{
        .texture = struct {
            transform: ?KhrTextureTransform = null,
        },
    },
});
```

The following extensions currently have structs provided:
```
KHR_lights_punctual
KHR_texture_transform
KHR_texture_basisu
KHR_materials_emissive_strength
EXT_meshopt_compression
```
