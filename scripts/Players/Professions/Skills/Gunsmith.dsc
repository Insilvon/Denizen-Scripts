GunsmithDice:
    type: item
    material: player_head[skull_skin=1d940aea-0b65-44ff-b0bf-f98330aca06a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNmI0MGU1ZGIyMWNlZGFjNGM5NzJiN2IyMmViYjY0Y2Y0YWRkNjFiM2I1NGIxMzE0MzVlZWRkMzA3NTk4YjcifX19]
    display name: <&a>Gunsmith Dice
    lore:
        - Roll based on your
        - profession's skill!

GunsmithTooltip:
    type: item
    material: player_head[skull_skin=945906b4-6fdc-4b99-9a26-30906befb63a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjM4YzUzZTY2ZjI4Y2YyYzdmYjE1MjNjOWU1ZGUxYWUwY2Y0ZDdhMWZhZjU1M2U3NTI0OTRhOGQ2ZDJlMzIifX19]
    display name: <&a>Help Item
    lore:
        - Gain profession levels
        - by crafting guns,
        - cannons, ammunition,
        - and more!
# GunsmithController:
#     type: world
#     events:
#         # Pistol Principles
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_PistolPrinciples1]>:
#                 - determine cancelled
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_PistolPrinciples2]>:
#                 - determine cancelled
#         # Rifle Principles
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_RiflePrinciples1]>:
#                 - determine cancelled
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_RiflePrinciples2]>:
#                 - determine cancelled
#         # Cannon Principles
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_CannonPrinciples1]>:
#                 - determine cancelled
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_CannonPrinciples2]>:
#                 - determine cancelled
#         # Ammunition
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_AmmunitionKnowledge]>:
#                 - determine cancelled
#         # Cannonballs
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_CannonballKnowledge]>:
#                 - determine cancelled
#         # Tinkering
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_TinkeringKnowledge]>:
#                 - determine cancelled

GunsmithSkills:
    type: yaml data
    1:
        skill: PistolPrinciples1
    2:
        skill: PistolPrinciples2
        requirements:
            - PistolPrinciples1
    3:
        skill: RiflePrinciples1
    4:
        skill: RiflePrinciples2
        requirements:
            - RiflePrinciples1
    5:
        skill: PrismatechDevices
    6:
        skill: CannonPrinciples1
    7:
        skill: CannonPrinciples2
        requirements:
            - CannonPrinciples1
    8:
        skill: AmmunitionKnowledge
        requirements:
            - PistolPrinciples1
    9:
        skill: CannonballKnowledge
        requirements:
            - CannonPrinciples1
    10:
        skill: TinkeringKnowledge1
#============================SKILLS
#==============
PistolPrinciples1:
    type: item
    material: map
    display name: <&7>PistolPrinciples1
    lore:
        - Cost: 1
        - Learn fundamentals of
        - pistol crafting.
PistolPrinciples1Learned:
    type: item
    material: filled_map
    display name: <&a>PistolPrinciples1
    lore:
        - Learned fundamentals of
        - pistol crafting.
PistolPrinciples1Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_PistolPrinciples1
#==============
PistolPrinciples2:
    type: item
    material: map
    display name: <&7>PistolPrinciples2
    lore:
        - Cost: 1
        - Learn advanced fundamentals of
        - pistol crafting.
PistolPrinciples2Learned:
    type: item
    material: filled_map
    display name: <&a>PistolPrinciples2
    lore:
        - Learned advanced fundamentals of
        - pistol crafting.

PistolPrinciples2Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_PistolPrinciples2
#==============
RiflePrinciples1:
    type: item
    material: map
    display name: <&7>RiflePrinciples1
    lore:
        - Cost: 1
        - Learn fundamentals
        - of rifle crafting.
RiflePrinciples1Learned:
    type: item
    material: filled_map
    display name: <&a>RiflePrinciples1
    lore:
        - Learned fundamentals
        - of rifle crafting.
RiflePrinciples1Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_RiflePrinciples1
#==============
RiflePrinciples2:
    type: item
    material: map
    display name: <&7>RiflePrinciples2
    lore:
        - Cost: 1
        - Learn advanced fundamentals
        - of rifle crafting.
RiflePrinciples2Learned:
    type: item
    material: filled_map
    display name: <&a>RiflePrinciples2
    lore:
        - Learned advanced fundamentals
        - of rifle crafting.
RiflePrinciples2Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_RiflePrinciples2
#==============
PrismatechDevices:
    type: item
    material: map
    display name: <&7>PrismatechDevices
    lore:
        - Cost: 1
        - Learn techniques on
        - how to integrate prismatech
        - into existing weapons.
PrismatechDevicesLearned:
    type: item
    material: filled_map
    display name: <&a>PrismatechDevices
    lore:
        - Learned techniques on
        - how to integrate prismatech
        - into existing weapons.
PrismatechDevicesCast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_PrismatechDevices
#==============
CannonPrinciples1:
    type: item
    material: map
    display name: <&7>CannonPrinciples1
    lore:
        - Cost: 1
        - Learn fundamentals
        - of cannon construction.
CannonPrinciples1Learned:
    type: item
    material: filled_map
    display name: <&a>CannonPrinciples1
    lore:
        - Learned fundamentals
        - of cannon construction.
CannonPrinciples1Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_CannonPrinciples1
#==============
CannonPrinciples2:
    type: item
    material: map
    display name: <&7>CannonPrinciples2
    lore:
        - Cost: 1
        - Learn advanced fundamentals
        - of cannon construction.
CannonPrinciples2Learned:
    type: item
    material: filled_map
    display name: <&a>CannonPrinciples2
    lore:
        - Learned advanced fundamentals
        - of cannon construction.
CannonPrinciples2Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_CannonPrinciples2
#==============
AmmunitionKnowledge:
    type: item
    material: map
    display name: <&7>AmmunitionKnowledge
    lore:
        - Cost: 1
        - Learn fundamentals of
        - ammunition crafting.
AmmunitionKnowledgeLearned:
    type: item
    material: filled_map
    display name: <&a>AmmunitionKnowledge
    lore:
        - Learned fundamentals of
        - ammunition crafting.
AmmunitionKnowledgeCast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_AmmunitionKnowledge
#==============
CannonballKnowledge:
    type: item
    material: map
    display name: <&7>CannonballKnowledge
    lore:
        - Cost: 1
        - Learn fundamentals of
        - cannonball crafting.
CannonballKnowledgeLearned:
    type: item
    material: filled_map
    display name: <&a>CannonballKnowledge
    lore:
        - Learned fundamentals of
        - cannonball crafting.
CannonballKnowledgeCast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_CannonballKnowledge
#==============
TinkeringKnowledge1:
    type: item
    material: map
    display name: <&7>TinkeringKnowledge1
    lore:
        - Cost: 1
        - Learn techniques to help
        - in crafting one's own weapons.
TinkeringKnowledge1Learned:
    type: item
    material: filled_map
    display name: <&a>TinkeringKnowledge1
    lore:
        - Learned techniques to help
        - in crafting one's own weapons.
TinkeringKnowledge1Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_TinkeringKnowledge
