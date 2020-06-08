QuestLog:
    type: command
    name: questlog
    usage: /questlog
    script:
        - inject QuestLoginScript
        - inventory open d:ActiveQuestMenu

QuestController:
    type: world
    events:
        on player clicks item in ActiveQuestMenu:
            - determine cancelled passively
            - define item:<context.item.script.name||air>
            - choose <[item]>:
                - case CompletedQuestItem:
                    - inventory close
                    - flag player CompletedQuestPage:1
                    - inventory open d:CompletedQuestMenu
                - case LastPageActiveQuestItem:
                    - if <player.flag[ActiveQuestPage]> >= 1:
                        - flag player ActiveQuestPage:--
                        - inventory close
                        - inventory open d:ActiveQuestMenu
                - case NextPageActiveQuestItem:
                    - flag player ActiveQuestPage:++
                    - inventory close
                    - inventory open d:ActiveQuestMenu
                - case CharacterSheetBackItem:
                    - inventory close
                    - inventory open d:CharacterSheetMenu
                - default:
                    - if <context.item.material.name> != air:
                        - if <context.click> == DROP:
                            - flag player ActiveQuestItems:<-:<context.item.script.name>
                            - inventory close
                            - drop <context.item> <player.location>
                        - else:
                            - inventory close
                            - adjust <player> show_book:<context.item.book>
        on player clicks item in CompletedQuestMenu:
            - determine cancelled passively
            - define item:<context.item.script.name||air>
            - choose <[item]>:
                - case ActiveQuestItem:
                    - inventory close
                    - flag player ActiveQuestPage:1
                    - inventory open d:ActiveQuestMenu
                - case LastPageCompletedQuestItem:
                    - if <player.flag[CompletedQuestPage]> >= 1:
                        - flag player CompletedQuestPage:--
                        - inventory close
                        - inventory open d:CompletedQuestMenu
                - case NextPageCompletedQuestItem:
                    - flag player CompletedQuestPage:++
                    - inventory close
                    - inventory open d:CompletedQuestMenu
                - case CharacterSheetBackItem:
                    - inventory close
                    - inventory open d:CharacterSheetMenu
                - default:
                    - if <context.item.material.name> != air:
                        - if <context.click> == DROP:
                            - flag player CompletedQuestItems:<-:<context.item.script.name>
                            - inventory close
                            - drop <context.item> <player.location>
                        - else:
                            - inventory close
                            - adjust <player> show_book:<context.item.book>

QuestLoginScript:
    type: task
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character for this"
            - stop
        - if !<player.has_flag[QuestJournal]>:
            - flag player QuestJournal
        - flag player QuestJournalPage:1

# Will reset all flags associated with this character's base quest structure
QuestReset:
    type: task
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - narrate "<&e>[Quests] - Removing data for character <[character]>"
        - flag player QuestJournal:!
        - flag player ActiveQuestPage:!
        - flag player CompletedQuestPage:!
        - flag player ActiveQuestItems:!
        - flag player CompletedQuestItems:!

# Will remove the given item from the Character's Active Quest Menu
RemoveActiveQuest:
    type: task
    definitions: player|item
    script:
        - if <player.flag[ActiveQuestItems].size> == 1:
            - if <player.flag[ActiveQuestItems]> == <[item]>:
                - flag player ActiveQuestItems:!
            - else:
                - stop
        - else:
            - flag <[player]> ActiveQuestItems:<player.flag[ActiveQuestItems].exclude[<[item]>]>

# Will add the specified item to the character's active quest menu
AddActiveQuest:
    type: task
    definitions: player|item
    script:
        - flag player ActiveQuestItems:->:<[item]>
        - title "title: <gold>*QUESTS*" "subtitle:<gold>Your questlog has been updated."

# Will add the specified item to the character's completed quest menu
AddCompletedQuest:
    type: task
    definitions: player|item
    script:
        - flag player CompletedQuestItems:->:<[item]>
        - title "title: <gold>*QUESTS*" "subtitle:<gold>Your questlog has been updated."
