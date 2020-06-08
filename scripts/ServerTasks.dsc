CreeperCheck:
    type: world
    debug: false
    events:
        on entity spawns:
        - if <context.entity.entity_type> == CREEPER:
            - determine cancelled
        - if <context.entity.entity_type> == PHANTOM:
            - determine cancelled
GetLuckyInventory:
    type: task
    script:
        - note in@generic[holder=PLAYER;contents=li@i@iron_axe[display_name=&ampampssb&ampampssnJason&ampampsqsWood Tamer&scdurability=2&scenchantments=sharpness,1]|i@bow[display_name=Grapple Arrow Bow&scscript=GRAPPLEARROWBOW]|i@air|i@air|i@air|i@air|i@air|i@iron_nugget[display_name=&ampampss6&ampampsslSpecial Nug&sclore=&ampampssfA strange iron nugget that has|&ampampssfOne unique and strange use&ampampdot&ampampdot&ampampdot ]|i@baked_potato[quantity=57]|i@arrow[quantity=63]|i@elytra[display_name=&ampampsseSkyborne Parafoil&scdurability=305&sclore=A custom parafoil created|by the skyborne&ampampdot&scscript=SKYBORNEPARAFOIL]|i@air|i@air|i@air|i@air|i@air|i@coal_block[quantity=64]|i@dandelion[display_name=&ampampsse Little Miss Mari&sclore=It&ampampsqs a yellow bud that is almost always a beautiful flower&ampampdot|However, when it speaks or wishes to observe, it turns|back into a bud&ampampdot When it is speaking, its petals wrap|around the bud to create a makeshift mouth&ampampdot ]|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@paper[quantity=64]|i@wooden_axe[display_name=&ampampss2Super Special Axe&scdurability=7&scenchantments=knockback,1|sharpness,2|unbreaking,50&sclore=&ampampss3They say it&ampampsqs special|&ampampss3but&ampampdot&ampampdot&ampampdot is it really?]|i@air|i@air|i@air|i@air|i@air|i@air|i@air|i@cooked_beef[quantity=54]|i@air|i@air|i@elytra[display_name=&ampampsseSkyborne Parafoil&scdurability=91&sclore=A custom parafoil created|by the skyborne&ampampdot&scscript=SKYBORNEPARAFOIL];title=Inventory;uniquifier=755] as:LuckyInv
