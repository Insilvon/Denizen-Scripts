#FLAGS:
# Profession: Has set up things before
# ActiveProfessions: Total number of professed
# TotalProfessions: Total number of professions that COULD be professed rn

ProfessionFormat:
    type: format
    format: "<&c>[Professions]<&co><&f> <text>"


# ProfessionStatItem:
#     type: item
#     material: player_head[skull_skin=577218c5-279a-4c2b-9afe-2dbd419e7937|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWNjNThjYjU1YjFhMTFlNmQ4OGMyZDRkMWE2MzY2YzIzODg3ZGVlMjYzMDRiZGE0MTJjNGE1MTgyNWYxOTkifX19]
#     display name: Stats

#= Menus
ProfessionMenu:
    type: inventory
    inventory: CHEST
    title: Profession Menu
    size: 9
    slots:
        - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
    procedural items:
        - define character:<proc[GetCharacterName].context[<player>]||null>
        - if <[character]> == null:
            - narrate "You must have a character to use this!"
            - determine <list[]>
        - if <player.has_flag[Profession]>:
            - define list:<list[]>
            - define active:<player.flag[ActiveProfessions]>
            - foreach li@Artisan|Nomad|Culinary|Engineer|Blacksmith|Apothecary|Tradesman|Gunsmith|Miner|Pilot|Arcanist|Naturalist as:item:
                - if <player.has_flag[Profession_<[item]>]>:
                    - define list:<[list].include[<[item]>Item]>
            - repeat <player.flag[OptionalProfessions]||0>:
                - define list:<[list].include[EmptySlotItem]>
            - determine <[list]>

ProfessionSelectMenu:
    type: inventory
    inventory: CHEST
    title: Profession Selection Menu
    size: 18
    slots:
        # - "[] [EngineerItem] [BlacksmithItem] [ApothecaryItem] [TradesmanItem] [GunsmithItem] [PilotItem] [ArcanistItem] []"
        # - "[] [] [MinerItem] [NaturalistItem] [NomadItem] [ArtisanItem] [CulinaryItem] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [MinerItem] [] [] [] [] [] []"

ProfessionConfirmMenu:
    type: inventory
    inventory: CHEST
    title: Profession Confirm Menu
    size: 9
    slots:
        - "[] [] [] [] [] [] [] [] []"
    procedural items:
        - define list:air|air|air|ConfirmItem|<player.flag[ProfessionItem]>|RejectItem|air|air|air
        - determine <[list]>

#= Command
Profession:
    type: command
    debug: false
    name: profession
    description: null
    usage: /profession
    permission: Aetheria.profession
    script:
        - define character:<proc[GetCharacterName].context[<player>]||null>
        - if <[character]> == null:
            - narrate "You must have a character to use this!"
            - stop
        - if !<player.has_flag[Profession]>:
            - flag player Profession
            - flag player TotalProfessions:1
            - flag player ActiveProfessions:0
            - flag player OptionalProfessions:1
        - define arg:<context.args.get[1]||null>
        - choose <[arg]>:
            - case reset:
                - inject ProfessionReset
            - case stats:
                - narrate "====[ Current Debug Stats ]====" format:ProfessionFormat
                - narrate "Profession: <player.flag[Profession]>" format:ProfessionFormat
                - narrate "Total Professions: <player.flag[TotalProfessions]>" format:ProfessionFormat
                - narrate "Active Professions: <player.flag[ActiveProfessions]>" format:ProfessionFormat
                - narrate "Available Professions: <player.flag[OptionalProfessions]>" format:ProfessionFormat
                - narrate "Levels:"
                - foreach li@Artisan|Nomad|Culinary|Engineer|Blacksmith|Apothecary|Tradesman|Gunsmith|Miner|Pilot|Arcanist|Naturalist as:prof:
                    - if <player.has_flag[Profession_<[prof]>]>:
                        - narrate "<[prof]>: <&c><player.flag[Profession_<[prof]>]>" format:ProfessionFormat
                        - narrate "EXP: <&c><player.flag[Profession_<[prof]>_EXP]>" format:ProfessionFormat
            - case achievements:
                - flag player ProfessionAchievement d:15s
                - inventory open d:ProfessionMenu
            - case bind:
                - define prof:<context.args.get[2]||null>
                - define skill:<context.args.get[3]||null>
                - if <[prof]> == null || <[skill]> == null:
                    - narrate "/profession bind Profession Skillname"
                    - stop
                - if !<proc[GetCharacterYAML].context[<[target]>|Professions.<[prof]>.<[skill]>]||null>:
                    - narrate "You do not know this skill!"
                - if <player.item_in_hand.has_nbt[Castable]> || <player.item_in_hand.has_nbt[Profession]>:
                    - narrate "You cannot bind more skills to this item!"
                    - stop
                - if <player.item_in_hand.has_nbt>:
                    - inventory adjust s:<player.item_in_hand.slot> nbt:<player.item_in_hand.nbt>|Castable
                - else:
                    - inventory adjust s:<player.item_in_hand.slot> nbt:Castable/<[skill]>|Profession/<[prof]>
            - default:
                - inventory open d:ProfessionMenu

