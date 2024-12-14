local file = io.open("input.txt", "r")

if not file then
    print "File not found"
    return
end

local content = file:read "*a"

file:close()

--- Helpers
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

local function surrounding_positions(g, x, y)
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
        else
            table.insert(plots, { x = p.x, y = p.y, plot = " " })
        end
    end
    return plots
end

local function score_region(g, region)
    local perim = {}
    for _, p in ipairs(region) do
        local surr = surrounding_positions(g, p.x, p.y)
        for _, s in ipairs(surr) do
            if not is_in(region, s) then
                table.insert(perim, s)
            end
        end
    end

    return #region * #perim
end

local function score_grid(g, plots)
    local regions = {}

    while #plots > 0 do
        local region = {}
        local queue = {}
        table.insert(queue, table.remove(plots, 1))

        while #queue > 0 do
            local p = table.remove(queue, 1)
            table.insert(region, p) -- if it is in the queue then it belongs to the region
            local surr = surrounding_plots(g, p.x, p.y)
            for _, s in ipairs(surr) do
                if is_in(plots, s) and s.plot == p.plot then
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

    local score = 0

    for _, r in ipairs(regions) do
        score = score + score_region(g, r)
    end

    print(score)
end

-- solve
local grid, plots = load(content)
score_grid(grid, plots)
