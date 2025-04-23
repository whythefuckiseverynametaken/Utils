local MathUtils = {}

function MathUtils:clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

function MathUtils:round(number, decimals) -- Rounds a number to a specific number of decimal places. MathUtils.round(3.14159, 2) → 3.14
    decimals = decimals or 0
    local power = 10 ^ decimals
    
    return math.floor(number * power + 0.5) / power
end

function MathUtils.lerp(a,b,c) -- Linearly interpolates between a and b using c (0–1 range). MathUtils.lerp(0, 100, 0.5) → 50 
    return a + (b - a) * c
end

function MathUtils.remap(value, inMin, inMax, outMin, outMax) -- Converts a number from one range into another. MathUtils.remap(50, 0, 100, 0, 1) → 0.5
    return outMin + ((value - inMin) / (inMax - inMin)) * (outMax - outMin)
end

function MathUtils.distance2D(x1, y1, x2, y2) -- Returns the 2D distance between two points. MathUtils.distance2D(0, 0, 3, 4) → 5
	return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

return MathUtils