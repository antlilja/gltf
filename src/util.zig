pub const Index = enum(u32) {
    undefined = 0xffffffff,
    _,

    pub fn get(self: Index) u32 {
        return switch (self) {
            .undefined => unreachable,
            else => return @intFromEnum(self),
        };
    }
};

pub const NullableIndex = enum(u32) {
    null = 0xffffffff,
    _,

    pub fn getOrNull(self: NullableIndex) ?u32 {
        return switch (self) {
            .null => null,
            else => @intFromEnum(self),
        };
    }

    pub fn get(self: NullableIndex) u32 {
        return switch (self) {
            .null => unreachable,
            else => @intFromEnum(self),
        };
    }
};