#= Scripts
ProfessionLearnedSkill:
    type: procedure
    debug: false
    definitions: target|prof|skill
    script:
        - define result:<proc[GetCharacterYAML].context[<[target]>|Professions.<[prof]>.<[skill]>]||null>
        - if <[result]> == null:
            - determine false
        - else:
            - determine true
ProfessionLearnSkill:
    type: task
    debug: false
    definitions: target|prof|skill
    script:
        - run SetCharacterYaml def:<[target]>|Professions.<[prof]>.<[skill]>|true

ProfessionReset:
    type: task
    debug: false
    speed: instant
    script:
        - foreach li@Artisan|Nomad|Culinary|Engineer|Blacksmith|Apothecary|Tradesman|Gunsmith|Miner|Pilot|Arcanist|Naturalist as:prof:
            - flag player Profession_<[prof]>:!
            - run SetCharacterYAML def:<player>|Professions|!
        - foreach <player.list_flags> as:theFlag:
            - if <[theFlag].contains_text[Profession]>:
                - flag player <[theFlag]>:!
        - narrate "Your profession information has been reset." format:ProfessionFormat


GetProfessionlevel:
    type: procedure
    debug: false
    definitions: exp
    script:
        - define file:ProfessionLevels
        - define data:<script[<[file]>].list_keys.exclude[type]>
        - define level:0
        - foreach <[data].numerical> as:key:
            - if <[exp]> < <script[<[file]>].yaml_key[<[key]>.exp]>:
                - determine <[level]>
            - else:
                - define level:<[key]>
        - determine <[level]>


ProfessionLevels:
    type: yaml data
    1:
        exp: 125
    2:
        exp: 150
    3:
        exp: 275
    4:
        exp: 375
    5:
        exp: 500
    6:
        exp: 650
    7:
        exp: 825
    8:
        exp: 1025
    9:
        exp: 1250
    10:
        exp: 1400


ProfessionGiveEXP:
    type: task
    debug: false
    speed: instant
    definitions: target|profession|amount
    script:
        - define character:<proc[GetCharacterName].context[<[target]>]||null>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - define currentEXP:<[target].flag[Profession_<[Profession]>_EXP]>
        - define currentLevel:<proc[GetProfessionLevel].context[<[currentEXP]>]>
        - flag player Profession_<[Profession]>_EXP:+:<[amount]>
        - define currentEXP:<[target].flag[Profession_<[Profession]>_EXP]>
        - define newLevel:<proc[GetProfessionLevel].context[<[currentEXP]>]>
        - if <[newLevel]> != <[currentLevel]>:
            - flag <[target]> Profession_<[Profession]>:<[newLevel]>
            - narrate "You are now level <[newLevel]>." format:ProfessionFormat

ProfessionAdd:
    type: task
    debug: false
    speed: instant
    definitions: target|profession
    script:
        - define character:<proc[GetCharacterName].context[<[target]>]||null>
        - if <[character]> == null:
            - narrate "You must have a character to do this!"
            - stop
        - if <[target].has_flag[Profession_<[profession]>]>:
            - narrate "You are already a member of this profession." format:ProfessionFormat
            - stop
        - if <[target].flag[ActiveProfessions]> == 2:
            - narrate "You have already selected two professions."
            - stop
        - flag <[target]> ProfessionItem:!
        - flag <[target]> ActiveProfessions:++
        - flag <[target]> OptionalProfessions:--
        - flag <[target]> Profession_<[profession]>:0
        - flag <[target]> Profession_<[profession]>_EXP:0
        - inventory open d:Profession<[profession]>Menu

GetSkillReqs:
    type: procedure
    definitions: skill|profession
    script:
        - define file:<[profession]>Skills
        - define data:<script[<[file]>].list_keys.exclude[type]>
        - foreach <[data].numerical> as:key:
            - if <[skill]> == <script[<[file]>].yaml_key[<[key]>.skill]>:
                - define reqs:<script[<[file]>].yaml_key[<[key]>.requirements]||null>
                - determine <[reqs]>
        - determine null

