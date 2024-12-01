local utils = {}

function utils.loadInput(filename)
	local file = io.open(filename, "r")

	if not file then
		print("Error opening file")
		os.exit(1)
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

	return left, right
end

return utils
