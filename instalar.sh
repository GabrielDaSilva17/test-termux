#!/data/data/com.termux/files/usr/bin/bash

# ==========================================
# GABRIEL-TERMUX ULTRA EDITION 2026 (FINAL v5.6)
# ==========================================
# Fusão das versões 0.5.5 e 0.4.6.1 + Novo Visual
# ==========================================

VERSION="5.6"

# --- CORES E ESTILO ---
R="\e[31m"; G="\e[32m"; Y="\e[33m"; C="\e[36m"; B="\e[1m"; W="\e[0m"; P="\e[35m"

# --- CABEÇALHO ---
clear
echo -e "${Y}${B}============================================${W}"
echo -e "\n${P}   [ GABRIEL-TERMUX v${VERSION} ULTRA ]   ${W}\n"
echo -e "${Y}${B}============================================${W}"
sleep 1

# Salva versão para verificações futuras
echo "$VERSION" > ~/.gabriel_version
# Corrige dpkg travado antes de começar
dpkg --configure -a > /dev/null 2>&1

# --- FUNÇÕES DE LOG ---
msg() { echo -e "${C}➤ $1${W}"; }
ok()  { echo -e "${G}  [OK] Concluído${W}"; }
err() { echo -e "${R}  [X] Falha (Tentando método alternativo...)${W}"; }

# 1. ATUALIZAÇÃO E REPOSITÓRIOS
msg "Atualizando Repositórios e Base..."
pkg update -y > /dev/null 2>&1
pkg upgrade -y -o Dpkg::Options::="--force-confnew" > /dev/null 2>&1
pkg install x11-repo termux-api game-repo tur-repo -y > /dev/null 2>&1
ok

# 2. CORREÇÃO DE CORES (LOLCAT/RUBY)
msg "Configurando Cores (Lolcat)..."
if ! pkg install lolcat -y > /dev/null 2>&1; then
    # Fallback para Ruby se o pacote nativo falhar
    pkg install ruby -y > /dev/null 2>&1 
    gem install lolcat > /dev/null 2>&1
fi
ok

# 3. INSTALAÇÃO DE FERRAMENTAS (LISTA UNIFICADA)
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
    if ! dpkg -s "$PKG" >/dev/null 2>&1; then
        echo -ne "  Installing $PKG... "
        pkg install "$PKG" -y > /dev/null 2>&1 && echo -e "${G}✔${W}" || echo -e "${R}✖${W}"
    fi
done

# 4. REDE PRIVADA (TAILSCALE - LÓGICA V5.5)
msg "Configurando Rede P2P (Tailscale)..."
if pkg install tailscale -y > /dev/null 2>&1; then
    ok
else
    # Download manual inteligente se falhar
    echo -e "${Y}  Baixando binário oficial (Fallback)...${W}"
    ARCH=$(uname -m)
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
        fi
    fi
fi

# 5. PYTHON EXTRAS E ACODEX
msg "Finalizando Python e Web Tools..."
pkg install termux-x11 -y > /dev/null 2>&1
python -m ensurepip --default-pip > /dev/null 2>&1
pip install yt-dlp speedtest-cli > /dev/null 2>&1
ok

msg "Instalando AcodeX Server..."
# Usa o instalador do AcodeX original
curl -sL https://raw.githubusercontent.com/bajrangCoder/acode-plugin-acodex/main/installServer.sh | bash > /dev/null 2>&1
ok

# Links simbólicos úteis
ln -sf $PREFIX/bin/clang $PREFIX/bin/gcc >/dev/null 2>&1
# Inicializa SSH se não estiver rodando
pgrep sshd >/dev/null || sshd >/dev/null 2>&1

# 6. CONFIGURAÇÃO VISUAL .BASHRC (O NOVO VISUAL PEDIDO)
msg "Aplicando Novo Tema Visual..."

# Usando 'EOF' com aspas simples para proteger variáveis $ do script de instalação
cat << 'EOF' > ~/.bashrc
# --- GABRIEL CONFIG v5.6 ---

# Aliases de Produtividade
alias atualizar='pkg update && pkg upgrade -y'
alias fechar='pkill termux-x11'
alias ssh-on='sshd && echo "SSH Iniciado em:" && ifconfig | grep "inet " | grep -v 127.0.0.1'
alias cls='clear'
alias limpar='rm -rf ~/.termux/shell_history'
alias atualizar-setup='curl -fsSL https://raw.githubusercontent.com/GabrielDaSilva17/Termux-Auto-Install/main/instalar.sh | bash'
alias acodex='acodex-server'
alias rede-on='sudo tailscale up'
alias rede-status='tailscale status'
alias code='code-server'

clear

# Função para desenhar o Banner
draw_header() {
    # 1. Nome Gabriel em ASCII Art
    if command -v lolcat &> /dev/null; then
        echo "╔═══════════════════════════════════════════════════════════╗" | lolcat
        figlet -f slant "   GABRIEL   " | lolcat
        echo "╚═══════════════════════════════════════════════════════════╝" | lolcat
    else
        echo "-------------------------------------------------------------"
        echo "                      GABRIEL                                "
        echo "-------------------------------------------------------------"
    fi

    # 2. Grid de Status (Solicitado pelo usuário)
    # Funcao auxiliar para verificar status e colorir
    chk() {
        if command -v $1 &> /dev/null; then
            echo -e "\033[1;32mON\033[0m" # Verde
        else
            echo -e "\033[1;31mOFF\033[0m" # Vermelho
        fi
    }

    # Verifica especificamente o processo do SSH
    chk_ssh() {
        if pgrep sshd &> /dev/null; then echo -e "\033[1;32mON\033[0m"; else echo -e "\033[1;31mOFF\033[0m"; fi
    }

    echo -e "    \033[1;33mPYTHON:\033[0m $(chk python)   \033[1;33mNODE:\033[0m $(chk node)   \033[1;33mSSH:\033[0m $(chk_ssh)"
    echo -e "    \033[1;33mCLANG :\033[0m $(chk clang)   \033[1;33mGIT :\033[0m $(chk git)    \033[1;33mX11:\033[0m $(chk termux-x11)"
    echo -e "    \033[1;33mACODEX:\033[0m $(chk acodex-server)"
    echo " "
}

draw_header

# 3. Informações do Sistema (Estilo Android)
# Força o logo Android e desativa info desnecessária para ficar limpo
neofetch --ascii_distro android --disable packages shell term resolution --color_blocks off

# 4. Prompt Personalizado
export PS1='\[\e[1;32m\]Gabriel\[\e[0m\]@\[\e[1;34m\]Termux\[\e[0m\]:\[\e[1;33m\]\w\[\e[0m\] $ '

EOF

# Recarrega para aplicar imediatamente
source ~/.bashrc

echo -e "\n${G}${B}INSTALAÇÃO COMPLETA (v$VERSION)!${W}"
echo -e "${C}Reinicie o Termux ou digite 'source ~/.bashrc' para ver o novo visual.${W}"
