    #- Character Sheets 2.0
# - Save data per player, per character. 

#= Flags:
# CharacterSheet: have they used this system
# CharacterSheet_Characters: Linkedlist of Characters that are loaded
    #- <player.flag[<[charactersheet_characters].size>]> -- number of characters loaded and active
# CharacterSheet_Limit: total number of characters that can be made
# CharacterSheet_CurrentCharacter: current character loaded from the sheet and active

CharacterFormat:
    type: format
    format: "<&b>[Characters]<&co><&f> <text>"
# Controller
CharacterSheetController:
    type: world
    events:
        on player joins:
            - if !<player.has_flag[CharacterSheet]>:
                - if !<server.has_file[CharacterSheets/<player.uuid>/base.yml]>:
                    - narrate "Creating Base File" format:CharacterFormat
                    - yaml create id:base
                    - yaml "savefile:/CharacterSheets/<player.uuid>/base.yml" id:base
                    - yaml "load:/CharacterSheets/<player.uuid>/base.yml" id:base
                    # Set data here
                    - yaml id:base set info.username:<player.name>
                    - yaml id:base set permissions.character_limit:1
                    - yaml "savefile:/CharacterSheets/<player.uuid>/base.yml" id:base
                    - yaml unload id:base
                - inject CharacterSheetPrompt
        on player clicks item in CharacterSheetMenu:
            - determine cancelled passively
            - if <context.item.material.name||null> == PLAYER_HEAD:
                - inventory open d:CharacterSheetSelectMenu
            - choose <context.item.script.name||null>:
                - case CharacterSheetDiscoveriesItem:
                    - inventory open d:CharacterSheetDiscoveriesMenu
                - case CharacterSheetQuestItem:
                    - execute as_player "questlog"
                - case CharacterSheetRollItem:
                    - inventory open d:CharacterSheetRollMenu
                - case CharacterSheetLetterItem:
                    - execute as_player "l"
                - case CharacterSheetProfessionsItem:
                    - execute as_player "profession"
                # - case CharacterSheetCharmItem:
                #     - narrate "Opening Charm Menu!"
                - case CharacterSheetSkinItem:
                    - define character:<player.flag[CharacterSheet_CurrentCharacter]>
                    - if !<player.has_flag[<[character]>_SkinMenu]>:
                        - note in@CharacterSkinMenu as:<[Character]>_SkinMenu
                        - flag player <[character]>_SkinMenu
                        - flag player <[character]>_Skin_ID:1
                    - inventory open d:in@<player.flag[CharacterSheet_CurrentCharacter]>_SkinMenu
        on player clicks item in CharacterSheetSelectMenu:
            - determine cancelled passively
            - define item:<context.item||air>
            - if <[item].script.name||null> == CharacterSheetBackItem:
                - inventory open d:CharacterSheetMenu
            - if <[item]> != air && <context.item.material.name> == PLAYER_HEAD:
                - define character:<context.item.display>
                - if <context.click> == DROP:
                    - flag player CharacterDelete:<context.item> d:2m
                    - inventory open d:CharacterSheetDeleteMenu
                - if <context.click> == LEFT:
                    - inventory close
                    - inject CharacterSheetSwap
        on player clicks item in CharacterSheetDeleteMenu:
            - determine cancelled passively
            - define item:<context.item||air>
            - if <[item].script.name> == CharacterDeleteConfirmItem:
                - define character:<player.flag[CharacterDelete]||null>
                - if <[character]> == null:
                    - narrate "Timed Out. Please try again."
                    - inventory close
                    - stop
                - define character:<[character].display>
                - inject CharacterSheetDelete
                - inventory close
                - stop
            - if <[item].material.name> == PLAYER_HEAD || <[item].script.name> == CharacterDeleteCancelItem:
                - inventory open d:CharacterSheetSelectMenu
                - stop
        on player clicks item in CharacterSkinMenu:
            - determine cancelled passively
            - define character:<player.flag[CharacterSheet_CurrentCharacter]>
            - if <context.item.script.name||null> == CharacterSheetBackItem:
                - inventory open d:CharacterSheetMenu
            - if <context.click> == left && <context.item.material.name> == player_head:
                - define id:<context.item.lore.get[1]>
                - define skin:<player.flag[<[character]>_Skin_<[id]>]>
                - flag <player> <[character]>_skin:<[skin]>
                - define skinTexture:true
                - inject SkinHandler
            - if <context.click> == DROP && <context.item.material.name> == player_head:
                - define id:<context.item.lore.get[1]>
                - take <context.item> from:<[character]>_SkinMenu
                - flag <player> <[character]>_Skin_<[id]>:!
        on player clicks item in CharacterSheetRollMenu:
            - determine cancelled passively
            - define item:<context.item>
            - choose <[item].script.name>:
                - case CharacterSheetBackItem:
                    - inventory open d:CharacterSheetMenu
                    - stop
                - case CharacterSheetRollDice:
                    - execute as_player "roll"
                    - inventory close
                - case ArtisanDice:
                    - execute as_player "proll Artisan"
                    - inventory close
                - case NomadDice:
                    - execute as_player "proll Nomad"
                    - inventory close
                - case CulinaryDice:
                    - execute as_player "proll Culinary"
                    - inventory close
                - case EngineerDice:
                    - execute as_player "proll Engineer"
                    - inventory close
                - case BlacksmithDice:
                    - execute as_player "proll Blacksmith"
                    - inventory close
                - case ApothecaryDice:
                    - execute as_player "proll Apothecary"
                    - inventory close
                - case TradesmanDice:
                    - execute as_player "proll Tradesman"
                    - inventory close
                - case GunsmithDice:
                    - execute as_player "proll Gunsmith"
                    - inventory close
                - case MinerDice:
                    - execute as_player "proll Miner"
                    - inventory close
                - case PilotDice:
                    - execute as_player "proll Pilot"
                    - inventory close
                - case ArcanistDice:
                    - execute as_player "proll Arcanist"
                    - inventory close
                - case NaturalistDice:
                    - execute as_player "proll Naturalist"
                    - inventory close
            
        on player clicks item in CharacterSheetDiscoveriesMenu:
            - determine cancelled passively
            - define item:<context.item>
            - choose <[item].script.name||air>:
                - case CharacterSheetBackItem:
                    - inventory open d:CharacterSheetMenu
                    - stop 
                - case BrewhavenMap:
                    - give BrewhavenMap
                - case CrimsonSunMap:
                    - give CrimsonSunMap
                - case CrimsonDeltaMap:
                    - give CrimsonDeltaMap
                - case GeezerGarageMap:
                    - give GeezerGarageMap
                - case LapidasMap:
                    - give LapidasMap
                - case MiasmyynCoveMap:
                    - give MiasmyynCoveMap
                - case GenevahMap:
                    - give GenevahMap
                - case CentrecrestMap:
                    - give CentrecrestMap
                - case SunTeahouseMap:
                    - give SunTeahouseMap
                
            

