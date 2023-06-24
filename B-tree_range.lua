BTreeNode = {}
BTreeNode.__index = BTreeNode

function BTreeNode.new(leaf)
    local self = setmetatable({}, BTreeNode)
    self.leaf = leaf or false
    self.keys = {}
    self.children = {}
    return self
end

BTree = {}
BTree.__index = BTree

function BTree.new(t)
    local self = setmetatable({}, BTree)
    self.root = BTreeNode.new(true)
    self.t = t
    return self
end

function BTree:insert(key, value)
    local root = self.root
    if #root.keys == (2 * self.t) - 1 then
        local temp = BTreeNode.new()
        self.root = temp
        table.insert(temp.children, root)
        self:_split_child(temp, 1)
        self:_insert_non_full(temp, key, value)
    else
        self:_insert_non_full(root, key, value)
    end
end

function BTree:_insert_non_full(x, key, value)
    local i = #x.keys
    if x.leaf then
        table.insert(x.keys, {key, value})
        table.sort(x.keys, function(a, b) return a[1] < b[1] end)
    else
        while i >= 1 and key < x.keys[i][1] do
            i = i - 1
        end
      i = i + 1
      if #x.children[i].keys == (2 * self.t) - 1 then
        self:_split_child(x, i)
            if key > x.keys[i][1] then
                i = i + 1
            end
        end
        self:_insert_non_full(x.children[i], key, value)
    end
end
  

function BTree:_split_child(x, i)
    local t = self.t
    local y = x.children[i]
    local z = BTreeNode.new(y.leaf)
    table.insert(x.children, i + 1, z)
    table.insert(x.keys, i, table.remove(y.keys, t))
    z.keys = {table.unpack(y.keys, t)}
    y.keys = {table.unpack(y.keys, 1, t - 1)}
    if not y.leaf then
        z.children = {table.unpack(y.children, t + 1)}
        y.children = {table.unpack(y.children, 1, t)}
    end
    x.children[i + 1] = z
end
 

function BTree:search(key, x, count)
    x = x or self.root
    count = count or 0
    local i = 1
    while i <= #x.keys and key > x.keys[i][1] do
        i = i + 1
        count = count + 1
    end
    if i <= #x.keys and key == x.keys[i][1] then
        return count, x.keys[i][2]
    elseif x.leaf then
        return count, nil
    else
        return self:search(key, x.children[i], count)
    end
end

function BTree:range_search(start_key, end_key, x, result, count)
    x = x or self.root
    result = result or {}
    count = count or 0
    local i = 1
    while i <= #x.keys and start_key > x.keys[i][1] do
        i = i + 1
        count = count + 1
    end
    while i <= #x.keys and x.keys[i][1] <= end_key do
        if x.leaf then
            table.insert(result, x.keys[i][2])
        else
            result, count = self:range_search(start_key, end_key, x.children[i], result, count)
        end
        i = i + 1
    end
    if not x.leaf and i <= #x.children then
        result, count = self:range_search(start_key, end_key, x.children[i], result, count)
    end
    return result, count
end



local btree = BTree.new(14)
----------------------------------
btree:insert(5, "Apple")
btree:insert(10, "Orange")
btree:insert(3, "Banana")
btree:insert(7, "Grapes")
btree:insert(8, "Mango")
btree:insert(20, "Strawberry")
btree:insert(25, "Blueberry")
btree:insert(15, "Blackberry")
btree:insert(18, "Raspberry")
btree:insert(22, "Cherry")
btree:insert(30, "Peach")
btree:insert(28, "Apricot")
btree:insert(35, "Guava")
btree:insert(40, "Pineapple")
btree:insert(45, "Watermelon")
btree:insert(50, "Cantaloupe")
btree:insert(55, "Honeydew")
btree:insert(60, "Kiwi")
btree:insert(65, "Lemon")
btree:insert(70, "Lime")
btree:insert(75, "Grapefruit")
btree:insert(80, "Plum")
btree:insert(85, "Nectarine")
btree:insert(90, "Pomegranate")
btree:insert(95, "Cranberry")
btree:insert(100, "Passion Fruit")
btree:insert(78, "Lychee")
btree:insert(56, "Rambutan")
btree:insert(12, "Dragon Fruit")
btree:insert(11, "Fig")
btree:insert(43, "Tangerine")
btree:insert(87, "Persimmon")
btree:insert(88, "Date")
btree:insert(62, "Papaya")
btree:insert(48, "Carambola")
----------------------------------
local start_key = 25
local end_key = 65
local search_results, total_searches = btree:range_search(start_key, end_key)

if #search_results > 0 then
    print("B-Tree Range Search:")
    print("Start Key:", start_key)
    print("End Key:", end_key)
    for i, value in ipairs(search_results) do
        print("Value", i, ":", value)
    end
    print("Total Searches:", total_searches)
else
    print("No values found in the specified key range.")
    print("Total Searches:", total_searches)
end
