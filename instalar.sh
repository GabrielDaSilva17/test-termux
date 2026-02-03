#!/data/data/com.termux/files/usr/bin/bash

# Para o script se houver erro
set -e

echo "--- 🚀 INICIANDO INSTALAÇÃO AUTOMÁTICA GABRIEL-TERMUX ---"

# 1. Repositórios e Instalação do X11 (Corrigido para evitar 'command not found')
echo "Configurando repositórios e instalando X11..."
pkg update -y
pkg install x11-repo termux-api -y
pkg install termux-x11 sdl2 -y 

# 2. Base de Compilação e Python (Sua estrutura original)
echo "Instalando Python e Compiladores..."
TOOLS=("python" "python-pip" "clang" "make" "binutils" "git" "cmake")
for tool in "${TOOLS[@]}"; do
    pkg install "$tool" -y
done

# Criar atalho do GCC apontando para o Clang
ln -sf $PREFIX/bin/clang $PREFIX/bin/gcc

# 3. Utilitários Extras
echo "Instalando ferramentas de suporte..."
EXTRAS=("curl" "wget" "nano" "htop")
for extra in "${EXTRAS[@]}"; do
    pkg install "$extra" -y
done

echo "--- ✅ AMBIENTE CONFIGURADO ---"

# 4. Download dos arquivos do projeto (C e Header)
echo "Baixando fontes do projeto..."
curl -LO https://raw.githubusercontent.com/GabrielDaSilva17/test-termux/main/config.h
curl -LO https://raw.githubusercontent.com/GabrielDaSilva17/test-termux/main/programa.c

# 5. Compilação
echo "--- 🛠️ COMPILANDO PROGRAMA GRÁFICO ---"
# O compilador usa o programa.c e busca as definições no config.h automaticamente
gcc programa.c -o meu_app -lSDL2

echo "✅ Compilação concluída!"

# 6. Execução Inteligente (Verifica se o X11 já está rodando)
echo "Configurando ambiente gráfico..."

if [ -e /data/data/com.termux/files/usr/tmp/.X11-unix/X0 ]; then
    echo "Servidor X11 já está ativo. Prosseguindo..."
else
    echo "Iniciando novo servidor X11..."
    termux-x11 :0 &
    sleep 2
fi

# Variáveis para evitar erro de MESA e definir a tela
export DISPLAY=:0
export GALLIUM_DRIVER=llvmpipe

echo "🚀 Abrindo o programa..."
./meu_app
