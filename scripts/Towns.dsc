# Towns Proof of Concept
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.1.0
# Allows players to claim towns, manage their resources, and dominate their enemies
# /town raid|claim|invite|promote|info|

# =================================================================================
# ==================================Core Command===================================
# =================================================================================
# TownController:
#     type: world
#     events:
#         on system time hourly:
            
TownFoodCheck:
    type: task
    script:
        - foreach <server.flag[TownList].as_list> as:town:
            - ~yaml load:Towns/<[town]>.yml id:<[town]>
            - define townFarmers:<yaml[<[town]>].read[NPCs.Farmer]>
            - define addition:<[townFarmers].mul_int[3]>
            - define townFood:<yaml[<[town]>].read[Resources.Food].add_int[<[addition]>]>
            - define totalNPCs:<yaml[<[town]>].read[NPCs.Total]>
            - define hunger:<[totalNPCs]>
            - define townFood:<[townFood].sub_int[<[hunger]>]>
            - if <[townFood]> < 0:
                - narrate "Your town is hungry!"
                - yaml id:<[town]> set Town.Satisfaction:-:1
            - else:
                - narrate "Your town is doing okay."
                - yaml id:<[town]> set Town.Satisfaction:+:1
            - yaml id:<[town]> set Resources.Food:<[townFood]>
            - ~yaml "savefile:/Towns/<[town]>.yml" id:<[town]>
            - yaml unload id:<[town]>
# Core Town Command
TownCommand:
    type: command
    name: town
    description: (DEV) Creates a town using active flags
    usage: /town create name
    script:
        - define args:<context.args>
        - if <[args].size> == 1:
            - define command:<[args].get[1]>
            - if <[command]> == info:
                - inject TownInfo
            - if <[command]> == leave:
                - inject TownLeave
            - run TownHelp
        - if <[args].size> == 2:
            - define command:<[args].get[1]>
            - foreach claim|raid|invite|create|join|surrender as:switch:
                - if <[args].get[1]> == <[switch]>:
                    - inject Town<[switch]>
        - if <[args].size> == 3:
            - define command:<[args].get[1]>
            - if <[command]> == promote:
                - inject TownPromote
        - run TownHelp

# =================================================================================
# ===========================Core Command Task Scripts=============================
# =================================================================================

# Narrates to display when /town help is run or command is invalid
# TODO - add formatting
TownHelp:
    type: task
    script:
        - narrate "/town claim <name>"
        - narrate "/town raid <townname>"
        - narrate "/town invite <username>"
        - narrate "/town promote <username>"
        - narrate "/town info"

# /Town Info - displays current statistics about the player town.
TownInfo:
    type: task
    script:
        - define name:<proc[GetCharacterTown].context[<player>]||null>
        - if <[name]> == null || <[name]> == none:
            - narrate "You are not a member of a town!"
            - stop
        - ~yaml "load:/Towns/<[name]>.yml" id:<[name]>
        - narrate "[Town] - Showing info for <[name]><&co> Satisfaction - <yaml[<[name]>].read[Town.Satisfaction]>"
        - narrate "<&b>[<[name]>] - RESOURCES"
        - narrate "<&b>[<[name]>] -    Building Materials: <&f><yaml[<[name]>].read[Resources.BuildingMaterials]>"
        - narrate "<&b>[<[name]>] -    Crafting Materials: <&f><yaml[<[name]>].read[Resources.CraftingMaterials]>"
        - narrate "<&b>[<[name]>] -    Food: <&f><yaml[<[name]>].read[Resources.Food]>"
        - narrate "<&b>[<[name]>] -    Minerals: <&f><yaml[<[name]>].read[Resources.Minerals]>"
        - narrate "<&b>[<[name]>] -    Weapons: <&f><yaml[<[name]>].read[Resources.Weapons]>"
        - narrate "<&e>[<[name]>] - VILLAGERS"
        - narrate "<&e>[<[name]>] -    Farmers: <&f><yaml[<[name]>].read[NPCs.Farmer]>"
        - narrate "<&e>[<[name]>] -    Blacksmiths: <&f><yaml[<[name]>].read[NPCs.Blacksmith]>"
        - narrate "<&e>[<[name]>] -    Miners: <&f><yaml[<[name]>].read[NPCs.Miner]>"
        - narrate "<&e>[<[name]>] -    Woodcutters: <&f><yaml[<[name]>].read[NPCs.Woodcutter]>"
        - narrate "<&e>[<[name]>] -    Trainers <&f><yaml[<[name]>].read[NPCs.Trainer]>"
        - narrate "<&e>[<[name]>] -    Alchemists: <&f><yaml[<[name]>].read[NPCs.Alchemist]>"
        - narrate "<&a>[<[name]>] - MILITIA"
        - narrate "<&a>[<[name]>] -    Infantry: <&f><yaml[<[name]>].read[Militia.Infantry]>"
        - narrate "<&a>[<[name]>] -    Sentry: <&f><yaml[<[name]>].read[Militia.Sentry]>"
        - narrate "<&a>[<[name]>] -    Archer: <&f><yaml[<[name]>].read[Militia.Archer]>"
        - narrate "<&a>[<[name]>] -    Mage: <&f><yaml[<[name]>].read[Militia.Mage]>"
        - narrate "<&a>[<[name]>] -    Miniboss: <&f><yaml[<[name]>].read[Militia.Miniboss]>"
        - narrate "<&a>[<[name]>] -    Boss: <&f><yaml[<[name]>].read[Militia.Boss]>"
        - ~yaml unload id:<[name]>
        - stop

