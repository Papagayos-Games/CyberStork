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

    self.getLife = function 
        (x) self.life = self.life + x
        print("aumenta vida")
        print(self.life)
    
    end
    
    self.receiveDamage = function (x, lua)
        print("recivido damage")
         self.life = self.life - x
         print(self.life)
        if self.life <= 0 then
            print("vida menor que 0")
            --lua:getCurrentScene():destroyEntity(self.entity)
            print("entidad destruida")
            return true
        end
        return false
     end

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