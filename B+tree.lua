BPlusTreeNode = {}
BPlusTreeNode.__index = BPlusTreeNode

function BPlusTreeNode.new(leaf)
    local self = setmetatable({}, BPlusTreeNode)
    self.leaf = leaf or false
    self.keys = {}
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

function BPlusTree:_allocate_node(t, leaf)
    return BPlusTreeNode.new(leaf)
end

function BPlusTree:insert(key, value)
    if not self.root then
        local x = self:_allocate_node(self.t, true)
        x.keys[1] = key
        x.children[1] = value
        self.root = x
    elseif #self.root.keys == (2 * self.t) - 1 then
        local s = self:_allocate_node(self.t, false)
        local _, dup_value = self:search(key)
        if dup_value then
            dup_value = value
            return
        end
        s.children[1] = self.root
        self:_split_child(s, 1)

        local i = 1
        if key > s.keys[i] then
            i = i + 1
        end
        self:_insert_non_full(s.children[i], key, value, self.t)

        self.root = s
    else
        self:_insert_non_full(self.root, key, value, self.t)
    end
end

function BPlusTree:_insert_non_full(x, key, value, t)
    local i = #x.keys
    if x.leaf then
        while i >= 1 and key <= x.keys[i] do
            if key == x.keys[i] then
                i = -1
                break
            end
            i = i - 1
        end

        if i ~= -1 then
            table.insert(x.keys, i + 1, key)
            table.insert(x.children, i + 1, value)
        end
    else
        while i >= 1 and key <= x.keys[i] do
            if key == x.keys[i] then
                i = -1
                break
            end
            i = i - 1
        end

        i = i + 1
        if #x.children[i].keys == (2 * t) - 1 then
            self:_split_child(x, i)
            if key > x.keys[i] then
                i = i + 1
            end
        end
        self:_insert_non_full(x.children[i], key, value, t)
    end
end

function BPlusTree:_split_child(x, i)
    local t = self.t
    y = x.children[i]
    local z = BPlusTreeNode.new(y.leaf)
    table.insert(x.children, i + 1, z)
    table.insert(x.keys, i, y.keys[t])
    if y.leaf then
        z.next = y.next
        y.next = z
    end

    for j = 1, t - 1 do
        table.insert(z.keys, y.keys[j + t])
    end
    for j = 1, t do
        table.insert(z.children, y.children[j + t])
    end
    for j = t, 2 * t - 1 do
        table.remove(y.keys, t + 1)
        table.remove(y.children, t + 1)
    end
end


function BPlusTree:search(key, x, count)
    x = x or self.root
    count = count or 0
    local i = 1
    while i <= #x.keys and key > x.keys[i] do
        i = i + 1
        count = count + 1
    end
    if x.leaf then
        if i <= #x.keys and key == x.keys[i] then
            return count, x.children[i]
        else
            return count, nil
        end
    else
        return self:search(key, x.children[i], count)  -- 수정된 부분
    end
end

local bptree = BPlusTree.new(2)
----------------------------------
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
bptree:insert(62, "Papaya")
bptree:insert(48, "Carambola")
----------------------------------

local search_key = 100
local search_count, search_value = bptree:search(search_key)
if search_value then
    print("B+ Tree Search:")
    print("Search Key:", search_key)
    print("Search Count:", search_count)
    print("Search Value:", search_value)
else
    print("Key not found in the B+ tree.")
end