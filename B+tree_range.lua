BPlusTreeValue = {}
BPlusTreeValue.__index = BPlusTreeValue

function BPlusTreeValue.new(key, value)
    local self = setmetatable({}, BPlusTreeValue)
    self.key = key
    self.value = value
    return self
end

BPlusTreeNode = {}
BPlusTreeNode.__index = BPlusTreeNode

function BPlusTreeNode.new(leaf)
    local self = setmetatable({}, BPlusTreeNode)
    self.leaf = leaf or false
    self.values = {}
    self.children = {}
    self.next = nil
    return self
end

BPlusTree = {}
BPlusTree.__index = BPlusTree

function BPlusTree.new(t)
    local self = setmetatable({}, BPlusTree)
    self.root = BPlusTreeNode.new(true)
    self.t = t
    return self
end

function BPlusTree:insert(key, value)
    local node_value = BPlusTreeValue.new(key, value)
    local root = self.root
    if #root.values == (2 * self.t) - 1 then
        local temp = BPlusTreeNode.new(false)
        self.root = temp
        table.insert(temp.children, root)
        self:_split_child(temp, 1)
        self:_insert_non_full(temp, node_value)
    else
        self:_insert_non_full(root, node_value)
    end
end

function BPlusTree:_insert_non_full(x, node_value)
    local i = #x.values
    local key = node_value.key
    if x.leaf then
        table.insert(x.values, node_value)
        table.sort(x.values, function(a, b) return a.key < b.key end)
    else
        while i >= 1 and key < x.values[i].key do
            i = i - 1
        end
      i = i + 1
      if #x.children[i].values == (2 * self.t) - 1 then
        self:_split_child(x, i)
            if key > x.values[i].key then
                i = i + 1
            end
        end
        self:_insert_non_full(x.children[i], node_value)
    end
end

function BPlusTree:_split_child(x, i)
    local t = self.t
    local y = x.children[i]
    local z = BPlusTreeNode.new(y.leaf)
    table.insert(x.children, i + 1, z)
    table.insert(x.values, i, y.values[t])
    z.values = {table.unpack(y.values, t + 1)}
    y.values = {table.unpack(y.values, 1, t - 1)}
    
    if not y.leaf then
        z.children = {table.unpack(y.children, t + 1)}
        y.children = {table.unpack(y.children, 1, t)}
    else
        z.next = y.next
        y.next = z
    end
    x.children[i + 1] = z
end

function BPlusTree:search(key)
    local x = self.root
    while not x.leaf do
        local i = 1
        while i <= #x.values and key > x.values[i].key do
            i = i + 1
        end
        x = x.children[i]
    end
    for _, vpair in ipairs(x.values) do
        if key == vpair.key then
            return true
        end
    end
    return false
end

function BPlusTree:range_search(start_key, end_key)
    local x = self.root
    local i = 1
    local search_results = {}
    while not x.leaf do
        while i <= #x.values and start_key > x.values[i].key do
            i = i + 1
        end
        x = x.children[i]
    end
    while x and x.values[1].key <= end_key do
        for _, vpair in ipairs(x.values) do
            if vpair.key >= start_key and vpair.key <= end_key then
                table.insert(search_results, vpair)
            end
        end
        x = x.next
    end
    return search_results
end

local bptree = BPlusTree.new(14)
bptree:insert(5, "Apple")
bptree:insert(10, "Orange")
bptree:insert(3, "Banana")
bptree:insert(7, "Grapes")
bptree:insert(8, "Mango")
bptree:insert(20, "Strawberry")
bptree:insert(25, "Blueberry")
bptree:insert(15, "Blackberry")
bptree:insert(18, "Raspberry")
bptree:insert(22, "Cherry")
bptree:insert(30, "Peach")
bptree:insert(28, "Apricot")
bptree:insert(35, "Guava")
bptree:insert(40, "Pineapple")
bptree:insert(45, "Watermelon")
bptree:insert(50, "Cantaloupe")
bptree:insert(55, "Honeydew")
bptree:insert(60, "Kiwi")
bptree:insert(65, "Lemon")
bptree:insert(70, "Lime")
bptree:insert(75, "Grapefruit")
bptree:insert(80, "Plum")
bptree:insert(85, "Nectarine")
bptree:insert(90, "Pomegranate")
bptree:insert(95, "Cranberry")
bptree:insert(100, "Passion Fruit")
bptree:insert(78, "Lychee")
bptree:insert(56, "Rambutan")
bptree:insert(12, "Dragon Fruit")
bptree:insert(11, "Fig")
bptree:insert(43, "Tangerine")
bptree:insert(87, "Persimmon")
bptree:insert(88, "Date")
bptree:insert(62, "Guanabana")

local start_key = 25
local end_key = 65
local search_results = bptree:range_search(start_key, end_key)

if #search_results > 0 then
    local search_count = 0
    print("B+Tree Range Search:")
    print("Start Key:", start_key)
    print("End Key:", end_key)
    for i, vpair in ipairs(search_results) do
        search_count = search_count + 1
        print("Value", i, ":", vpair.value)
    end
    print("Total Searches:", search_count)
else
    print("No values found in the specified key range.")
end