#!/data/data/com.termux/files/usr/bin/bash

# ==========================================
# GABRIEL-TERMUX ULTRA EDITION 2026 (CLEAN)
# ==========================================

# Cores
VERDE="\e[92m"; AMARELO="\e[33m"; CIANO="\e[36m"; VERMELHO="\e[31m"; RESET="\e[0m"; NEGRITO="\e[1m"; ROXO="\e[35m"

# Título Limpo
clear
echo -e "${AMARELO}${NEGRITO}============================================${RESET}"
echo -e "\n${ROXO} [ GABRIEL-TERMUX ULTRA EDITION 2026 ]${RESET}\n"
echo -e "${AMARELO}${NEGRITO}============================================${RESET}"
sleep 1

# Função para executar comandos silenciosamente com feedback visual
run_silent() {
    echo -ne "${CIANO}$1... ${RESET}"
    eval "$2" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${VERDE}OK${RESET}"
    else
        echo -e "${VERMELHO}Falha (Tentando corrigir...)${RESET}"
        eval "$2" # Tenta rodar de novo mostrando erro se falhar
    fi
}

# 1. REPOSITÓRIOS (Sem forçar troca de mirror)
echo -e "\n${AMARELO}>>> Configurando Base do Sistema${RESET}"
# Removido termux-change-repo para evitar erros de configuração desnecessários
run_silent "Atualizando Pacotes (Isso demora um pouco)" "pkg update -y"
run_silent "Ativando X11 e Root Repos" "pkg install x11-repo termux-api game-repo -y"
# Atualiza de novo para garantir que os novos repositórios sejam lidos
run_silent "Sincronizando Novos Repositórios" "pkg update -y"

# 2. LOLCAT (Visual)
echo -ne "${AMARELO}Verificando Cores... ${RESET}"
if pkg install lolcat -y > /dev/null 2>&1; then
    echo -e "${VERDE}OK${RESET}"
else
    pkg install ruby -y > /dev/null 2>&1
    gem install lolcat > /dev/null 2>&1
    echo -e "${VERDE}OK (Via Ruby)${RESET}"
fi

# 3. FUNÇÃO DE INSTALAÇÃO DE PACOTES (Minimalista)
install_pkg_clean() {
    pkg_name=$1
    # Verifica antes para não poluir a tela
    if dpkg -s "$pkg_name" &> /dev/null; then
        return # Se já existe, não mostra nada, mantém limpo
    fi
    
    echo -ne "${CIANO}Instalando $pkg_name... ${RESET}"
    pkg install "$pkg_name" -y > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        echo -e "${VERDE}Concluído${RESET}"
    else
        echo -e "${VERMELHO}Erro${RESET}"
        # Tenta de novo visível apenas se falhar
        pkg install "$pkg_name" -y
    fi
}

# 4. LOOP DE INSTALAÇÃO
echo -e "\n${AMARELO}>>> Instalando Ferramentas${RESET}"
# Se o pacote já tiver, ele pula silenciosamente. Se não, mostra instalando.
packages=(
    "figlet" "ncurses-utils" "git" "python" "python-pip" 
    "clang" "make" "cmake" "binutils" "curl" "wget" "perl" "ruby" 
    "php" "nodejs" "bash" "nano" "zip" "unzip" "openssl" "openssh" 
    "zsh" "ffmpeg" "htop" "screen" "jq" "rsync" "tree" "termux-api" 
    "neofetch" "cmatrix" "cowsay" "fortune" "sl" "ranger" 
    "proot" "proot-distro" "tsu" "man" "vim" "proxychains-ng"
)

for pkg in "${packages[@]}"; do
    install_pkg_clean "$pkg"
done

# 5. INSTALAÇÃO X11/SDL2
echo -e "\n${AMARELO}>>> Configurando Interface Gráfica${RESET}"
run_silent "Instalando Termux-X11" "pkg install termux-x11 -y || pkg install termux-x11-nightly -y"
run_silent "Instalando Drivers SDL2" "pkg install sdl2 -y"

# Configurações Finais
echo -e "\n${AMARELO}>>> Finalizando Ajustes${RESET}"
run_silent "Atualizando PIP" "pip install --upgrade pip"
run_silent "Instalando yt-dlp (Downloader)" "pip install yt-dlp"
run_silent "Instalando Speedtest" "pip install speedtest-cli"
run_silent "Configurando SSH" "sshd"
run_silent "Linkando Compiladores" "ln -sf $PREFIX/bin/clang $PREFIX/bin/gcc"

# 6. CONFIGURAÇÃO VISUAL (.bashrc)
echo "" > ~/.bashrc

cat << 'EOF' >> ~/.bashrc
# --- GABRIEL CONFIG ---
alias atualizar='pkg update && pkg upgrade -y'
alias fechar='pkill termux-x11'
alias ssh-on='sshd && ifconfig | grep inet'
alias cls='clear'
alias limpar='rm -rf ~/.termux/shell_history'

clear

# 1. BANNER
draw_banner() {
    if command -v lolcat &> /dev/null; then
        echo "╔═══════════════════════════════════════════════════════════╗" | lolcat
        figlet -f slant "   GABRIEL   " | lolcat
        echo "╚═══════════════════════════════════════════════════════════╝" | lolcat
    else
        echo "-------------------------------------------------------------"
        figlet -f slant "   GABRIEL   "
        echo "-------------------------------------------------------------"
    fi
}
draw_banner

# 2. STATUS
check() {
    if command -v $1 &> /dev/null; then echo -e "\033[1;32mON\033[0m"; else echo -e "\033[1;31mOFF\033[0m"; fi
}

echo -e "    \033[1;33mPYTHON:\033[0m $(check python)   \033[1;33mNODE:\033[0m $(check node)   \033[1;33mSSH:\033[0m $(check sshd)"
echo -e "    \033[1;33mCLANG :\033[0m $(check clang)   \033[1;33mGIT :\033[0m $(check git)    \033[1;33mX11:\033[0m $(check termux-x11)"
echo " "

# 3. ANDROID INFO
neofetch --ascii_distro android --disable packages shell term resolution

export PS1='\[\e[1;32m\]Gabriel\[\e[0m\]@\[\e[1;34m\]Termux\[\e[0m\]:\[\e[1;33m\]\w\[\e[0m\] $ '
EOF

source ~/.bashrc

# Tela Final
clear
echo -e "${VERDE}${NEGRITO}INSTALAÇÃO COMPLETA!${RESET}"
echo -e "${VERDE}[✓]${RESET} Sistema Limpo e Configurado"
echo " "
echo "Reinicie o Termux."