AttemptToLearnSkill:
    type: task
    debug: false
    script:
        # Get all requirements
        - define skillRequirements:<proc[GetSkillReqs].context[<[skill]>|<[profession]>]>
        - if <[skillRequirements]> != null:
            # check each one. If it's not learned, then deny
            - foreach <[skillRequirements]> as:reqSkill:
                - if !<proc[ProfessionLearnedSkill].context[<player>|<[profession]>|<[skill]>]>:
                    - inventory close
                    - narrate "You cannot learn this skill until you've learned its prerequisites!" format:ProfessionFormat
                    - stop
        - define character:<proc[GetCharacterName].context[<player>]||null>
        # Check the character's digital level for this prof
        - if <[character]> == null:
            - narrate "CRITICAL ERROR"
            - stop
        - define level:<player.flag[Profession_<[profession]>]>
        - define "cost:<context.item.lore.get[1].after[Cost: ]>"
        # Actual check
        - if <[level]> >= <[cost]>:
            - flag player Profession_<[Profession]>:-:<[cost]>
            - run SetCharacterYAML def:<player>|Professions.<[profession]>.<context.item.script.name>|true
            - inventory close
            - title "title:<&c>[!]" "subtitle:<&a>You have learned a new skill!" targets:<player>
            - wait 3s
            - inventory open d:Profession<[profession]>Menu
        - else:
            - inventory close
            - narrate "You do not have enough skill points to get this!" format:ProfessionFormat

ProfessionSkillClick:
    type: task
    speed: instant
    script:
        - determine cancelled passively
        - define item:<context.item.script.name||null>
        - if <[item]> != null:
            - if <context.item.script.name.contains_text[Learned]>:
                - run <context.item.script.name.before[learned]>Cast
            - else:
                - define skill:<context.item.script.name>
                - inject AttemptToLearnSkill

