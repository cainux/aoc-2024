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

function isSafe(numbers)
    local direction = Direction.NONE

    for i, num in ipairs(numbers) do
        if i == #numbers then
            return true
        end

        local delta = num - numbers[i + 1]

        if delta == 0 then
            return false
        end

        local deltaDirection = delta > 0 and Direction.UP or Direction.DOWN

        if direction == Direction.NONE then
            direction = deltaDirection
        else
            if deltaDirection ~= direction then
                return false
            end
        end

        if math.abs(delta) > 3 then
            return false
        end
    end
end

function removeAt(numbers, position)
    local newList = {}
    for i = 1, #numbers do
        if i ~= position then
            table.insert(newList, numbers[i])
        end
    end
    return newList
end

local counter = 0

for line in file:lines() do
    local numbers = splitToNumbers(line)
    if isSafe(numbers) then
        counter = counter + 1
    else
        for i = 1, #numbers do
            local newList = removeAt(numbers, i)
            if isSafe(newList) then
                counter = counter + 1
                break
            end
        end
    end
end

print(counter)
