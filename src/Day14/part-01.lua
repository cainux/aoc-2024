local file = io.open("input-test.txt", "r")

if not file then
    print "File not found"
    os.exit()
end

local max_x, max_y = 11, 7

local function load(lines)
    local robots = {}
    for line in lines do
        local px, py, vx, vy = line:match "p=(%d+),(%d+) v=([-]?%d+),([-]?%d+)"
        -- print("p=" .. px .. "," .. py .. " v=" .. vx .. "," .. vy)
        table.insert(robots, { px = tonumber(px), py = tonumber(py), vx = tonumber(vx), vy = tonumber(vy) })
    end
    return robots
end

local function print_grid(robots)
    local grid = {}

    for _, robot in ipairs(robots) do
        grid[robot.py] = grid[robot.py] or {}
        grid[robot.py][robot.px] = "#"
    end

    for y = 0, max_y do
        local line = grid[y] or {}
        for x = 0, max_x do
            io.write(line[x] or ".")
        end
        io.write "\n"
    end
end

local robots = load(file:lines())
print_grid(robots)
