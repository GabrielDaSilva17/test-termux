# 🚀 Gabriel-Termux ULTRA EDITION 2026

![Termux](https://img.shields.io/badge/Platform-Termux-orange?style=for-the-badge&logo=android)
![Shell](https://img.shields.io/badge/Language-Bash-green?style=for-the-badge&logo=gnu-bash)
![Version](https://img.shields.io/badge/Version-3.0%20Ultra-blue?style=for-the-badge)
![Maintenance](https://img.shields.io/badge/Maintained-Yes-success?style=for-the-badge)

Este repositório oferece um script de automação de elite para o **Termux**. Ele transforma seu ambiente básico em uma estação de trabalho poderosa, integrando ferramentas de desenvolvimento, redes, servidores e utilitários gráficos com um visual exclusivo.
## Versao: `4.5`

## 🛠️ O que o Mega Installer faz?

O script executa uma configuração completa dividida em camadas:

### 🐍 Programação & Desenvolvimento
* **Linguagens:** Python (Pip), Node.js, PHP, Ruby e Perl.
* **Compiladores:** Clang (com atalho para GCC), Make, CMake e Binutils.
* **Editores:** Nano, Vim e suporte a Man Pages.

### 🌐 Redes & Servidores
* **SSH:** Configuração automática do servidor `sshd` na porta 8022.
* **Ferramentas:** Curl, Wget, Rsync, Jq e Proxychains-ng.
* **Download:** **yt-dlp** (sucessor do youtube-dl) e Speedtest-cli.

### 🖼️ Ambiente Gráfico (X11)
* **Repositórios:** Ativação automática do `x11-repo`.
* **Gráficos:** Suporte ao **Termux-X11** e biblioteca SDL2 para jogos/apps em C.

### 📂 Utilitários & Diversão
* **Gestão:** Ranger (Explorador de arquivos), Tree, Htop e Zip/Unzip.
* **Visual:** Neofetch (Modo Android), Cmatrix, Figlet, Cowsay, Fortune e SL.
* **Correção:** Instalação automática do `lolcat` via Ruby para garantir cores.

## 🚀 Como instalar

Abra o seu Termux e cole o comando abaixo:

```bash
curl -fsSL https://raw.githubusercontent.com/GabrielDaSilva17/Termux-Auto-Install/main/instalar.sh| bash
```

## 🏗️ Estrutura do Script

O instalador segue este fluxo lógico:

1. **Identidade:** Banner estilizado com os créditos do criador.
2. **Otimização:** Atualização global de pacotes e ativação de repositórios extras.
3. **Smart Install:** Loop de verificação que evita reinstalar o que você já possui.
4. **Visual Repair:** Correção automática de erros de cor (Lolcat/Ruby).
5. **Setup Final:** Inicialização do SSH e configuração do Banner Permanente.

## ⚡ Atalhos Criados (Aliases)

O script facilita sua vida criando comandos curtos:

| Comando | O que faz? |
| --- | --- |
| `atualizar` | Atualiza todos os pacotes do sistema de uma vez. |
| `ssh-on` | Liga o servidor SSH e mostra seu endereço IP. |
| `fechar` | Encerra processos travados do servidor X11. |
| `cls` | Limpa a tela (alternativa ao clear). |
| `atualizar-setup` | atualizado termux por completo |
| `acodex` | AcodeX - Terminal.|

## 🔑 Pós-Instalação

* **Senha SSH:** Digite `passwd` para criar sua senha de acesso remoto.
* **Acesso Gráfico:** Certifique-se de ter o aplicativo **Termux:X11** instalado no seu Android para rodar apps gráficos.

---

**Criado por:** [GabrielDaSilva17](https://www.google.com/search?q=https://github.com/GabrielDaSilva17)
*Otimizando o Termux para o próximo nível.*

