# # Character Sheets
# # Made and designed for AETHERIA
# # @author Insilvon
# # @version 1.0.8
# # Allows players to create and save descriptions of their character for others to view

# # Description Related Commands
# Description:
#     type: command
#     name: description
#     description: Set and manage your character<&sq>s description.
#     usage: /description set|add <&lt>Your Description<&gt>
#     aliases: /d
#     script:
#         - if !<player.has_flag[CurrentCharacter]>:
#             - narrate "You do not have a current character! Set this up first!"
#         - define rawArgs:<context.args>
#         - define id:<player.flag[CurrentCharacter]>
#         - if <[rawArgs].size> == 1:
#             - define command:<[rawArgs].get[1]>
#             - if <[command]> == read:
#                 - yaml "load:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
#                 - narrate "<yaml[<[id]>].read[Description.Text]>"
#                 - yaml unload id:<[id]>
#             - else:
#                 - narrate "Descriptions<&co> Use <&a>/description set<&f> or <&a>/description add."
#                 - narrate "Descriptions<&co> To view another player<&sq>s description, right click them!"
#             - stop
#         - if <[rawArgs].size> == 3:
#             - define command:<[rawArgs].get[1]>
#             - define text:<[rawArgs].get[2]>
#             - yaml "load:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
#             - if <[command]> == set:
#                 - yaml id:<[id]> set Description.Text:<[text]>
#             - if <[command]> == add:
#                 - yaml id:<[id]> set "Description.Text:<yaml[<[id]>].read[Description.Text]> <[text]>"
#             - yaml "savefile:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
#             - yaml unload id:<[id]>
#             - stop
#         - narrate "Descriptions<&co> Use <&a>/description set<&f> or <&a>/description add."
#         - narrate "Descriptions<&co> To view another player<&sq>s description, right click them!"

# BossbarCommand:
#     type: command
#     name: dbossbar
#     description: Null
#     usage: /dbossbar
#     permission: Aetheria.dbossbar
#     script:
Roll:
    type: command
    name: roll
    description: null
    usage: /roll number
    permission: Aetheria.roll
    script:
        - define number:<context.args.get[1]||20>
        - if <[number].is_integer>:
            - define result:<util.random.int[<1>].to[<[number]>]>
            - define color:<&f>
            - if <[number]> == 20:
                - if <[result]> == 20:
                    - define color:<&e>
                - if <[result]> < 20 && <[result]> >= 15:
                    - define color:<&a>
                - if <[result]> < 15 && <[result]> > 8:
                    - define color:<&b>
                - if <[result]> <= 8 && <[result]> > 1:
                    - define color:<&c>
                - if <[result]> == 1:
                    - define color:<&4>
            - narrate "<&e>[Dice]:<&f> <player.name.display> rolled a <[color]><[result]>!" targets:<player.location.find.players.within[<15.15>]>
        - else:
            - narrate "<&e>[Dice]:<&f> Invalid command, please use /roll <&lt>Number<&gt>>"

# SystemRoll:
#     type: procedure
#     definitions: bound
#     script:
#         - narrate "<[bound]>"
#         - define result:<util.random.int[<1>].to.[<[bound]>]>
#         - narrate "<[result]>"
#         - determine <[result]>

