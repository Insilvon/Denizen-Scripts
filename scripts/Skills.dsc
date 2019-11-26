# Skillbook System
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.1

# =================================================================================
# ============================= Core Command Scripts ==============================
# =================================================================================

# Main Skill Command - shows menu of all skills available to you
Skills:
    type: command
    name: skills
    usage: /skills
    script:
        - flag player <proc[GetCharacterName].context[<player>]>_SkillMenu:1
        - inject LoadSkillInventory

# Something to run on the player at launch
SkillSetup:
    type: task
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - flag player <[Character]>_BlockedSkills:7
        - flag player <[Character]>_LearnedSkills:->:SpeedSkillBook
        - flag player <[Character]>_LearnedSkills:->:StrengthSkillBook
        - flag player <[Character]>_LearnedSkills:->:WeaknessSkillBook
        - flag player <[Character]>_SkillMenu:1
        - note in@SkillInventoryTemplate as:<[Character]>_Skills

# Removes all flags/inventories for the character
SkillReset:
    type: task
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - flag player <[Character]>_BlockedSkills:!
        - flag player <[Character]>_ActiveSkills:!
        - flag player <[Character]>_LearnedSkills:!
        - flag player <[Character]>_SkillMenu:!
        - note remove as:<[Character]>_Skills
        
# =================================================================================
# ============================= General Event Scripts =============================
# =================================================================================

# Script to run on the "On Player Clicks in Inventory" event
SkillOnPlayerClicksInInventory:
    type: task
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - if <context.inventory> == in@<[character]>_Skills:
            - define inventory:in@<[character]>_skills
            - flag player <[character]>_activeskills:!
            - determine passively cancelled
            - if <context.slot> > 45:
                - define slot:<context.slot>
                - define item:<[inventory].slot[<[slot]>].script.name||air>
                - if <[item]> == INVENTORYBLOCKITEM:
                    - determine cancelled
                - else:
                    - narrate "You have selected a skillslot. Choose a skill to equip!"
                    - flag player <[character]>_Slot:<[slot]>
            - else:
                - if <player.has_flag[<[character]>_slot]>:
                    - inventory set d:in@<[character]>_skills o:<context.item> s:<player.flag[<[character]>_slot]>
                    - flag player <[character]>_slot:!
            - define num:0
            - define loop:<element[9].sub_int[<player.flag[<[character]>_BlockedSkills]>]>
            - repeat <[loop]>:
                - define number:<element[46].add_int[<[num]>]>
                - flag player <[character]>_activeskills:->:<[inventory].slot[<element[46].add_int[<[num]>]>].script.name>
                - define num:++

# Script to run on the "On Player Drop Clicks in Inventory" event
SkillOnPlayerDropClicksInInventory:
    type: task
    script:
        - if <context.inventory> == in@<proc[GetCharacterName].context[<player>]>_Skills:
            - determine cancelled
# Control Click
SkillOnPlayerControlClicksInInventory:
    type: task
    script:
        - if <context.inventory> == in@<proc[GetCharacterName].context[<player>]>_Skills || <context.inventory> == in@<[character]>_CompletedQuestMenu:
            - determine cancelled
# =================================================================================
# =============================== Items/Inventories ===============================
# =================================================================================

# Menu to hold the skills
SkillInventoryTemplate:
    type: inventory
    title: Learned Skills
    size: 54
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"

# TEST ITEMS
SpeedSkillBook:
    type: item
    material: diamond_sword
    display name: "Book of Speed"
    lore:
        - Use this to set speed book as active!

StrengthSkillBook:
    type: item
    material: book
    display name: "Book of Strength"
    lore:
        - Use this to set strength book as active!

WeaknessSkillBook:
    type: item
    material: book
    display name: "Book of Weakness"
    lore:
        - Use this to set weakness book as active!

# Item which blocks locked skillslots
InventoryBlockItem:
    type: item
    material: barrier
    display name: You haven<&sq>t unlocked this skill section yet!
    lore:
        - Additional slots can be unlocked
        - through interactions with the world.

