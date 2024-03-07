--!strict
-- lexer.luau - converts a string to tokens

local Token = require(script.Parent.types.tokens)
type TokenType = Token.KalToken

local function lexer(code: string): {TokenType}
    local transformedCode: string = code:gsub("%(", " ( "):gsub("%)", " ) "):gsub("\"", " \" "):gsub("\n", " \n ")
    local splitCode: {string} = transformedCode:split(" ")
    local tokens: {TokenType} = {}

    local quoteMode: boolean = false
    local depth: number = 0
    local line: number = 1

    for _, word in ipairs(splitCode) do
        if quoteMode then
            if word == "\"" then
                quoteMode = false
            elseif #word > 0 then
                table.insert(tokens, Token.createToken(word, "sytoken"))
            end
        else
            if word == "[" then
                depth += 1
                table.insert(tokens, Token.createToken(nil, "lbtoken"))
            elseif word == "]" then
                depth -= 1
                table.insert(tokens, Token.createToken(nil, "rbtoken"))
            elseif word == "\"" then
                quoteMode = true
            elseif word == "\n" then
                line += 1
                table.insert(tokens, Token.createToken(nil, "nltoken"))
            else
                local num = tonumber(word)
                if num then
                    table.insert(tokens, Token.createToken(num, "nutoken"))
                elseif #word > 0 then
                    table.insert(tokens, Token.createToken(word, "sytoken"))
                end
            end
        end

        if depth < 0 then
            error("Bracket missing, error occured at line " .. line)
        end
    end

    if quoteMode then
        error("Missing quotes!")
    end

    return tokens
end

return lexer