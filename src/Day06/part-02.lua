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

local start_x, start_y

-- find ^ in the grid
for y = 1, #grid do
    for x = 1, #grid[y] do
        if grid[y][x] == "^" then
            start_x = x
            start_y = y
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

local function contains(t, o)
    for _, r in ipairs(t) do
        if r.x == o.x and r.y == o.y then
            return true
        end
    end
    return false
end

local function within_bounds(x, y) return 1 <= x and x <= #grid[1] and 1 <= y and y <= #grid end

guard.x = start_x
guard.y = start_y

local xes = {}

while within_bounds(guard.x, guard.y) do
    if grid[guard.y][guard.x] == "." then
        if not contains(xes, { x = guard.x, y = guard.y }) then
            table.insert(xes, { x = guard.x, y = guard.y })
        end
    end
    local next_x, next_y = next_position()
    if within_bounds(next_x, next_y) and grid[next_y][next_x] == "#" then
        guard.direction = turn_right[guard.direction]
    else
        guard.x = next_x
        guard.y = next_y
    end
end

local function visited(path, x, y, direction)
    for _, p in ipairs(path) do
        if p.x == x and p.y == y and p.direction == direction then
            return true
        end
    end
    return false
end

local count = 0

for _, O in ipairs(xes) do
    local Ox, Oy = O.x, O.y
    grid[Oy][Ox] = "O"

    local history = {}
    guard.direction = "^"
    guard.x = start_x
    guard.y = start_y

    while within_bounds(guard.x, guard.y) do
        table.insert(history, { x = guard.x, y = guard.y, direction = guard.direction })

        local next_x, next_y = next_position()

        if visited(history, next_x, next_y, guard.direction) then
            count = count + 1
            break
        elseif within_bounds(next_x, next_y) and (grid[next_y][next_x] == "#" or grid[next_y][next_x] == "O") then
            guard.direction = turn_right[guard.direction]
        else
            guard.x = next_x
            guard.y = next_y
        end
    end

    grid[Oy][Ox] = "."
end

print(count)
