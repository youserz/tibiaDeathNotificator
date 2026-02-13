-- Configs
-- Localhost
local pythonServerURL = "http://127.0.0.1:5000/trigger_death"

-- Configuração de Itens para contar
local supplyConfig = {
    hpId = 266, 
    mpId = 268 
}

local deathNotified = false
local charName = player:getName()

-- Trigger para Screenshot
function triggerPythonScreenshot()
    -- Coleta dados
    local lvl = player:getLevel()
    local hp = player:getHealth()
    local pos = player:getPosition()
    local posStr = pos.x .. "," .. pos.y .. "," .. pos.z
    
    local hpCount = player:getItemsCount(supplyConfig.hpId)
    local mpCount = player:getItemsCount(supplyConfig.mpId)

    -- Monta a mensagem pro Discord
    local discordMessage = "- **MORTE DETECTADA: " .. charName .. "**\n" ..
                           "- Local: `" .. posStr .. "` | Lvl: " .. lvl .. "\n" ..
                           "- Pots: " .. hpCount .. " HP / " .. mpCount .. " MP\n" ..
                           "- **Screenshot da VM capturada automaticamente:**"

    -- Monta o JSON para o Python
    local payload = '{"charName": "' .. charName .. '", "message": "' .. discordMessage:gsub("\n", "\\n") .. '"}'

    -- Envia o sinal para o Python (Localhost)
    if HTTP.postJSON then
        HTTP.postJSON(pythonServerURL, payload, function(data, err)
            if err then
                print("ERRO ao conectar com Python: " .. err)
                print("Verifique se o script server_death.py está rodando na VM!")
            else
                print("Sinal enviado para o Python com sucesso!")
            end
        end)
    else
        -- Fallback para HTTP.post
        HTTP.post(pythonServerURL, payload, function(data, err)
            if err then
                print("ERRO ao conectar com Python: " .. err)
            else
                print("Sinal enviado para o Python com sucesso!")
            end
        end)
    end
end

-- Macro Mnitor
macro(500, "Death Trigger Localhost", function()
    if player:isDead() or player:getHealth() <= 0 then
        if not deathNotified then
            warn("Morte! Acionando Python para screenshot...")
            triggerPythonScreenshot()
            deathNotified = true 
        end
    else
        if deathNotified then
            deathNotified = false
            print("Monitor resetado.")
        end
    end
end)

-- Testar conexão
UI.Button("Testar Python+Discord", function()
    triggerPythonScreenshot()
end)