local file = io.open("input.txt", "r")

if file == nil then
    print "oops"
    return
end

local function split(str)
    local t = {}
    for s in str:gmatch "([^,]+)" do
        table.insert(t, s)
    end
    return t
end

local rules = {}
local updates = {}

for line in file:lines() do
    if line:find "|" then
        local l, r = line:match "(%d+)|(%d+)"
        local ln, rn = tonumber(l), tonumber(r)
        table.insert(rules, { ln, rn })
    elseif line:find "," then
        local t = split(line)
        table.insert(updates, t)
    end
end

file:close()

local result = 0

for _, update in ipairs(updates) do
    local correct = true
    for i = 1, #update - 1 do
        if not correct then
            break
        end
        local l, r = tonumber(update[i]), tonumber(update[i + 1])
        for _, rule in ipairs(rules) do
            if rule[2] == l and rule[1] == r then
                correct = false
                break
            end
        end
    end
    if correct then
        local middle_value = tonumber(update[math.ceil(#update / 2)])
        result = result + middle_value
    end
end

print(result)
