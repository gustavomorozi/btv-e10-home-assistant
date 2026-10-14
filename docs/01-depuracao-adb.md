# 1. Depuração: achar o ADB da caixa

## Por que o cabo USB falha
Em várias TV box o modo "Depuração USB" aparece nas Opções do desenvolvedor, mas o PC **não enumera** o aparelho (erros como "Falha na redefinição de porta" no Windows). Não perca tempo: o ADB por **rede** costuma estar ligado.

## Passo a passo
1. Descubra o IP da caixa (lista de clientes do roteador). Fixe o IP (reserva de DHCP): o IP muda e quebra tudo.
2. Teste a porta 5555 (`adb connect IP:5555`). Se falhar, **não é essa**.
3. Varra as portas TCP do IP:
   - Windows: `scripts/find-adb-port.ps1 -Ip 192.168.0.X`
   - Linux/macOS: `scripts/find-adb-port.sh 192.168.0.X`
   Portas conhecidas que aparecem: 22 (SSH da própria caixa), 554/8080 (apps), e uma **porta alta** (ex.: `11993`) que é o `adbd` em TCP.
4. `adb connect IP:PORTA` e depois `adb devices -l` (deve listar `device`).
5. `adb shell getprop persist.adb.tcp.port` confirma a porta configurada.

Se `adb connect` disser `unauthorized`, aceite o aviso na tela da caixa ("Permitir depuração USB?").

## O que o ADB da caixa permite (usuário `shell`, uid 2000, grupo `input`)
- `pm list packages -3 -f` (apps instalados), `dumpsys ...` (estado do sistema), `screencap -p` (captura de tela).
- `input`, `am`, `monkey`, `sendevent` (ver docs 3 a 6).
- Ele **não é root**: `su` não existe.

## SSH da própria caixa (opcional)
Algumas unidades trazem um servidor SSH antigo (dropbear 0.52) rodando como root. Clientes modernos exigem algoritmos legados:

```
ssh -o KexAlgorithms=+diffie-hellman-group1-sha1 \
    -o HostKeyAlgorithms=+ssh-rsa \
    -o MACs=+hmac-sha1 \
    -o Ciphers=+aes128-cbc,aes256-cbc \
    USUARIO@IP
```
Chave pública pode não funcionar (home em `/sdcard`). **Troque a senha padrão ou desligue o SSH** se não usar.

## Checklist de diagnóstico
- [ ] IP fixo na caixa e no roteador
- [ ] `adb connect IP:PORTA` conectou
- [ ] `adb shell id` → `uid=2000(shell)`
- [ ] Integração `androidtv` do HA com a mesma porta
- [ ] Sinal de Wi-Fi: caixas 2,4 GHz atrasam vídeo; cabo de rede ajuda
