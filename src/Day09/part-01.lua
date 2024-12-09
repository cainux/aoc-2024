local file = io.open("input.txt", "r")

if not file then
    print "File not found"
    return
end

local input = file:read "l"

file:close()

---
--- Helper Functions
---
local function load(content)
    local diskmap = {}
    local file_id = 0
    local is_file = true

    for c in content:gmatch "." do
        table.insert(diskmap, {
            id = is_file and file_id or ".",
            length = tonumber(c),
        })
        if is_file then
            file_id = file_id + 1
        end
        is_file = not is_file
    end

    return diskmap
end

local function last_file_index(diskmap)
    for i = #diskmap, 1, -1 do
        if diskmap[i].id ~= "." then
            return i
        end
    end
    print "Should not reach here!"
    os.exit(1)
end

local function first_gap_index(diskmap)
    for i = 1, #diskmap do
        if diskmap[i].id == "." and diskmap[i].length > 0 then
            return i
        end
    end
    print "Should not reach here!"
    os.exit(1)
end

local function has_gap(diskmap)
    local last_file = last_file_index(diskmap)
    for i = last_file - 1, 1, -1 do
        if diskmap[i].id == "." and diskmap[i].length > 0 then
            return true
        end
    end
    return false
end

local function swap(diskmap, pos1, pos2)
    local tmp = diskmap[pos1]
    diskmap[pos1] = diskmap[pos2]
    diskmap[pos2] = tmp
end

local function compact(diskmap)
    while has_gap(diskmap) do
        local fpos = last_file_index(diskmap)
        local gpos = first_gap_index(diskmap)
        local f = diskmap[fpos]
        local g = diskmap[gpos]

        if g.length == f.length then
            swap(diskmap, fpos, gpos)
        elseif g.length < f.length then
            local dl = f.length - g.length
            local new_f = {
                id = f.id,
                length = dl,
            }
            f.length = g.length
            swap(diskmap, fpos, gpos)
            table.insert(diskmap, fpos, new_f)
        else
            local dl = g.length - f.length
            local new_g = {
                id = g.id,
                length = dl,
            }
            g.length = f.length
            swap(diskmap, fpos, gpos)
            table.insert(diskmap, gpos + 1, new_g)
        end
    end
end

local function checksum(diskmap)
    local blockpos = 0
    local result = 0
    for _, p in ipairs(diskmap) do
        if p.id ~= "." then
            for _ = 1, p.length do
                result = result + (blockpos * p.id)
                blockpos = blockpos + 1
            end
        end
    end
    return result
end

---
--- Solve
---
local diskmap = load(input)
compact(diskmap)
print(checksum(diskmap))
