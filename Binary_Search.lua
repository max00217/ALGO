function binarySearch(array, key)
    local low = 1
    local high = #array
    local count = 0

    while low <= high do
        local mid = math.floor((low + high) / 2)
        count = count + 1
        if array[mid][1] == key then
            return count, array[mid][2]
        elseif array[mid][1] < key then
            low = mid + 1
        else
            high = mid - 1
        end
    end
    return count, nil
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
  -- Perform binary search
local search_key = 60
local search_count, search_value = binarySearch(data, search_key)
if search_value then
    print("Binary Search:")
    print("Search Key:", search_key)
    print("Search Count:", search_count)
    print("Search Value:", search_value)
else
    print("Key not found.")
end