# Main Command
CharacterSheetCommand:
    type: command
    name: charactersheet
    desc: charactersheet create|delete|skin
    usage: charactersheet create|delete|skin
    aliases:
        - c
    script:
        - define command:<context.args.get[0]||null>
        - choose <[command]>:
            - case Help:
                - narrate "Character Commands:" format:CharacterFormat
                - narrate "<&b>/c help<&f> - Display this menu."
                - narrate "<&b>/c <&f> - Open the Character Menu"
                - narrate "<&b>/c reset<&f> - Wipe ALL DATA regarding ALL CHARACTERS."
                - narrate "<&b>/c create YourCharactersRealName<&f> - Create a new Character with a given real name. Ex: /c create JamesBond"
                - narrate "<&b>/c nick YourCharactersDisplayName<&f> - Nickname your character something other than their real name. Ex: /c nick &b007"
                - narrate "<&b>/c skin help<&f> - view the skin help!"
                - stop
            - case Create:
                - if <context.args.size> != 2:
                    - narrate "Syntax: /c create YourCharacterName"
                    - narrate "You may use Underscores in the name. Ex: JohnSmith or John_Smith"
                    - stop
                - inject CharacterSheetCreate
            - case Stats:
                - inject CharacterSheetStats
            - case Reset:
                - inject CharacterSheetReset
            - case Delete:
                - if <context.args.get[2]||null> == confirm:
                    - inject CharacterSheetDelete
                    - stop
                - narrate "This will delete your current character. Are you sure?"
                - wait 1s
                - narrate "Run <&c>/charactersheet delete confirm<&f> to continue."
            - case Skin:
                - inject CharacterSheetSkinHandler
            - case nick:
                - define arg:<context.args.get[2]||null>
                - if <[arg]> != null:
                    - execute as_server "nickname <player.name> <[arg]>"
                    - adjust <player> "player_list_name:<player.display_name.replace[_].with[ ].parse_color>"
                    - stop
            - default:
                - if <player.has_flag[CharacterSheet_CurrentCharacter]>:
                    - inventory open d:CharacterSheetMenu
                - else:
                    - inventory open d:CharacterSheetSelectMenu
            # - case Skin:

