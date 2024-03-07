local rs = game:GetService("ReplicatedStorage")
local shared = rs.Shared
local lexer = require(shared.lexer)
local Token = require(shared.types.tokens)
local KalNode = require(shared.types.KalNode)
local parser = require(shared.parser)
local function prettyPrintNode(node: KalNode.KalNodeType, indent: number)
    local indentStr = string.rep(" ", indent)
    local tokenValue = node.type and node.type.val and node.type.val.val or "nil"
    local tokenType = node.type and Token.getTokenType(node.type) or "nil"
    print(indentStr .. "Node {")
    print(indentStr .. "  fileStart: " .. node.fileStart)
    print(indentStr .. "  fileEnd: " .. node.fileEnd)
    print(indentStr .. "  fileLine: " .. node.fileLine)
    print(indentStr .. "  depth: " .. node.depth)
    print(indentStr .. "  type: " .. tokenType)
    print(indentStr .. "  value: " .. tostring(tokenValue))
    print(indentStr .. "  children: {")
    for _, child in ipairs(node.children) do
        prettyPrintNode(child, indent + 4)
    end
    print(indentStr .. "  }")
    print(indentStr .. "}")
end

print(prettyPrintNode(parser("(test 123.456 (func) \"abc\")\n(newline)"), 0))
