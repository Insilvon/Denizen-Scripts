#= Flags
#= Player flags
#- Chracter_Lockpick_Keyring_ID:1


#- Notification for joining town
#= keyrings getting eaten


#= FORMAT
LockpickFormat:
    type: format
    format: "<&c>[Locks]<&co><&f> <text>"

#= COMMAND
LockpickCommand:
    type: command
    debug: false
    name: lockpick
    description: (DEV) Use lockpicks, lock things.
    usage: /lockpick
    aliases:
    - l
    - lock
    - pick
    script:
        - choose <context.args.get[1]||null>:
            - case lock:
                - inject LockpickLock
                - stop
            - case rename:
                - inject LockpickRename
                - stop
            - case unlock:
                - inject LockpickUnlock
                - stop
            - default:
                - inject LockpickHelp
#= ITEMS
Lockpick:
    type: item
    material: stick
    display name: <&e>Lockpick

LockpickKey:
    type: item
    material: tripwire_hook
    display name: <&e>Key
    recipes:
        1:
            type: shapeless
            input: iron_nugget

LockpickKeyring:
    type: item
    material: name_tag
    display name: <&e>Empty Keyring
    recipes:
        1:
            type: shaped
            input:
                - air|iron_ingot|air
                - iron_ingot|leather|iron_ingot
                - air|iron_ingot|air
#= CONTROLLER
LockpickController:
    type: world
    events:
        on player places chest:
            - define other:<context.location.other_block||null>
            - if <[other]> != null:
                - if <server.has_flag[<[other]>_Key]>:
                    - determine cancelled passively
                    - narrate "You are not permitted to hack into locked chests." format:LockpickFormat
        on piston extends:
            - define blocks:<context.blocks>
            - define list:li@iron_door|oak_door|spruce_door|birch_door|acacia_door|jungle_door|dark_oak_door
            - foreach <[blocks]> as:block:
                - if <[block].material.name> == observer:
                    - determine cancelled
                - define direction:li@forward|left|right|backward
                - foreach <[direction]> as:point:
                - if <[list].contains[<[block].forward.block.material.name>]> && <server.has_flag[<[block].forward.block>_Key]> && !<server.has_flag[<[block].forward.block>_Key].contains_text[<proc[GetCharacterName].context[<player>]>]>:
                    - determine cancelled
                - if <[list].contains[<[block].left.block.material.name>]> && <server.has_flag[<[block].left.block>_Key]> && !<server.has_flag[<[block].forward.block>_Key].contains_text[<proc[GetCharacterName].context[<player>]>]>:
                    - determine cancelled
                - if <[list].contains[<[block].right.block.material.name>]> && <server.has_flag[<[block].right.block>_Key]> && !<server.has_flag[<[block].forward.block>_Key].contains_text[<proc[GetCharacterName].context[<player>]>]>:
                    - determine cancelled
                - if <[list].contains[<[block].backward.block.material.name>]> && <server.has_flag[<[block].backward.block>_Key]> && !<server.has_flag[<[block].forward.block>_Key].contains_text[<proc[GetCharacterName].context[<player>]>]>:
                    - determine cancelled
        on player right clicks with LockpickKeyring:
            - define character <proc[GetCharacterName].context[<player>]>
            - if !<context.item.has_lore>:
                - define id:<player.flag[<[character]>_Lockpick_Keyring_ID]>
                - inventory adjust slot:<player.item_in_hand.slot> "lore:<[id]>"
                - inventory adjust slot:<player.item_in_hand.slot> "display_name:<[character]><&sq>s Keyring"
                - note <player.item_in_hand> as:<[character]>_Lockpick_Keyring_<[id]>
                - note in@LockpickKeyringGUI as:<[character]>_Lockpick_Keyring_<[id]>_GUI
                - inventory set d:<player.inventory> s:<player.item_in_hand.slot> o:<[character]>_Lockpick_Keyring_<[id]>
                - flag player <[character]>_Lockpick_Keyring_ID:++
            - define id:<context.item.lore.get[1]>
            - inventory open d:in@<[character]>_Lockpick_Keyring_<[id]>_GUI
        # Prevent them from moving things except keys
        on player clicks item in LockpickKeyringGUI:
            - if <context.item> != i@air && <context.item.script.name> != LockpickKey
                - determine cancelled

