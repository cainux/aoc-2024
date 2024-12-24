local file = io.open("input.txt", "r")

if not file then
    print "File not found"
    os.exit()
end

local function load(lines)
    local machines = {}
    local machine = {}

    for line in lines do
        -- print(line)
        if line == "" then
            table.insert(machines, machine)
            machine = {}
        else
            local instruction, x, y = line:match "([%a%s]+): X.(%d+), Y.(%d+)"
            local part = "+"
            if instruction == "Prize" then
                part = "="
            end
            local parsed = instruction .. ": X" .. part .. x .. ", Y" .. part .. y
            if parsed ~= line then
                print("Error parsing line: " .. line)
                os.exit()
            end
            -- print(parsed)

            if instruction == "Button A" then
                machine.buttonA = { x = tonumber(x), y = tonumber(y) }
            elseif instruction == "Button B" then
                machine.buttonB = { x = tonumber(x), y = tonumber(y) }
            elseif instruction == "Prize" then
                machine.prize = { x = tonumber(x), y = tonumber(y) }
            end
        end
    end

    -- add the last one
    table.insert(machines, machine)

    return machines
end

local function score_machine(machine)
    local buttonA = machine.buttonA
    local buttonB = machine.buttonB
    local prize = machine.prize

    for a = 0, 100 do
        for b = 0, 100 do
            local x = a * buttonA.x + b * buttonB.x
            local y = a * buttonA.y + b * buttonB.y

            if x == prize.x and y == prize.y then
                return a * 3 + b
            end
        end
    end

    return 0
end

-- Now do some stuff
-- The final result we want to input-test.txt is 480
local machines = load(file:lines())
local score = 0

for i, machine in ipairs(machines) do
    -- print("Machine " .. i)
    -- print("Button A: " .. machine.buttonA.x .. ", " .. machine.buttonA.y)
    -- print("Button B: " .. machine.buttonB.x .. ", " .. machine.buttonB.y)
    -- print("Prize: " .. machine.prize.x .. ", " .. machine.prize.y)
    -- print("Score: " .. score_machine(machine))
    -- print()
    score = score + score_machine(machine)
end

print("Total score: " .. score)
