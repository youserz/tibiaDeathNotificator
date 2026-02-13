from flask import Flask, request
import mss
import requests
import datetime
import os
import threading

# Configs
DISCORD_WEBHOOK = "SEU_LINK" 
PORTA_LOCAL = 5000

app = Flask(__name__)

def send_to_discord(filepath, texto_extra):
    """Envia a imagem capturada para o Discord"""
    try:
        with open(filepath, "rb") as f:
            payload = {"content": f"{texto_extra}"}
            files = {"file": (filepath, f, "image/png")}
            requests.post(DISCORD_WEBHOOK, data=payload, files=files)
        print(f"Relatório enviado com sucesso!")
    except Exception as e:
        print(f"Erro ao enviar para Discord: {e}")

def take_screenshot_and_send(char_name, info_text):
    """Tira o print da tela inteira e chama o envio"""
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    filename = f"death_{char_name}_{timestamp}.png"
    
    print(f"Tirando screenshot da tela...")
    
    with mss.mss() as sct:
        # Tira print do monitor 1
        sct.shot(mon=-1, output=filename)
    
    # Envia para o Discord
    send_to_discord(filename, info_text)
    
    # Remove o arquivo depois de enviar para não encher o HD
    os.remove(filename) 

@app.route('/trigger_death', methods=['POST'])
def receive_trigger():
    """Recebe o sinal do Lua"""
    try:
        # Pega os dados que o Lua mandou (Nome, Level, etc)
        data = request.json
        char_name = data.get("charName", "Desconhecido")
        message = data.get("message", "Morte detectada.")
        
        print(f"\nSINAL RECEBIDO: {char_name} morreu!")
        
        # Cria uma thread separada para não travar a resposta
        t = threading.Thread(target=take_screenshot_and_send, args=(char_name, message))
        t.start()
        
        return "OK", 200
    except Exception as e:
        print(f"Erro no processamento: {e}")
        return "Erro", 500

if __name__ == '__main__':
    print(f"--- SERVIDOR DE SCREENSHOT RODANDO ---")
    print(f"Aguardando sinal do Bot em http://127.0.0.1:{PORTA_LOCAL}...")
    # host='0.0.0.0' permite conexões locais
    app.run(host='0.0.0.0', port=PORTA_LOCAL)
