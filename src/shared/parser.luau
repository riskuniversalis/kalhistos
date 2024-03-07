--!strict
-- parser.luau - parses a list of Tokens into a syntax tree

local Token = require(script.Parent.types.tokens)
local KalNode = require(script.Parent.types.KalNode)
local lexer = require(script.Parent.lexer)

local function computeDepth(root: KalNode.KalNodeType)
    local end_file_line = root.fileLine
    for _, child in ipairs(root.children) do
        child.parent = root
        child.depth = root.depth + 1
        if child.type and child.type.val then
            local val = tostring(child.type.val)
            child.fileStart = root.fileEnd
            child.fileEnd = child.fileStart + #val - 1
            end_file_line = child.fileEnd
        end

        computeDepth(child)
    end

    root.fileEnd = end_file_line
end

local function generate(tokens: {Token.KalToken}, root: KalNode.KalNodeType): KalNode.KalNodeType
    local current_pos = root.fileStart
    local stack = {}  -- Keep track of the current_pos for nested expressions

    while #tokens > 0 do
        local token = table.remove(tokens, 1)
        if not token then break end
        local node: KalNode.KalNodeType | nil = nil
        local tokenType = Token.getTokenType(token)
        local tokenValue = tostring(token.val or "")

        if tokenType == "Numeric Token" or tokenType == "Symbol Token" or tokenType == "String Token" then
            node = KalNode.new(token, current_pos, current_pos + #tokenValue - 1, root.fileLine, 0, root)
            current_pos += #tokenValue
        elseif tokenType == "Newline Token" then
            root.fileLine += 1
            node = KalNode.new(token, current_pos, current_pos, root.fileLine, 0, root)
            current_pos += 1
        elseif tokenType == "Left Bracket Token" then
            table.insert(stack, current_pos)  -- Save the current_pos on the stack
            node = generate(tokens, KalNode.new(nil, current_pos, current_pos, root.fileLine, 0, nil))
            current_pos += 1  -- Increment current_pos for the left bracket
        elseif tokenType == "Right Bracket Token" then
            node = KalNode.new(token, current_pos, current_pos, root.fileLine, 0, root)
            current_pos += 1  -- Increment current_pos for the right bracket
            if #stack > 0 then
                local stack_remove = table.remove(stack)
                if not stack_remove then 
                    print(stack_remove) 
                    break
                end
                current_pos = stack_remove  -- Restore the current_pos from the stack
            else
                break
            end
        else
            error("Unknown token: " .. tostring(tokenType))
        end

        if node ~= nil then
            root:addChild(node)
        end
    end

    root.fileEnd = current_pos - 1

    return root
end

local function parser(code: string): KalNode.KalNodeType
    --[[TODO: make the node positions correct. tried a few things but its like 2am so I'm running out of brainpower]]
    local tokens = lexer(code)
    local start = KalNode.new(nil, 0, 0, 1, 0, nil)
    local root = generate(tokens, start)
    computeDepth(root)
    return root
end

return parser