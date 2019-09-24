# Character Sheets
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.8
# Allows players to create and save descriptions of their character for others to view

# Description Related Commands
Description:
    type: command
    name: description
    description: Set and manage your character<&sq>s description.
    usage: /description set|add <&lt>Your Description<&gt>
    aliases: /d
    script:
        - if !<player.has_flag[CurrentCharacter]>:
            - narrate "You do not have a current character! Set this up first!"
        - define rawArgs:<context.args>
        - define id:<player.flag[CurrentCharacter]>
        - if <[rawArgs].size> == 1:
            - define command:<[rawArgs].get[1]>
            - if <[command]> == read:
                - yaml "load:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
                - narrate "<yaml[<[id]>].read[Description.Text]>"
                - yaml unload id:<[id]>
            - else:
                - narrate "Descriptions<&co> Use <&a>/description set<&f> or <&a>/description add."
                - narrate "Descriptions<&co> To view another player<&sq>s description, right click them!"
            - stop
        - if <[rawArgs].size> == 3:
            - define command:<[rawArgs].get[1]>
            - define text:<[rawArgs].get[2]>
            - yaml "load:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
            - if <[command]> == set:
                - yaml id:<[id]> set Description.Text:<[text]>
            - if <[command]> == add:
                - yaml id:<[id]> set "Description.Text:<yaml[<[id]>].read[Description.Text]> <[text]>"
            - yaml "savefile:/CharacterSheets/<player.uuid>/<[id]>.yml" id:<[id]>
            - yaml unload id:<[id]>
            - stop
        - narrate "Descriptions<&co> Use <&a>/description set<&f> or <&a>/description add."
        - narrate "Descriptions<&co> To view another player<&sq>s description, right click them!"

SetCharacterYAML:
    type: task
    definitions: player|key|value
    script:
        - define id:<[player].flag[CurrentCharacter]>
        - ~yaml "load:/CharacterSheets/<[player].uuid>/<[id]>.yml" id:<[player]>
        - ~yaml id:<[player]> set <[key]>:<[value]>
        - ~yaml "savefile:/CharacterSheets/<[player].uuid>/<[id]>.yml" id:<[player]>
        - ~yaml unload id:<[player]>

# Gets this character's base name
# Could be replaced, purely here for accessibility
GetCharacterName:
    type: procedure
    definitions: player
    script:
        - determine <proc[GetCharacterYAML].context[<[player]>|Info.Character_Name]>
# Gets the last known location of this player
GetCharacterLocation:
    type: procedure
    definitions: player
    script:
        - determine <proc[GetCharacterYAML].context[<[player]>|Info.Character_Location]>
# Gets the name of the town the player is currently a member of
GetCharacterTown:
    type: procedure
    definitions: player
    script:
        - determine <proc[GetCharacterYAML].context[<[player]>|Town.Name]>
# General utility to access character sheet info
GetCharacterYAML:
    type: procedure
    definitions: player|key
    script:
        - define character:<[player].flag[CurrentCharacter]>
        - yaml load:/CharacterSheets/<[player].uuid>/<[character]>.yml id:<[character]>
        - define result:<yaml[<[character]>].read[<[key]>]>
        - yaml unload id:<[character]>
        - determine <[result]>

CharacterHasTown:
    type: procedure
    definitions: player
    script:
        - define town:<proc[GetCharacterTown].context[<player>]>
        - if <[town]> == none:
            - determine false
        - else:
            - determine true