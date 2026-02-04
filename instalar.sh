#!/data/data/com.termux/files/usr/bin/bash

# ==========================================
# GABRIEL-TERMUX ULTRA EDITION 2026 (POLISHED)
# ==========================================

VERSION="0.5.5"

# --- CORES E ESTILO ---
R="\e[31m"; G="\e[32m"; Y="\e[33m"; C="\e[36m"; B="\e[1m"; W="\e[0m"

# --- CABEÇALHO ---
clear
echo -e "${Y}${B}============================================${W}"
echo -e "\n${C}   [ GABRIEL-TERMUX v${VERSION} ]   ${W}\n"
echo -e "${Y}${B}============================================${W}"
sleep 1

# Salva versão
echo "$VERSION" > ~/.gabriel_version
dpkg --configure -a > /dev/null 2>&1

# Funções de Log
msg() { echo -e "${C}➤ $1${W}"; }
ok()  { echo -e "${G}  [OK] Concluído${W}"; }
err() { echo -e "${R}  [X] Falha (Tentando método alternativo...)${W}"; }

# 1. ATUALIZAÇÃO INICIAL
msg "Atualizando Repositórios..."
pkg update -y > /dev/null 2>&1
pkg install x11-repo termux-api game-repo tur-repo -y > /dev/null 2>&1
ok

# 2. PACOTES ESPECIAIS (Cores)
msg "Instalando Lolcat..."
if ! pkg install lolcat -y > /dev/null 2>&1; then
    pkg install ruby -y > /dev/null 2>&1 && gem install lolcat > /dev/null 2>&1
fi
ok

# 3. LISTA DE FERRAMENTAS
msg "Instalando Ferramentas Essenciais..."
PACOTES=(
    "figlet" "ncurses-utils" "git" "python" "clang" "make" "cmake" 
    "binutils" "curl" "wget" "perl" "ruby" "php" "nodejs" "bash" 
    "nano" "zip" "unzip" "openssl" "openssh" "zsh" "ffmpeg" "htop" 
    "screen" "jq" "rsync" "tree" "termux-api" "neofetch" "cmatrix" 
    "cowsay" "fortune" "sl" "ranger" "xorgproto" "proot" "proot-distro" 
    "tsu" "man" "vim" "proxychains-ng" "code-server" "sdl2"
)

for PKG in "${PACOTES[@]}"; do
    # Só instala se não tiver
    if ! dpkg -s "$PKG" >/dev/null 2>&1; then
        echo -ne "  Installing $PKG... "
        pkg install "$PKG" -y > /dev/null 2>&1 && echo -e "${G}✔${W}" || echo -e "${R}✖${W}"
    fi
done

# 4. REDE PRIVADA (TAILSCALE - LÓGICA ROBUSTA)
msg "Configurando Rede P2P (Tailscale)..."
if pkg install tailscale -y > /dev/null 2>&1; then
    ok
else
    err
    echo -e "${Y}  Baixando binário oficial...${W}"
    ARCH=$(uname -m)
    # Detecta arquitetura
    case $ARCH in
        aarch64) URL_PART="arm64" ;;
        arm*)    URL_PART="arm" ;;
        *)       URL_PART="unknown" ;;
    esac

    if [ "$URL_PART" != "unknown" ]; then
        wget -q "https://pkgs.tailscale.com/stable/tailscale_1.58.2_${URL_PART}.tgz" -O ts.tgz
        if [ -f ts.tgz ]; then
            tar xzf ts.tgz > /dev/null 2>&1
            DIR=$(find . -maxdepth 1 -type d -name "tailscale_*")
            cp "$DIR/tailscale" "$PREFIX/bin/" 2>/dev/null
            cp "$DIR/tailscaled" "$PREFIX/bin/" 2>/dev/null
            chmod +x $PREFIX/bin/tailscale*
            rm -rf ts.tgz "$DIR"
            ok
        else
            echo -e "${R}  Erro no download manual.${W}"
        fi
    else
        echo -e "${R}  Arquitetura não suportada ($ARCH)${W}"
    fi
fi

# 5. GRÁFICOS E CONFIGS
msg "Finalizando X11 e Python..."
pkg install termux-x11 -y > /dev/null 2>&1
python -m ensurepip --default-pip > /dev/null 2>&1
pip install yt-dlp speedtest-cli > /dev/null 2>&1
ok

msg "AcodeX Server..."
curl -sL https://raw.githubusercontent.com/bajrangCoder/acode-plugin-acodex/main/installServer.sh | bash > /dev/null 2>&1
ok

# Links simbólicos
ln -sf $PREFIX/bin/clang $PREFIX/bin/gcc >/dev/null 2>&1
sshd >/dev/null 2>&1

# 6. CRIAÇÃO DO .BASHRC (MODO SEGURO)
# Usando 'EOF' com aspas para evitar expansão prematura de variáveis
cat << 'EOF' > ~/.bashrc
# --- GABRIEL CONFIG v0.5.5 ---
alias atualizar='pkg update && pkg upgrade -y'
alias fechar='pkill termux-x11'
alias ssh-on='sshd && echo "SSH Iniciado" && ifconfig | grep inet'
alias cls='clear'
alias limpar='rm -rf ~/.termux/shell_history'
alias atualizar-setup='curl -fsSL https://raw.githubusercontent.com/GabrielDaSilva17/Termux-Auto-Install/main/instalar.sh | bash'
alias acodex='acodex-server'
alias rede-on='sudo tailscale up'
alias rede-status='tailscale status'

clear

# Banner
if command -v lolcat &> /dev/null; then
    echo "╔════════════════════════════════════════╗" | lolcat
    figlet -f slant " GABRIEL " | lolcat
    echo "╚════════════════════════════════════════╝" | lolcat
fi

# Status Checker
check() {
    command -v $1 &> /dev/null && echo -e "\e[32mON\e[0m" || echo -e "\e[31mOFF\e[0m"
}

echo -e " PYTHON: $(check python)  NODE: $(check node)  SSH: $(check sshd)"
echo -e " CLANG : $(check clang)  ACODEX: $(check axs)  REDE: $(check tailscale)"

# Update Checker (Rápido)
check_up() {
    LOCAL=$(cat ~/.gabriel_version 2>/dev/null || echo "0")
    REMOTE=$(curl -sL --max-time 2 "https://raw.githubusercontent.com/GabrielDaSilva17/Termux-Auto-Install/main/instalar.sh" | grep '^VERSION="' | head -1 | cut -d'"' -f2)
    if [ ! -z "$REMOTE" ] && [ "$REMOTE" != "$LOCAL" ]; then
        echo -e "\n\e[1;32m⚡ ATUALIZAÇÃO: $REMOTE (Digite 'atualizar-setup') ⚡\e[0m\n"
    fi
}
check_up

neofetch --ascii_distro android --disable packages shell term resolution
export PS1='\[\e[1;32m\]Gabriel\[\e[0m\]@\[\e[1;34m\]Termux\[\e[0m\]:\[\e[1;33m\]\w\[\e[0m\] $ '
EOF

source ~/.bashrc

echo -e "\n${G}${B}INSTALAÇÃO COMPLETA! Reinicie o Termux.${W}"


