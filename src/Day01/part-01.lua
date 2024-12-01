local utils = require("utils")
local left, right = utils.loadInput("input.txt")

-- Now solve the puzzle
table.sort(left)
table.sort(right)

local acc = 0

for i = 1, #left do
	local delta = math.abs(left[i] - right[i])
	acc = acc + delta
end

print(acc)
