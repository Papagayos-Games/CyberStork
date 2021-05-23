local JSON = assert(loadfile "LuaScripts/json.lua")()

local score = {}

score["instantiate"] = function(params, entity)
    local p = JSON:decode(params)
    local self = {}
    self.scores = {}
    self.maxScores = 3
    self.fileName = "Scores.txt"
    self.path = "\\Assets\\"

    if not p then return self end

    if p.fileName ~= nil then self.fileName = p.fileName end

    if p.maxScores ~= nil then self.maxScores = p.maxScores end

    return self
end

score["start"] = function(_self, lua)
    local f = io.popen "cd"
    local current_dir = f:read '*l'
    f:close()

    local path_ = current_dir .. _self.path .. _self.fileName

    local file = io.open(path_)


    print(type(file))

    if file == nil then
        print("No se ha podido abrir el archivo " .. _self.path ..
                  _self.fileName)
        local fileCre = io.open(path_, "w")
        print("archivo creado" .. _self.path .. _self.fileName)
        fileCre:close()
        return
    end

    local i = 0
    for line in file:lines() do
        table.insert(_self.scores, tonumber(line));
        i = i + 1
        if i >= _self.maxScores then break end
    end
    file:close()


    for key, value in pairs(_self.scores) do -- actualcode
        print("[" .. key .. "] " .. value)
    end

end

score["update"] = function(_self, lua) end

return score
