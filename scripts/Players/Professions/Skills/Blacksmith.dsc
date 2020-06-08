BlacksmithTooltip:
    type: item
    material: player_head[skull_skin=945906b4-6fdc-4b99-9a26-30906befb63a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjM4YzUzZTY2ZjI4Y2YyYzdmYjE1MjNjOWU1ZGUxYWUwY2Y0ZDdhMWZhZjU1M2U3NTI0OTRhOGQ2ZDJlMzIifX19]
    display name: <&a>Help Item
    lore:
        - Gain profession levels
        - by forging tools, armor,
        - and weapons.

BlacksmithDice:
    type: item
    material: player_head[skull_skin=6c7a241b-4ef6-4c66-8cb8-958c6cb395a8|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYzZkNGEwMWRiNjEyNjYwMWRlZDE0MDZjZjYyMzhjZTJiNzAyNGVhY2U1ZWE2MDRmYmMyMDhhMmFmMjljOTdhZCJ9fX0=]
    display name: <&a>Blacksmith Dice
    lore:
        - Roll based on your
        - profession's skill!

# BlacksmithController:
#     type: world
#     events:
#         on player crafts item:
#             - define ironList:li@iron_axe|iron_pickaxe|iron_leggings|iron_boots|iron_chestplate|iron_helmet|iron_hoe|iron_sword|iron_shovel
#             - define goldList:li@gold_axe|gold_pickaxe|gold_leggings|gold_boots|gold_chestplate|gold_helmet|gold_hoe|gold_sword|gold_shovel
#             - define diamondList:li@diamond_axe|diamond_pickaxe|diamond_leggings|diamond_boots|diamond_chestplate|diamond_helmet|diamond_hoe|diamond_sword|diamond_shovel
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if <[character]> == null:
#                 - narrate "You need a character to do this!"
#                 - stop
#             # Easy vanilla checks
#             - if <[ironList].contains[<context.item>]>:
#                 - if !<player.has_flag[<[Character]>_Blacksmith]>:
#                     - narrate "You must be a blacksmith to craft this!"
#                     - stop
#             - if <[goldList].contains[<context.item>]>:
#                 - if !<player.has_flag[<[Character]>_Blacksmith]>:
#                     - narrate "You must be a blacksmith to craft this!"
#                     - stop
#             - if <[diamondList].contains[<context.item>]>:
#                 - if !<player.has_flag[<[Character]>_Blacksmith]>:
#                     - narrate "You must be a blacksmith to craft this!"
#                     - stop

BlacksmithSkills:
    type: yaml data
    1:
        skill: Toolsmith1
    2:
        skill: Toolsmith2
        requirements:
            - Toolsmith1
    3:
        skill: Toolsmith3
        requirements:
            - Toolsmith2
    4:
        skill: Toolsmith4
        requirements:
            - Toolsmith3
    5:
        skill: Armorsmith1
    6:
        skill: Armorsmith2
        requirements:
            - Armorsmith1
    7:
        skill: Armorsmith3
        requirements:
            - Armorsmith2
    8:
        skill: Armorsmith4
        requirements:
            - Armorsmith3
    9:
        skill: Weaponsmith1
    10:
        skill: Weaponsmith2
        requirements:
            - Weaponsmith1
    11:
        skill: Weaponsmith3
        requirements:
            - Weaponsmith2
    12:
        skill: Weaponsmith4
        requirements:
            - Weaponsmith3
    13:
        skill: Repair
    14:
        skill: Engraving
    15:
        skill: MakersMark


#===========================SKILLS
#==============
Toolsmith1:
    type: item
    material: map
    display name: <&7>Toolsmith1
    lore:
        - Cost: 1
Toolsmith1Learned:
    type: item
    material: filled_map
    display name: <&a>Toolsmith1
    lore:

Toolsmith1Cast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Toolsmith2:
    type: item
    material: map
    display name: <&7>Toolsmith2
    lore:
        - Cost: 1
