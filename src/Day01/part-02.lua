local utils = require("utils")
local left, right = utils.loadInput("input.txt")

local function countOccurrences(list, target)
	local count = 0
	for _, v in ipairs(list) do
		if v == target then
			count = count + 1
		end
	end
	return count
end

local acc = 0

for _, v in ipairs(left) do
	local occurrences = countOccurrences(right, v)
	acc = acc + (v * occurrences)
end

print(acc)