ProfessionController:
    type: world
    debug: false
    events:
        on player right clicks with item:
            - if <context.item.has_nbt[Castable]> && <context.item.has_nbt[Profession]>:
                - define prof:<context.item.nbt[Profession]>
                - define skill:<context.item.nbt[Castable]>
                - define result:<proc[ProfessionLearnedSkill].context[<player>|<[prof]>|<[skill]>]>
                - if <[result]>:
                    - run <context.item.nbt[Castable]>Cast
        on player clicks item in ProfessionEngineerMenu:
            - if <context.item.material.name> == player_head:
                - determine cancelled
            - if <context.item.script.name> == CharacterSheetBackItem:
                - inventory open d:ProfessionMenu
                - stop
            - define profession:Engineer
            - inject ProfessionSkillClick
        on player clicks item in ProfessionPilotMenu:
            - if <context.item.material.name> == player_head:
                - determine cancelled
            - if <context.item.script.name> == CharacterSheetBackItem:
                - inventory open d:ProfessionMenu
                - stop
            - define profession:Pilot
            - inject ProfessionSkillClick
        on player clicks item in ProfessionGunsmithMenu:
            - if <context.item.material.name> == player_head:
                - determine cancelled
            - if <context.item.script.name> == CharacterSheetBackItem:
                - inventory open d:ProfessionMenu
                - stop
            - define profession:Gunsmith
            - inject ProfessionSkillClick
        on player clicks item in ProfessionMinerMenu:
            - if <context.item.material.name> == player_head:
                - determine cancelled
            - if <context.item.script.name> == CharacterSheetBackItem:
                - inventory open d:ProfessionMenu
                - stop
            - define profession:Miner
            - inject ProfessionSkillClick
        on player clicks item in ProfessionBlacksmithMenu:
            - if <context.item.material.name> == player_head:
                - determine cancelled
            - if <context.item.script.name> == CharacterSheetBackItem:
                - inventory open d:ProfessionMenu
                - stop
            - define profession:Blacksmith
            - inject ProfessionSkillClick
        on player clicks item in ProfessionTradesmanMenu:
            - if <context.item.material.name> == player_head:
                - determine cancelled
            - if <context.item.script.name> == CharacterSheetBackItem:
                - inventory open d:ProfessionMenu
                - stop
            - define profession:Tradesman
            - inject ProfessionSkillClick
        on player clicks item in ProfessionApothecaryMenu:
            - if <context.item.material.name> == player_head:
                - determine cancelled
            - if <context.item.script.name> == CharacterSheetBackItem:
                - inventory open d:ProfessionMenu
                - stop
            - define profession:Apothecary
            - inject ProfessionSkillClick
        on player clicks item in ProfessionArcanistMenu:
            - if <context.item.material.name> == player_head:
                - determine cancelled
            - if <context.item.script.name> == CharacterSheetBackItem:
                - inventory open d:ProfessionMenu
                - stop
            - define profession:Arcanist
            - inject ProfessionSkillClick
        on player clicks item in ProfessionNaturalistMenu:
            - if <context.item.material.name> == player_head:
                - determine cancelled
            - if <context.item.script.name> == CharacterSheetBackItem:
                - inventory open d:ProfessionMenu
                - stop
            - define profession:Naturalist
            - inject ProfessionSkillClick
        on player clicks item in ProfessionCulinaryMenu:
            - if <context.item.material.name> == player_head:
                - determine cancelled
            - if <context.item.script.name> == CharacterSheetBackItem:
                - inventory open d:ProfessionMenu
                - stop
            - define profession:Culinary
            - inject ProfessionSkillClick
        on player clicks item in ProfessionNomadMenu:
            - if <context.item.material.name> == player_head:
                - determine cancelled
            - if <context.item.script.name> == CharacterSheetBackItem:
                - inventory open d:ProfessionMenu
                - stop
            - define profession:Nomad
            - inject ProfessionSkillClick
        on player clicks item in ProfessionArtisanMenu:
            - if <context.item.material.name> == player_head:
                - determine cancelled
            - if <context.item.script.name> == CharacterSheetBackItem:
                - inventory open d:ProfessionMenu
                - stop
            - define profession:Artisan
            - inject ProfessionSkillClick
        on player clicks item in ProfessionConfirmMenu:
            - if <context.item.material.name> == player_head:
                - determine cancelled
            - if <context.item.script.name> == CharacterSheetBackItem:
                - inventory open d:ProfessionMenu
                - stop
            - determine cancelled passively
            - choose <context.item.script.name>:
                - case ConfirmItem:
                    - inventory close
                    - run ProfessionAdd def:<player>|<player.flag[ProfessionItem].before[item]>
                - case RejectItem:
                    - inventory close
        on player clicks item in ProfessionSelectMenu:
            - determine cancelled passively
            - define list:li@ArtisanItem|NomadItem|CulinaryItem|EngineerItem|BlacksmithItem|ApothecaryItem|TradesmanItem|GunsmithItem|MinerItem|PilotItem|ArcanistItem|NaturalistItem|EmptySlotItem
            - if <[list].contains[<context.item.script.name>]>:
                - choose <context.item.script.name>:
                    - case EngineerItem:
                        - flag player ProfessionItem:EngineerItem d:5m
                        - inventory open d:in@ProfessionConfirmMenu
                    - case BlacksmithItem:
                        - flag player ProfessionItem:BlacksmithItem d:5m
                        - inventory open d:in@ProfessionConfirmMenu
                    - case ApothecaryItem:
                        - flag player ProfessionItem:ApothecaryItem d:5m
                        - inventory open d:in@ProfessionConfirmMenu
                    - case GunsmithItem:
                        - flag player ProfessionItem:GunsmithItem d:5m
                        - inventory open d:in@ProfessionConfirmMenu
                    - case TradesmanItem:
                        - flag player ProfessionItem:TradesmanItem d:5m
                        - inventory open d:in@ProfessionConfirmMenu
                    - case MinerItem:
                        - flag player ProfessionItem:MinerItem d:5m
                        - inventory open d:in@ProfessionConfirmMenu
                    - case PilotItem:
                        - flag player ProfessionItem:PilotItem d:5m
                        - inventory open d:in@ProfessionConfirmMenu
                    - case ArcanistItem:
                        - flag player ProfessionItem:ArcanistItem d:5m
                        - inventory open d:in@ProfessionConfirmMenu
                    - case NaturalistItem:
                        - flag player ProfessionItem:NaturalistItem d:5m
                        - inventory open d:in@ProfessionConfirmMenu
                    - case CulinaryItem:
                        - flag player ProfessionItem:CulinaryItem d:5m
                        - inventory open d:in@ProfessionConfirmMenu
                    - case NomadItem:
                        - flag player ProfessionItem:NomadItem d:5m
                        - inventory open d:in@ProfessionConfirmMenu
                    - case ArtisanItem:
                        - flag player ProfessionItem:ArtisanItem d:5m
                        - inventory open d:in@ProfessionConfirmMenu
        on player clicks item in ProfessionMenu:
            - determine cancelled passively
            - define item:<context.item||air>
            - if <[item].script.name||null> == CharacterSheetBackItem:
                - inventory open d:CharacterSheetMenu
                - stop
            - define list:li@ArtisanItem|NomadItem|CulinaryItem|EngineerItem|BlacksmithItem|ApothecaryItem|TradesmanItem|GunsmithItem|MinerItem|PilotItem|ArcanistItem|NaturalistItem|EmptySlotItem
            - if <[list].contains[<context.item.script.name||air>]>:
                - if <context.item.script.name> == EmptySlotItem:
                    - inventory close
                    - inventory open d:in@ProfessionSelectMenu
                - else:
                    - define profession:<context.item.script.name.before[item]>
                    - if <player.has_flag[ProfessionAchievement]>:
                        - inventory open d:Profession<[profession]>AchievementMenu
                    - else:
                        - inventory close
                        - inventory open d:in@Profession<[profession]>Menu