#= TASKS
LockpickOnPlayerPlacesBlock:
    type: task
    debug: false
    script:
        - define location:<context.location>
        - define doors:<[location].find.blocks[iron_door|oak_door|spruce_door|birch_door|acacia_door|jungle_door|dark_oak_door|chest|barrel|iron_trapdoor|oak_trapdoor|spruce_trapdoor|birch_trapdoor|acacia_trapdoor|jungle_trapdoor|dark_oak_trapdoor].within[4]>
        - if <[doors].size> != 0:
            - define character:<proc[GetCharacterName].context[<player>]>
            - foreach <[doors]> as:door:
                - if <server.has_flag[<[door]>_Key]>:
                    - if !<server.flag[<[door]>_Key].contains_text[<[character]>]>:
                        - narrate "You cannot place a block this close to someone's locked block!" format:LockpickFormat
                        - determine cancelled
                        - stop
                    - else:
                        - if !<player.has_flag[LockpickWarn]>:
                            - narrate "Be careful, you're placing blocks very close to your locked items." format:LockpickFormat
                            - flag player LockpickWarn d:30m
LockpickBreakCheckIfLocked:
    type: task
    script:
        - define location:<context.location.block>
        - if <server.has_flag[<[location]>_Key]>:
            - if <server.flag[<[location]>_Key].contains_text[<proc[GetCharacterName].context[<player>]>]>:
                - define block:<[location].material.name>
                - if <[block]> == chest || <[block].contains_text[door]>:
                    - define half:<[location].material.half||null>
                    - choose <[half]>:
                        - case LEFT:
                            - flag server <[location].right>_Key:!
                        - case RIGHT:
                            - flag server <[location].left>_Key:!
                        - case TOP:
                            - flag server <[location].below>_Key:!
                        - case BOTTOM:
                            - flag server <[location].above>_Key:!
                    - flag server <[location]>_key:!
            - else:
                - narrate "You cannot break someone's locked block!" format:LockpickFormat
                - determine cancelled
LockpickUnlock:
    type: task
    debug: false
    script:
        - define location:<player.location.cursor_on.block>
        - if <server.has_flag[<[location]>_Key]>:
            - define block:<[location].material.name>
            - if <[block]> == chest || <[block].contains_text[door]>:
                - define half:<[location].material.half||null>
                - choose <[half]>:
                    - case LEFT:
                        - flag server <[location].right>_Key:!
                    - case RIGHT:
                        - flag server <[location].left>_Key:!
                    - case TOP:
                        - flag server <[location].below>_Key:!
                    - case BOTTOM:
                        - flag server <[location].above>_Key:!
                - flag server <[location]>_key:!
        - narrate "You have unlocked this <[location].material.name>." format:LockpickFormat
LockpickCheckIfLocked:
    type: task
    script:
        - define location:<context.location.block||null>
        - if !<server.has_flag[<[location]>_Key]>:
            - stop
        - if <player.item_in_hand.script.name||null> != LockpickKey && <player.item_in_offhand.script.name||null> != LockpickKeyring:
            - narrate "This is locked tight." format:LockpickFormat
            - determine cancelled
            - stop
        - define character:<proc[GetCharacterName].context[<player>]>
        - if <player.item_in_hand.script.name||null> == LockpickKey:
            - define ID:<player.item_in_hand.lore.get[1]>
            - define attempt:<[character]>_Key_<[ID]>
            - if <[attempt]> != <server.flag[<[location]>_Key]>:
                - narrate "This is locked tight." format:LockpickFormat
                - determine cancelled
                - stop
            - else:
                - stop
        - if <player.item_in_offhand.script.name||null> == LockpickKeyring:
            - define ID:<player.item_in_offhand.lore.get[1]>
            - define inventory:in@<[character]>_Lockpick_Keyring_<[id]>_GUI
            - define contents:<[inventory].list_contents.full>
            - foreach <[contents]> as:Key:
                - define keyID:<[key].lore.get[1]||null>
                - define attempt:<[character]>_Key_<[keyID]>
                - if <[attempt]> == <server.flag[<[location]>_Key]>:
                    - stop
            - narrate "This is locked tight." format:LockpickFormat
            - determine cancelled
            - stop
            
