#!/bin/bash
echo "[*] Resetting container 04 - Dead Laptop..."
docker compose down -v
docker compose up --build -d
echo "[+] Done!"
