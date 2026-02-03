#!/data/data/com.termux/files/usr/bin/bash

# ==========================================
# GABRIEL-TERMUX ULTRA EDITION 2026 (FIX)
# ==========================================

# VERSÃO DO SCRIPT
VERSION="0.4.0"

# Cores
VERDE="\e[92m"; AMARELO="\e[33m"; CIANO="\e[36m"; VERMELHO="\e[31m"; RESET="\e[0m"; NEGRITO="\e[1m"; ROXO="\e[35m"

# Título Limpo
clear
echo -e "${AMARELO}${NEGRITO}============================================${RESET}"
echo -e "\n${ROXO} [ GABRIEL-TERMUX v${VERSION} ]${RESET}\n"
echo -e "${AMARELO}${NEGRITO}============================================${RESET}"
sleep 1

# Salva a versão atual
echo "$VERSION" > ~/.gabriel_version

# Repara pacotes quebrados
dpkg --configure -a > /dev/null 2>&1

# 1. REPOSITÓRIOS
echo -e "\n${AMARELO}>>> Configurando Base do Sistema${RESET}"
echo -ne "${CIANO}Atualizando Pacotes... ${RESET}"
if pkg update -y > /dev/null 2>&1; then
    echo -e "${VERDE}OK${RESET}"
else
    echo -e "${VERMELHO}Erro (Ignorado)${RESET}"
fi

echo -ne "${CIANO}Ativando Repositórios... ${RESET}"
if pkg install x11-repo termux-api game-repo -y > /dev/null 2>&1; then
    echo -e "${VERDE}OK${RESET}"
else
    echo -e "${VERMELHO}Erro${RESET}"
fi

# 2. LOLCAT
echo -ne "${AMARELO}Verificando Cores... ${RESET}"
if pkg install lolcat -y > /dev/null 2>&1; then
    echo -e "${VERDE}OK${RESET}"
else
    pkg install ruby -y > /dev/null 2>&1
    gem install lolcat > /dev/null 2>&1
    echo -e "${VERDE}OK (Via Ruby)${RESET}"
fi

# 3. INSTALAÇÃO DE PACOTES
install_pkg_clean() {
    pkg_name=$1
    if dpkg -s "$pkg_name" 2>/dev/null | grep -q "Status: install ok installed"; then 
        return 
    fi
    echo -ne "${CIANO}Instalando $pkg_name... ${RESET}"
    pkg install "$pkg_name" -y > /dev/null 2>&1
    if [ $? -eq 0 ]; then 
        echo -e "${VERDE}Concluído${RESET}"
    else 
        echo -e "${VERMELHO}Erro${RESET}"
        pkg install "$pkg_name" -y
    fi
}

echo -e "\n${AMARELO}>>> Instalando Ferramentas${RESET}"
packages=(
    "figlet" "ncurses-utils" "git" "python" 
    "clang" "make" "cmake" "binutils" "curl" "wget" "perl" "ruby" 
    "php" "nodejs" "bash" "nano" "zip" "unzip" "openssl" "openssh" 
    "zsh" "ffmpeg" "htop" "screen" "jq" "rsync" "tree" "termux-api" 
    "neofetch" "cmatrix" "cowsay" "fortune" "sl" "ranger" 
    "proot" "proot-distro" "tsu" "man" "vim" "proxychains-ng"
)

for pkg in "${packages[@]}"; do install_pkg_clean "$pkg"; done

# 4. INSTALAÇÃO X11/SDL2
echo -e "\n${AMARELO}>>> Configurando Interface Gráfica${RESET}"
echo -ne "${CIANO}Termux-X11... ${RESET}"
if pkg install termux-x11 -y >/dev/null 2>&1 || pkg install termux-x11-nightly -y >/dev/null 2>&1; then
    echo -e "${VERDE}OK${RESET}"
else
    echo -e "${VERMELHO}Erro${RESET}"
fi
install_pkg_clean "sdl2"

# 5. CONFIGURAÇÕES FINAIS
echo -e "\n${AMARELO}>>> Finalizando Ajustes${RESET}"

echo -ne "${CIANO}Configurando PIP... ${RESET}"
python -m ensurepip --default-pip >/dev/null 2>&1
if pip install --upgrade pip >/dev/null 2>&1; then
    echo -e "${VERDE}OK${RESET}"
else
    echo -e "${VERMELHO}Erro${RESET}"
fi

echo -ne "${CIANO}Instalando yt-dlp... ${RESET}"
if pip install yt-dlp >/dev/null 2>&1; then
    echo -e "${VERDE}OK${RESET}"
else
    echo -e "${VERMELHO}Erro${RESET}"
fi

echo -ne "${CIANO}Instalando Speedtest... ${RESET}"
if pip install speedtest-cli >/dev/null 2>&1; then
    echo -e "${VERDE}OK${RESET}"
else
    echo -e "${VERMELHO}Erro${RESET}"
fi

# Instalação do AcodeX Server (CORRIGIDO)
echo -ne "${CIANO}AcodeX - Terminal... ${RESET}"
# Garante que o NPM use o prefixo correto no Termux
npm config set prefix $PREFIX > /dev/null 2>&1
if npm install -g acodex-server > /dev/null 2>&1; then 
    echo -e "${VERDE}OK${RESET}"
else 
    echo -e "${VERMELHO}Erro (Tente manual)${RESET}"
fi

sshd >/dev/null 2>&1
ln -sf $PREFIX/bin/clang $PREFIX/bin/gcc >/dev/null 2>&1