# Character Creation Script
CharacterSheetCreate:
    type: task
    speed: instant
    script:
        - if !<player.has_flag[CharacterSheet]>:
            - run CharacterSheetFirstTimeSetup def:<player>
        - define current:<player.flag[CharacterSheet_Characters].size>
        - define limit:<player.flag[CharacterSheet_Limit]>
        - if <[current]> >= <[limit]>:
            - narrate "You have reached the maximum number of characters allowed for this account."
            - stop
        - define charactername:<context.args.get[2]>
        - if <player.has_flag[CharacterSheet_Characters]> && <player.flag[CharacterSheet_Characters].contains[<[charactername]>]>:
            - narrate "You already have a character with this name! If this is an error, submit a ticket!"
            - stop
        - flag player CharacterSheet_Characters:->:<[charactername]>
        # Is this the first character?
        # - flag player CharacterSheet_CurrentCharacter:<[charactername]>
        # Create the file for them
        - run CreateCharacterSheet def:<player>|<[charactername]>
        - wait 2s
        - define character:<[charactername]>
        - inject CharacterSheetSwap
        - money set quantity:1000
        - give cooked_beef quantity:32
        - give stone_sword quantity:1
        - give stone_pickaxe quantity:1
        - give stone_axe quantity:1

# Character Sheet Delete Current Character
CharacterSheetDelete:
    type: task
    speed: instant
    script:
        - narrate "Now deleting <[Character]>"
        - flag player CharacterSheet_Characters:<-:<[Character]>
        - flag player CharacterSheet_CurrentCharacter:!
        - define active:<player.flag[CharacterSheet_Characters].size||0>
        - if <[active]> == 0:
            - inject CharacterSheetReset
        - else:
            - define character:<player.flag[CharacterSheet_Characters].get[1]>
            - inject CharacterSheetSwap


# Character Sheet Statistics
CharacterSheetStats:
    type: task
    speed: instant
    script:
        - narrate "Current Stats >>>>>>"
        - narrate "Have used Character Sheets: <player.flag[CharacterSheet]>"
        - narrate "Characters: <player.flag[CharacterSheet_Characters].comma_separated>"
        - narrate "Number of Characters: <player.flag[CharacterSheet_Characters].size>"
        - narrate "Character Limit: <player.flag[CharacterSheet_Limit]>"
        - narrate "Current Character: <player.flag[CharacterSheet_CurrentCharacter]>"

