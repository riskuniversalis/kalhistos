local rs = game:GetService("ReplicatedStorage")
local lexer = require(rs.Shared.lexer)
local Token = require(rs.Shared.types.tokens)

local function prettyPrintTokens(tokens)
    local result = ""
    for i, token in ipairs(tokens) do
        local tokenType = Token.getTokenType(token)
        local tokenValue = if token.val then token.val.val else "nil"
        result = result .. string.format("%d. %s: %s\n", i, tokenType, tostring(tokenValue))
    end
    return result
end

print(prettyPrintTokens(lexer("(test 123.456 (func) \"abc\")\n(newline)")))
