local JSON = assert(loadfile "LuaScripts/json.lua")()

local UIclase = {}

UIclase["instantiate"] = function (params, entity)
    p = JSON:decode(params)
    local self = {}
    self.entity = entity

    if not p then return self end

    if p.fileName ~= nil then self.fileName = p.fileName end

    if p.maxScores ~= nil then self.maxScores = p.maxScores end
    
    return self
end

UIclase["start"] = function (_self, lua)
    _self.label = lua:getUIButton(_self.entity)
    local s = lua:getLuaSelf(lua:getEntity("gameManager"), "score")
    local text = ""
    print(s.getAcutalScore(s))
    for key, value in pairs(s.getScores(s)) do -- actualcode
        text = text .. value .. "\n"
    end
    _self.label:setText(text)
end

UIclase["update"] = function (_self, lua) end

return UIclase