# Skinning
CharacterSheetSkinHandler:
    type: task
    speed: instant
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if !<player.has_flag[<[character]>_SkinMenu]>:
            - note in@CharacterSkinMenu as:<[Character]>_SkinMenu
            - flag player <[character]>_SkinMenu
            - flag player <[character]>_Skin_ID:1
        - define arg:<context.args.get[2]||null>
        - choose <[arg]>:
            - case help:
                - narrate "To use this feature, you must upload your character's skin to <&a>http://imgur.com<&f> and get the .png link from the image." format:CharacterFormat
                - narrate "Then run /c skin i.imgur.com/yourskinlink.png to set this character's skin." format:CharacterFormat
                - narrate "<&b>/c skin <&lt>url<&gt> <&f>- sets your character's main skin." format:CharacterFormat
                - narrate "<&b>/c skin add <&lt>url<&gt> Name <&f>- adds a skin to your character's wardrobe." format:CharacterFormat
                - narrate "<&b>/c skin reset <&f> - Remove custom skins and return to default." format:CharacterFormat
            - case reset:
                - adjust <player> skin_blob:<server.flag[<player.uuid>_DefaultSkin]>
            - case view:
                - define character:<player.flag[CharacterSheet_CurrentCharacter]>
                - if !<player.has_flag[<[character]>_SkinMenu]>:
                    - note in@CharacterSkinMenu as:<[Character]>_SkinMenu
                    - flag player <[character]>_SkinMenu
                    - flag player <[character]>_Skin_ID:1
                - inventory open d:<[character]>_SkinMenu
            - case add:
                - if <context.args.get[3]||null> != null && <context.args.size> == 4:
                    - narrate "Changing skin to <context.args.get[3]>!" format:CharacterFormat
                    - define character:<player.flag[CharacterSheet_CurrentCharacter]>
                    #= Replace this with a dynamic menu and loaded skin stuff from YAML
                    - flag player <[character]>_skin:<context.args.get[3]>
                    - define skinTexture:true
                    - inject SkinHandler
                    # - define inv:in@<player.uuid>_GUI
                    # - define target:<[inv].list_contents.with_lore[<[character]>].get[1].get[1]>
                    # - define slot:<[inv].find[<[target]>]>
                    - give player_head[skull_skin=<player.uuid>|<[skinTexture]>;lore=<player.flag[<[character]>_Skin_ID]>;display_name=<context.args.get[4]||null>] to:<[character]>_skinmenu
                    - flag player <[character]>_Skin_<player.flag[<[character]>_Skin_ID]>:<context.args.get[3]>
                    - flag player <[character]>_Skin_ID:++
                    - run SetCharacterYAML def:<player>|skins.<[character]>|<[skinTexture]>
                - else:
                    - narrate "/c skin add <&lt>url<&gt> nameforskin"
            - default:
                - if <context.args.size> == 2:
                    - narrate "Changing skin to <context.args.get[2]>!" format:CharacterFormat
                    - if !<player.has_flag[<[character]>_SkinMenu]>:
                        - note in@CharacterSkinMenu as:<[Character]>_SkinMenu
                        - flag player <[character]>_SkinMenu
                    - define character:<player.flag[CurrentCharacter]>
                    - flag player <[character]>_skin:<context.args.get[2]>
                    - define skinTexture:true
                    - inject SkinHandler
                    - run SetCharacterYAML def:<player>|skins.<[character]>|<[skinTexture]>

                - else:
                    - narrate "To use this feature, you must upload your character's skin to <&a>http://imgur.com<&f> and get the .png link from the image." format:CharacterFormat
                    - narrate "Then run /c skin i.imgur.com/yourskinlink.png to set this character's skin." format:CharacterFormat
                    - narrate "<&b>/c skin <&lt>url<&gt> <&f>- sets your character's main skin." format:CharacterFormat
                    - narrate "<&b>/c skin add <&lt>url<&gt> Name <&f>- adds a skin to your character's wardrobe." format:CharacterFormat
                    - narrate "<&b>/c skin view <&f>- view all skins in your character's wardrobe." format:CharacterFormat
                    - narrate "<&b>/c skin reset <&f> - Remove custom skins and return to default." format:CharacterFormat
        - stop

# Reset Your Character
CharacterSheetReset:
    type: task
    speed: instant
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - inject ProfessionReset
        - foreach <player.flag[CharacterSheet_Characters]||null>:
            - foreach <player.list_flags> as:theFlag:
                - if <[theFlag].contains_text[<[character]>]>:
                    - flag <player> <[theFlag]>:!
            - note remove as:<[Character]>_SkinMenu
        - flag player CharacterSheet:!
        - flag player CharacterSheet_Characters:!
        - flag player CharacterSheet_CurrentCharacter:!
        - inject CharacterSheetPrompt