# 6. CONFIGURAÇÃO VISUAL (.bashrc)
echo "" > ~/.bashrc

cat << 'EOF' >> ~/.bashrc
# --- GABRIEL CONFIG ---
alias atualizar='pkg update && pkg upgrade -y'
alias fechar='pkill termux-x11'
alias ssh-on='sshd && ifconfig | grep inet'
alias cls='clear'
alias limpar='rm -rf ~/.termux/shell_history'

# Atalhos
alias atualizar-setup='curl -fsSL https://raw.githubusercontent.com/GabrielDaSilva17/Termux-Auto-Install/main/instalar.sh | bash'
alias acodex='acodex-server'

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
    if command -v $1 &> /dev/null; then
        echo -e "\033[1;32mON\033[0m"
    else
        echo -e "\033[1;31mOFF\033[0m"
    fi
}

echo -e "    \033[1;33mPYTHON:\033[0m $(check python)   \033[1;33mNODE:\033[0m $(check node)   \033[1;33mSSH:\033[0m $(check sshd)"
echo -e "    \033[1;33mCLANG :\033[0m $(check clang)   \033[1;33mGIT :\033[0m $(check git)    \033[1;33mX11:\033[0m $(check termux-x11)"
echo -e "    \033[1;33mACODEX:\033[0m $(check acodex-server)"
echo " "

# 3. ANDROID INFO
neofetch --ascii_distro android --disable packages shell term resolution

# 4. VERIFICADOR DE ATUALIZAÇÃO (RODA NO FINAL PARA NÃO BUGAR O VISUAL)
check_update() {
    REMOTE_URL="https://raw.githubusercontent.com/GabrielDaSilva17/Termux-Auto-Install/main/instalar.sh"
    LOCAL_VER=$(cat ~/.gabriel_version 2>/dev/null || echo "0")
    # Timeout de 2s para não travar se sem internet
    REMOTE_VER=$(curl -sL --max-time 2 $REMOTE_URL | head -n 20 | grep '^VERSION="' | cut -d'"' -f2)
    
    # Verifica versão e limpa espaços em branco
    REMOTE_VER=$(echo $REMOTE_VER | tr -d '[:space:]')
    LOCAL_VER=$(echo $LOCAL_VER | tr -d '[:space:]')

    if [[ "$REMOTE_VER" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] && [ "$REMOTE_VER" != "$LOCAL_VER" ]; then
         echo -e "\n\033[1;32m >> NOVA ATUALIZACAO DISPONIVEL: $REMOTE_VER << \033[0m"
         echo -e "Digite \033[1;33matualizar-setup\033[0m para baixar.\n"
    fi
}
check_update

export PS1='\[\e[1;32m\]Gabriel\[\e[0m\]@\[\e[1;34m\]Termux\[\e[0m\]:\[\e[1;33m\]\w\[\e[0m\] $ '
EOF

source ~/.bashrc

# Tela Final
clear
echo -e "${VERDE}${NEGRITO}INSTALAÇÃO COMPLETA! (v$VERSION)${RESET}"
echo -e "${VERDE}[✓]${RESET} Visual Corrigido"
echo -e "${VERDE}[✓]${RESET} AcodeX Configurado"
echo " "
echo "Reinicie o Termux."


----"
    fi
}
draw_banner

# 2. STATUS
check() {
    if command -v $1 &> /dev/null; then
        echo -e "\033[1;32mON\033[0m"
    else
        echo -e "\033[1;31mOFF\033[0m"
    fi
}

echo -e "    \033[1;33mPYTHON:\033[0m $(check python)   \033[1;33mNODE:\033[0m $(check node)   \033[1;33mSSH:\033[0m $(check sshd)"
echo -e "    \033[1;33mCLANG :\033[0m $(check clang)   \033[1;33mGIT :\033[0m $(check git)    \033[1;33mX11:\033[0m $(check termux-x11)"
echo -e "    \033[1;33mACODEX:\033[0m $(check acodex-server)"
echo " "

# 3. VERIFICADOR DE ATUALIZAÇÃO (CORRIGIDO SEM PARENTESES)
check_update() {
    REMOTE_URL="https://raw.githubusercontent.com/GabrielDaSilva17/Termux-Auto-Install/main/instalar.sh"
    LOCAL_VER=$(cat ~/.gabriel_version 2>/dev/null || echo "0")
    REMOTE_VER=$(curl -sL $REMOTE_URL | head -n 20 | grep '^VERSION="' | cut -d'"' -f2)
    
    # Verifica versão de forma segura
    if [[ "$REMOTE_VER" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] && [ "$REMOTE_VER" != "$LOCAL_VER" ]; then
         echo -e "\n\033[1;32m >> NOVA ATUALIZACAO DISPONIVEL: $REMOTE_VER << \033[0m"
         echo -e "Digite \033[1;33matualizar-setup\033[0m para baixar.\n"
    fi
}
check_update & disown

# 4. ANDROID INFO
neofetch --ascii_distro android --disable packages shell term resolution

export PS1='\[\e[1;32m\]Gabriel\[\e[0m\]@\[\e[1;34m\]Termux\[\e[0m\]:\[\e[1;33m\]\w\[\e[0m\] $ '
EOF

source ~/.bashrc

# Tela Final
clear
echo -e "${VERDE}${NEGRITO}INSTALAÇÃO COMPLETA! (v$VERSION)${RESET}"
echo -e "${VERDE}[✓]${RESET} Erro de Sintaxe Corrigido"
echo " "
echo "Reinicie o Termux."


