-- local file = io.open("input-test-larger.txt", "r")
local file = io.open("input.txt", "r")
-- local file = io.open("sample.txt", "r")

if not file then
    print "File not found"
    return
end

local content = file:read "*a"

file:close()

local mx, my = 0, 0

local function print_world(world)
    for y = 1, my do
        for x = 1, mx do
            local found = false
            for _, item in ipairs(world) do
                if item.x == x and item.y == y then
                    io.write(item.type)
                    found = true
                    break
                end
            end
            if not found then
                io.write "."
            end
        end
        io.write "\n"
    end
    print()
end

local function load(input)
    local world = {}
    local robot = {}
    local instructions = ""
    local y = 1
    local max_x, max_y = 0, 0

    for line in input:gmatch "[^\r\n]+" do
        if line:match "^#" then
            max_y = y
            local x = 1
            for char in line:gmatch "." do
                max_x = x
                if char == "#" then
                    table.insert(world, { type = char, x = x, y = y })
                    table.insert(world, { type = char, x = x + 1, y = y })
                elseif char == "O" then
                    local l = { type = "[", x = x, y = y }
                    local r = { type = "]", x = x + 1, y = y }
                    -- link the 2...
                    l.sibling = r
                    r.sibling = l
                    table.insert(world, l)
                    table.insert(world, r)
                elseif char == "@" then
                    robot = { type = char, x = x, y = y }
                    table.insert(world, robot)
                end
                x = x + 2
            end
            y = y + 1
        else
            instructions = instructions .. line
        end
    end

    return world, robot, instructions, max_x + 1, max_y
end

local function object_at(world, x, y)
    for _, item in ipairs(world) do
        if item.x == x and item.y == y then
            return item
        end
    end
    return nil
end

local function contains(boxes, box)
    for _, b in ipairs(boxes) do
        if b == box or b.sibling == box then
            return true
        end
    end
    return false
end

local function move(world, robot, dx, dy)
    local object = object_at(world, robot.x + dx, robot.y + dy)

    -- Simplest case: if there is nothing, move
    if not object then
        robot.x = robot.x + dx
        robot.y = robot.y + dy
        return
    end

    -- Another simple case: if there is a wall, immediately stop
    if object and object.type == "#" then
        return
    end

    -- If there is a box, add it to a list
    -- then check along the direction until a space or wall
    -- if there is a wall, stop
    local boxes_to_move = {}
    local queue = {}

    table.insert(queue, object)

    while #queue > 0 do
        local box = table.remove(queue, 1)

        while box do
            if not box.sibling then
                print("invalid box: ", box.type, box.x, box.y)
                os.exit(1)
            end

            if not contains(boxes_to_move, box) then
                table.insert(boxes_to_move, box)
            end

            if dy == 0 then
                box = box.sibling
                box = object_at(world, box.x + dx, box.y + dy)
            elseif dx == 0 then
                local next_to_sibling = object_at(world, box.sibling.x + dx, box.sibling.y + dy)
                if next_to_sibling then
                    if next_to_sibling.type == "#" then
                        return
                    end
                end
                box = object_at(world, box.x + dx, box.y + dy)
                if (box and box ~= next_to_sibling and box.sibling ~= next_to_sibling) or (not box and next_to_sibling) then
                    table.insert(queue, next_to_sibling)
                end
            else
                print "invalid direction"
                os.exit(1)
            end

            if box and box.type == "#" then
                return
            end
        end
    end

    -- print("moving boxes: ", #boxes_to_move)
    -- if there is a space, move the boxes
    for _, box in ipairs(boxes_to_move) do
        box.x = box.x + dx
        box.y = box.y + dy

        local sibling = box.sibling

        sibling.x = sibling.x + dx
        sibling.y = sibling.y + dy
    end

    -- then move the robot
    robot.x = robot.x + dx
    robot.y = robot.y + dy
end

local function pause() _ = io.read() end

local function process(world, robot, instructions)
    -- print_world(world)
    for char in instructions:gmatch "." do
        -- print("move: " .. char)
        -- pause()
        if char == "<" then
            move(world, robot, -1, 0)
        elseif char == ">" then
            move(world, robot, 1, 0)
        elseif char == "^" then
            move(world, robot, 0, -1)
        elseif char == "v" then
            move(world, robot, 0, 1)
        end
        -- print_world(world)
    end
end

local function score_world(world)
    local score = 0
    for _, object in ipairs(world) do
        if object.type == "[" then
            local y = object.y - 1
            local x = object.x - 1
            -- print("score will be 100 * " .. y .. " + " .. x)

            score = score + (100 * y + x)
        end
    end
    return score
end

-- Solve
local world, robot, instructions, max_x, max_y = load(content)
mx = max_x
my = max_y

-- print_world(world)
process(world, robot, instructions)
print_world(world)
print(score_world(world))

-- the answer is not 1564455
