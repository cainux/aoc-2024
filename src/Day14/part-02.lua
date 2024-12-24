local file = io.open("input.txt", "r")
local max_x, max_y = 101, 103

if not file then
    print "File not found"
    os.exit()
end

local function load(lines)
    local robots = {}
    for line in lines do
        local px, py, vx, vy = line:match "p=(%d+),(%d+) v=([-]?%d+),([-]?%d+)"
        table.insert(robots, { px = tonumber(px), py = tonumber(py), vx = tonumber(vx), vy = tonumber(vy) })
    end
    return robots
end

local function print_grid(robots)
    local grid = {}

    for _, robot in ipairs(robots) do
        grid[robot.py] = grid[robot.py] or {}
        grid[robot.py][robot.px] = "x"
    end

    for y = 0, max_y - 1 do
        local line = grid[y] or {}
        for x = 0, max_x - 1 do
            io.write(line[x] or " ")
        end
        io.write "\n"
    end

    print()
end

local function move(robots)
    for _, robot in ipairs(robots) do
        robot.px = robot.px + robot.vx
        robot.py = robot.py + robot.vy

        -- If the robot has moved out of the grid bounday then teleport
        while robot.px < 0 do
            robot.px = robot.px + max_x
        end

        while robot.px >= max_x do
            robot.px = robot.px - max_x
        end

        while robot.py < 0 do
            robot.py = robot.py + max_y
        end

        while robot.py >= max_y do
            robot.py = robot.py - max_y
        end
    end
end

-- Solve (output the lot then grep/search for a row of letters)
local robots = load(file:lines())
file:close()

local i = 1
while i < 10000 do
    move(robots)
    print("seconds: " .. i)
    print_grid(robots)
    i = i + 1
end
