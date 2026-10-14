# 2. Integração com o Home Assistant

## Criar a integração
*Configurações → Dispositivos e serviços → Adicionar integração → **Android Debug Bridge*** (`androidtv`):
- **Host:** o IP da caixa
- **Porta:** a porta real do ADB (**não** a 5555 se for outra)
- Deixe o método "ADB sem chave" se pedir; a caixa já aceitou o PC antes.

Resultado: `media_player.android_tv_<ip>` e `remote.android_tv_<ip>`.

## Serviços úteis
| Serviço | Para quê |
|---|---|
| `androidtv.adb_command` | Roda um comando de shell na caixa (`target.entity_id` = o media_player) |
| `androidtv.upload` | Envia um arquivo do HA para a caixa (precisa de pasta em `allowlist_external_dirs`) |
| `androidtv.download` | Traz um arquivo da caixa |
| `androidtv.learn_sendevent` | Aprende um evento de entrada |

## Limitações importantes
- `adb_command` **não devolve a saída**. Não dá para testar condições (`if` instalou, `if` volume é X).
- O HA mantém uma conexão ADB. Se você abrir o `adb` no PC, às vezes uma sai. Reconectar resolve.
- O IP da caixa muda: **reserve o IP no roteador**, senão a integração fica "indisponível".

## Companion app (alternativa limitada)
O app Companion "minimal" em APK só dá volume, abrir app, TTS e sensores (sem teclas como OK e setas). O ADB cobre mais e é mais confiável.

## Voz (Assist/Gemini)
Dê **apelidos** (aliases) às entidades (por exemplo "receptor", "tv box") e exponha só o que for seguro. Em português, o agente padrão do HA entende poucas frases de script; um agente de LLM (Gemini, por exemplo) entende bem melhor.
Não exponha scripts que instalem aplicativos.
