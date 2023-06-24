function binaryRangeSearch(array, start_key, end_key)
    local low = 1
    local high = #array
    local count = 0
    local result = {}

    -- Find lower bound
    while low <= high do
        local mid = math.floor((low + high) / 2)
        count = count + 1

        if array[mid][1] >= start_key then
            high = mid - 1
        else
            low = mid + 1
        end
    end

    -- Iterate from the lower bound and collect values
    for i = low, #array do
        if array[i][1] > end_key then
            break
        end
        table.insert(result, array[i][2])
        count = count + 1
    end

    return count, result
end
----------------------------------
local data = {
    {3, "Banana"},
    {5, "Apple"},
    {7, "Grapes"},
    {8, "Mango"},
    {10, "Orange"},
    {11, "Fig"},
    {12, "Dragon Fruit"},
    {15, "Blackberry"},
    {18, "Raspberry"},
    {20, "Strawberry"},
    {22, "Cherry"},
    {25, "Blueberry"},
    {28, "Apricot"},
    {30, "Peach"},
    {35, "Guava"},
    {40, "Pineapple"},
    {43, "Tangerine"},
    {45, "Watermelon"},
    {48, "Carambola"},
    {50, "Cantaloupe"},
    {55, "Honeydew"},
    {56, "Rambutan"},
    {60, "Kiwi"},
    {62, "Papaya"},
    {65, "Lemon"},
    {70, "Lime"},
    {75, "Grapefruit"},
    {78, "Lychee"},
    {80, "Plum"},
    {85, "Nectarine"},
    {87, "Persimmon"},
    {88, "Date"},
    {90, "Pomegranate"},
    {95, "Cranberry"},
    {100, "Passion Fruit"}
  }
----------------------------------
local start_key = 25
local end_key = 65
local search_count, search_results = binaryRangeSearch(data, start_key, end_key)

if #search_results > 0 then
    print("Binary Range Search:")
    print("Start Key:", start_key)
    print("End Key:", end_key)
    for i, value in ipairs(search_results) do
        print("Value", i, ":", value)
    end
    print("Total Searches:", search_count)
else
    print("No values found in the specified key range.")
    print("Total Searches:", search_count)
end
