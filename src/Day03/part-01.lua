local file = io.open("input.txt", "r")

if file == nil then
    print "error opening file"
    os.exit(1)
end

function Matches(inputstr, expression)
    local matches = {}
    for match in inputstr:gmatch(expression) do
        table.insert(matches, match)
    end
    return matches[1], matches[2]
end

local input = file:read "a"
local acc = 0

for mul in input:gmatch "mul%(%d+,%d+%)" do
    local l, r = Matches(mul, "%d+")
    acc = acc + (tonumber(l) * tonumber(r))
end

print(acc)