# /town claim
# TODO - change this to a 3-arger and allow for /town claim name
TownClaim:
    type: task
    script:
        - if !<player.has_flag[CurrentCharacter]>:
            - narrate "You need to have a character to perform this!"
            - stop
        - define town:<proc[GetCharacterTown].context[<player>]>
        - if <[town]> != none:
            - narrate "You are already a part of a town! You cannot claim this town."
            - narrate "Leave your town with /town leave."
            - stop
        - define name:<[args].get[2]>
        - define owner:<proc[GetTownOwnerUUID].context[<[name]>]>
        - if <[owner]> == none:
            - narrate "You have assumed control over <[name]>."
            - run SetTownYAML def:<[name]>|Town.Owner|<player.uuid>
            - run SetTownYAML def:<[name]>|Town.OwnerName|<proc[GetCharacterName].context[<player>]>
            - flag server <player.name>_townClaimInvite:!
            # set the name in the new owner's file
            - run SetCharacterYAML def:<player>|Town.Name|<[name]>
            - stop
        - else:
            - if <server.has_flag[<player.name>_townClaimInvite]>:
                - if <server.flag[<player.name>_townClaimInvite]> == <[name]>:
                    - narrate "You have assumed control over <[name]>."
                    - run SetTownYAML def:<[name]>|Town.Owner|<player.uuid>
                    - run SetTownYAML def:<[name]>|Town.OwnerName|<proc[GetCharacterName].context[<player>]>
                    - flag server <player.name>_townClaimInvite:!
                    # remove the old owner from the town
                    - run SetCharacterYAML def:<[owner]>|Town.Name|none
                    # set the name in the new owner's file
                    - run SetCharacterYAML def:<player>|Town.Name|<[name]>
                    - stop
            - narrate "Nobody has surrendered their town to you."
        - stop

# /town invite <playername> - allows players to invite others to their town
TownInvite:
    type: task
    script:
        - define town:<proc[GetCharacterTown].context[<player>]>
        - define target:<server.match_player[<[args].get[2]>]||null>
        - if <[town]> == "":
            - narrate "You are not a member of a town!"
            - stop
        - define owner:<proc[CheckTownOwner].context[<player>]>
        - if !<[owner]>:
            - narrate "You are not the owner of that town!"
            - stop
        - if <[target]> == null:
            - narrate "That player is not online!"
            - stop
        - if <[target]> == <player.name>:
            - narrate "You cannot invite yourself!"
            - stop
        - narrate "You have invited <[target].name> to your town."
        - narrate "You have been invited to join the town of <[town]>." targets:<[target]||null>
        - narrate "Use /town join <[town]> to accept." targets:<[target]||null>
        - flag server <[target].name>_townInvite:<[town]> duration:5m
        - stop

# /town join <name> - allows players to join towns they are actively invited to
TownJoin:
    type: task
    script:
        - if !<player.has_flag[CurrentCharacter]>:
            - narrate "You do not have a character selected!"
            - stop
        - define target:<[args].get[2]>
        - if <server.has_flag[<player.name>_townInvite]>:
            - if <server.flag[<player.name>_townInvite]> == <[target]>:
                - narrate "You have joined the town of <[target]>."
                - run SetCharacterYAML def:<player>|Town.Name|<[target]>
                # Add the BASE NAME of this person, not the current display name
                - run TownAddMember def:<[target]>|<proc[GetCharacterName].context[<player>]>
                - stop
        - narrate "You have not been invited to <[target]>."
        - stop

TownLeave:
    type: task
    script:
        - if !<proc[CharacterHasTown].context[<player>]>:
            - narrate "You are not a member of a town!"
            - stop
        - define owner:<proc[CheckTownOwner].context[<player>]>
        - narrate "<[owner]>"
        - if <[owner]>:
            - narrate "You are the owner. Are you sure? Run /town disband"
            - stop
        - else:
            - narrate "You have left your town"
            - run SetCharacterYAML def:<player>|Town.Name|none
            - stop
