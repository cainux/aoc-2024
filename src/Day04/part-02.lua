local file = io.open("input.txt", "r")

if file == nil then
    print "oops"
    return
end

local content = file:read "*a"
file:close()

local grid = {}

for line in content:gmatch "[^\r\n]+" do
    table.insert(grid, {})
    for char in line:gmatch "." do
        table.insert(grid[#grid], char)
    end
end

local rows = #grid
local cols = #grid[1]
local count = 0

for y = 2, rows - 1 do
    for x = 2, cols - 1 do
        if grid[y][x] == "A" then
            local tl = grid[y - 1][x - 1]
            local tr = grid[y - 1][x + 1]
            local bl = grid[y + 1][x - 1]
            local br = grid[y + 1][x + 1]
            local tlbr = tl .. "A" .. br
            local trbl = tr .. "A" .. bl
            if (tlbr == "MAS" or tlbr == "SAM") and (trbl == "MAS" or trbl == "SAM") then
                count = count + 1
            end
        end
    end
end

print(count)
