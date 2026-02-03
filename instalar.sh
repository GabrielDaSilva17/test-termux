#!/bin/bash

echo "Iniciando a automação de instalação..."

# Atualiza a lista de pacotes
pkg update && pkg upgrade -y  # No Termux use pkg, no Ubuntu use sudo apt update

# Lista de ferramentas para instalar
TOOLS=("python" "clang" "gcc" "git" "make")

for tool in "${TOOLS[@]}"; do
    echo "Instalando $tool..."
    pkg install "$tool" -y
done

echo "Tudo pronto! Python, C e compiladores instalados."
