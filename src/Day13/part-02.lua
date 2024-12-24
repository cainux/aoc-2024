local file = io.open("input.txt", "r")

if not file then
    print "File not found"
    os.exit()
end

local function load(lines)
    local offset = 10000000000000
    local machines = {}
    local machine = {}

    for line in lines do
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

            if instruction == "Button A" then
                machine.buttonA = { x = tonumber(x), y = tonumber(y) }
            elseif instruction == "Button B" then
                machine.buttonB = { x = tonumber(x), y = tonumber(y) }
            elseif instruction == "Prize" then
                machine.prize = { x = offset + tonumber(x), y = offset + tonumber(y) }
            end
        end
    end

    -- add the last one
    table.insert(machines, machine)

    return machines
end

local function score_machine(machine)
    -- I do not understand the math here, but it's called "Cramer's Rule"
    local ax, ay = machine.buttonA.x, machine.buttonA.y
    local bx, by = machine.buttonB.x, machine.buttonB.y
    local px, py = machine.prize.x, machine.prize.y

    -- Calculate the determinants
    local d = ax * by - ay * bx
    local da = ax * py - ay * px
    local db = px * by - py * bx

    -- From here we can work out if there is a solution
    if da % d ~= 0 or db % d ~= 0 then
        return 0
    end

    -- I don't know how but this gets us how many times we need to press each button
    -- double slash just means integer division (no remainder)
    local a = db // d
    local b = da // d

    return a * 3 + b
end

-- Now do some stuff
-- The final result we want to input-test.txt is only machines 2 and 4 are winnable
local machines = load(file:lines())
local score = 0

for i, machine in ipairs(machines) do
    local machine_score = score_machine(machine)
    -- if machine_score > 0 then
    --     print("Machine " .. i)
    --     print("Button A: " .. machine.buttonA.x .. ", " .. machine.buttonA.y)
    --     print("Button B: " .. machine.buttonB.x .. ", " .. machine.buttonB.y)
    --     print("Prize: " .. machine.prize.x .. ", " .. machine.prize.y)
    --     print("Score: " .. machine_score)
    --     print()
    -- end
    score = score + machine_score
end

print("Total score: " .. score)
