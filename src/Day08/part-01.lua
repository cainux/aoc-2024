local file = io.open("input.txt", "r")

if file == nil then
    print "oops"
    return
end

local content = file:read "*a"

file:close()

--
-- Helper Functions
--
local function char_at(g, x, y) return g[y][x] end

local function dump(g)
    for y = 1, #g do
        print(table.concat(g[y]))
    end
    print()
end

local function in_bounds(g, x, y) return y > 0 and y <= #g and x > 0 and x <= #g[1] end

local function matching_antennas(antennas, a)
    local matches = {}
    for _, aa in ipairs(antennas) do
        if aa.frequency == a.frequency and aa.x ~= a.x and aa.y ~= a.y then
            table.insert(matches, aa)
        end
    end
    return matches
end

local function antinode(a1, a2)
    local dx = math.abs(a1.x - a2.x)
    local dy = math.abs(a1.y - a2.y)
    local x = a1.x < a2.x and a2.x + dx or a2.x - dx
    local y = a1.y < a2.y and a2.y + dy or a2.y - dy

    return x, y
end

--
-- Solve
--
local grid = {}
local antennas = {}

for line in content:gmatch "[^\r\n]+" do
    table.insert(grid, {})
    for char in line:gmatch "." do
        table.insert(grid[#grid], char)
    end
end

-- walk the grid
for y = 1, #grid do
    for x = 1, #grid[y] do
        local pos = char_at(grid, x, y)
        if pos ~= "." then
            table.insert(antennas, { frequency = pos, x = x, y = y })
        end
    end
end

dump(grid)

-- for each antenna
for _, antenna in ipairs(antennas) do
    -- for each matching antenna
    for _, m in ipairs(matching_antennas(antennas, antenna)) do
        -- find the antinode
        local x, y = antinode(antenna, m)

        -- mark it on the grid
        if in_bounds(grid, x, y) and char_at(grid, x, y) ~= "#" then
            grid[y][x] = "#"
        end
    end
end

dump(grid)

-- count the number of positions marked "#"
local count = 0

for y = 1, #grid do
    for x = 1, #grid[y] do
        local pos = char_at(grid, x, y)
        if pos == "#" then
            count = count + 1
        end
    end
end

print(count)
