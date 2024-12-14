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

local function is_in(plots, pos)
    for _, p in ipairs(plots) do
        if p.x == pos.x and p.y == pos.y then
            return true
        end
    end
    return false
end

local function score_region(region)
    local corners = 0

    for _, p in ipairs(region) do
        local x, y = p.x, p.y
        local offsets = {
            { 1, 1 },
            { 1, -1 },
            { -1, 1 },
            { -1, -1 },
        }
        for _, offset in ipairs(offsets) do
            local x_offset, y_offset = offset[1], offset[2]
            local x_neighbour = { x = x + x_offset, y = y }
            local y_neighbour = { x = x, y = y + y_offset }
            local diagonal_neighbour = { x = x + x_offset, y = y + y_offset }

            if not is_in(region, x_neighbour) and not is_in(region, y_neighbour) then
                corners = corners + 1
            elseif is_in(region, x_neighbour) and is_in(region, y_neighbour) and not is_in(region, diagonal_neighbour) then
                corners = corners + 1
            end
        end
    end

    return #region * corners
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
        score = score + score_region(r)
    end

    print(score)
end

-- solve
local grid, plots = load(content)
score_grid(grid, plots)