#===========================================#
#===============[ Engineer ]================#
#===========================================#
# Class dedicated to the construction of complex mechanisms,
# airship parts, and other tinkering-based-goods
ProfessionEngineerMenu:
    type: inventory
    inventory: CHEST
    title: "Engineer Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
    procedural items:
        - define file:EngineerSkills
        - define data:<script[<[file]>].list_keys.exclude[type]>
        - define list:<list[]>
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - define level:<player.flag[Profession_Engineer]>
        - define exp:<player.flag[Profession_Engineer_EXP]>
        - define 'lore:<i@EngineerTooltip.lore.insert[<&a>Levels: <&c><[level]><&f>|<&a>EXP: <&c><[exp]><&f>].at[1]>'
        - define list:<[list].include[EngineerTooltip[lore=<[lore]>]]>
        - foreach <[data].numerical> as:key:
            - define skill:<script[<[file]>].yaml_key[<[key]>.skill]>
            - define result:<proc[ProfessionLearnedSkill].context[<player>|Engineer|<[skill]>]>
            - if <[result]>:
                #- narrate "Adding <[skill]>Learned!" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>Learned]>
            - else:
                #- narrate "Adding <[skill]>" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>]>
        - determine <[list]>
EngineerItem:
    type: item
    material: iron_ingot
    display name: "<&e>Engineer"
    lore:
        - Class dedicated to the construction
        - of complex mechanisms, airship
        - parts, and other tinkering-based
        - goods.
EngineerMinerAchievementMenu:
    type: inventory
    inventory: CHEST
    title: "Engineer Achievements"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
#===========================================#
#===============[ Pilot ]===================#
#===========================================#
# Class dedicated to the controlling, flying, and maintaining of
# airships. Capable of constructing their own as well. (Maybe)
PilotItem:
    type: item
    material: Blaze_Rod
    display name: "<&b>Pilot"
    lore:
        - Class dedicated to sailing
        - the skies in any airship
        - imagineable.
ProfessionPilotMenu:
    type: inventory
    inventory: CHEST
    title: "Pilot Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
    procedural items:
        - define file:PilotSkills
        - define data:<script[<[file]>].list_keys.exclude[type]>
        - define list:<list[]>
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - define level:<player.flag[Profession_Pilot]>
        - define exp:<player.flag[Profession_Pilot_EXP]>
        - define 'lore:<i@PilotTooltip.lore.insert[<&a>Levels: <&c><[level]><&f>|<&a>EXP: <&c><[exp]><&f>].at[1]>'
        - define list:<[list].include[PilotTooltip[lore=<[lore]>]]>
        - foreach <[data].numerical> as:key:
            - define skill:<script[<[file]>].yaml_key[<[key]>.skill]>
            - define result:<proc[ProfessionLearnedSkill].context[<player>|Pilot|<[skill]>]>
            - if <[result]>:
                #- narrate "Adding <[skill]>Learned!" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>Learned]>
            - else:
                #- narrate "Adding <[skill]>" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>]>
        - determine <[list]>
ProfessionPilotAchievementMenu:
    type: inventory
    inventory: CHEST
    title: "Pilot Achievements"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
#===========================================#
#===============[ Gunsmith ]=============#
#===========================================#
# Class responsible for the creation of new weapons for use in battle.
# Works closely with the raw materials created by blacksmiths and the
# contraptions made from Engineers.
# Focus mainly on Guns, Cannons.
GunsmithItem:
    type: item
    material: Crossbow
    display name: "<&d>Gunsmith"
    lore:
        - Class dedicated to the
        - creation, installation, 
        - and maintenance of cannons
        - and handheld firearms.
ProfessionGunsmithMenu:
    type: inventory
    inventory: CHEST
    title: "Gunsmith Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
    procedural items:
        - define file:GunsmithSkills
        - define data:<script[<[file]>].list_keys.exclude[type]>
        - define list:<list[]>
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - define level:<player.flag[Profession_Gunsmith]>
        - define exp:<player.flag[Profession_Gunsmith_EXP]>
        - define 'lore:<i@GunsmithTooltip.lore.insert[<&a>Levels: <&c><[level]><&f>|<&a>EXP: <&c><[exp]><&f>].at[1]>'
        - define list:<[list].include[GunsmithTooltip[lore=<[lore]>]]>
        - foreach <[data].numerical> as:key:
            - define skill:<script[<[file]>].yaml_key[<[key]>.skill]>
            - define result:<proc[ProfessionLearnedSkill].context[<player>|Gunsmith|<[skill]>]>
            - if <[result]>:
                # #- narrate "Adding <[skill]>Learned!" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>Learned]>
            - else:
                # #- narrate "Adding <[skill]>" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>]>
        - determine <[list]>
ProfessionGunsmithAchievementMenu:
    type: inventory
    inventory: CHEST
    title: "Gunsmith Achievements"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"

#===========================================#
#=================[ Miner ]=================#
#===========================================#
# They mine. They can collect rare ores - basically the same as V1.
# They can create Miner's backpacks as well.
MinerItem:
    type: item
    material: Iron_Pickaxe
    display name: "<&e>Miner"
    lore:
        - A class dedicated to
        - scavenging the earth for
        - rare and lost ores, including
        - those unobtainable to the
        - average surveyor.
