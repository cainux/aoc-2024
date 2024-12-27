local file = io.open("input-test.txt", "r")

if not file then
    print "File not found"
    return
end

local content = file:read "*a"

file:close()

local function dump(g)
    for y = 1, #g do
        print(table.concat(g[y]))
    end
    print()
end

local function load(input)
    local grid = {}
    local s = {}
    local e = {}

    local y = 1
    for line in input:gmatch "[^\r\n]+" do
        table.insert(grid, {})
        local x = 1
        for char in line:gmatch "." do
            table.insert(grid[#grid], char)
            if char == "S" then
                s = { facing = "e", x = x, y = y }
            elseif char == "E" then
                e = { x = x, y = y }
            end
            x = x + 1
        end
        y = y + 1
    end
    return grid, s, e
end

local function ahead(grid, current)
    local x, y = current.x, current.y
    if current.facing == "n" then
        y = y - 1
    elseif current.facing == "s" then
        y = y + 1
    elseif current.facing == "e" then
        x = x + 1
    elseif current.facing == "w" then
        x = x - 1
    end
    return grid[y][x]
end

local function search(grid, current, history)
    local moves = {
        "cw",
        "ccw",
        "f",
    }

    local next = ahead(grid, current)

    if next == "E" then
        return path
    end

    if next == "#" then
        return false
    end


end

-- Solve
local grid, s, e = load(content)
dump(grid)
print(s.facing, s.x, s.y, e.x, e.y)