# =================================================================================
# =============================== Items/Inventories ===============================
# =================================================================================
# Item in inventory to load Active Quest Menu
ActiveQuestItem:
    type: item
    material: book
    display name: Active Quests
    lore:
        - "Show Active Quests"

# Item to show next Active Quest page
NextPageActiveQuestItem:
    type: item
    material: player_head[skull_skin=23b3f9dc-f02c-4ea8-a949-dbd56b03602c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNGVmMzU2YWQyYWE3YjE2NzhhZWNiODgyOTBlNWZhNWEzNDI3ZTVlNDU2ZmY0MmZiNTE1NjkwYzY3NTE3YjgifX19]
    display name: Next Page

# Item to show last Active Quest page
LastPageActiveQuestItem:
    type: item
    material: player_head[skull_skin=1226610a-b7f8-47e5-a15d-126c4ef18635|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjg0ZjU5NzEzMWJiZTI1ZGMwNThhZjg4OGNiMjk4MzFmNzk1OTliYzY3Yzk1YzgwMjkyNWNlNGFmYmEzMzJmYyJ9fX0=]
    display name: Back

# Item to show next Completed Quest page
NextPageCompletedQuestItem:
    type: item
    material: player_head[skull_skin=23b3f9dc-f02c-4ea8-a949-dbd56b03602c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNGVmMzU2YWQyYWE3YjE2NzhhZWNiODgyOTBlNWZhNWEzNDI3ZTVlNDU2ZmY0MmZiNTE1NjkwYzY3NTE3YjgifX19]
    display name: Next Page

# Item to show last Active Quest page
LastPageCompletedQuestItem:
    type: item
    material: player_head[skull_skin=1226610a-b7f8-47e5-a15d-126c4ef18635|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjg0ZjU5NzEzMWJiZTI1ZGMwNThhZjg4OGNiMjk4MzFmNzk1OTliYzY3Yzk1YzgwMjkyNWNlNGFmYmEzMzJmYyJ9fX0=]
    display name: Back

# Item in inventory to load Completed Quest Menu
CompletedQuestItem:
    type: item
    material: book
    display name: Completed Quests
    lore:
        - "Show Completed Quests"

# Menu template which shows active quests
ActiveQuestMenu:
    type: inventory
    inventory: CHEST
    title: Active Quests
    size: 45
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [i@CompletedQuestItem] [i@LastPageActiveQuestItem] [i@NextPageActiveQuestItem] [CharacterSheetBackItem]"
    procedural items:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if !<player.has_flag[ActiveQuestPage]>:
            - flag <player> ActiveQuestPage:1
        - define page:<player.flag[ActiveQuestPage]>
        - define end:<[page].mul_int[41]>
        - define start:<[end].sub_int[40]>
        - if <[start]> < 1:
            - define start:1
        - define items:<player.flag[ActiveQuestItems]||null>
        # - narrate "Found <[items]>"
        - define list:<list[]>
        - if <[items]> != null:
            - define display:<player.flag[ActiveQuestItems].get[<[start]>].to[<[end]>]>
            - define list:<[list].include[<[display]>]>
        - determine <[list]>
        
# Menu template which shows compelted quests
CompletedQuestMenu:
    type: inventory
    inventory: CHEST
    title: Completed Quests
    size: 45
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [i@ActiveQuestItem] [i@LastPageCompletedQuestItem] [i@NextPageCompletedQuestItem] [CharacterSheetBackItem]"
    procedural items:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if !<player.has_flag[CompletedQuestPage]>:
            - flag <player> CompletedQuestPage:1
        - define page:<player.flag[CompletedQuestPage]>
        - define end:<[page].mul_int[41]>
        - define start:<[end].sub_int[40]>
        - if <[start]> < 1:
            - define start:1
        - define items:<player.flag[CompletedQuestItems]||null>
        - define list:<list[]>
        - if <[items]> != null:
            - define display:<player.flag[CompletedQuestItems].get[<[start]>].to[<[end]>]>
            - define list:<[list].include[<[display]>]>
        - determine <[list]>