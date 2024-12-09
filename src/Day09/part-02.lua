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

local function first_big_enough_gap_index(diskmap, fpos, length)
    for i = 1, fpos - 1 do
        if diskmap[i].id == "." and diskmap[i].length >= length then
            return i
        end
    end
    return nil
end

local function swap(diskmap, pos1, pos2)
    local tmp = diskmap[pos1]
    diskmap[pos1] = diskmap[pos2]
    diskmap[pos2] = tmp
end

local function compact(diskmap)
    for fpos = #diskmap, 1, -1 do
        if diskmap[fpos].id ~= "." then
            local gpos = first_big_enough_gap_index(diskmap, fpos, diskmap[fpos].length)
            if gpos then
                local f = diskmap[fpos]
                local g = diskmap[gpos]
                if g.length == f.length then
                    swap(diskmap, fpos, gpos)
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
        else
            blockpos = blockpos + p.length
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
