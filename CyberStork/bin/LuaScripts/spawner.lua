local JSON = assert(loadfile "LuaScripts/json.lua")()
local spawner = {}

local function createfunc (_self, lua, object) 
    local pos = lua:getTransform(_self.entity):getPosition()
    lua:getTransform(object):setPosition(Vector3(pos.x, pos.y, pos.z - 100))
end

spawner["instantiate"] = function (params, entity)
    p = JSON:decode(params)
    local self = {}
    --Objeto a spawnear
    if p.spawnObject ~= nil then
        self.spawnObject = p.spawnObject
    else
        self.spawnObject = "meteor"
    end

    --Cada cuantos segundos spawnea
    if p.timeToSpawn ~= nil then
        self.timeToSpawn = p.timeToSpawn
    else
        self.timeToSpawn = 1.5
    end

    self.entity =  entity
    self.previousTime = self.timeToSpawn
    self.time = -1

    self.changeTimeToSpawn = function (x, time) 
        self.previousTime = self.timeToSpawn
        self.timeToSpawn = x
        self.time = time
     end
    return self
end

spawner["start"] = function (_self, lua)
    _self.timeSinceSpawn = lua:getInputManager():getTicks()
end

spawner["update"] = function (_self, lua, deltaTime)
    if (lua:getInputManager():getTicks() - _self.timeSinceSpawn)/1000  >= _self.timeToSpawn then
        print(_self.spawnObject)
        local objectSpawned = lua:instantiate(_self.spawnObject)
        createfunc(_self,lua, objectSpawned)

        objectSpawned:start();
        _self.timeSinceSpawn = lua:getInputManager():getTicks()
    end 

    if _self.time > 0 then
        _self.time = _self.time - deltaTime
    else 
        _self.timeToSpawn = _self.previousTime

    end
end

return spawner