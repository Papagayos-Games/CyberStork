local JSON = assert(loadfile "LuaScripts/json.lua")()
local health = {}

health["instantiate"] = function (params, entity)
    p = JSON:decode(params)
    local self = {}
    self.entity = entity

    if p.life ~= nil then
        self.life = p.life
    else
        self.life = 1
    end

    self.addLife = function (x, lua)
	-- En caso de que sea el jugador
		if self.life < 3 and self.entity:getName() == "Player" then
			self.life = self.life + x
			if self.life == 2 then
				lua:getUIImage(lua:getEntity("Vida2")):setActive(true)
			elseif self.life == 3 then
				lua:getUIImage(lua:getEntity("Vida3")):setActive(true)
			end
		end
    end
    
    self.receiveDamage = function (x, lua)
         self.life = self.life - x
        if self.life <= 0 then
            --lua:getCurrentScene():destroyEntity(self.entity)
            return true
        end
		--Cuando se le reste vida al jugador, desaparece un icono
		if self.entity:getName() == "Player" then
			if(self.life == 1) then
				lua:getUIImage(lua:getEntity("Vida2")):setActive(false)
			elseif self.life == 2 then
				lua:getUIImage(lua:getEntity("Vida3")):setActive(false)
			end
		end
		
        return false
     end

	print(self.life)
    return self
end

health["start"] = function (_self, lua)
end

health["update"] = function (_self, lua)

   -- if _self.life <= 0 then
    --    lua:getCurrentScene():destroyEntity(_self.entity)
   -- end
end

return health