# 3. Botões rápidos: `sendevent` em vez de `input keyevent`

## O problema
`adb shell input keyevent 24` leva **~1,8 a 2,1 s** por tecla nessa caixa (cada comando `input` sobe uma JVM). Via HA com `androidtv.adb_command` chegava a **~5 s**. O ping era 3,7 ms: a rede não é o gargalo.

## A solução
`sendevent` é um programa nativo. Ele escreve direto no teclado da caixa (`/dev/input/event1`, nome `aml_keypad`):

```
sendevent /dev/input/event1 1 <KEY> 1; sendevent /dev/input/event1 0 0 0; sendevent /dev/input/event1 1 <KEY> 0; sendevent /dev/input/event1 0 0 0
```

Medidas: início direto no PC **~0,5 s**; via HA **~1,3 s**.

Como descobrir seu dispositivo/teclas: `adb shell getevent -lp` lista os dispositivos e os códigos que cada um aceita. Seu usuário `shell` precisa estar no grupo `input` (`id` mostra).

## Códigos Linux testados (BTV E10)
| Tecla | Código | Tecla | Código |
|---|---|---|---|
| Início (home) | 102 | Vol + | 115 |
| OK | 353 | Vol − | 114 |
| Cima | 103 | Mudo | 113 |
| Baixo | 108 | Play/Pausa | 164 |
| Esquerda | 105 | Próxima | 163 |
| Direita | 106 | Anterior | 165 |
| Voltar | 158 | Avançar | 208 |
| Menu | 139 | Acordar | 143 |
| Enter | 28 | Backspace | 14 |

Rebobinar: tente `168` (não confirmado). Suspender: `input keyevent 223` (a caixa só suspende, não desliga).

## No Home Assistant
Use `androidtv.adb_command` com `target.entity_id: media_player.android_tv_...`. Veja [`homeassistant/scripts_btv.yaml`](../homeassistant/scripts_btv.yaml): os scripts de volume têm o campo `passos` e usam modo `queued`.

**Atenção:** o HA **não devolve a saída** do comando. O script não sabe se funcionou. Para confirmar, use `adb` no PC.

## Cuidado com testes de volume
Cada toque muda o volume real da TV. Antes/depois leia `adb shell dumpsys audio` (stream `STREAM_MUSIC`, saída HDMI vai de 0 a 15) e restaure.

## Abrir apps e conteúdo
- App: `monkey -p <pacote> -c android.intent.category.LAUNCHER 1` (~6 s a frio).
- URL no YouTube: `am start -a android.intent.action.VIEW -d '<url>' -p com.google.android.youtube.tv`.
