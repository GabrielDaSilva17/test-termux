#!/data/data/com.termux/files/usr/bin/bash

# Cores
VERDE="\e[92m"
AMARELO="\e[33m"
CIANO="\e[36m"
VERMELHO="\e[31m"
RESET="\e[0m"
NEGRITO="\e[1m"

clear
echo -e "${AMARELO}${NEGRITO}============================================${RESET}"
echo -e "\n${AMARELO} [${VERDE}Gabriel-Termux${RESET}${VERMELHO} Extreme Edition${AMARELO}]${RESET}\n"
echo -e "${AMARELO}${NEGRITO}============================================${RESET}"
sleep 2

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

echo -e "${AMARELO}Atualizando tudo e configurando SSH...${RESET}"
pkg update -y && pkg upgrade -y
pkg install x11-repo termux-api -y

# Lista Completa (Base + Ferramentas + SSH)
packages=(
    "git" "python" "python-pip" "clang" "make" "cmake" "binutils" 
    "curl" "wget" "perl" "ruby" "php" "nodejs" "bash" "nano" 
    "zip" "unzip" "openssl" "openssh" "zsh" "ffmpeg" "htop" 
    "screen" "jq" "rsync" "tree" "termux-api" "termux-x11" "sdl2"
    "neofetch" "cmatrix" "figlet" "cowsay" "fortune" "sl" "ranger"
)

for pkg in "${packages[@]}"; do
    install_package "$pkg"
done

# --- Configuração do SSH ---
echo -e "${CIANO}Configurando servidor SSH...${RESET}"
sshd # Inicia o servidor SSH
echo -e "${AMARELO}O servidor SSH foi iniciado na porta 8022.${RESET}"

# --- Instalação do yt-dlp ---
echo -e "${CIANO}Instalando yt-dlp...${RESET}"
pip install yt-dlp

# Atalho GCC
ln -sf $PREFIX/bin/clang $PREFIX/bin/gcc

clear
echo -e "${VERDE}${NEGRITO}============================================${RESET}"
echo -e "${CIANO}      SISTEMA GABRIEL-TERMUX PRONTO! 🚀${RESET}"
echo -e "${VERDE}${NEGRITO}============================================${RESET}"

# Mostra o IP para você saber como conectar via SSH
MEU_IP=$(ifconfig wlan0 | grep "inet " | awk '{print $2}')
echo -e "${AMARELO}Seu IP local: ${VERDE}$MEU_IP${RESET}"
echo -e "${AMARELO}Conecte via PC usando: ${CIANO}ssh $MEU_IP -p 8022${RESET}"

figlet "GABRIEL"
