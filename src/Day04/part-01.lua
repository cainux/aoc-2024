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

local word = "XMAS"
local wordlen = #word
local rows = #grid
local cols = #grid[1]
local count = 0

local directions = {
    { 1,  0 },
    { 0,  1 },
    { 1,  1 },
    { 1,  -1 },
    { -1, 0 },
    { 0,  -1 },
    { -1, -1 },
    { -1, 1 },
}

for y = 1, rows do
    for x = 1, cols do
        if grid[y][x] == word:sub(1, 1) then
            for _, dir in ipairs(directions) do
                local dx, dy = dir[1], dir[2]
                local found = true
                for k = 1, wordlen - 1 do
                    local xx = x + k * dx
                    local yy = y + k * dy
                    local l = word:sub(k + 1, k + 1)
                    if xx < 1 or xx > cols or yy < 1 or yy > rows or grid[yy][xx] ~= l then
                        found = false
                        break
                    end
                end
                if found then
                    count = count + 1
                end
            end
        end
    end
end

print(count)
