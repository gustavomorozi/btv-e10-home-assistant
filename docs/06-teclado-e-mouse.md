# 6. Teclado e mouse

## Teclado (texto)
`adb shell input text 'meu%stexto'` digita no campo selecionado:
- espaço vira `%s`;
- **sem acentos** nem emoji;
- leva ~2 s (é um comando `input`).

No HA: um `input_text` (campo no painel) + o script `btv_digitar`, que limpa o texto para `[A-Za-z0-9 .,@_-]`. Também há `btv_enter` (tecla 28) e `btv_apagar` (tecla 14), via `sendevent`.

## Mouse
Mouse real por ADB é ruim: `input tap` e `input swipe` também levam ~2 s cada, então o ponteiro "trava". Opções melhores:
- App que transforma as **setas do controle em ponteiro** (por exemplo, "Mouse Toggle for Android TV"). As setas pelo HA respondem em ~1,3 s.
- Um mouse/teclado USB ou Bluetooth ligado na caixa.
- Dispositivo uinput virtual exigiria root.

Instale o app do mouse só de fonte confiável (ver aviso em [05-instalar-apk](05-instalar-apk.md)).
