local file = io.open("input.txt", "r")

if file == nil then
    print "oops"
    return
end

local equations = {}

for line in file:lines() do
    local sum = tonumber(line:match "^(%d+):")
    local values = {}
    for value in line:gmatch "%s%d+" do
        table.insert(values, tonumber(value:match "%d+"))
    end
    table.insert(equations, { sum = sum, values = values })
end

local function evaluate(equation)
    local operators = {}
    local numbers = {}

    -- Split the equation into numbers and operators
    for part in equation:gmatch "%d+%D?" do
        local number = tonumber(part:match "%d+")
        local operator = part:match "%D"

        table.insert(numbers, number)
        if operator then
            table.insert(operators, operator)
        end
    end

    -- Evaluate the expression from left to right
    local result = numbers[1]
    for i = 1, #operators do
        if operators[i] == "+" then
            result = result + numbers[i + 1]
        elseif operators[i] == "*" then
            result = result * numbers[i + 1]
        elseif operators[i] == "|" then
            result = tonumber(tostring(result) .. tostring(numbers[i + 1]))
        end
    end

    return result
end

local function check(values, index, current, target)
    if index > #values then
        local evaluated = evaluate(current)
        if evaluated == target then
            return true
        end
        return false
    end

    if check(values, index + 1, current .. "+" .. values[index], target) then
        return true
    end

    if check(values, index + 1, current .. "*" .. values[index], target) then
        return true
    end

    if check(values, index + 1, current .. "|" .. values[index], target) then
        return true
    end

    return false
end

local count = 0

for _, e in ipairs(equations) do
    if check(e.values, 2, tonumber(e.values[1]), e.sum) then
        count = count + e.sum
    end
end

print(count)
