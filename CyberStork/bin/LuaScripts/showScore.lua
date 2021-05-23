local JSON = assert(loadfile "LuaScripts/json.lua")()

local UIScore = {}

UIScore["instantiate"] = function(params, entity)
    p = JSON:decode(params)
    local self = {}
    self.entity = entity

    if p then
        if p.actualScore ~= nil then self.actualScore = p.actualScore end
    end
    
    -- Llamar a esta funcion cuando se destruya un enemigo para sumar el score y
    -- se actualice en pantalla
    self.updateScoreText = function(s, score)
        s.button:setText(score)
    end

    return self
end

UIScore["start"] = function(_self, lua)
    _self.button = lua:getUIButton(_self.entity)
    local s = lua:getLuaSelf(lua:getEntity("gameManager"), "score")
    local text = s.getActualScore(s)
    _self.button:setText(text)
end

UIScore["update"] = function(_self, lua) end

return UIScore
