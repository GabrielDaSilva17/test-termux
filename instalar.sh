#!/data/data/com.termux/files/usr/bin/bash

# Cores e Estilo
VERDE="\e[92m"; AMARELO="\e[33m"; CIANO="\e[36m"; VERMELHO="\e[31m"; RESET="\e[0m"; NEGRITO="\e[1m"

clear
echo -e "${AMARELO}${NEGRITO}============================================${RESET}"
echo -e "\n${AMARELO} [${VERDE}Gabriel-Termux${RESET}${VERMELHO} ULTRA EDITION 2026${AMARELO}]${RESET}\n"
echo -e "${AMARELO}${NEGRITO}============================================${RESET}"
sleep 1

# Função de instalação
install_package() {
    pkg_name=$1
    if dpkg -s "$pkg_name" &> /dev/null; then
        echo -e "${VERDE} • $pkg_name já instalado ✅${RESET}"
    else
        echo -e "${VERMELHO} • Instalando $pkg_name...${RESET}"
        pkg install "$pkg_name" -y
        echo -e "${VERDE} • $pkg_name pronto ✅${RESET}"
    fi
}

echo -e "${AMARELO}Otimizando repositórios...${RESET}"
pkg update -y && pkg upgrade -y
pkg install x11-repo termux-api -y

# Super Lista de Pacotes
packages=(
    "git" "python" "python-pip" "clang" "make" "cmake" "binutils" 
    "curl" "wget" "perl" "ruby" "php" "nodejs" "bash" "nano" 
    "zip" "unzip" "openssl" "openssh" "zsh" "ffmpeg" "htop" 
    "screen" "jq" "rsync" "tree" "termux-api" "termux-x11" "sdl2"
    "neofetch" "cmatrix" "figlet" "cowsay" "fortune" "sl" "ranger"
    "proot" "proot-distro" "tsu" "man" "vim" "proxychains-ng"
)

for pkg in "${packages[@]}"; do
    install_package "$pkg"
done

# --- Configurações Extras e Banner Permanente ---
echo -e "${CIANO}Configurando Aliases e Banner Permanente...${RESET}"

# Aliases úteis
echo "alias atualizar='pkg update && pkg upgrade -y'" >> ~/.bashrc
echo "alias fechar='pkill termux-x11'" >> ~/.bashrc
echo "alias ssh-on='sshd && ifconfig | grep inet'" >> ~/.bashrc
echo "alias limpar='rm -rf ~/.termux/shell_history'" >> ~/.bashrc

# INJETANDO O BANNER 'GABRIEL' NO INÍCIO DO TERMUX
# Verifica se já existe para não duplicar linhas
if ! grep -q "figlet.*GABRIEL" ~/.bashrc; then
    echo "clear" >> ~/.bashrc
    echo 'figlet -f slant "GABRIEL" | lolcat 2>/dev/null || figlet "GABRIEL"' >> ~/.bashrc
    echo "echo ' '" >> ~/.bashrc
fi

# --- Instalação do yt-dlp e ferramentas Python ---
echo -e "${CIANO}Instalando ferramentas Python modernas...${RESET}"
pip install --upgrade pip
pip install yt-dlp speedtest-cli

# --- Setup SSH ---
sshd
ln -sf $PREFIX/bin/clang $PREFIX/bin/gcc

# ==========================================
# FASE FINAL: VERIFICAÇÃO E ESTÉTICA
# ==========================================

clear
echo -e "${AMARELO}${NEGRITO}VERIFICANDO VERSÕES INSTALADAS...${RESET}"
echo " "
echo -e "${CIANO}Python:${RESET} $(python --version)"
echo -e "${CIANO}NodeJS:${RESET} $(node -v)"
echo -e "${CIANO}Clang :${RESET} $(clang --version | head -n 1)"
echo -e "${CIANO}Git   :${RESET} $(git --version)"
echo -e "${CIANO}PHP   :${RESET} $(php -v | head -n 1)"
echo " "
echo -e "${AMARELO}Carregando checklist...${RESET}"
sleep 4

clear
echo -e "${VERDE}${NEGRITO}=== STATUS DO SISTEMA ===${RESET}"
echo " "
echo -e "${VERDE}[✓]${RESET} Repositórios Atualizados"
echo -e "${VERDE}[✓]${RESET} Ambiente X11 Configurado"
echo -e "${VERDE}[✓]${RESET} Compiladores (C/C++) Prontos"
echo -e "${VERDE}[✓]${RESET} SSH Server (Porta 8022) Ativo"
echo -e "${VERDE}[✓]${RESET} yt-dlp & FFmpeg Instalados"
echo -e "${VERDE}[✓]${RESET} Banner 'GABRIEL' Configurado no Boot"
echo " "
echo -e "${AMARELO}Finalizando setup...${RESET}"
sleep 3

clear
echo -e "${VERDE}${NEGRITO}============================================${RESET}"
echo -e "${CIANO}      SETUP GABRIEL-TERMUX FINALIZADO! 🚀${RESET}"
echo -e "${VERDE}${NEGRITO}============================================${RESET}"

# Mostra Info Final
MEU_IP=$(ifconfig wlan0 | grep "inet " | awk '{print $2}')
echo -e "${AMARELO}IP Local:${VERDE} $MEU_IP ${RESET}"
echo -e "${AMARELO}Atalhos:${CIANO} atualizar, fechar, ssh-on${RESET}"

echo " "
# Mostra o banner agora para confirmar
figlet -f slant "GABRIEL" | lolcat 2>/dev/null || figlet "GABRIEL"
echo " "
neofetch
