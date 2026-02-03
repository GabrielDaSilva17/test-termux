#!/data/data/com.termux/files/usr/bin/bash

# ==========================================
# GABRIEL-TERMUX: REPAIR & INSTALL EDITION
# ==========================================

# Cores
VERDE="\e[92m"; AMARELO="\e[33m"; CIANO="\e[36m"; VERMELHO="\e[31m"; RESET="\e[0m"; NEGRITO="\e[1m"
CINZA="\e[90m"

clear
echo -e "${AMARELO}${NEGRITO}============================================${RESET}"
echo -e "\n${AMARELO} [${VERDE}Gabriel-Termux${RESET}${VERMELHO} FINAL FIX 2026${AMARELO}]${RESET}\n"
echo -e "${AMARELO}${NEGRITO}============================================${RESET}"
sleep 1

# Função de instalação segura
install_package() {
    pkg_name=$1
    echo -ne "${AMARELO}Verificando $pkg_name... ${RESET}"
    if dpkg -s "$pkg_name" &> /dev/null; then
        echo -e "${VERDE}OK (Já instalado)${RESET}"
    else
        echo -e "${VERMELHO}Instalando...${RESET}"
        pkg install "$pkg_name" -y > /dev/null 2>&1
        if [ $? -eq 0 ]; then
             echo -e "${VERDE}Instalado com sucesso!${RESET}"
        else
             echo -e "${VERMELHO}Erro (Tentando continuar...)${RESET}"
        fi
    fi
}

echo -e "${CIANO} Atualizando repositórios (pode demorar)...${RESET}"
pkg update -y > /dev/null 2>&1 && pkg upgrade -y > /dev/null 2>&1
pkg install x11-repo termux-api -y > /dev/null 2>&1

# LISTA COMPLETA DE PACOTES
# Nota: 'lolcat' e 'figlet' são essenciais para o banner
packages=(
    "git" "python" "python-pip" "clang" "make" "cmake" "binutils" 
    "curl" "wget" "perl" "ruby" "php" "nodejs" "bash" "nano" 
    "zip" "unzip" "openssl" "openssh" "zsh" "ffmpeg" "htop" 
    "screen" "jq" "rsync" "tree" "termux-api" "termux-x11" "sdl2"
    "neofetch" "cmatrix" "figlet" "cowsay" "fortune" "sl" "ranger"
    "proot" "proot-distro" "tsu" "man" "vim" "proxychains-ng" "lolcat"
)

# Loop de instalação
for pkg in "${packages[@]}"; do
    install_package "$pkg"
done

# Instalações Python
echo -e "${CIANO}Configurando Python Utils...${RESET}"
pip install --upgrade pip > /dev/null 2>&1
pip install yt-dlp speedtest-cli > /dev/null 2>&1

# Configurações de Sistema
sshd > /dev/null 2>&1
ln -sf $PREFIX/bin/clang $PREFIX/bin/gcc > /dev/null 2>&1

# ==========================================
# PARTE 1: VERIFICAÇÃO VISUAL (DURANTE A INSTALAÇÃO)
# ==========================================
clear
echo -e "${AMARELO}${NEGRITO}🔎 CHECANDO VERSÕES INSTALADAS...${RESET}"
echo " "
sleep 1
# Função para checar versão sem erro
check_version() {
    if command -v $1 &> /dev/null; then
        echo -e "${CIANO}$2:${RESET} $($3)"
    else
        echo -e "${CIANO}$2:${RESET} ${VERMELHO}Não encontrado!${RESET}"
    fi
}

check_version "python" "Python" "python --version"
check_version "node"   "NodeJS" "node -v"
check_version "clang"  "Clang " "clang --version | head -n 1"
check_version "git"    "Git   " "git --version"
check_version "php"    "PHP   " "php -v | head -n 1"

echo " "
echo -e "${AMARELO}Gerando Checklist Final...${RESET}"
sleep 3

clear
echo -e "${VERDE}${NEGRITO}=== RELATÓRIO DE INSTALAÇÃO ===${RESET}"
echo " "
# Simulação de checklist real baseada no comando 'command -v'
[ -f $PREFIX/bin/termux-x11 ] && echo -e "${VERDE}[✓]${RESET} X11 (Interface Gráfica)" || echo -e "${VERMELHO}[X]${RESET} X11 Falhou"
sleep 0.5
[ -f $PREFIX/bin/sshd ] && echo -e "${VERDE}[✓]${RESET} Servidor SSH" || echo -e "${VERMELHO}[X]${RESET} SSH Falhou"
sleep 0.5
[ -f $PREFIX/bin/clang ] && echo -e "${VERDE}[✓]${RESET} Compilador C/C++" || echo -e "${VERMELHO}[X]${RESET} Clang Falhou"
sleep 0.5
[ -f $PREFIX/bin/yt-dlp ] && echo -e "${VERDE}[✓]${RESET} Downloader (yt-dlp)" || echo -e "${VERMELHO}[X]${RESET} yt-dlp Falhou"
sleep 0.5
[ -f $PREFIX/bin/figlet ] && echo -e "${VERDE}[✓]${RESET} Sistema de Banners" || echo -e "${VERMELHO}[X]${RESET} Figlet Falhou"
echo " "
echo -e "${AMARELO}Configurando inicialização permanente...${RESET}"
sleep 2

# ==========================================
# PARTE 2: CONFIGURAÇÃO DO .BASHRC (TODA VEZ QUE ABRIR)
# ==========================================

# Limpa o arquivo antigo
echo "" > ~/.bashrc

# Recria o arquivo com a lógica de verificação
cat << 'EOF' >> ~/.bashrc
# --- GABRIEL TERMUX CONFIG ---

# Aliases
alias atualizar='pkg update && pkg upgrade -y'
alias fechar='pkill termux-x11'
alias ssh-on='sshd && ifconfig | grep inet'
alias limpar='rm -rf ~/.termux/shell_history'

# Limpa a tela ao abrir
clear

# 1. O BANNER GABRIEL (Com proteção de erro)
if command -v figlet &> /dev/null && command -v lolcat &> /dev/null; then
    figlet -f slant "GABRIEL" | lolcat
else
    echo "GABRIEL TERMUX"
fi

# 2. MINI-DASHBOARD DE STATUS (O que está ON/OFF)
echo -e "\033[1;33m====================================\033[0m"
echo -e "\033[1;32m SYSTEM STATUS \033[0m"

# Checagem rápida no boot
check_stat() {
    if command -v $1 &> /dev/null; then
        echo -e " $2: \033[1;32m[ON]\033[0m"
    else
        echo -e " $2: \033[1;31m[OFF]\033[0m"
    fi
}

# Exibe em colunas (lado a lado)
echo -ne "$(check_stat python Python)   "
echo -e  "$(check_stat clang Clang)"
echo -ne "$(check_stat node NodeJS)   "
echo -e  "$(check_stat sshd SSH)"
echo -ne "$(check_stat git Git)      "
echo -e  "$(check_stat termux-x11 X11)"

echo -e "\033[1;33m====================================\033[0m"
echo " "

# 3. INFO DO ANDROID (Neofetch minimalista)
neofetch --ascii_distro android --disable packages --disable shell --disable term

EOF

# Ativa as configurações agora
source ~/.bashrc

# Mensagem Final
echo -e "${CIANO}Tudo pronto. Feche o Termux e abra novamente para testar!${RESET}"
