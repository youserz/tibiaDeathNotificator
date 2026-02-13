# 💀 Tibia Death Monitor

![Python](https://img.shields.io/badge/Python-3.9%2B-blue?style=for-the-badge&logo=python&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-5.1-000080?style=for-the-badge&logo=lua&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-2.0-000000?style=for-the-badge&logo=flask&logoColor=white)
![SQL
Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)

> **Um pipeline de monitoramento event-driven aplicado a jogos online.**

Projeto pessoal desenvolvido para integrar automação de eventos no
cliente do Tibia com uma arquitetura inspirada em microsserviços.

------------------------------------------------------------------------

## 📝 Sobre o Projeto

A ideia surgiu durante as férias, quando precisei rodar o cliente do
jogo em uma **VM na nuvem** para evitar deixar meu PC ligado 24/7 (custo
e ruído).

Para não perder o progresso do personagem, transformei o cenário em um
laboratório de engenharia de software. O objetivo foi criar uma solução
de **observabilidade** que capturasse eventos críticos (como a morte do
personagem) e gerasse evidências visuais e logs estruturados em tempo
real.

------------------------------------------------------------------------

## 🎯 O que ele faz?

-   🕵️ **Monitora** a saúde do personagem via injeção de script Lua\
-   📡 **Comunica** eventos via protocolo HTTP (IPC local)\
-   📸 **Captura** screenshots do sistema operacional no momento exato
    do evento\
-   💾 **Persiste** logs em banco de dados relacional\
-   🔔 **Notifica** instantaneamente via Discord Webhook

------------------------------------------------------------------------

## 🧩 Arquitetura

``` mermaid
graph LR
    A[Game Client<br>Lua Trigger] -->|HTTP POST| B[Python Flask<br>Microservice]
    B -->|Log Event| C[(SQL Server)]
    B -->|Capture Screenshot| D[OS Screenshot Library]
    D -->|Upload & Alert| E[Discord Webhook]
```

### ⚙️ Stack Tecnológica

| Componente | Tecnologia | Função |
|------------|-----------|--------|
| Trigger | Lua Script | Detecta HP = 0 no cliente |
| Backend | Python | Orquestração e automação |
| API | Flask | Recebe eventos HTTP |
| Database | SQL Server | Persistência de eventos |
| Alertas | Discord Webhook | Notificação em tempo real |
| Infra | Cloud VM | Execução 24/7 |


## 👨‍💻 Autor

Bernardo Henrique\
**Data & AI Engineering Enthusiast**
------------------------------------------------------------------------

## 📄 Licença

Este projeto é open-source e está licenciado sob a licença **MIT**.

