local file = io.open("input.txt", "r")

if file == nil then
    print "oops"
    return
end

local content = file:read "*a"
file:close()

local grid = {}

for line in content:gmatch "[^\r\n]+" do
    table.insert(grid, {})
    for char in line:gmatch "." do
        table.insert(grid[#grid], char)
    end
end

local guard = {
    x = 0,
    y = 0,
    direction = "^", -- ^ v < >
}

-- find ^ in the grid
for y = 1, #grid do
    for x = 1, #grid[y] do
        if grid[y][x] == "^" then
            guard.x = x
            guard.y = y
            break
        end
    end
end

local turn_right = {
    ["^"] = ">",
    [">"] = "v",
    ["v"] = "<",
    ["<"] = "^",
}

local function next_position()
    if guard.direction == "^" then
        return guard.x, guard.y - 1
    elseif guard.direction == "v" then
        return guard.x, guard.y + 1
    elseif guard.direction == "<" then
        return guard.x - 1, guard.y
    elseif guard.direction == ">" then
        return guard.x + 1, guard.y
    end
end

local function within_bounds(x, y) return 1 <= x and x <= #grid[1] and 1 <= y and y <= #grid end

grid[guard.y][guard.x] = "X"
local counter = 1

while within_bounds(guard.x, guard.y) do
    if grid[guard.y][guard.x] == "." then
        grid[guard.y][guard.x] = "X"
        counter = counter + 1
    end
    local x, y = next_position()
    if within_bounds(x, y) and grid[y][x] == "#" then
        guard.direction = turn_right[guard.direction]
    else
        guard.x = x
        guard.y = y
    end
end

for y = 1, #grid do
    print(table.concat(grid[y]))
end

print(counter)