Toolsmith2Learned:
    type: item
    material: filled_map
    display name: <&a>Toolsmith2
    lore:

Toolsmith2Cast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Toolsmith3:
    type: item
    material: map
    display name: <&7>Toolsmith3
    lore:
        - Cost: 1
Toolsmith3Learned:
    type: item
    material: filled_map
    display name: <&a>Toolsmith3
    lore:

Toolsmith3Cast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Toolsmith4:
    type: item
    material: map
    display name: <&7>Toolsmith4
    lore:
        - Cost: 1
Toolsmith4Learned:
    type: item
    material: filled_map
    display name: <&a>Toolsmith4
    lore:

Toolsmith4Cast:
    type: task
    definitions: target
    script:
        - narrate "WIP"

#==============
Armorsmith1:
    type: item
    material: map
    display name: <&7>Armorsmith1
    lore:
        - Cost: 1
Armorsmith1Learned:
    type: item
    material: filled_map
    display name: <&a>Armorsmith1
    lore:

Armorsmith1Cast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Armorsmith2:
    type: item
    material: map
    display name: <&7>Armorsmith2
    lore:
        - Cost: 1
Armorsmith2Learned:
    type: item
    material: filled_map
    display name: <&a>Armorsmith2
    lore:

Armorsmith2Cast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Armorsmith3:
    type: item
    material: map
    display name: <&7>Armorsmith3
    lore:
        - Cost: 1
Armorsmith3Learned:
    type: item
    material: filled_map
    display name: <&a>Armorsmith3
    lore:

Armorsmith3Cast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Armorsmith4:
    type: item
    material: map
    display name: <&7>Armorsmith4
    lore:
        - Cost: 1
Armorsmith4Learned:
    type: item
    material: filled_map
    display name: <&a>Armorsmith4
    lore:

Armorsmith4Cast:
    type: task
    definitions: target
    script:
        - narrate "WIP"

#==============
Weaponsmith1:
    type: item
    material: map
    display name: <&7>Weaponsmith1
    lore:
        - Cost: 1
Weaponsmith1Learned:
    type: item
    material: filled_map
    display name: <&a>Weaponsmith1
    lore:

Weaponsmith1Cast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Weaponsmith2:
    type: item
    material: map
    display name: <&7>Weaponsmith2
    lore:
        - Cost: 1
Weaponsmith2Learned:
    type: item
    material: filled_map
    display name: <&a>Weaponsmith2
    lore:

Weaponsmith2Cast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Weaponsmith3:
    type: item
    material: map
    display name: <&7>Weaponsmith3
    lore:
        - Cost: 1
Weaponsmith3Learned:
    type: item
    material: filled_map
    display name: <&a>Weaponsmith3
    lore:

Weaponsmith3Cast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Weaponsmith4:
    type: item
    material: map
    display name: <&7>Weaponsmith4
    lore:
        - Cost: 1
Weaponsmith4Learned:
    type: item
    material: filled_map
    display name: <&a>Weaponsmith4
    lore:

Weaponsmith4Cast:
    type: task
    definitions: target
    script:
        - narrate "WIP"

#==============
Repair:
    type: item
    material: map
    display name: <&7>Repair
    lore:
        - Cost: 1
RepairLearned:
    type: item
    material: filled_map
    display name: <&a>Repair
    lore:

RepairCast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Engraving:
    type: item
    material: map
    display name: <&7>Engraving
    lore:
        - Cost: 1
EngravingLearned:
    type: item
    material: filled_map
    display name: <&a>Engraving
    lore:

EngravingCast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
MakersMark:
    type: item
    material: map
    display name: <&7>Maker's Mark
    lore:
        - Cost: 1
MakersMarkLearned:
    type: item
    material: filled_map
    display name: <&a>Maker's Mark
    lore:

MakersMarkCast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