Kernel:
    type: world
    debug: false
    events:
        on player dies:
            - determine passively no_drops
            - determine passively keep_level
            - determine keep_inv
        on player right clicks VILLAGER:
            - determine cancelled
        on VILLAGER breeds:
            - determine cancelled
        on BAT spawns:
            - determine cancelled
        on player damaged by fly_into_wall:
            - if <player.has_flag[Fresh]>:
                - determine cancelled
            - define newDamage:<context.damage.div[2]>
            - determine <[newDamage].as_decimal>
        on player damaged by fall:
            - if <player.has_flag[Fresh]>:
                - determine cancelled
        on player exits notable cuboid:
            - if <player.has_flag[Duel]>:
                - narrate "You cannot run from a duel! You must forfeit!" format:DuelFormat
                - determine cancelled
        on server start:
            - yaml "load:Utilities/DiscordBot.yml" id:DiscordBot
            
            - wait 5s
            - ~discord id:mybot connect code:<yaml[DiscordBot].read[info.code]>
            - wait 5s
            - define channel:<discord[mybot].group[Aetheria].channel[big-sister]>
            - define "message:<&co>white_check_mark<&co> **Server has started.**"
            - ~discord id:mybot message channel:<[channel]> <[message]>
            # Load all the Town Files
            - foreach <server.flag[Town_List]> as:Town:
                - if <server.has_file[/Towns/<[Town]>.yml]>:
                    - ~yaml "load:/Towns/<[Town]>.yml" id:<[Town]>
            # Load all the Node Files
            - foreach <server.flag[Node_List]> as:Node:
                - if <server.has_file[/CustomData/Nodes/<[node]>.yml]>:
                    - ~yaml "load:/CustomData/Nodes/<[node]>.yml" id:<[Node]>
    
        on NPC dies priority:1:
            - determine cancelled passively
            - define channel:<discord[mybot].group[Aetheria].channel[big-sister]>
            - define "message:<&co>white_check_mark<&co> `<npc.name> with id <npc> has died.`"
            - ~discord id:mybot message channel:<[channel]> <[message]>
            - if <npc.has_flag[Node]>:
                - run ClearNodeManager instantly def:<npc.flag[Node]>|<npc>
            - if <npc.has_flag[Follower]>:
                - remove <npc>
                
        on player joins:
            - if !<player.has_flag[CharacterSheet_notnew]>:
                - flag <player> CharacterSheet_notnew
                - define channel:<discord[mybot].group[Aetheria].channel[⚙clockworks⚙]>
                - define "message:@everyone - <player.name> has joined the server for the first time!"
                - ~discord id:mybot message channel:<[channel]> <[message]>
                - flag player notnew
            - if !<player.has_flag[CharacterSheet_HiddenNames]>:
                - execute as_op "team join HiddenNames"
                - flag player CharacterSheet_HiddenNames
            - wait 2s
            - adjust <player> "player_list_name:<player.display_name.replace[_].with[ ].parse_color>"
            # - inject SkinSave
            # - inject PlayerControllerOnJoin
            # - inject LetterOnJoin
            # - inject DaysSinceCrashOnJoin
            # - if <player.has_flag[CurrentCharacter]>:
            #     - inject QuestOnPlayerLogin
           
        # on player clicks item in inventory priority:1:
        #     # - if <context.inventory> == <player.inventory>:
        #     #     - stop
        #     # - define character:<proc[GetCharacterName].context[<player>]>
        #     # - if <context.inventory.notable_name||null> == <[character]>_Mailbox:
        #     #     - if <context.cursor_item.script.name||null> != LETTERBASE && <context.item.script.name||null> != LETTERBASE:
        #     #         - determine cancelled
        #     # Check notable inventory Names
        #     # - if <context.inventory.notable_name||null> == <[character]>_ProfessionMenu:
        #     #     - inject ClicksItemInCharacterProfessionMenu
        #     #     - stop
        #     # Check The Item Clicked
        #     - choose <context.item.script.name||null>:
        #         # - case ConfirmItem:
        #         #     - inject ClicksConfirmItemInInventory
        #         # - case RejectItem:
        #         #     - inject RejectMenu
        #         - case ActiveQuestItem:
        #             - run QuestMenuHandler def:ActiveQuest instantly
        #         - case CompletedQuestItem:
        #             - run QuestMenuHandler def:CompletedQuest instantly
        #         - case NextPageActiveQuestItem:
        #             - run QuestPageHandler def:ActiveQuest|next instantly
        #         - case NextPageCompletedQuestItem:
        #             - run QuestPageHandler def:CompletedQuest|next instantly
        #         - case LastPageActiveQuestItem:
        #             - run QuestPageHandler def:ActiveQuest|back instantly
        #         - case LastPageCompletedQuestItem:
        #             - run QuestPageHandler def:CompletedQuest|back instantly
        #         - default:
        #             - inject QuestOnPlayerClicksInInventory
        #             - inject SkillOnPlayerClicksInInventory
        on player enters SkyworldZone:
            - if <player.equipment.chestplate.script.name> == SkyborneParafoil:
                - teleport <player> l@1194,197,-877,aetheria
                - flag player Fresh d:15s
            # - else:
            #     - execute as_op "tp Lord_Pita"
        on item recipe formed:
            - if <context.item.material.name.contains[diamond]> && <context.item.material.name> != diamond:
                - determine cancelled
        on player changes world from skyworld_v2 to aetheria:
            - flag player Below
        on player changes world from aetheria to skyworld_v2:
            - flag player Below:!
        on item enchanted:
            - determine cancelled
        on player prepares anvil craft item:
            - determine cancelled
        # on player places block:
        #     - inject OnPlayerPlacesCustomTree
        #     - inject LockpickOnPlayerPlacesBlock
        # on player right clicks block:
        #     - inject LockpickCheckIfLocked
        # on player breaks block:
        #     - inject LockpickBreakCheckIfLocked
        on player right clicks with firework_rocket:
            - if <player.equipment.contains_text[elytra]> && <context.item.script.name||null> != ParafoilBoostCanister:
                - determine cancelled
            - else:
                - narrate "<&e>*You unleash a canister and feel the force of the wind on your face.*"
                - take ParafoilBoostCanister
        on player enters Portal1:
            - if !<player.has_flag[Teleporting]> && <server.has_flag[Portal]> && <l@-5082,169,568,skyworld_v2.material.name> == player_head:
                - flag player Teleporting d:5s
                - teleport <player> l@-7467,178,1765,skyworld_v2
        on player enters Portal2:
            - if !<player.has_flag[Teleporting]> && <server.has_flag[Portal]> && <l@-7452,174,1781,skyworld_v2.material.name> == player_head:
                - flag player Teleporting d:5s
                - teleport <player> l@-5049,176,600,skyworld_v2

        on sit command:
            - determine cancelled
        on gsit command:
            - determine cancelled
        # on player places torch:
        #     - if <player.flag[mode]||null> != builder:
        #         - if !<player.has_flag[TorchNotified]>:
        #             - narrate "<&e>Your torches will burn out in 15 minutes."
        #             - flag player TorchNotified d:15m
        #         - wait 15m
        #         - if <context.location.material.name> == torch:
        #             - modifyblock <context.location> air
        #             - drop BurntOutTorch <context.location>
        #             - playsound location:<context.location> sound:block.fire.extinguish volume:0.5 custom
        #     # - if <player.flag[mode]||null> != RP:
        #     #     - determine FORMAT:BuildFormat
        on player left clicks skeleton_skull:
            - playsound <player.location> sound:BLOCK_NOTE_BLOCK_XYLOPHONE volume:10 pitch:<util.random.decimal[0.6].to[1.4]>

