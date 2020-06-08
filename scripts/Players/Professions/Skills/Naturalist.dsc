

NaturalistDice:
    type: item
    material: player_head[skull_skin=2201f095-0c4a-46c1-806c-b9f338c42232|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMmNlYjcxM2NkOWNmOTE5MjY0YjYzMWU3MGY1MjhiZDIwYzQzZTc5MjQxNjk1ZDZiZmM5Y2ZjN2RjZDYzZCJ9fX0=]
    display name: <&a>Naturalist Dice
    lore:
        - Roll based on your
        - profession's skill!

NaturalistTooltip:
    type: item
    material: player_head[skull_skin=945906b4-6fdc-4b99-9a26-30906befb63a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjM4YzUzZTY2ZjI4Y2YyYzdmYjE1MjNjOWU1ZGUxYWUwY2Y0ZDdhMWZhZjU1M2U3NTI0OTRhOGQ2ZDJlMzIifX19]
    display name: <&a>Help Item
    lore:
        - Gain profession levels
        - growing custom crops,
        - breeding animals, and
        - catching fish!
# NaturalistController:
#     type: world
#     events:

NaturalistSkills:
    type: yaml data
    1:
        skill: FarmingKnowledge1
    2:
        skill: FarmingKnowledge2
        requirements:
            - FarmingKnowledge1
    3:
        skill: BreedingKnowledge1
    4:
        skill: BreedingKnowledge2
        requirements:
            - BreedingKnowledge1
    5:
        skill: FishingKnowledge1
    6:
        skill: FishingKnowledge2
        requirements:
            - FishingKnowledge1
    7:
        skill: GreenThumb
    8:
        skill: Fertilizer
    9:
        skill: AxeProficiency
    10:
        skill: HorseStats
    

#======================================= SKILLS
#==============
FarmingKnowledge1:
    type: item
    material: map
    display name: <&7>FarmingKnowledge1
    lore:
        - Cost: 1
        - Learn how to grow rare crops.
FarmingKnowledge1Learned:
    type: item
    material: filled_map
    display name: <&a>FarmingKnowledge1
    lore:
        - Learned how to grow rare crops.
FarmingKnowledge1Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_FarmingKnowledge1
#==============
FarmingKnowledge2:
    type: item
    material: map
    display name: <&7>FarmingKnowledge2
    lore:
        - Cost: 1
        - Learn how to grow
        - more rare crops.
FarmingKnowledge2Learned:
    type: item
    material: filled_map
    display name: <&a>FarmingKnowledge2
    lore:
        - Learned how to grow
        - more rare crops.
FarmingKnowledge2Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_FarmingKnowledge2
#==============
BreedingKnowledge1:
    type: item
    material: map
    display name: <&7>BreedingKnowledge1
    lore:
        - Cost: 1
        - Learn tecniques to
        - breed animals.
BreedingKnowledge1Learned:
    type: item
    material: filled_map
    display name: <&a>BreedingKnowledge1
    lore:
        - Learned tecniques to
        - breed animals.
BreedingKnowledge1Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_BreedingKnowledge1
#==============
BreedingKnowledge2:
    type: item
    material: map
    display name: <&7>BreedingKnowledge2
    lore:
        - Cost: 1
        - Learn techniques to
        - breed even more
        - animals.
BreedingKnowledge2Learned:
    type: item
    material: filled_map
    display name: <&a>BreedingKnowledge2
    lore:
        - Learned techniques to
        - breed even more
        - animals.
BreedingKnowledge2Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_BreedingKnowledge2

#==============
FishingKnowledge1:
    type: item
    material: map
    display name: <&7>FishingKnowledge1
    lore:
        - Cost: 1
        - Learn techniques to
        - catch rare fish.
FishingKnowledge1Learned:
    type: item
    material: filled_map
    display name: <&a>FishingKnowledge1
    lore:
        - Learned techniques to
        - catch rare fish.
FishingKnowledge1Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_FishingKnowledge1
#==============
FishingKnowledge2:
    type: item
    material: map
    display name: <&7>FishingKnowledge2
    lore:
        - Cost: 1
        - Learn techniques to
        - catch even more rare fish.
FishingKnowledge2Learned:
    type: item
    material: filled_map
    display name: <&a>FishingKnowledge2
    lore:
        - Learned techniques to
        - catch even more rare fish.
FishingKnowledge2Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_FishingKnowledge2

#==============
GreenThumb:
    type: item
    material: map
    display name: <&7>GreenThumb
    lore:
        - Cost: 1
        - A passive ability
        - which allows double
        - the regular harvest of
        - crops.
GreenThumbLearned:
    type: item
    material: filled_map
    display name: <&a>GreenThumb
    lore:
        - A passive ability
        - which allows double
        - the regular harvest of
        - crops.
GreenThumbCast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_GreenThumb
#==============
Fertilizer:
    type: item
    material: map
    display name: <&7>Fertilizer
    lore:
        - Cost: 1
        - Learn how to craft
        - fertilizer and instantly
        - grow crops.
FertilizerLearned:
    type: item
    material: filled_map
    display name: <&a>Fertilizer
    lore:
        - Learned how to craft
        - fertilizer and instantly
        - grow crops.
FertilizerCast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_Fertilizer
#==============
AxeProficiency:
    type: item
    material: map
    display name: <&7>AxeProficiency
    lore:
        - Cost: 1
        - Gain the ability
        - to fell entire trees
        - with ease.
AxeProficiencyLearned:
    type: item
    material: filled_map
    display name: <&a>AxeProficiency
    lore:
        - Gained the ability
        - to fell entire trees
        - with ease.
AxeProficiencyCast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - execute as_server "pex user <[target].name> group add UltimateTimber"
#==============
HorseStats:
    type: item
    material: map
    display name: <&7>Horse Stats
    lore:
        - Cost: 1
        - Gain the ability
        - to see the stats of
        - horses you encounter.
HorseStatsLearned:
    type: item
    material: filled_map
    display name: <&a>Horse Stats
    lore:
        - Gained the ability
        - to see the stats of
        - horses you encounter.
HorseStatsCast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - execute as_server "pex user <[target].name> group add HorseStats"