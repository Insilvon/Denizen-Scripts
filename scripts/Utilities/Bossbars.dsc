# BossbarCommand:
#     type: command
#     name: dbossbar
#     description: Null
#     usage: /dbossbar
#     permission: Aetheria.dbossbar
#     script:
#         - bossbar TestBar players:<server.list_online_players> "title:Test" color:red
#         - wait 1
#         - bossbar update TestBar progress:0.2
#         - wait 1
#         - bossbar update TestBar progress:0.4
#         - wait 2
#         - bossbar update TestBar progress:0.6
#         - wait 1
#         - bossbar update TestBar progress:0.8
#         - wait 1
#         - bossbar update TestBar progress:1
#         - wait 1
#         - bossbar remove TestBar

RadiationWatcher:
    type: task
    definitions: player
    script:
        - bossbar <[player]>_Radiation players:<[player]> "title:Radiation Level" progress:0.0 color:purple
        - define level:0
        - while <[player].has_flag[Below]> && <[level].as_int> != 14:
            - define delay:<proc[GetRadiationDelayTime].context[<[player]>]>
            - wait <[delay]>s
            - choose <[level].as_int>:
                - case 10:
                    - bossbar update <[player]>_Radiation progress:1
                - case 11:
                    - random:
                        - narrate "<&d>[Ambient]:<&d> *You are now fully exposed to the radiation.*" targets:<[player]>
                        - narrate "<&d>[Ambient]:<&d> *The radiation is approaching lethal levels.*" targets:<[player]>
                        - narrate "<&d>[Ambient]:<&d> *You are beginning to feel sick.*" targets:<[player]>
                    - bossbar update <[player]>_Radiation color:pink
                - case 12:
                    - random:
                        - narrate "<&d>[Ambient]:<&e> *You are in imminent danger of death from radiation.*" targets:<[player]>
                        - narrate "<&d>[Ambient]:<&e> *Your body cannot last much longer.*" targets:<[player]>
                        - narrate "<&d>[Ambient]:<&e> *The radiation is getting into your system. Evacuate.*" targets:<[player]>
                    - bossbar update <[player]>_Radiation color:yellow
                - case 13:
                    - random:
                        - narrate "<&d>[Ambient]:<&4> *You have grown fatigued. If you do not evacuate, you will perish.*" targets:<[player]>
                        - narrate "<&d>[Ambient]:<&4> *The radiation has gotten into your system. Death is imminent.*" targets:<[player]>
                        - narrate "<&d>[Ambient]:<&4> *Your skin feels like it is about to boil.*" targets:<[player]>
                    - bossbar update <[player]>_Radiation color:red
                - default:
                    - random:
                        - narrate "<&d>[Ambient]:<&f> *You are becoming weaker to the radiation.*" targets:<[player]>
                        - narrate "<&d>[Ambient]:<&f> *Your body is losing its strength.*" targets:<[player]>
                        - narrate "<&d>[Ambient]:<&f> *The radiation is starting to weaken your shell.*" targets:<[player]>
                    - bossbar update <[player]>_Radiation progress:0.<[level]>
            - define level:<[level].add_int[1]>
        - if <[level].as_int> == 14:
            - wait <[delay]>s
            - narrate "You died." targets:<[player]>
            - execute as_server "kill <[player].name>"
        - bossbar remove <[player]>_Radiation
GetRadiationDelayTime:
    type: procedure
    definitions: <player>
    script:
        - define base:3
        - if <player.has_flag[RadiationResistance]>:
            - define ResBonus:<player.flag[RadiationResistance]>
            - define base:<[base].add_int[<[ResBonus]>]>
        - determine <[base]>