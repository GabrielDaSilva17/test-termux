#!/data/data/com.termux/files/usr/bin/bash

# ==========================================
# GABRIEL-TERMUX: ULTIMATE FULL EDITION
# ==========================================

# 1. Definição de Cores
VERDE="\e[92m"
AMARELO="\e[33m"
CIANO="\e[36m"
VERMELHO="\e[31m"
ROXO="\e[35m"
RESET="\e[0m"
NEGRITO="\e[1m"

# Limpa a tela inicial
clear
echo -e "${AMARELO}${NEGRITO}============================================${RESET}"
echo -e "\n${ROXO} [ GABRIEL-TERMUX ULTRA INSTALLER COMPLETO ]${RESET}\n"
echo -e "${AMARELO}${NEGRITO}============================================${RESET}"
sleep 1

# --- FUNÇÃO DE INSTALAÇÃO SEGURA (Não deixa passar erro despercebido) ---
install_package() {
    pkg_name=$1
    echo -ne "${AMARELO}Checando $pkg_name... ${RESET}"
    
    # Verifica se já está instalado
    if dpkg -s "$pkg_name" &> /dev/null; then
        echo -e "${VERDE}OK (Já existe) ✅${RESET}"
    else
        # Tenta instalar
        echo -ne "${VERMELHO}Instalando... ${RESET}"
        pkg install "$pkg_name" -y > /dev/null 2>&1
        
        # Confere se instalou mesmo
        if [ $? -eq 0 ]; then
            echo -e "${VERDE}Sucesso!${RESET}"
        else
            echo -e "\n${VERMELHO}${NEGRITO}!!! FALHA AO INSTALAR $pkg_name !!!${RESET}"
            echo -e "${VERMELHO}Tentando novamente em 5 segundos...${RESET}"
            sleep 5
            pkg install "$pkg_name" -y
        fi
    fi
}

# 2. Atualização Inicial
echo -e "${CIANO}Atualizando a base do sistema (Aguarde)...${RESET}"
pkg update -y && pkg upgrade -y
pkg install x11-repo termux-api -y

# 3. LISTA COMPLETA E GIGANTE DE PACOTES
# Nada foi removido aqui.
packages=(
    # Essenciais do Banner
    "figlet" "lolcat" "ncurses-utils" "procps" 
    
    # Linguagens e Compiladores
    "python" "python-pip" "clang" "make" "cmake" "binutils" 
    "perl" "ruby" "php" "nodejs" "git" "rust"
    
    # Web e Rede
    "curl" "wget" "openssl" "openssh" "rsync" "proxychains-ng" "net-tools"
    
    # Sistema e Arquivos
    "bash" "zsh" "nano" "vim" "zip" "unzip" "tar" "tree" "jq" 
    "htop" "proot" "proot-distro" "tsu" "man" "screen"
    
    # Interface Gráfica e Multimídia
    "termux-x11" "sdl2" "ffmpeg" "imagemagick"
    
    # Diversão e Visual
    "neofetch" "cmatrix" "cowsay" "fortune" "sl" "ranger"
)

# Loop de Instalação
for pkg in "${packages[@]}"; do
    install_package "$pkg"
done

# 4. Configurações Pós-Instalação
echo -e "${CIANO}Configurando Python Utils (yt-dlp)...${RESET}"
pip install --upgrade pip > /dev/null 2>&1
pip install yt-dlp speedtest-cli > /dev/null 2>&1

echo -e "${CIANO}Configurando SSH e GCC...${RESET}"
sshd > /dev/null 2>&1
ln -sf $PREFIX/bin/clang $PREFIX/bin/gcc > /dev/null 2>&1

# ==========================================
# FASE VISUAL: CHECKLIST DAS VERSÕES
# (Isso é o que estava faltando antes)
# ==========================================
clear
echo -e "${AMARELO}${NEGRITO}🔎 CONFERINDO SISTEMA...${RESET}"
echo " "
sleep 1

check_version() {
    if command -v $1 &> /dev/null; then
        echo -e "${CIANO}$2:${RESET} $($3)"
    else
        echo -e "${CIANO}$2:${RESET} ${VERMELHO}Não detectado!${RESET}"
    fi
}

check_version "python" "Python" "python --version"
check_version "node"   "NodeJS" "node -v"
check_version "clang"  "Clang " "clang --version | head -n 1"
check_version "git"    "Git   " "git --version"
echo " "
echo -e "${AMARELO}Gerando Relatório Final...${RESET}"
sleep 3

clear
echo -e "${VERDE}${NEGRITO}=== RELATÓRIO DE INSTALAÇÃO ===${RESET}"
echo " "
[ -f $PREFIX/bin/termux-x11 ] && echo -e "${VERDE}[✓]${RESET} X11 Gráfico" || echo -e "${VERMELHO}[X]${RESET} X11 Falhou"
sleep 0.2
[ -f $PREFIX/bin/sshd ] && echo -e "${VERDE}[✓]${RESET} Servidor SSH" || echo -e "${VERMELHO}[X]${RESET} SSH Falhou"
sleep 0.2
[ -f $PREFIX/bin/yt-dlp ] && echo -e "${VERDE}[✓]${RESET} Youtube-DLP" || echo -e "${VERMELHO}[X]${RESET} yt-dlp Falhou"
sleep 0.2
[ -f $PREFIX/bin/figlet ] && echo -e "${VERDE}[✓]${RESET} Visual (Banner)" || echo -e "${VERMELHO}[X]${RESET} Figlet Falhou"
echo " "
echo -e "${AMARELO}Criando Banner Permanente...${RESET}"
sleep 2

# ==========================================
# CONFIGURAÇÃO FINAL DO .BASHRC
# (O Quadrado Gigante + Android)
# ==========================================

# Limpa configurações antigas
echo "" > ~/.bashrc

# Escreve a nova configuração
cat << 'EOF' >> ~/.bashrc
# --- GABRIEL TERMUX CONFIG ---

# Aliases Úteis
alias atualizar='pkg update && pkg upgrade -y'
alias fechar='pkill termux-x11'
alias ssh-on='sshd && ifconfig | grep inet'
alias cls='clear'
alias limpar='rm -rf ~/.termux/shell_history'

# Limpa a tela ao iniciar
clear

# 1. O BANNER QUADRADO (Estilo Placa)
echo -e "\033[1;35m╔═══════════════════════════════════════════════════════════╗\033[0m"
figlet -f slant "   GABRIEL   " | lolcat
echo -e "\033[1;35m╚═══════════════════════════════════════════════════════════╝\033[0m"

# 2. STATUS DO SISTEMA (Centralizado)
check() {
    if command -v $1 &> /dev/null; then echo -e "\033[1;32mON\033[0m"; else echo -e "\033[1;31mOFF\033[0m"; fi
}

echo -e "    \033[1;33mPYTHON:\033[0m $(check python)   \033[1;33mNODE:\033[0m $(check node)   \033[1;33mSSH:\033[0m $(check sshd)"
echo -e "    \033[1;33mCLANG :\033[0m $(check clang)   \033[1;33mGIT :\033[0m $(check git)    \033[1;33mX11:\033[0m $(check termux-x11)"
echo " "

# 3. INFO DO ANDROID (Alinhada)
neofetch --ascii_distro android --disable packages shell term resolution

EOF

# Recarrega configurações
source ~/.bashrc

# Fim
echo -e "${VERDE}Instalação Completa! Feche o Termux e abra de novo.${RESET}"