ProfessionMinerMenu:
    type: inventory
    inventory: CHEST
    title: "Miner Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
    procedural items:
        - define file:MinerSkills
        - define data:<script[<[file]>].list_keys.exclude[type]>
        - define list:<list[]>
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - define level:<player.flag[Profession_Miner]>
        - define exp:<player.flag[Profession_Miner_EXP]>
        - define 'lore:<i@MinerTooltip.lore.insert[<&a>Levels: <&c><[level]><&f>|<&a>EXP: <&c><[exp]><&f>].at[1]>'
        - define list:<[list].include[MinerTooltip[lore=<[lore]>]]>
        - foreach <[data].numerical> as:key:
            - define skill:<script[<[file]>].yaml_key[<[key]>.skill]>
            - define result:<proc[ProfessionLearnedSkill].context[<player>|Miner|<[skill]>]>
            - if <[result]>:
                #- narrate "Adding <[skill]>Learned!" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>Learned]>
            - else:
                #- narrate "Adding <[skill]>" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>]>
        - determine <[list]>

ProfessionMinerAchievementMenu:
    type: inventory
    inventory: CHEST
    title: "Miner Achievements"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
#===========================================#
#==============[ Blacksmith ]===============#
#===========================================#
# Class which has been nerfed significantly. Rather than creating
# full swords and weaponry, they create the components necessarily for assembly.
# Smiths can create the Pommels, Hilts, and Blades. When put together
# raw, they form a regular sword. Gunsmiths can make the custom
# swords and whatnot.
BlacksmithItem:
    type: item
    material: anvil
    display name: "<&d>Blacksmith"
    lore:
        - Class dedicated to the art
        - of the forge - working through
        - three pathways of knowledge.
        - Tools, Armor, and Weapons.

ProfessionBlacksmithMenu:
    type: inventory
    inventory: CHEST
    title: "Blacksmith Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
    procedural items:
        - define file:BlacksmithSkills
        - define data:<script[<[file]>].list_keys.exclude[type]>
        - define list:<list[]>
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - define level:<player.flag[Profession_Blacksmith]>
        - define exp:<player.flag[Profession_Blacksmith_EXP]>
        - define 'lore:<i@BlacksmithTooltip.lore.insert[<&a>Levels: <&c><[level]><&f>|<&a>EXP: <&c><[exp]><&f>].at[1]>'
        - define list:<[list].include[BlacksmithTooltip[lore=<[lore]>]]>
        - foreach <[data].numerical> as:key:
            - define skill:<script[<[file]>].yaml_key[<[key]>.skill]>
            - define result:<proc[ProfessionLearnedSkill].context[<player>|Blacksmith|<[skill]>]>
            - if <[result]>:
                #- narrate "Adding <[skill]>Learned!" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>Learned]>
            - else:
                #- narrate "Adding <[skill]>" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>]>
        - determine <[list]>
ProfessionBlacksmithAchievementMenu:
    type: inventory
    inventory: CHEST
    title: "Blacksmith Achievements"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
#===========================================#
#===============[ Tradesman ]===============#
#===========================================#
# A merchant class with better NPC negotiation, but
# also access to the original tailor class to make clothes
# and trade exclusive items.
TradesmanItem:
    type: item
    material: Blue_Banner
    display name: "<&3>Tradesman"
    lore:
        - A class dedicated to a
        - life's work of trade,
        - moneymaking, and haggling.
ProfessionTradesmanMenu:
    type: inventory
    inventory: CHEST
    title: "Tradesman Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
    procedural items:
        - define file:TradesmanSkills
        - define data:<script[<[file]>].list_keys.exclude[type]>
        - define list:<list[]>
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - define level:<player.flag[Profession_Tradesman]>
        - define exp:<player.flag[Profession_Tradesman_EXP]>
        - define 'lore:<i@TradesmanTooltip.lore.insert[<&a>Levels: <&c><[level]><&f>|<&a>EXP: <&c><[exp]><&f>].at[1]>'
        - define list:<[list].include[TradesmanTooltip[lore=<[lore]>]]>        - foreach <[data].numerical> as:key:
            - define skill:<script[<[file]>].yaml_key[<[key]>.skill]>
            - define result:<proc[ProfessionLearnedSkill].context[<player>|Tradesman|<[skill]>]>
            - if <[result]>:
                #- narrate "Adding <[skill]>Learned!" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>Learned]>
            - else:
                #- narrate "Adding <[skill]>" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>]>
        - determine <[list]>
ProfessionTradesmanAchievementMenu:
    type: inventory
    inventory: CHEST
    title: "Tradesman Achievements"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