# First Time Setup
CharacterSheetFirstTimeSetup:
    type: task
    definitions: target
    script:
        - flag <[target]> CharacterSheet
        - flag <[target]> CharacterSheet_Limit:1
        - run CreateCharacterBaseSheet def:<[target]>
#=
CharacterSheetSwap:
    type: task
    speed: instant
    script:
        - narrate "You are now <[character]>."
        - define currentCharacter:<player.flag[CharacterSheet_CurrentCharacter]||null>
        - define targetCharacter:<[character]>
        - if <[CurrentCharacter]> != null:
            - inject SaveCurrentCharacterSheet
        - inject LoadTargetCharacterSheet
        - if <player.has_flag[<[currentcharacter]>_skin]>:
            - inject SkinHandler
            - define skin_blob:<player.skin_blob>
            - adjust <[item]> skull_skin:<player.uuid>|<[skin_blob]>
        - else:
            - narrate "You have not set a skin for this character! Do so with <&hover[View Skin Command]><&click[/c skin help]><&3>/c skin help<&f><&end_click><&end_hover>" format:CharacterFormat
        - adjust <player> "player_list_name:<player.display_name.replace[_].with[ ].parse_color>"

SaveCurrentCharacterSheet:
    type: task
    speed: instant
    script:
        - if <server.has_file[/CharacterSheets/<player.uuid>/<[CurrentCharacter]>.yml]>:
            - define coreflags:<player.list_flags.get[<player.list_flags.find_all_partial[CharacterSheet]>]>
            - define others:<player.list_flags.exclude[<[coreflags]>]>
            - define flagValues:<list[]>
            - foreach <[others]> as:theFlag:
                - define flagValues:<[flagValues].include[<[theFlag]>/<player.flag[<[theFlag]>]>]>
                - flag player <[theFlag]>:!
            - yaml load:/CharacterSheets/<player.uuid>/<[CurrentCharacter]>.yml id:<[CurrentCharacter]>
            - yaml id:<[CurrentCharacter]> set flags:<[others]>
            - yaml id:<[CurrentCharacter]> set info.character_location:<player.location>
            - yaml id:<[CurrentCharacter]> set info.character_equipment:<player.equipment>
            - yaml id:<[CurrentCharacter]> set info.character_display_name:<player.display_name.escaped>
            - yaml id:<[CurrentCharacter]> set info.character_inventory:<player.inventory.list_contents>
            - yaml id:<[CurrentCharacter]> set money:<player.money>
            - yaml id:<[CurrentCharacter]> set flags:<[flagValues]>
            - yaml savefile:/CharacterSheets/<player.uuid>/<[CurrentCharacter]>.yml id:<[CurrentCharacter]>
        - else:
            - narrate "We couldn't find a file for your current character! Stopping!"
            - stop
