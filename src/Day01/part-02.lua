local file = io.open("input.txt", "r")

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
