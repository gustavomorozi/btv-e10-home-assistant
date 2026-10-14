# 4. Espelhar a tela do celular ou do PC

## Miracast: não dá
Teste feito: o app AirScreen mostra "Miracast: Desativado" com o aviso de que o Android **bloqueia Miracast para apps de terceiros desde o Android 8**. A BTV E10 usa Android 9, e o Wi-Fi Direct (`p2p0`) fica desligado. O **Smart View da Samsung nunca vai ver** a caixa, nem o Win+K do Windows.

## Cast e AirPlay: funcionam
Instale (ou use, se já veio) o **AirScreen** (`com.ionitech.airscreen`). Aberto na caixa, ele recebe:
- **Google Cast** (portas 8008/8009)
- **AirPlay** (5000/7000)

A caixa aparece com o nome `AS-xxxx[Cast]` (ou o nome que você der em *Nome do dispositivo*).

### PC (Chrome)
Menu ⋮ → Salvar, compartilhar e transmitir → **Transmitir** → escolha a caixa → Fontes → **Transmitir tela**.

### Celular Android
- **Google Home** → *Todos os dispositivos* → *Dispositivos locais* → `AS-xxxx[Cast]` → **Transmitir tela** (ela **não** aparece em Favoritos).
- Apps como YouTube: ícone de Cast.
- Se aparecer "Indisponível", pode haver outra sessão de Cast ativa. Pare a do PC antes.

### iPhone / iPad
AirPlay.

## Qualidade ruim?
O Cast do Chrome comprime o vídeo, e a caixa só tem **Wi-Fi 2,4 GHz** (72 Mbps de link no nosso caso). Texto pequeno fica "mole". O que ajuda de verdade:
1. **Cabo de rede** na caixa (a maioria tem a porta `eth0`).
2. PC no 5 GHz ou por cabo.
3. Escala do Windows 125–150% e zoom no navegador.

O AirScreen não tem opção de qualidade para o Cast (a resolução "Auto" só vale para AirPlay/Miracast).

## Tela estendida (segundo monitor)
O Cast do Chrome só **espelha**. Para estender: monitor virtual no Windows + transmitir essa tela, ou o Spacedesk (software de terceiros nos dois lados).

## Automatizar
O script `btv_espelhar_tela` do arquivo de scripts acorda a caixa e abre o AirScreen. O HA não consegue iniciar a transmissão: esse toque final é de quem está no PC/celular.
