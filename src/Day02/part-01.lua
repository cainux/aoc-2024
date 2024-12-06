local file = io.open("input.txt", "r")

if file == nil then
    os.exit(1)
end

function splitToNumbers(input)
    local numbers = {}

    for num in input:gmatch "%S+" do
        table.insert(numbers, tonumber(num))
    end

    return numbers
end

local Direction = {
    NONE = 0,
    UP = 1,
    DOWN = 2,
}

local counter = 0

for line in file:lines() do
    local direction = Direction.NONE
    local numbers = splitToNumbers(line)
    for i, num in ipairs(numbers) do
        if i == #numbers then
            counter = counter + 1
            break
        end

        local delta = num - numbers[i + 1]

        if delta == 0 then
            break
        end

        local deltaDirection = delta > 0 and Direction.UP or Direction.DOWN

        if direction == Direction.NONE then
            direction = deltaDirection
        else
            if deltaDirection ~= direction then
                break
            end
        end

        if math.abs(delta) > 3 then
            break
        end
    end
end

print(counter)
