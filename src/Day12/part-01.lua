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
    local plots = {}
    for y = 1, #grid do
        for x = 1, #grid[y] do
            table.insert(plots, { x = x, y = y, char = char_at(grid, x, y) })

            -- print(x, y, char_at(grid, x, y))
            --
            -- local nesw = {
            --     { x = x, y = y - 1 },
            --     { x = x, y = y + 1 },
            --     { x = x - 1, y = y },
            --     { x = x + 1, y = y },
            -- }
        end
    end
    -- Get all the plots into a list
    -- get the first plot in the list, start a new 'region'
    -- get all the plots around it, if they are the same char, add them to the region, remove them from the list
    -- get all the plots around the plots in the region, if they are the same char, add them to the region
    -- repeat until no more plots can be added to the region
    -- get the next plot in the list, start a new region
    -- repeat until all plots have been added to a region
end

-- solve
local grid = load(content)
print_grid(grid)
score(grid)
