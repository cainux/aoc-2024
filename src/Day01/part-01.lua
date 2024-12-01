local file = io.open("input-test.txt", "r")

if not file then
    print("Error opening file")
    return
end

local left = {}
local right = {}

for line in file:lines() do
    local l, r = line:match("(%d+)%s+(%d+)")
    l, r = tonumber(l), tonumber(r)
    table.insert(left, l)
    table.insert(right, r)
end

file:close()

-- Now solve the puzzle
table.sort(left)
table.sort(right)

local acc = 0

for i = 1, #left do
    local delta = math.abs(left[i] - right[i])
    acc = acc + delta
end

print(acc)
