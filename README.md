# BTV E10 + Home Assistant

Guia prático (em português) para **depurar e controlar uma TV box BTV E10** (Android 9, Amlogic, 32 bits) a partir do **Home Assistant**, usando ADB pela rede. Tudo aqui foi testado numa BTV E10 real com Home Assistant OS 2026.10.

> English summary at the bottom.

## O problema que isto resolve
- "Ativei a depuração USB, liguei o cabo e o PC não enxerga a caixa."
- "A integração Android Debug Bridge do HA não conecta (porta 5555 fechada)."
- "Os botões de volume/início pelo Home Assistant demoram 2 a 5 segundos."
- "Como instalo um APK, espelho a tela ou digito texto sem controle remoto?"

## Resumo do que descobrimos
| Assunto | Resultado |
|---|---|
| Depuração USB por cabo | Em muitas unidades a porta OTG não enumera. **Não precisa**: o ADB por rede já pode estar ligado. |
| Porta do ADB | **Não é a 5555.** Nesta caixa era uma porta alta (ex.: `11993`). Varra as portas TCP do IP da caixa. Veja [docs/01-depuracao-adb.md](docs/01-depuracao-adb.md). |
| Integração do HA | "Android Debug Bridge" (`androidtv`) com host e **a porta certa** cria `media_player` e `remote`. |
| Latência | `input keyevent` leva ~2 s (sobe uma JVM). `sendevent` no teclado da caixa leva ~0,5 s direto e ~1,3 s via HA. Veja [docs/03-botoes-sendevent.md](docs/03-botoes-sendevent.md). |
| Espelhar tela | **Miracast é impossível** (Android 9 bloqueia). **Google Cast** e AirPlay funcionam com o app AirScreen. Veja [docs/04-espelhamento.md](docs/04-espelhamento.md). |
| Instalar APK pelo HA | Possível com `androidtv.upload` + `pm install`. Veja [docs/05-instalar-apk.md](docs/05-instalar-apk.md). |
| Teclado e mouse | Texto por `input text`; mouse real exige app tipo "Mouse Toggle". Veja [docs/06-teclado-e-mouse.md](docs/06-teclado-e-mouse.md). |

## Começo rápido
1. Descubra o IP da caixa no roteador e a porta do ADB: `scripts/find-adb-port.ps1` (Windows) ou `scripts/find-adb-port.sh` (Linux/macOS).
2. `adb connect IP:PORTA` e confirme com `adb shell id` (deve mostrar `uid=2000(shell)`).
3. No HA: *Configurações → Dispositivos e serviços → Adicionar integração → Android Debug Bridge*, host `IP`, porta `PORTA`.
4. Copie [`homeassistant/scripts_btv.yaml`](homeassistant/scripts_btv.yaml) para o seu `scripts.yaml` e troque `media_player.android_tv_192_168_0_X` pela sua entidade.
5. (Opcional) instalar APK: [`scripts/instalar-apk-btv.bat`](scripts/instalar-apk-btv.bat) no Windows (arrastar o arquivo).

## Segurança (leia)
- ADB por rede e SSH como root **sem senha forte** dão controle total da caixa a qualquer pessoa na sua rede. Troque senhas padrão, use rede de confiança e não exponha essas portas na internet.
- **Não instale APK de origem desconhecida.** Confira o arquivo no VirusTotal antes. Firmwares e apps de grupos de mensagens podem travar a caixa ou conter malware.
- Nada aqui foi feito para burlar proteções de serviços de terceiros.

## Contribuir
Abra uma *issue* com: modelo exato da caixa, versão do Android (`getprop ro.build.version.release`), saída de `getprop | grep -i adb` e o que já tentou. PRs com outros modelos são bem-vindos (tabela de códigos de tecla, portas de ADB diferentes etc.).

## Licença
MIT. Sem garantia: você mexe no seu aparelho por sua conta e risco.

---

## English summary
Guide (Portuguese docs) to debugging and controlling a **BTV E10 Android 9 TV box** from **Home Assistant** over network ADB:
- USB debugging via cable often never enumerates; network ADB may already be on, **but not on port 5555** (ours was a high port found by scanning).
- Use the *Android Debug Bridge* integration with the right port; `androidtv.adb_command` does not return output.
- `input keyevent` is slow (~2 s, JVM start); use `sendevent /dev/input/event1` (~0.5 s direct, ~1.3 s via HA).
- Miracast is blocked on Android 9 for third-party apps; Google Cast/AirPlay work with AirScreen.
- Install APK from HA with `androidtv.upload` + `pm install` (allowlist the source folder).
