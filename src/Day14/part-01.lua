local file = io.open("single.txt", "r")

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

    for y = 0, max_y - 1 do
        local line = grid[y] or {}
        for x = 0, max_x - 1 do
            io.write(line[x] or ".")
        end
        io.write "\n"
    end

    print()
end

local function move(robots)
    for _, robot in ipairs(robots) do
        robot.px = robot.px + robot.vx
        robot.py = robot.py + robot.vy

        -- If the robot has moved out of max_x or max_y then teleport
        while robot.px < 0 do
            robot.px = robot.px + max_x
        end

        while robot.px > max_x do
            robot.px = robot.px - max_x
        end

        while robot.py < 0 do
            robot.py = robot.py + max_y
        end

        while robot.py > max_y do
            robot.py = robot.py - max_y
        end
    end
end

-- Solve
local robots = load(file:lines())
file:close()

print_grid(robots)

for i = 1, 5 do
    move(robots)
    print("After " .. i .. " seconds:")
    print_grid(robots)
end
