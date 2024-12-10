local file = io.open("input.txt", "r")

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

local function score_trailhead(grid, start_x, start_y)
    local max_x = #grid
    local max_y = #grid[1]
    local stack = {}
    local score = 0

    table.insert(stack, { x = start_x, y = start_y })

    while #stack > 0 do
        local curr = table.remove(stack)
        local curr_height = tonumber(char_at(grid, curr.x, curr.y))
        if curr_height == 9 then
            score = score + 1
        else
            local nesw = {
                { x = curr.x, y = curr.y - 1 },
                { x = curr.x, y = curr.y + 1 },
                { x = curr.x - 1, y = curr.y },
                { x = curr.x + 1, y = curr.y },
            }

            for _, dir in ipairs(nesw) do
                local x = dir.x
                local y = dir.y
                if x > 0 and x <= max_y and y > 0 and y <= max_x then
                    local height = tonumber(char_at(grid, x, y))
                    if height == curr_height + 1 then
                        table.insert(stack, { x = x, y = y })
                    end
                end
            end
        end
    end

    -- print("  score:", score)
    return score
end

local function score(grid)
    local result = 0
    for y = 1, #grid do
        for x = 1, #grid[y] do
            local height = char_at(grid, x, y)
            if height == "0" then
                -- print("trailhead:", x, y)
                result = result + score_trailhead(grid, x, y)
            end
        end
    end
    return result
end

--- Solve
local grid = load(content)
-- print_grid(grid)
print(score(grid))