# =================================================================================
# ===========================Custom Block YAML Add/Edit============================
# =================================================================================

CreateChunkFile:
    type: task
    debug: true
    definitions: chunkID|locale|theItem
    script:
        - yaml create id:<[chunkID]>
        - yaml "savefile:/ChunkData/<[chunkID]>.yml" id:<[chunkID]>
        - yaml "load:/ChunkData/<[chunkID]>.yml" id:<[chunkID]>
        - yaml id:<[chunkID]> set info.<[locale]>:<[theItem]>
        - yaml "savefile:/ChunkData/<[chunkID]>.yml" id:<[chunkID]>
        # - yaml unload id:<[chunkID]>
AddToChunkFile:
    type: task
    debug: true
    definitions: chunkID|locale|theItem
    speed: 3t
    script:
        - yaml "load:/ChunkData/<[chunkID]>.yml" id:<[chunkID]>
        - yaml id:<[chunkID]> set info.<[locale]>:<[theItem]>
        - yaml "savefile:/ChunkData/<[chunkID]>.yml" id:<[chunkID]>
        # - yaml unload id:<[chunkID]>

# NPCS Save character steps
SaveNPCStep:
    type: task
    debug: false
    script:
        - define "script:s@<npc.script.yaml_key[interact scripts].get[1].after[1 ]>"
        - define character:<proc[GetCharacterName].context[<player>]>
        - flag player <[character]>_<npc>:<[script].step>
LoadNPCStep:
    type: task
    script:
        - define step:<player.flag[<proc[GetCharacterName].context[<player>]>_<npc>]||1>
        - define "script:s@<npc.script.yaml_key[interact scripts].get[1].after[1 ]>"
        - if <[script].step[<player>]> != <[step]>:
            - zap step:<[step]> <[script]> player:<player>
#= Servertasks
SetCharacterYAML:
    type: task
    debug: false
    definitions: player|key|value
    script:
        - define id:<[player].flag[CharacterSheet_CurrentCharacter]>
        - ~yaml "load:/CharacterSheets/<[player].uuid>/<[id]>.yml" id:<[player]>
        - yaml id:<[player]> set <[key]>:<[value]>
        - ~yaml "savefile:/CharacterSheets/<[player].uuid>/<[id]>.yml" id:<[player]>

SetBaseYAML:
    type: task
    debug: false
    definitions: player|key|value
    script:
        - define id:<[player]>
        - ~yaml "load:/CharacterSheets/<[player].uuid>/base.yml" id:<[player]>
        - yaml id:<[player]> set <[key]>:<[value]>
        - ~yaml "savefile:/CharacterSheets/<[player].uuid>/base.yml" id:<[player]>
        - yaml unload id:<[player]>