LoadTargetCharacterSheet:
    type: task
    speed: instant
    script:
        - if <server.has_file[/CharacterSheets/<player.uuid>/<[targetCharacter]>.yml]>:
            - flag <player> CharacterSheet_CurrentCharacter:<[targetCharacter]>
            - define character_name:<proc[GetCharacterName].context[<player>]>
            - define character_display_name:<proc[GetCharacterYAML].context[<player>|Info.Character_Display_Name]>
            # Set nick
            - execute as_server "nickname <player.name> <[character_display_name].unescaped.parse_color>"
            # move them to their last location
            - define location:<proc[GetCharacterLocation].context[<player>]>
            - if <[location]> == null:
                - define location:<player.location>
            - teleport <player> <[location]>
            # set their inventory
            - inventory clear d:<player.inventory>
            - define inventory:<proc[GetCharacterYAML].context[<player>|info.character_inventory]||null>
            # - narrate "Found inventory <[inventory]>"
            - if <[inventory]> != li@:
                # - inventory set d:<player.inventory> o:<[inventory]>
                - inventory set d:<player.inventory> o:<[inventory]>
            # set their equipment
            - define equipment:<proc[GetCharacterYAML].context[<player>|info.character_equipment]||null>
            - if <[equipment]> != null:
                - adjust <player> 'equipment:<[equipment]>'
            - else:
                - adjust <player> 'equipment:li@air|air|air|air'
            # set their money
            - define dough:<proc[GetCharacterYAML].context[<player>|money].as_int>
            # - narrate "Found dough <[dough]>"
            - money set quantity:<proc[GetCharacterYAML].context[<player>|money]>
            # set their flags
            - define flags:<proc[GetCharacterYAML].context[<player>|flags]>
            - foreach <[flags]> as:theFlag:
                - define theFlagName:<[theFlag].before[/]>
                - define theFlagValue:<[theFlag].after[/]>
                # - narrate "<[theFlagName]> <[theFlagValue]>"
                - flag <player> <[theFlagName]>:<[theFlagValue]>
            # set their skins
        - else:
            - narrate "We couldn't find a file for your target character! Stopping!"
            - stop
# Task which generates a base file for this player
CreateCharacterBaseSheet:
    type: task
    definitions: target
    script:
        - if !<server.has_file[CharacterSheets/<[target].uuid>/base.yml]>:
            - narrate "Creating Base File" format:CharacterFormat
            - yaml create id:base
            - yaml "savefile:/CharacterSheets/<[target].uuid>/base.yml" id:base
            - yaml "load:/CharacterSheets/<[target].uuid>/base.yml" id:base
            # Set data here
            - yaml id:base set info.username:<[target].name>
            - yaml id:base set permissions.character_limit:1
            - yaml "savefile:/CharacterSheets/<[target].uuid>/base.yml" id:base
            - yaml unload id:base

# Task which creates a new character sheet for this player YAML
CreateCharacterSheet:
    type: task
    definitions: target|charactername
    script:
        - narrate "Creating character <[charactername]> for player <[target].name>."
        - define id:<[charactername]>
        - yaml create id:<[id]>
        - ~yaml "savefile:/CharacterSheets/<[target].uuid>/<[id]>.yml" id:<[id]>
        - ~yaml "load:/CharacterSheets/<[target].uuid>/<[id]>.yml" id:<[id]>
        - ~yaml id:<[id]> set Info.Character_Name:<[charactername]>
        - ~yaml id:<[id]> set Info.Character_Display_Name:<[charactername]>
        - ~yaml id:<[id]> set Info.Character_Location:<[target].location>
        - ~yaml id:<[id]> set Money:0
        # Description
        - ~yaml id:<[id]> set Description.Text:""
        # Faction
        - ~yaml id:<[id]> set Faction.Name:""
        # Town
        - ~yaml id:<[id]> set Town.Name:""
        # Renown
        - ~yaml id:<[id]> set Renown.ChildrenOfTheSun:0
        - ~yaml id:<[id]> set Renown.Skyborne:0
        - ~yaml id:<[id]> set Renown.Outsiders:0
        - ~yaml "savefile:/CharacterSheets/<[target].uuid>/<[id]>.yml" id:<[id]>

# Character Sheet Skull Getter
GetCharacterSheetSkull:
    type: procedure
    definitions: target|character
    script:
        - define skin:<proc[GetSpecificCharacterYAML].context[<[target]>|<[character]>|skins.<[character]>]>
        - define skindata:1
        - if <[skin]> != null:
            - define skindata:<[target].uuid>|<[skin]>
        - else:
            - define skindata:<[target].name>
        - define name:<[character]>
        - define "lore:Play as|<[character]>"
        - define item:player_head[skull_skin=<[skindata]>;lore=<[lore]>;display_name=<[character]>]
        - determine <[item]>
GetCharacterSheetSwapSkull:
    type: procedure
    defintions: target
    script:
        - define "lore:Choose your Character."
        - define "display:<&3>Character Select"
        - define item:player_head[skull_skin=<player.name>;lore=<[lore]>;display_name=<[display]>]
        - determine <[item]>

