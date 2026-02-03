# 🚀 Gabriel-Termux Auto-Install

Este repositório contém um script de automação para configurar rapidamente o ambiente de desenvolvimento no **Termux**. Ele instala as ferramentas essenciais para programação em Python, C/C++, suporte a interface gráfica (X11) e utilitários de sistema.

## 🛠️ O que é instalado?

O script realiza a instalação automatizada dos seguintes pacotes:

* **Linguagens:** Python 3 e Pip.
* **Compiladores:** Clang (com atalho para GCC), Make, CMake e Binutils.
* **Gráficos:** X11-Repo, Termux-X11 e biblioteca SDL2.
* **Ferramentas:** Git, Curl, Wget, Nano e Htop.
* **API:** Suporte ao Termux-API.

## 🚀 Como usar

Para configurar o seu Termux instantaneamente, abra o terminal e cole o comando abaixo:

```bash
curl -fsSL https://raw.githubusercontent.com/GabrielDaSilva17/test-termux/main/instalar.sh | bash

