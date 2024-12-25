local file = io.open("input.txt", "r")

if not file then
    print "File not found"
    return
end

local content = file:read "*a"

file:close()

local function print_world(world, max_x, max_y)
    for y = 1, max_y do
        for x = 1, max_x do
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
                elseif char == "O" then
                    table.insert(world, { type = char, x = x, y = y })
                elseif char == "@" then
                    robot = { type = char, x = x, y = y }
                    table.insert(world, robot)
                end
                x = x + 1
            end
            y = y + 1
        else
            instructions = instructions .. line
        end
    end

    return world, robot, instructions, max_x, max_y
end

local function object_at(world, x, y)
    for _, item in ipairs(world) do
        if item.x == x and item.y == y then
            return item
        end
    end
    return nil
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
    local boxes = {}

    while object do
        table.insert(boxes, object)
        object = object_at(world, object.x + dx, object.y + dy)
        if object and object.type == "#" then
            return
        end
    end

    -- if there is a space, move the boxes
    for _, box in ipairs(boxes) do
        box.x = box.x + dx
        box.y = box.y + dy
    end

    -- then move the robot
    robot.x = robot.x + dx
    robot.y = robot.y + dy
end

local function process(world, robot, instructions)
    for char in instructions:gmatch "." do
        if char == "<" then
            move(world, robot, -1, 0)
        elseif char == ">" then
            move(world, robot, 1, 0)
        elseif char == "^" then
            move(world, robot, 0, -1)
        elseif char == "v" then
            move(world, robot, 0, 1)
        end
    end
end

local function score_world(world)
    local score = 0
    for _, object in ipairs(world) do
        if object.type == "O" then
            score = score + (100 * (object.y - 1) + (object.x - 1))
        end
    end
    return score
end

-- Solve
local world, robot, instructions, max_x, max_y = load(content)

print_world(world, max_x, max_y)
process(world, robot, instructions)
print_world(world, max_x, max_y)
print(score_world(world))