# Obnoxious Character Sheet Prompt
CharacterSheetPrompt:
    type: task
    speed: instant
    script:
        - if !<player.has_flag[CharacterSheetSpectator]>:
            - create player <player.display_name> <player.location> save:temp
            - flag player CharacterSheetSpectator:<entry[temp].created_npc> d:5h
            - define host:<entry[temp].created_npc>
        - else:
            - define host:<player.flag[CharacterSheetSpectator]>
        - wait 1s
        - invisible <[host]> state:true
        - adjust <[host]> name_visible:false
        - while !<player.has_flag[CharacterSheet]> && <player.is_online>:
            - adjust <player> gamemode:spectator
            - adjust <player> spectate:<[host]>
            - narrate "You must have a character sheet to play!"
            - narrate "Create your character with <&c>/c create <&lt>YourCharacterName<&gt>"
            - narrate "<&l><&o><&4>DO NOT USE COLORCODES. USE UNDERSCORES TO SEPARATE NAMES."
            - wait 7s
        - if <player.is_online>:
            - adjust <player> spectate:<player>
        - if <player.is_online>:
            - adjust <player> gamemode:survival
        - if <player.is_online>:
            - remove <[host]>
            - flag player CharacterSheetSpectator:!

CharacterSheetQuestItem:
    type: item
    material: cartography_table
    display name: <&e>Your Quests
    lore:
        - Click to view your 
        - quest menu!
#= Discoveries
CharacterSheetDiscoveriesItem:
    type: item
    material: player_head[skull_skin=ed78c07a-0253-4cef-89ba-bb6151097163|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOWMxMWQ2Yzc5YjhhMWYxODkwMmQ3ODNjZGRhNGJkZmI5ZDQ3MzM3YjczNzkxMDI4YTEyNmE2ZTZjZjEwMWRlZiJ9fX0=]
    display name: <&b>Discoveries
    lore:
        - Click to view images of
        - all the places you have
        - discovered!
CharacterSheetDiscoveriesMenu:
    type: inventory
    title: <&3>Discoveries
    inventory: CHEST
    size: 54
    slots:
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
    procedural items:
        - define list:<list[]>
        - if <player.has_flag[Discoveries]>:
            - foreach <player.flag[Discoveries]> as:Location:
                - define list:<[list].include[<[location]>Map]>
        - determine <[list]>
#=TODO: Make this reuse old maps
testLocationMap:
    type: item
    material: filled_map[map=1]
    display name: <&b>Test Location
    lore:
        - A Test Location!
# GiveCustomMap:
#     type: task
#     script:
#         - map new:world image:testLocation.png resize save:map
#         - narrate <entry[map].created_map>
#         - give filled_map[map=<entry[map].created_map>]
#= Rolling
CharacterSheetRollItem:
    type: item
    material: player_head[skull_skin=6677c802-9806-47d8-b91f-8e5f50aa75cd|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNmUyMmMyOThlN2M2MzM2YWYxNzkwOWFjMWYxZWU2ODM0YjU4YjFhM2NjOTlhYmEyNTVjYTdlYWViNDc2MTczIn19fQ==]
    display name: <&d>Dice bag
    lore:
        - Dice for character based rolls,
        - CHARM rolls, and Profession rolls.

CharacterSheetRollDice:
    type: item
    material: player_head[skull_skin=6677c802-9806-47d8-b91f-8e5f50aa75cd|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNmUyMmMyOThlN2M2MzM2YWYxNzkwOWFjMWYxZWU2ODM0YjU4YjFhM2NjOTlhYmEyNTVjYTdlYWViNDc2MTczIn19fQ==]
    display name: <&c>Vanilla Dice
    lore:
        - A basic d-20 used for
        - DMing and regular encounters.

CharacterSheetRollMenu:
    type: inventory
    title: <&5>Dice Bag
    inventory: CHEST
    size: 27
    slots:
        - "[CharacterSheetRollDice] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
    procedural items:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - define list:<list[]>
        - foreach li@Artisan|Nomad|Culinary|Engineer|Blacksmith|Apothecary|Tradesman|Gunsmith|Miner|Pilot|Arcanist|Naturalist as:prof:
            - if <player.has_flag[<[character]>_Profession_<[prof]>]>:
                - define list:<[list].include[<[prof]>Dice]>
        - determine <[list]>
