local file = io.open("input.txt", "r")
-- local max_x, max_y = 11, 7
local max_x, max_y = 101, 103

if not file then
    print "File not found"
    os.exit()
end

local mid_x = (max_x - 1) // 2
local mid_y = (max_y - 1) // 2

local tl = { q = "tl", x1 = 0, y1 = 0, x2 = mid_x - 1, y2 = mid_y - 1 }
local tr = { q = "tr", x1 = mid_x + 1, y1 = 0, x2 = max_x - 1, y2 = mid_y - 1 }
local bl = { q = "bl", x1 = 0, y1 = mid_y + 1, x2 = mid_x - 1, y2 = max_y - 1 }
local br = { q = "br", x1 = mid_x + 1, y1 = mid_y + 1, x2 = max_x - 1, y2 = max_y - 1 }

local quadrants = { tl, tr, bl, br }

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

local function within(robot, x1, y1, x2, y2) return robot.px >= x1 and robot.px <= x2 and robot.py >= y1 and
    robot.py <= y2 end

-- Solve
local robots = load(file:lines())
file:close()

-- print_grid(robots)

for i = 1, 100 do
    move(robots)
    -- print("After " .. i .. " seconds:")
    -- print_grid(robots)
end

print_grid(robots)
local counts = {}

for _, q in ipairs(quadrants) do
    print("Checking " .. q.q .. " " .. q.x1 .. "," .. q.y1 .. " " .. q.x2 .. "," .. q.y2)
    local count = 0
    for _, robot in ipairs(robots) do
        if within(robot, q.x1, q.y1, q.x2, q.y2) then
            count = count + 1
        end
    end
    table.insert(counts, count)
    print(q.q .. " has " .. count .. " robots")
end

local result = 1

for _, count in ipairs(counts) do
    result = result * count
end

print("Result: " .. result)
