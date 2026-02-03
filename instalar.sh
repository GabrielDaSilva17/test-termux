#!/data/data/com.termux/files/usr/bin/bash

# Para o script se houver erro
set -e

echo "--- 🚀 INICIANDO INSTALAÇÃO GABRIEL-TERMUX ---"

# 1. Atualização e Repositórios Específicos
echo "Configurando repositórios (X11 e API)..."
pkg update -y
pkg install -y
pkg install x11-repo termux-api -y

# 2. Base de Compilação e Python
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

echo "--- ✅ TUDO PRONTO! ---"
echo "Ambiente configurado com Python, C, Git e API."