#= Character Sheet
CharacterSheetMenu:
    type: inventory
    title: <&3>Character Sheet
    inventory: CHEST
    size: 27
    slots:
        - "[CharacterSheetRollItem] [CSLI] [CSLI] [CSLI] [CharacterSheetDiscoveriesItem] [CSLI] [CSLI] [CSLI] [CharacterSheetQuestItem]"
        - "[CSLI] [CharacterSheetProfessionsItem] [CSLI] [CharacterSheetCharmItem] [CSLI] [CharacterSheetLetterItem] [CSLI] [CharacterSheetSkinItem] [CSLI]"
        - "[] [CSLI] [CSLI] [CSLI] [] [CSLI] [CSLI] [CSLI] []"
    procedural items:
        - define balanceItem:Sol[display_name=<&e>Crests;lore=<player.money>]
        # - define townItem:i@brick[display_name=<&5>Your Town;lore=<player.flag[<player.flag[CharacterSheet_CurrentCharacter]>_Town]||None>]
        - define skullItem:<proc[GetCharacterSheetSwapSkull]>
        - define characteR:<player.flag[CharacterSheet_CurrentCharacter]>
        - define 'townItem:i@brick[display_name=<&b>Your Town;lore=<player.flag[<[character]>_Town]||None>]'
        - determine li@<[balanceItem]>|<[townItem]>|<[skullItem]>

#= Character Select
# Character Select Menu
CharacterSheetSelectMenu:
    type: inventory
    title: <&3>Character Select Menu
    inventory: CHEST
    size: 27
    slots:
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"
    procedural items:
        - define list:<list[]>
        - if <player.has_flag[CharacterSheet]>:
            - foreach <player.flag[CharacterSheet_Characters]> as:character:
                - define item:<proc[GetCharacterSheetSkull].context[<player>|<[character]>]>
                - define list:<[list].include[<[item]>]>
        - determine <[list]>

CSLI:
    type: item
    material: gray_stained_glass_pane
    display name: <&4>X
CharacterSheetProfessionsItem:
    type: item
    material: iron_pickaxe[flags=hide_enchants]
    display name: <&a>Professions
    enchantments:
        - infinity:1
    lore:
        - The Profession System.
        - Coming REAL Soon!
CharacterSheetCharmItem:
    type: item
    material: iron_sword[flags=hide_enchants]
    display name: <&b>CHARM
    enchantments:
        - infinity:1
    lore:
        - The Combat Skills System.
        - Coming Soon!
CharacterSheetLetterItem:
    type: item
    material: map
    display name: <&5>Letters
CharacterSheetSkinItem:
    type: item
    material: creeper_head
    display name: <&6>Your Skins
CharacterSheetBackItem:
    type: item
    material: barrier
    display name: <&4>Go Back
CharacterSheetTownItem:
    type: item
    material: brick
    display name: <&5>Towns
#= Character Delete GUI
# Character Delete Confirm Menu
CharacterSheetDeleteMenu:
    type: inventory
    title: Character Delete Menu
    inventory: CHEST
    size: 9
    slots:
        - "[] [] [] [] [] [] [] [] []"
    procedural items:
        - define list:li@air|air|air|CharacterDeleteConfirmItem|<player.flag[CharacterDelete]>|CharacterDeleteCancelItem|air|air|air
        - determine <[list]>
CharacterDeleteConfirmItem:
    type: item
    material: green_stained_glass
    display name: <&4>Confirm Deletion
CharacterDeleteCancelItem:
    type: item
    material: red_stained_glass
    display name: <&4>Cancel
#= Character Skin Menu
CharacterSkinMenu:
    type: inventory
    inventory: chest
    title: <&d>Skin Closet
    size: 27
    slots:
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] [CharacterSheetBackItem]"