TownSurrender:
    type: task
    script:
        - if <[proc[CharacterHasTown].context[<player>]> == false:
            - narrate "You are not a member of a town!"
            - stop
        - if !<proc[CheckTownOwner].context[<player>]>:
            - narrate "You are not the owner of this town!"
            - stop
        - define target:<server.match_player[<[args].get[2]>]||null>
        - if <[target]> == null:
            - narrate "That player is not online!"
            - stop
        - define town:<proc[GetCharacterTown].context[<player>]>
        - narrate "You have offered ownership of your town to <proc[GetCharacterName].context[<[target]>]>."
        - narrate "You have been invited to command the town of <[town]>." targets:<[target]||null>
        - narrate "Use /town claim <[town]> to accept." targets:<[target]||null>
        - flag server <[target].name>_townClaimInvite:<[town]> duration:5m
        - stop
# /town promote name rank - lets players promote other members of the town to specific titles
TownPromote:
    type: task
    script:
        - define target:<server.match_player[<[args].get[2]>]||null>
        # Are you even the owner?
        - define town:<proc[GetCharacterTown].context[<player>]>
        - if <proc[GetTownOwner]>.context[<[town]>]> != <player.name>:
            - narrate "You are not the owner of your town - you can<&sq>t promote people."
            - stop
        # Are they online?
        - if <[target]> == null:
            - narrate "That player is not online!"
            - stop
        - define target_town:<proc[GetCharacterTown].context[<[target]>]>
        # Are they in the town?
        - if town != target_town:
            - narrate "That player is not a member of your town!"
        - stop

# Developer Command which creates a new town at the given location. Uses Denizen pos1/pos2 flags to identify the cuboid.
TownCreate:
    type: task
    script:
        - define pos1:<player.flag[pos1]>
        - define pos2:<player.flag[pos2]>
        - define name:<[args].get[2]>
        - if !<server.has_file[/Towns/<[name]>.yml]>:
            - inject TownCreateHelper
        - else:
            - narrate "Town - Town already exists!"

# Helper for TownCreate
# TODO: Generalize this and fit it into /town claim
TownCreateHelper:
    type: task
    script:
        - yaml create id:<[name]>
        - ~yaml "savefile:/Towns/<[name]>.yml" id:<[name]>
        - ~yaml "load:/Towns/<[name]>.yml" id:<[name]>

        - ~yaml id:<[name]> set Town.Name:<[name]>
        - ~yaml id:<[name]> set Town.Level:0
        - ~yaml id:<[name]> set Town.Owner:none
        - ~yaml id:<[name]> set Town.Ownername:none
        - ~yaml id:<[name]> set Town.Satisfaction:none

        - ~yaml id:<[name]> set Inhabitants.list:null

        - ~yaml id:<[name]> set NPCs.Farmer:0
        - ~yaml id:<[name]> set NPCs.Blacksmith:0
        - ~yaml id:<[name]> set NPCs.Trainer:0
        - ~yaml id:<[name]> set NPCs.Alchemist:0
        - ~yaml id:<[name]> set NPCs.Woodcutter:0
        - ~yaml id:<[name]> set NPCs.Miner:0
        - ~yaml id:<[name]> set NPCs.Total:0

        - ~yaml id:<[name]> set Militia.Infantry:0
        - ~yaml id:<[name]> set Militia.Sentry:0
        - ~yaml id:<[name]> set Militia.Archer:0
        - ~yaml id:<[name]> set Militia.Mage:0
        - ~yaml id:<[name]> set Militia.Miniboss:0
        - ~yaml id:<[name]> set Militia.Boss:0

        - ~yaml id:<[name]> set Resources.BuildingMaterials:0
        - ~yaml id:<[name]> set Resources.Food:0
        - ~yaml id:<[name]> set Resources.Weapons:0
        - ~yaml id:<[name]> set Resources.Minerals:0
        - ~yaml id:<[name]> set Resources.CraftingMaterials:0

        - ~yaml "savefile:/Towns/<[name]>.yml" id:<[name]>
        - yaml unload id:<[name]>

# =================================================================================
# ================================== Functions ====================================
# =================================================================================

# Function which adds the specified CHARACTER, not player
# DEFINE YOUR CHARACTER BEFORE ADDING THEM
TownAddMember:
    type: task
    definitions: name|character
    script:
        - ~yaml "load:/Towns/<[name]>.yml" id:<[name]>
        - define currentMembers:<yaml[<[name]>].read[Inhabitants.List].as_list>
        - define currentMembers:<[currentMembers].insert[<[character]>].at[0]>
        - yaml id:<[name]> set Inhabitants.List:<[currentMembers]>
        - ~yaml "savefile:/Towns/<[name]>.yml" id:<[name]>
        - yaml unload id:<[name]>
# Function which adds the specified CHARACTER, not player
# TownName|<npcID>/Type
TownAddNPC:
    type: task
    definitions: name|keypair|npcType
    script:
        - ~yaml "load:/Towns/<[name]>.yml" id:<[name]>
        - define currentMembers:<yaml[<[name]>].read[Inhabitants.NPCS].as_list||li@>
        - define currentMembers:<[currentMembers].insert[<[keypair]>].at[0]>
        - yaml id:<[name]> set Inhabitants.NPCS:<[currentMembers]>
        - yaml id:<[name]> set NPCs.Total:+:1
        - yaml id:<[name]> set NPCs.<[npcType]>:+:1
        - ~yaml "savefile:/Towns/<[name]>.yml" id:<[name]>
        - yaml unload id:<[name]>
CheckTownOwner:
    type: procedure
    definitions: player
    script:
        - define town:<proc[GetCharacterTown].context[<[player]>]>
        - define character:<proc[GetCharacterName].context[<[player]>]>
        - define townCharacter:<proc[GetTownOwner].context[<[town]>]>
        - define townUUID:<proc[GetTownOwnerUUID].context[<[town]>]>
        - if <[character]> == <[townCharacter]>:
            - if <[townUUID]> == <[player]>:
                - determine true
        - else:
            - determine false
TownFindNPC:
    type: procedure
    definitions: npcID
    script:
        - foreach <server.flag[TownList].as_list> as:town:
            - define list:<proc[GetTownYAML].context[<[town]>|Inhabitants.NPCS]>
            - if <[list].map_get[<[npcID]>]> != null:
                # - determine <[list].map_get[<[npcID]>]>
                - determine <[town]>
        - determine null
TownRemoveNPC:
    type: task
    definitions: npcID|name
    script:
        - if <server.has_file[Towns/<[name]>.yml]>:
            - yaml load:Towns/<[name]>.yml id:<[name]>
            - define result:<yaml[<[name]>].read[Inhabitants.NPCS].as_list>
            - define npcType:<[result].map_get[<[npcID]>]>
            - define keypair:<[npcID]>/<[npcType]>
            - define result:<[result].exclude[<[keypair]>]>
            - yaml id:<[name]> set Inhabitants.NPCS:<[result]>
            - yaml id:<[name]> set NPCs.<[npcType]>:-:1
            - yaml id:<[name]> set NPCs.Total:-:1
            - ~yaml "savefile:/Towns/<[name]>.yml" id:<[name]>
            - yaml unload id:<[name]>
# =================================================================================
# =============================== Get/Set Methods =================================
# =================================================================================

# CHECK THIS WORKS
# Retrieves the owner UUID of the given town
# TODO: replace with character name so multiple characters one one account can have town control
GetTownOwnerUUID:
    type: procedure
    definitions: name
    script:
        - define result:p@<proc[GetTownYAML].context[<[name]>|Town.Owner]>
        - determine <[result]>
# CHECK THIS WORKS
# Retrieves the owner UUID of the given town
# TODO: replace with character name so multiple characters one one account can have town control
GetTownOwner:
    type: procedure
    definitions: name
    script:
        - define result:<proc[GetTownYAML].context[<[name]>|Town.OwnerName]>
        - determine <[result]>
# General YAML getter to fetch the value at a given key
GetTownYAML:
    type: procedure
    definitions: name|key
    script:
        - if <server.has_file[Towns/<[name]>.yml]>:
            - yaml load:Towns/<[name]>.yml id:<[name]>
            - define result:<yaml[<[name]>].read[<[key]>]>
            - yaml unload id:<[name]>
            - determine <[result]>
# ex run SetTownYaml def:SilTown|Town.OwnerName|<proc[GetCharacterName].context[<player>]>
SetTownYAML:
    type: task
    definitions: name|key|value
    script:
        - ~yaml "load:/Towns/<[name]>.yml" id:<[name]>
        - yaml id:<[name]> set <[key]>:<[value]>
        - ~yaml "savefile:/Towns/<[name]>.yml" id:<[name]>
        - yaml unload id:<[name]>

# Ex use: - run TownModifyYAML def:SilTown|NPC.Farmers|1
# Ex use: - run TownModifyYAML def:SilTown|Resources.Wood|1
# General Setter Method to modify values (add/sub) in the town
TownModifyYAML:
    type: task
    definitions: name|key|amount
    script:
        - ~yaml "load:/Towns/<[name]>.yml" id:<[name]>
        - define currentValue:<yaml[<[name]>].read[<[key]>]>
        - yaml id:<[name]> set <[key]>:<[currentValue].add_int[<[amount]>]>
        - ~yaml "savefile:/Towns/<[name]>.yml" id:<[name]>
        - yaml unload id:<[name]>