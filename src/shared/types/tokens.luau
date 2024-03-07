--!strict
-- tokens.luau - types explicitly for tokens 
local KalValue = require(script.Parent.KalValue)

export type KalToken = {
    val: nil | KalValue.KalValueType,
    typename: string
}

local mod = {}
-- Function to check if a value is a KalToken
local function isToken(value: any): boolean
    -- Check if the value has a 'typename' field that ends with "token"
    return typeof(value) == "table" and typeof(value.typename) == "string" and value.typename:match("token$") ~= nil
end
--[[ 
    
Function to create a new node

Possible KalToken types:

"nutoken" (Numeric Token)

"sttoken" (String Token)

"sytoken" (Symbol Token)

"qutoken" (Quote Token)

"lbtoken" (Left Bracket Token)

"rbtoken" (Right Bracket Token)

"nltoken" (Newline Token)

"basetoken" (Base Token)

]]
local function createToken(value: string | number | nil, typename: string): KalToken
    if value then
        if typename == "nutoken" then
            return { val = KalValue.new(value), typename = "nutoken" }
        elseif typename == "sttoken" then
            return { val = KalValue.new(value), typename = "sttoken" }
        elseif typename == "sytoken" then
            return { val = KalValue.new(value), typename = "sytoken" }
        else
            error("Invalid token type: " .. typename)
        end
    else
        if typename == "qutoken" then
            return { val = nil, typename = "qutoken" }
        elseif typename == "lbtoken" then
            return { val = nil, typename = "lbtoken" }
        elseif typename == "rbtoken" then
            return { val = nil, typename = "rbtoken" }
        elseif typename == "nltoken" then
            return { val = nil, typename = "nltoken" }
        elseif typename == "basetoken" then
            return { val = nil, typename = "basetoken" }
        else
            error("Invalid token type: " .. typename)
        end
    end
end
-- Function to get the type of a node
local function getTokenType(node: KalToken): string
    if node.typename == "nutoken" then
        return "Numeric Token"
    elseif node.typename == "sttoken" then
        return "String Token"
    elseif node.typename == "sytoken" then
        return "Symbol Token"
    elseif node.typename == "qutoken" then
        return "Quote Token"
    elseif node.typename == "lbtoken" then
        return "Left Bracket Token"
    elseif node.typename == "rbtoken" then
        return "Right Bracket Token"
    elseif node.typename == "nltoken" then
        return "Newline Token"
    elseif node.typename == "basetoken" then
        return "Base Token"
    else
        error("Invalid token type: " .. node.typename)
    end
end
mod["isToken"] = isToken
mod["createToken"] = createToken
mod["getTokenType"] = getTokenType
return mod