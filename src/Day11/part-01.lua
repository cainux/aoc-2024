local function dump(input)
    print(table.concat(input, ", "))
    print()
end

local function blink(input, count)
    if count == 0 then
        return input
    end

    local new = {}

    for _, v in ipairs(input) do
        if v == 0 then
            table.insert(new, 1)
        elseif tostring(v):len() % 2 == 0 then
            local s = tostring(v)
            local len = #s
            local mid = len // 2
            local left = s:sub(1, mid)
            local right = s:sub(mid + 1, len)
            table.insert(new, tonumber(left))
            table.insert(new, tonumber(right))
        else
            table.insert(new, v * 2024)
        end
    end

    return blink(new, count - 1)
end

-- local input = { 125, 17 }
local input = { 5178527, 8525, 22, 376299, 3, 69312, 0, 275, }

-- dump(input)
local result = blink(input, 25)
print(#result)
