local rex = require "rex_pcre2"
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
local doThing = true
local acc = 0

for match in rex.gmatch(input, "mul\\([\\d,]+?\\)|do\\(\\)|don't\\(\\)") do
    if match == "do()" then
        doThing = true
    elseif match == "don't()" then
        doThing = false
    else
        if doThing then
            local l, r = Matches(match, "%d+")
            acc = acc + (tonumber(l) * tonumber(r))
        end
    end
end

print(acc)
