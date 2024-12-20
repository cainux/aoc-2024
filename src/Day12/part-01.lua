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
            table.insert(grid[#grid], { x = x, y = y, plot = char })
            table.insert(plots, { x = x, y = y, plot = char })
            x = x + 1
        end
        y = y + 1
    end
    return grid, plots
end

local function char_at(g, x, y) return g[y][x].plot end

local function surrounding_plots(g, x, y)
    local max_x, max_y = #g[1], #g
    local nesw = {
        { x = x, y = y - 1 },
        { x = x, y = y + 1 },
        { x = x - 1, y = y },
        { x = x + 1, y = y },
    }
    local plots = {}
    for _, p in ipairs(nesw) do
        if p.x > 0 and p.x <= max_x and p.y > 0 and p.y <= max_y then
            table.insert(plots, g[p.y][p.x])
        end
    end
    return plots
end

local function is_in(plots, plot)
    for _, p in ipairs(plots) do
        if p.x == plot.x and p.y == plot.y then
            return true
        end
    end
    return false
end

local function score_grid(grid, plots)
    local regions = {}

    while #plots > 0 do
        local region = {}
        local queue = {}
        local curr = table.remove(plots, 1)
        table.insert(queue, curr)

        while #queue > 0 do
            local p = table.remove(queue, 1)
            local surr = surrounding_plots(grid, p.x, p.y)
            for _, s in ipairs(surr) do
                if is_in(plots, s) and s.plot == p.plot then
                    table.insert(region, s)
                    table.insert(queue, s)
                    for i, q in ipairs(plots) do
                        if s.x == q.x and s.y == q.y then
                            table.remove(plots, i)
                            break
                        end
                    end
                end
            end
        end

        table.insert(regions, region)
    end

    print(#regions)
end

-- solve
local grid, plots = load(content)
-- print_grid(grid)
score_grid(grid, plots)