#===========================================#
#==============[ Apothecary ]===============#
#===========================================#
# The medical class. Craft cures and remedies from
# scientific sources (base), magical sources (Arcanist),
# or natural sources (Naturalist)
ApothecaryItem:
    type: item
    material: Potion
    display name: "<&a>Apothecary"
    lore:
        - Class dedicated to the growth,
        - harvest, and usage of custom herbs,
        - potions, and other healing-based
        - sources.
ProfessionApothecaryMenu:
    type: inventory
    inventory: CHEST
    title: "Apothecary Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
    procedural items:
        - define file:ApothecarySkills
        - define data:<script[<[file]>].list_keys.exclude[type]>
        - define list:<list[]>
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - define level:<player.flag[Profession_Apothecary]>
        - define exp:<player.flag[Profession_Apothecary_EXP]>
        - define 'lore:<i@ApothecaryTooltip.lore.insert[<&a>Levels: <&c><[level]><&f>|<&a>EXP: <&c><[exp]><&f>].at[1]>'
        - define list:<[list].include[ApothecaryTooltip[lore=<[lore]>]]>
        - foreach <[data].numerical> as:key:
            - define skill:<script[<[file]>].yaml_key[<[key]>.skill]>
            - define result:<proc[ProfessionLearnedSkill].context[<player>|Apothecary|<[skill]>]>
            - if <[result]>:
                #- narrate "Adding <[skill]>Learned!" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>Learned]>
            - else:
                #- narrate "Adding <[skill]>" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>]>
        - determine <[list]>
ProfessionApothecaryAchievementMenu:
    type: inventory
    inventory: CHEST
    title: "Apothecary Achievements"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
#===========================================#
#================[ Arcanist ]===============#
#===========================================#
# Alchemy. Good lord.
ArcanistItem:
    type: item
    material: Nether_Star
    display name: "<&c>Arcanist"
    lore:
        - Don't look at this yet.
ProfessionArcanistMenu:
    type: inventory
    inventory: CHEST
    title: "Arcanist Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
    procedural items:
        - define file:ArcanistSkills
        - define data:<script[<[file]>].list_keys.exclude[type]>
        - define list:<list[]>
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - define level:<player.flag[Profession_Arcanist]>
        - define exp:<player.flag[Profession_Arcanist_EXP]>
        - define 'lore:<i@ArcanistTooltip.lore.insert[<&a>Levels: <&c><[level]><&f>|<&a>EXP: <&c><[exp]><&f>].at[1]>'
        - define list:<[list].include[ArcanistTooltip[lore=<[lore]>]]>
        - foreach <[data].numerical> as:key:
            - define skill:<script[<[file]>].yaml_key[<[key]>.skill]>
            - define result:<proc[ProfessionLearnedSkill].context[<player>|Arcanist|<[skill]>]>
            - if <[result]>:
                #- narrate "Adding <[skill]>Learned!" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>Learned]>
            - else:
                #- narrate "Adding <[skill]>" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>]>
        - determine <[list]>
ProfessionArcanistAchievementMenu:
    type: inventory
    inventory: CHEST
    title: "Arcanist Achievements"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
#===========================================#
#==============[ Naturalist ]===============#
#===========================================#
# Class responsible for researching nature, beasts,
# pets, flora and fauna of all types. As a result, they can
# grow plants others may never be able to grow. (Farming base).
NaturalistItem:
    type: item
    material: wheat
    display name: "<&a>Naturalist"
    lore:
        - Class responsible for
        - the growth of custom plants,
        - breeding animals, and catching
        - the rarest of sea creatures.
ProfessionNaturalistMenu:
    type: inventory
    inventory: CHEST
    title: "Naturalist Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
    procedural items:
        - define file:NaturalistSkills
        - define data:<script[<[file]>].list_keys.exclude[type]>
        - define list:<list[]>
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - define level:<player.flag[Profession_Naturalist]>
        - define exp:<player.flag[Profession_Naturalist_EXP]>
        - define 'lore:<i@NaturalistTooltip.lore.insert[<&a>Levels: <&c><[level]><&f>|<&a>EXP: <&c><[exp]><&f>].at[1]>'
        - define list:<[list].include[NaturalistTooltip[lore=<[lore]>]]>
        - foreach <[data].numerical> as:key:
            - define skill:<script[<[file]>].yaml_key[<[key]>.skill]>
            - define result:<proc[ProfessionLearnedSkill].context[<player>|Naturalist|<[skill]>]>
            - if <[result]>:
                #- narrate "Adding <[skill]>Learned!" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>Learned]>
            - else:
                #- narrate "Adding <[skill]>" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>]>
        - determine <[list]>
ProfessionNaturalistAchievementMenu:
    type: inventory
    inventory: CHEST
    title: "Naturalist Achievements"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
#===========================================#
#=============[ Brewer/Cook ]===============#
#===========================================#
# Class for brewing, alcohol, and custom recipes.
# Poisoned food+drink
CulinaryItem:
    type: item
    material: bread
    display name: "<&d>Culinary"
    lore:
        - A class focused on the
        - creation of alcoholic
        - beverages and custom foodstuffs.
