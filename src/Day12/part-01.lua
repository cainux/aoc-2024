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
    local plots = {}
    local y = 1
    for line in input:gmatch "[^\r\n]+" do
        table.insert(grid, {})
        local x = 1
        for char in line:gmatch "." do
            table.insert(grid[#grid], char)
            table.insert(plots, { x = x, y = y, plot = char })
            x = x + 1
        end
        y = y + 1
    end
    return grid, plots
end

local function char_at(g, x, y) return g[y][x].plot end

local function score(grid, plots)
    local regions = {}
    while #plots > 0 do
        local region = {}
        local plot = table.remove(plots, 1)
        table.insert(region, plot)
        local nesw = {
            { x = plot.x, y = plot.y - 1 },
            { x = plot.x, y = plot.y + 1 },
            { x = plot.x - 1, y = plot.y },
            { x = plot.x + 1, y = plot.y },
        }
        for _, p in ipairs(nesw) do
            if p.x < 1 or p.x > #grid[1] or p.y < 1 or p.y > #grid then
            else
                local c = char_at(grid, p.x, p.y)
                if c == plot.plot then
                    table.insert(region, { x = p.x, y = p.y, plot = c })
                    print(p.x .. p.y, c)
                end
            end
        end
        table.insert(regions, region)
    end

    print(#regions)

    -- for y = 1, #grid do
    --     for x = 1, #grid[y] do
    -- print(x, y, char_at(grid, x, y))
    --
    -- local nesw = {
    --     { x = x, y = y - 1 },
    --     { x = x, y = y + 1 },
    --     { x = x - 1, y = y },
    --     { x = x + 1, y = y },
    -- }
    --     end
    -- end
    -- Get all the plots into a list
    -- get the first plot in the list, start a new 'region'
    -- get all the plots around it, if they are the same char, add them to the region, remove them from the list
    -- get all the plots around the plots in the region, if they are the same char, add them to the region
    -- repeat until no more plots can be added to the region
    -- get the next plot in the list, start a new region
    -- repeat until all plots have been added to a region
end

-- solve
local grid, plots = load(content)
-- print_grid(grid)
score(grid, plots)
