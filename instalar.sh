#!/data/data/com.termux/files/usr/bin/bash

# Para o script se houver erro
set -e

echo "--- 🚀 INICIANDO INSTALAÇÃO GABRIEL-TERMUX ---"

# 1. Atualização Geral
echo "Atualizando repositórios..."
pkg update -y && pkg upgrade -y

# 2. Base de Compilação e Python
echo "Instalando Python e Compiladores..."
TOOLS=("python" "python-pip" "clang" "make" "binutils" "git" "cmake")
for tool in "${TOOLS[@]}"; do
    pkg install "$tool" -y
done

# Criar atalho do GCC apontando para o Clang (necessário no Termux)
ln -sf $PREFIX/bin/clang $PREFIX/bin/gcc

# 3. Ativando Repositórios Específicos (X11 e API)
echo "Configurando repositórios X11 e API..."
pkg install x11-repo termux-api -y

# 4. Utilitários Essenciais
echo "Instalando ferramentas extras..."
EXTRAS=("curl" "wget" "nano" "htop")
for extra in "${EXTRAS[@]}"; do
    pkg install "$extra" -y
done

echo "--- ✅ TUDO PRONTO! ---"
echo "Python, C (GCC/Clang), Git e Termux-API configurados."
