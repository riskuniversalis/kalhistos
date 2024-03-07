--!strict
-- KalNode.luau: KalNode implementation
local tokens = require(script.Parent.tokens)
type token = tokens.KalToken
export type KalNodeImpl = {
    __index: KalNodeImpl,
    new: (type: token| nil, fileStart: number, fileEnd: number,
          fileLine: number, depth: number, parent: KalNodeType | nil) -> KalNodeType,
    addChild: (self: KalNodeType, child: KalNodeType) -> ()
}

export type KalNodeType = typeof(setmetatable({} :: {
    fileStart: number,
    fileEnd: number,
    fileLine: number,
    depth: number,
    root: boolean,
    type: token | nil,
    parent: KalNodeType | nil,
    children: {KalNodeType}
}, {} :: KalNodeImpl))

local KalNode: KalNodeImpl = {} :: KalNodeImpl
KalNode.__index = KalNode

function KalNode.new(type, fileStart, fileEnd, fileLine, depth, parent)
    local self = {}
    self.fileStart = fileStart
    self.fileEnd = fileEnd
    self.fileLine = fileLine
    self.depth = depth
    self.parent = parent
    self.root = if parent == nil then true else false
    self.type = type
    self.children = {}

    return setmetatable(self, KalNode)
end

function KalNode:addChild(child)
    table.insert(self.children, child)
end



return KalNode