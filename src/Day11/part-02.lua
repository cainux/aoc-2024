local function to_key(input) return table.concat(input, ",") end

local function dump(input)
    print(to_key(input))
    print()
end

local cache = {}

local function f(v, step)
    local key = v .. "," .. step
    if cache[key] then
        return cache[key]
    end

    if step == 0 then
        return 1
    end

    if v == 0 then
        local c = f(1, step - 1)
        cache[key] = c
        return c
    elseif tostring(v):len() % 2 ~= 0 then
        local c = f(v * 2024, step - 1)
        cache[key] = c
        return c
    else
        local s = tostring(v)
        local len = #s
        local mid = len // 2
        local left, right = tonumber(s:sub(1, mid)), tonumber(s:sub(mid + 1, len))
        local c = f(left, step - 1) + f(right, step - 1)
        cache[key] = c
        return c
    end
end

local function blink(input, count)
    local result = 0
    for _, v in ipairs(input) do
        result = result + f(v, count)
    end
    return result
end

-- local input = { 125, 17 }
local input = { 5178527, 8525, 22, 376299, 3, 69312, 0, 275 }

dump(input)
local result = blink(input, 75)
print(result)
