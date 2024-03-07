--!strict
-- KalValue.luau: typing for KalValue

export type KalValueImpl = {
    __index: KalValueImpl,
    new: (value: string | number) -> KalValueType,
}

export type KalValueType = typeof(setmetatable({} :: {
    val: string | number,
    length: number
}, {} :: KalValueImpl))

local KalValue: KalValueImpl = {} :: KalValueImpl
KalValue.__index = KalValue

function KalValue.new(value)
    local self = {}
    self.val = value
    self.length = tostring(value):len()

    return setmetatable(self, KalValue)
end


return KalValue