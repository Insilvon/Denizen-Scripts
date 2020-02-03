RPChatController:
    type: world
    debug: false
    events:
        on player chats:
            - determine cancelled passively
            - if <player.flag[mode]||null> == builder:
                - narrate <context.message.parse_color> format:BuildFormat
            - else:
                - if <context.message.contains_text[((]> && <context.message.contains_text[))]>:
                    - define prev:<player.flag[chat_channel]||casual>
                    - flag player chat_channel:OOC2
                - choose <player.flag[chat_channel]||OOC>:
                    - case Whisper:
                        - narrate <context.message.parse_color> targets:<player.location.find.players.within[<2.2>]> format:WhisperFormat
                    - case Hush:
                        - narrate <context.message.parse_color> targets:<player.location.find.players.within[<6.6>]> format:HushFormat
                    - case Casual:
                        - narrate <context.message.parse_color> targets:<player.location.find.players.within[<20.20>]> format:CasualFormat
                    - case Shout:
                        - narrate <context.message.parse_color> targets:<player.location.find.players.within[<35.35>]> format:ShoutFormat
                    - case Shriek:
                        - narrate <context.message.parse_color> targets:<player.location.find.players.within[<45.45>]> format:ShriekFormat
                    - case OOC:
                        - narrate <context.message.parse_color> targets:<server.list_online_players> format:OOCFormat
                    - case OOC2:
                        - narrate <context.message.parse_color> targets:<server.list_online_players> format:OOC2Format
                        - flag player chat_channel:<[prev]>
                    - case Global:
                        - narrate <context.message.parse_color> targets:<server.list_online_players> format:GlobalFormat
                    - default:
                        - narrate <context.message.parse_color> format:OOCFormat
            - define channel:<discord[mybot].group[Aetheria].channel[big-sister]>
            - define "message:**<proc[GetCharacterName].context[<player>]>** *<&lb><player.flag[chat_channel]||OOC><&rb>* » <context.message>"
            - ~discord id:mybot message channel:<[channel]> <[message]>
# RPFormat:
#     type: format
#     format: "<&3>[RP-DEV]<&co><&f><text>"


WhisperFormat:
    type: format
    format: "<&7>[W]<&f> <player.name.display><&co> <&7><text>"
HushFormat:
    type: format
    format: "<&3>[H]<&f> <player.name.display><&co> <&3><text>"
CasualFormat:
    type: format
    format: "<&a>[C]<&f> <player.name.display><&co> <&a><text>"
ShoutFormat:
    type: format
    format: "<&c>[S]<&f> <player.name.display><&co> <&c><text>"
ShriekFormat:
    type: format
    format: "<&4>[SR]<&f> <player.name.display><&co> <&4><text>"
OOCFormat:
    type: format
    format: "<&8>[OOC]<&f> <player.name.display><&co> <&8>((<text>))"
OOC2Format:
    type: format
    format: "<&8>[OOC]<&f> <player.name.display><&co> <&8><text>"
GlobalFormat:
    type: format
    format: "<&2>[G]<&f> <player.name.display><&co> <&2><text>"
BuildFormat:
    type: format
    format: "<&e>[DEV]<&f> <player.name.display><&co> <&e><text>"

ChatCommand:
    type: command
    debug: false
    name: ch
    description: no
    usage: /ch
    script:
        - define channel:<context.args.get[1]||null>:
        - choose <[channel]>:
            - case Whisper:
                - flag player chat_channel:Whisper
                - narrate "You are now speaking in Whisper"
            - case Hush:
                - flag player chat_channel:Hush
                - narrate "You are now speaking in Hush"
            - case Casual:
                - flag player chat_channel:Casual
                - narrate "You are now speaking in Casual"
            - case Shout:
                - flag player chat_channel:Shout
                - narrate "You are now speaking in Shout"
            - case Shriek:
                - flag player chat_channel:Shriek
                - narrate "You are now speaking in Shriek"
            - case OOC:
                - flag player chat_channel:OOC
                - narrate "You are now speaking in OOC"
            - case Global:
                - flag player chat_channel:Global
                - narrate "You are now speaking in Global"
            - case w:
                - flag player chat_channel:Whisper
                - narrate "You are now speaking in Whisper"
            - case h:
                - flag player chat_channel:Hush
                - narrate "You are now speaking in Hush"
            - case c:
                - flag player chat_channel:Casual
                - narrate "You are now speaking in Casual"
            - case s:
                - flag player chat_channel:Shout
                - narrate "You are now speaking in Shout"
            - case sr:
                - flag player chat_channel:Shriek
                - narrate "You are now speaking in Shriek"
            - case o:
                - flag player chat_channel:OOC
                - narrate "You are now speaking in OOC"
            - case g:
                - flag player chat_channel:Global
                - narrate "You are now speaking in Global"
            - case help:
                - inject ChatHelp
            - default:
                - flag player chat_channel:Casual
                - narrate "You are now speaking in Casual"
ChatHelp:
    type: task
    debug: false
    script:
        - narrate "<&e>Help Menu - Page One-----------<&gt>" format:ChatFormat
        - narrate "/ch w | whisper - range of 2 blocks."
        - narrate "/ch h | hush - range of 6 blocks."
        - narrate "/ch c | casual - range of 20 blocks."
        - narrate "/ch s | shout - range of 35 blocks."
        - narrate "/ch sr | shriek - range of 45 blocks."
        - narrate "/ch o | ooc - unlimited range."
        - narrate "/ch g | global - unlimited range"