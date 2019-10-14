# GetRenownValue:
#     type: procedure
#     speed: instant
#     definitions: player|faction
#     script:
#         - narrate "Searching for <[player]> and <[faction]>" targets:<server.match_player[Insilvon]>
#         - define character <proc[GetCharacterName].context[<[player]>]>
#         - narrate "Searching YAML for <[player]> and Renown.<[Faction]>"
#         - define value:<proc[GetCharacterYAML].context[<[player]>|Renown.<[faction]>]>
#         - narrate "Found <[value]>"
#         - determine <[value]>
GetRenownStatus:
    type: procedure
    speed: instant
    definitions: player|faction
    script:
        - narrate "Searching for <[player]> and <[faction]>" targets:<server.match_player[Insilvon]>
        - define character <proc[GetCharacterName].context[<[player]>]>
        - define value:<proc[GetCharacterYAML].context[<[player]>|Renown.<[faction]>]>
        - narrate "<[value]>" targets:<server.match_player[Insilvon]>
        - if <[value]> >= 0:
            - if <[value]> <= 50:
                - define status:unknown
            - if <[value]> <= 150:
                - define status:liked
            - if <[value]> <= 300:
                - define status:admired
            - else:
                - define status:hero
        - else:
            - if <[value]> >= -50:
                - define status:unknown
            - if <[value]> >= -150:
                - define status:disliked
            - if <[value]> >= -350:
                - define status:shunned
            - else:
                - define status:despised
        - determine li@<[status]>|<[value]>
ModifyRenownValue:
    type: task
    definitions: player|faction|value
    script:
        - define character:<proc[GetCharacterName].context[<[player]>]>
        - run ModifyCharacterYAML def:<[player]>|Renown.<[faction]>|<[value]>
RenownFlagUpdater:
    type: task
    script:
        - flag player renown_<proc[GetCharacterName].context[<player>]>_Skyborne:<proc[GetCharacterYAML].context[<player>|renown.Skyborne]>
        - flag player renown_<proc[GetCharacterName].context[<player>]>_ChildrenOfTheSun:<proc[GetCharacterYAML].context[<player>|renown.ChildrenoftheSun]>
        - flag player renown_<proc[GetCharacterName].context[<player>]>_Outsiders:<proc[GetCharacterYAML].context[<player>|renown.Outsiders]>