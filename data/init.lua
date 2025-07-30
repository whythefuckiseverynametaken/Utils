
local systemData = {}

-- Get System Data
for _, module: ModuleScript in ipairs( script:GetChildren() ) do
    if not ( module:IsA("ModuleScript") ) then continue end
    systemData[module.Name] = require( module )
end



return systemData :: {}