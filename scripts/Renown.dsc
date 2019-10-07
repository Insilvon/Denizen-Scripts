GetRenownValue:
    type: procedure
    speed: instant
    definitions: player|faction
    script:
        - narrate "Searching for <[player]> and <[faction]>" targets:<server.match_player[Insilvon]>
        - define character <proc[GetCharacterName].context[<[player]>]>
        - narrate "Searching YAML for <[player]> and Renown.<[Faction]>"
        - define value:<proc[GetCharacterYAML].context[<[player]>|Renown.<[faction]>]>
        - narrate "Found <[value]>"
        - determine <[value]>
GetRenownStatus:
    type: procedure
    speed: instant
    definitions: player|faction
    script:
        - narrate "Searching for <[player]> and <[faction]>" targets:<server.match_player[Insilvon]>
        - define value:<proc[GetRenownValue].context[<[player]>|<[Faction]>]>
        - narrate "<[value]>" targets:<server.match_player[Insilvon]>
        - if <[value]> > 0:
            - if <[value]> <= 50:
                - determine unknown
            - if <[value]> <= 150:
                - determine liked
            - if <[value]> <= 300:
                - determine admired
            - else:
                - determine hero
        - else:
            - if <[value]> >= -50:
                - determine unknown
            - if <[value]> >= -150:
                - determine disliked
            - if <[value]> >= -350:
                - determine shunned
            - else:
                - determine despised
ModifyRenownValue:
    type: task
    definitions: player|faction|value
    script:
        - define character:<proc[GetCharacterName].context[<[player]>]>
        - run ModifyCharacterYAML def:<[player]>|Renown.<[faction]>|<[value]>