# Item to show next page of learned skills
NextSkillPageItem:
    type: item
    material: player_head[skull_skin=23b3f9dc-f02c-4ea8-a949-dbd56b03602c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNGVmMzU2YWQyYWE3YjE2NzhhZWNiODgyOTBlNWZhNWEzNDI3ZTVlNDU2ZmY0MmZiNTE1NjkwYzY3NTE3YjgifX19]
    display name: Next Page

# Item to show last page of learned skills
LastSkillPageItem:
    type: item
    material: player_head[skull_skin=1226610a-b7f8-47e5-a15d-126c4ef18635|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjg0ZjU5NzEzMWJiZTI1ZGMwNThhZjg4OGNiMjk4MzFmNzk1OTliYzY3Yzk1YzgwMjkyNWNlNGFmYmEzMzJmYyJ9fX0=]
    display name: Back

# =================================================================================
# =========================== Support Scripts/Handlers ============================
# =================================================================================

# World script to listen to button clicks
SkillInventoryController:
    type: world
    events:
        on player clicks NextSkillPageItem in inventory:
            - run SkillMenuHandler def:next
            - determine cancelled
        on player clicks LastSkillPageItem in inventory:
            - run SkillMenuHandler def:last
            - determine cancelled
        # on player drop clicks in inventory priority:1:
        #     - inject SkillOnPlayerDropClicksInInventory
        # on player clicks in inventory priority:1:
        #     - inject SkillOnPlayerClicksInInventory

# Script which handles the page of items to load
SkillMenuHandler:
    type: task
    speed: instant
    definitions: direction
    script:
        - determine cancelled passively
        - if <[direction]> == next:
            - flag player <proc[GetCharacterName].context[<player>]>_SkillMenu:++
        - else:
            - flag player <proc[GetCharacterName].context[<player>]>_SkillMenu:--
            - if <player.flag[<proc[GetCharacterName].context[<player>]>_SkillMenu]> < 1:
                - flag player <proc[GetCharacterName].context[<player>]>_SkillMenu:1
        - inject LoadSkillInventory

# Main Inventory Loader, used as Injection for SkillChangePage
LoadSkillInventory:
    type: task
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define menu:<player.flag[<[character]>_SkillMenu]>
        - define end:<[menu].as_int.mul_int[42]>
        - define start:<[end].as_int.sub_int[41]>
        - define catch:li@
        - inventory clear d:in@<[character]>_Skills
        - if <player.flag[<[character]>_LearnedSkills]> != <[catch]> && <player.has_flag[<[character]>_LearnedSkills]>:
            - if <player.flag[<[character]>_LearnedSkills].size> < <[start]>:
                - flag player <[character]>_SkillMenu:--
                - inventory close
            - define display:<player.flag[<[character]>_LearnedSkills].get[<[start]>].to[<[end]>]||null>
            - if <[display]> == <[catch]> || <[display]> == null:
                - flag player <[character]>_SkillMenu:--
                - stop
            - foreach <[display]> as:item:
                - inventory add d:in@<[character]>_Skills o:<[item]>
        - inventory set d:in@<[Character]>_Skills o:i@NextSkillPageItem s:45
        - inventory set d:in@<[Character]>_Skills o:i@LastSkillPageItem s:44
        - define blocked:<player.flag[<[Character]>_BlockedSkills]>
        - if <player.flag[<[character]>_ActiveSkills]> != <[catch]> && <player.has_flag[<[character]>_ActiveSkills]>:
            - define value:0
            - foreach <player.flag[<[Character]>_ActiveSkills]> as:skill:
                - inventory set d:in@<[Character]>_Skills o:<[skill]> s:<element[46].add_int[<[value]>]>
                - define value:++
        - repeat <[blocked]>:
            - inventory set d:in@<[Character]>_Skills o:i@InventoryBlockItem s:<element[55].sub_int[<[value]>]>
        - inventory close
        - inventory open d:in@<[character]>_Skills

# Adds a Skillbook to the item. Takes params of the player and the item.
AddLearnedSkill:
    type: task
    definitions: player|item
    script:
        - flag player <proc[GetCharacterName].context[<[player]>]>_ActiveSkills:->:<[item]>
        - title "title: <gold>*SKILLS*" "subtitle:<gold>You have learned a new skill."
