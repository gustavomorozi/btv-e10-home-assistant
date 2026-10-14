# 5. Instalar APK

> **Aviso:** só instale APK de fonte que você conhece e confira no VirusTotal. Deixe esse script **fora** da voz/assistente.

## Do PC (mais simples)
`adb connect IP:PORTA` e `adb install -r app.apk`. O arquivo `scripts/instalar-apk-btv.bat` faz isso arrastando o APK em cima dele.

A caixa é **32 bits (armeabi-v7a)**: APK só de 64 bits não instala.

## Pelo Home Assistant
O HA não tem seletor de arquivo para APK (o envio de mídia só aceita áudio/vídeo/imagem). O fluxo é em 2 passos:

1. **Colocar o arquivo no HA**, por exemplo com o add-on **File editor** (ícone de upload) ou **Samba**, em uma pasta liberada.
2. Rodar o script `btv_instalar_apk` com o caminho do arquivo.

### Pastas liberadas
O serviço `androidtv.upload` só lê pastas de `allowlist_external_dirs`. Por padrão: `/media` e `/config/www`. Para liberar outra pasta (exige reiniciar o HA):

```yaml
homeassistant:
  allowlist_external_dirs:
    - "/config/minha-pasta"
```

### O script
Veja `homeassistant/scripts_btv.yaml` (`btv_instalar_apk`). Ele:
1. aceita o caminho completo (`/homeassistant/...` do File editor vira `/config/...`) ou só o nome (procura em `/config/www/apks`);
2. rejeita `..` e extensões diferentes de `.apk`;
3. `androidtv.upload` para `/sdcard/Download/<nome>`, `pm install -r` e `rm`.

**O HA não recebe o resultado do `pm install`.** Confira na lista de apps da caixa, ou no PC com `adb shell pm list packages -3`.

## Armadilhas
- Não abra um `.apk` no editor de texto do File editor (binário).
- Ao editar o `configuration.yaml`, **confira que salvou** (recarregue a página) antes de validar e reiniciar.