ProfessionCulinaryMenu:
    type: inventory
    inventory: CHEST
    title: "Culinary Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
    procedural items:
        - define file:CulinarySkills
        - define data:<script[<[file]>].list_keys.exclude[type]>
        - define list:<list[]>
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - define level:<player.flag[Profession_Culinary]>
        - define exp:<player.flag[Profession_Culinary_EXP]>
        - define 'lore:<i@CulinaryTooltip.lore.insert[<&a>Levels: <&c><[level]><&f>|<&a>EXP: <&c><[exp]><&f>].at[1]>'
        - define list:<[list].include[CulinaryTooltip[lore=<[lore]>]]>
        - foreach <[data].numerical> as:key:
            - define skill:<script[<[file]>].yaml_key[<[key]>.skill]>
            - define result:<proc[ProfessionLearnedSkill].context[<player>|Culinary|<[skill]>]>
            - if <[result]>:
                #- narrate "Adding <[skill]>Learned!" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>Learned]>
            - else:
                #- narrate "Adding <[skill]>" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>]>
        - determine <[list]>
ProfessionCulinaryAchievementMenu:
    type: inventory
    inventory: CHEST
    title: "Culinary Achievements"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
#===========================================#
#=============[ Nomad ]===============#
#===========================================#
# Class for brewing, alcohol, and custom recipes.
# Poisoned food+drink
NomadItem:
    type: item
    material: campfire
    display name: "<&a>Nomad"
    lore:
        - A class focused on making
        - themselves valuable through
        - experience and survival
        - abilities.
ProfessionNomadMenu:
    type: inventory
    inventory: CHEST
    title: "Nomad Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
    procedural items:
        - define file:NomadSkills
        - define data:<script[<[file]>].list_keys.exclude[type]>
        - define list:<list[]>
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - define level:<player.flag[Profession_Nomad]>
        - define exp:<player.flag[Profession_Nomad_EXP]>
        - define 'lore:<i@NomadTooltip.lore.insert[<&a>Levels: <&c><[level]><&f>|<&a>EXP: <&c><[exp]><&f>].at[1]>'
        - define list:<[list].include[NomadTooltip[lore=<[lore]>]]>
        - foreach <[data].numerical> as:key:
            - define skill:<script[<[file]>].yaml_key[<[key]>.skill]>
            - define result:<proc[ProfessionLearnedSkill].context[<player>|Nomad|<[skill]>]>
            - if <[result]>:
                #- narrate "Adding <[skill]>Learned!" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>Learned]>
            - else:
                #- narrate "Adding <[skill]>" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>]>
        - determine <[list]>
ProfessionNomadAchievementMenu:
    type: inventory
    inventory: CHEST
    title: "Nomad Achievements"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
#===========================================#
#=============[ Artisan ]===============#
#===========================================#
# Class for brewing, alcohol, and custom recipes.
# Poisoned food+drink
ArtisanItem:
    type: item
    material: emerald
    display name: "<&b>Artisan"
    lore:
        - A class focused on making
        - themselves valuable through
        - experience and survival
        - abilities.
ProfessionArtisanMenu:
    type: inventory
    inventory: CHEST
    title: "Artisan Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
    procedural items:
        - define file:ArtisanSkills
        - define data:<script[<[file]>].list_keys.exclude[type]>
        - define list:<list[]>
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - define level:<player.flag[Profession_Artisan]>
        - define exp:<player.flag[Profession_Artisan_EXP]>
        - define 'lore:<i@ArtisanTooltip.lore.insert[<&a>Levels: <&c><[level]><&f>|<&a>EXP: <&c><[exp]><&f>].at[1]>'
        - define list:<[list].include[ArtisanTooltip[lore=<[lore]>]]>
        - foreach <[data].numerical> as:key:
            - define skill:<script[<[file]>].yaml_key[<[key]>.skill]>
            - define result:<proc[ProfessionLearnedSkill].context[<player>|Artisan|<[skill]>]>
            - if <[result]>:
                #- narrate "Adding <[skill]>Learned!" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>Learned]>
            - else:
                #- narrate "Adding <[skill]>" targets:<server.match_player[Insilvon]>
                - define list:<[list].include[<[skill]>]>
        - determine <[list]>
ProfessionArtisanAchievementMenu:
    type: inventory
    inventory: CHEST
    title: "Artisan Achievements"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"

#= Items
EmptySlotItem:
    type: item
    material: barrier
    display name: <&c>Empty Slot
    lore:
    - Empty profession slot.
    - Click to fill!
ConfirmItem:
    type: item
    material: green_stained_glass
    display name: "<&a>Confirm"
RejectItem:
    type: item
    material: red_stained_glass
    display name: "<&c>Cancel"