ReadBaseYAML:
    type: procedure
    debug: false
    definitions: player|key
    script:
        - yaml load:/CharacterSheets/<[player].uuid>/base.yml id:<[player]>
        - define result:<yaml[<[player]>].read[<[key]>]>
        - yaml unload id:<[player]>
        - determine <[result]>
ModifyCharacterYAML:
    type: task
    debug: false
    definitions: player|key|value
    script:
        - define id:<[player].flag[CharacterSheet_CurrentCharacter]>
        - ~yaml "load:/CharacterSheets/<[player].uuid>/<[id]>.yml" id:<[player]>
        - define newValue:<yaml[<[player]>].read[<[key]>].add_int[<[value]>]>
        - yaml id:<[player]> set <[key]>:<[newValue]>
        - ~yaml "savefile:/CharacterSheets/<[player].uuid>/<[id]>.yml" id:<[player]>
        - yaml unload id:<[player]>
# This expects that all queries are of acceptable length
GetCharacterFromQuery:
    type: procedure
    debug: false
    definitions: player|query
    script:
        - define id:<[player]>_base>
        - yaml "load:/CharacterSheets/<[player].uuid>/base.yml" id:<[id]>
        - define characters:<yaml[<[id]>].read[characters]>
        - define index:<[characters].find_partial[<[query]>]>
        - if <[index]> == -1:
            - define result:false
        - else:
            - define result:<[characters].get[<[index]>]>
        - yaml unload id:<[id]>
        - determine <[result]>
# Gets this character's base name
# Could be replaced, purely here for accessibility
GetCharacterName:
    type: procedure
    debug: true
    definitions: player
    script:
        - determine <[player].flag[CharacterSheet_CurrentCharacter]||null>
        # - define name:<proc[GetCharacterYAML].context[<[player]>|Info.Character_Name]>
        # - if <[name]> == yaml[<&lt>[character]<&gt>].read[<&lt>[key]<&gt>]:
        #     - determine <[player].name>
        # - else:
        #     - determine <[name]>
GetCharacterDisplayName:
    type: procedure
    debug: false
    definitions: player
    script:
        - define name:<proc[GetCharacterYAML].context[<[player]>|Info.Character_Display_Name]>
        - if <[name]> == yaml[<&lt>[character]<&gt>].read[<&lt>[key]<&gt>]:
            - determine  <[player].name>
        - else:
            - determine <[name]>
# Gets the last known location of this player
GetCharacterLocation:
    type: procedure
    debug: false
    definitions: player
    script:
        - determine <proc[GetCharacterYAML].context[<[player]>|Info.Character_Location]>
# Gets the name of the town the player is currently a member of
GetCharacterTown:
    type: procedure
    debug: false
    definitions: player
    script:
        - determine <proc[GetCharacterYAML].context[<[player]>|Town.Name]>
# General utility to access character sheet info
GetCharacterYAML:
    type: procedure
    debug: true
    definitions: player|key
    script:
        - define character:<[player].flag[CharacterSheet_CurrentCharacter]||null>
        - if <[character]> == null:
            - determine null
        - yaml load:/CharacterSheets/<[player].uuid>/<[character]>.yml id:<[character]>
        - define result:<yaml[<[character]>].read[<[key]>]||null>
        - yaml unload id:<[character]>
        - determine <[result]>
GetSpecificCharacterYAML:
    type: procedure
    debug: true
    definitions: player|character|key
    script:
        - yaml load:/CharacterSheets/<[player].uuid>/<[character]>.yml id:<[character]>
        - define result:<yaml[<[character]>].read[<[key]>]||null>
        - yaml unload id:<[character]>
        - determine <[result]>
GetOtherCharacterYAML:
    type: procedure
    debug: false
    definitions: player|id|key
    script:
        - yaml load:/CharacterSheets/<[player].uuid>/<[id]>.yml id:<[id]>
        - define result:<yaml[<[id]>].read[<[key]>]>
        - yaml unload id:<[id]>
        - determine <[result]>
CharacterHasTown:
    type: procedure
    debug: false
    definitions: player
    script:
        - define town:<proc[GetCharacterTown].context[<player>]>
        - if <[town]> == none:
            - determine false
        - else:
            - determine true
