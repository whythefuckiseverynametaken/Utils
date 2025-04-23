local TableUtils = {}

function TableUtils:shallowCopy(table) -- Creates a copy of a table, but doesn't clone nested tables. Copies { a = 1, b = 2 } → { a = 1, b = 2 }
	local copy = {}
	for k, v in pairs(table) do
		copy[k] = v
	end
	return copy
end

function TableUtils:deepCopy(table) -- Creates a deep copy of a table — including nested tables.
	local function recurse(t)
		local copy = {}
		for k, v in pairs(t) do
			copy[k] = type(v) == "table" and recurse(v) or v
		end
		return copy
	end
	return recurse(table)
end

function TableUtils:randomEntry(table) -- Returns a random value from a table.
	local keys = {}

	for k in pairs(table) do
		table.insert(keys, k)
	end

	local randKey = keys[math.random(#keys)]
	return table[randKey]
end


return TableUtils