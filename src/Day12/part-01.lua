local file = io.open("test.txt", "r")

if not file then
    print "File not found"
    return
end

local content = file:read "*a"

file:close()

--- Helpers
local function print_grid(grid)
    for y = 1, #grid do
        for x = 1, #grid[y] do
            io.write(grid[y][x])
        end
        io.write "\n"
    end
end

local function load(input)
    local grid = {}
    for line in input:gmatch "[^\r\n]+" do
        table.insert(grid, {})
        for char in line:gmatch "." do
            table.insert(grid[#grid], char)
        end
    end
    return grid
end

local function char_at(g, x, y) return g[y][x] end

local function score(grid)
    for y = 1, #grid do
        for x = 1, #grid[y] do
            print(x, y, char_at(grid, x, y))
        end
    end
end

-- solve
local grid = load(content)
print_grid(grid)
score(grid)