LockpickLock:
    type: task
    debug: false
    script:
        - define location:<player.location.cursor_on.block>
        - define target:<[location].material.name>
        - define character:<proc[GetCharacterName].context[<player>]>

        - if <player.has_flag[<[character]>_Lockpick_Key_ID]>:
            - define ID:<player.flag[<[character]>_Lockpick_Key_ID]>
            - flag player <[character]>_Lockpick_Key_ID:++
        - else:
            - flag player <[character]>_Lockpick_Key_ID:2
            - define ID:1
        
        - if <player.item_in_hand.script.name> != LockpickKey || <player.item_in_hand.has_lore>:
            - narrate "You must be holding a new key to lock this!" format:LockpickFormat
            - stop
        - if <[target]> == chest || <[target].contains_text[door]>:
            - define half:<[location].material.half||null>
            - choose <[half]>:
                - case LEFT:
                    - flag server <[location].right>_Key:<[character]>_Key_<[ID]>
                - case RIGHT:
                    - flag server <[location].left>_Key:<[character]>_Key_<[ID]>
                - case TOP:
                    - flag server <[location].below>_Key:<[character]>_Key_<[ID]>
                - case BOTTOM:
                    - flag server <[location].above>_Key:<[character]>_Key_<[ID]>
            - flag server <[location]>_Key:<[character]>_Key_<[ID]>
            - adjust <[location].material> piston_reaction:BLOCK
            - inventory adjust slot:<player.item_in_hand.slot> lore:<[ID]>
            - narrate "The <[target]> has been locked!" format:LockpickFormat

LockpickKeyringGUI:
    type: inventory
    title: Keyring
    size: 27
    slots:
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"
        - "[] [] [] [] [] [] [] [] []"

TownCommand:
    type: command
    debug: false
    name: town
    description: (DEV) Creates a town using active flags
    usage: /town
    aliases:
    - t
    script:

LockpickRename:
    type: task
    debug: false
    script:
        - define newName:<context.args.get[2]||null>
        - if <[newName]> == null:
            - narrate "You must specify a name for the key/keyring!" format:LockpickFormat
            - stop
        - if <player.item_in_hand.script.name> == LockpickKeyring || <player.item_in_hand.script.name> == LockpickKey:
            - inventory adjust s:<player.item_in_hand.slot> display_name:<&e><[newName]>

LockpickHelp:
    type: task
    debug: false
    script:
        - narrate "<&e>Help Menu - Page One-----------<&gt>" format:LockpickFormat
        - narrate "<&c>IMPORTANT NOTE: To open a locked door/container, either hold the key for it in your hand or hold the Keyring for it in your OFFHAND. Trust me!"
        - narrate "  <&c><&hover[Click Me!]><&click[/lockpick]>/lockpick<&end_click><&end_hover>: <&f>Displays this list!"
        - narrate "  <&c><&hover[Click Me!]><&click[/lockpick lock]>/lockpick lock<&end_click><&end_hover>: <&f>If you are holding a new key, this will lock the chest, door, trapdoor, or barrel in front of you."
        - narrate "  <&c><&hover[Click Me!]><&click[/lockpick unlock]>/lockpick unlock<&end_click><&end_hover>: <&f>Will remove the lock on the block you're looking at. You will have to make a new key next time you wish to lock it."
        - narrate "  <&c>/lockpick rename <&lt>name<&gt>: <&f>Renames the Key or Keyring to something of your choice. Helpful to organize."