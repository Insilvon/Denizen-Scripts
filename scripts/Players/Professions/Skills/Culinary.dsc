CulinaryTooltip:
    type: item
    material: player_head[skull_skin=945906b4-6fdc-4b99-9a26-30906befb63a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjM4YzUzZTY2ZjI4Y2YyYzdmYjE1MjNjOWU1ZGUxYWUwY2Y0ZDdhMWZhZjU1M2U3NTI0OTRhOGQ2ZDJlMzIifX19]
    display name: <&a>Help Item
    lore:
        - Gain profession levels
        - by brewing alcohol and
        - cooking rare meals!

CulinaryDice:
    type: item
    material: player_head[skull_skin=2c932936-26ba-4d3d-9c7b-4c9392c6717c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjg4ZmE5NzNlYTQ0NGNjODA4NzY4ZWE0OGJmMjY1N2FlOWE1NmMwYWY2MDI3NWU4NDQ2M2IxOTU2MjliY2UifX19]
    display name: <&a>Culinary Dice
    lore:
        - Roll based on your
        - profession's skill!
CulinaryController:
    type: world
    events:
        on player crafts AdvancedBreweryBase:
            - define character:<proc[GetCharacterName].context[<player>]||null>
            - if <[character]> == null:
                - narrate "You need a character to do this!"
                - determine cancelled
            - if !<player.has_flag[<[character]>_AlcoholicProficiency1]>:
                - narrate "You have not unlocked the Culinary skill to do this!"
                - determine cancelled
        on player crafts AdvancedBreweryBase2:
            - define character:<proc[GetCharacterName].context[<player>]||null>
            - if <[character]> == null:
                - narrate "You need a character to do this!"
                - determine cancelled
            - if !<player.has_flag[<[character]>_AlcoholicProficiency2]>:
                - narrate "You have not unlocked the Culinary skill to do this!"
                - determine cancelled
        on player crafts AdvancedBreweryBase3:
            - define character:<proc[GetCharacterName].context[<player>]||null>
            - if <[character]> == null:
                - narrate "You need a character to do this!"
                - determine cancelled
            - if !<player.has_flag[<[character]>_AlcoholicProficiency3]>:
                - narrate "You have not unlocked the Culinary skill to do this!"
                - determine cancelled
        # on player crafts:
        #     - define character:<proc[GetCharacterName].context[<player>]||null>
        #     - if <[character]> == null:
        #         - narrate "You need a character to do this!"
        #         - determine cancelled
        #     - if !<player.has_flag[<[character]>_CookingProficiency1]>:
        #         - determine cancelled passively
        #         - narrate "You have not unlocked the Culinary Skill to do this!"
        # on player crafts:
        #     - define character:<proc[GetCharacterName].context[<player>]||null>
        #     - if <[character]> == null:
        #         - narrate "You need a character to do this!"
        #         - determine cancelled
        #     - if !<player.has_flag[<[character]>_CookingProficiency2]>:
        #         - determine cancelled passively
        #         - narrate "You have not unlocked the Culinary Skill to do this!"
        # on player crafts:
        #     - define character:<proc[GetCharacterName].context[<player>]||null>
        #     - if <[character]> == null:
        #         - narrate "You need a character to do this!"
        #         - determine cancelled
        #     - if !<player.has_flag[<[character]>_CookingProficiency3]>:
        #         - determine cancelled passively
        #         - narrate "You have not unlocked the Culinary Skill to do this!"
AdvancedBreweryBase:
    type: item
    material: diamond
    display name: <&b>Advanced Brewery Drink Base
    lore:
        - A base item used to craft
        - advanced brewery potions.
        - Can be traded between brewers.
    recipes:
        1:
            type: shapeless
            output_quantity: 1
            input: diamond
AdvancedBreweryBase2:
    type: item
    material: diamond
    display name: <&6>Rare Brewery Drink Base
    lore:
        - A base item used to craft
        - the rare brewery potions.
        - Can be traded between
        - brewers.
    recipes:
        1:
            type: shapeless
            output_quantity: 1
            input: AdvancedBreweryBase
AdvancedBreweryBase3:
    type: item
    material: diamond
    display name: <&e>Exotic Brewery Drink Base
    lore:
        - A base item used to craft
        - the exotic brewery potions.
        - Can be traded between
        - brewers.
    recipes:
        1:
            type: shapeless
            output_quantity: 1
            input: AdvancedBreweryBase2

CulinarySkills:
    type: yaml data
    1:
        skill: RefinedPalate
    2:
        skill: Recipe
    3:
        skill: AlcoholicProficiency1
    4:
        skill: AlcoholicProficiency2
        requirements:
            - AlcoholicProficency1
    5:
        skill: AlcoholicProficiency3
        requirements:
            - AlcoholicProficency2
    6:
        skill: CookingProficiency1
    7:
        skill: CookingProficiency2
        requirements:
            - CookingProficiency1
    8:
        skill: CookingProficiency3
        requirements:
            - CookingProficiency2
    9:
        skill: Toxic Safety
CulinaryLevels:
    type: yaml data
    1:
        exp: 5
    2:
        exp: 10
    3:
        exp: 20
    4:
        exp: 25
#=========================SKILLS
#==============
RefinedPalate:
    type: item
    material: map
    display name: <&7>RefinedPalate
    lore:
        - Cost: 1
        - Cast to gain information about
        - the drink or meal in your hand.
RefinedPalateLearned:
    type: item
    material: filled_map
    display name: <&a>RefinedPalate
    lore:
        - Cast to gain information about
        - the drink or meal in your hand.
RefinedPalateCast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!" targets:<[target]>
            - stop
        # - define item:<[target].item_in_hand>
        # # Is it a denizen item or a nondenizen item, like brewery?
        # - if <[item].script.name||null> == null:
        # - else:
        #     - choose <[item].script.name>:
        #         - default:
        #             - narrate "No recipe was able to be made!"

#==============
Recipe:
    type: item
    material: map
    display name: <&7>Recipe
    lore:
        - Cost: 1
        - Cast to create a recipe
        - for the food or drink in
        - your hand, assuming you
        - know the recipe. This can
        - be given to other cooks to
        - learn.
RecipeLearned:
    type: item
    material: filled_map
    display name: <&a>Recipe
    lore:
        - Cast to create a recipe
        - for the food or drink in
        - your hand, assuming you
        - know the recipe. This can
        - be given to other cooks to
        - learn.
RecipeCast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
AlcoholicProficiency1:
    type: item
    material: map
    display name: <&7>AlcoholicProficiency1
    lore:
        - Cost: 1
        - Gain permissions to
        - brew alcoholic drinks.
AlcoholicProficiency1Learned:
    type: item
    material: filled_map
    display name: <&a>AlcoholicProficiency1
    lore:
        - Gained permissions to
        - brew alcoholic drinks.
AlcoholicProficiency1Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!" targets:<[target]>
            - stop
        - flag <[target]> <[character]>_AlcoholicProficiency1
        - execute as_server "pex user <[target].name> group add brewery"
        - narrate "You can now use Brewing tools to create drinks." targets:<[target]>
        - narrate "To use Brewery, read here: https://github.com/DieReicheErethons/Brewery/wiki/Usage" targets:<[target]>
        - wait 3s
        - narrate "You can now craft advanced-tier brewery recipes."
        - narrate "To do so, craft the Advanced Brewery Base item. Place a diamond in"
        - narrate "a crafting table. Add it to the cauldron before your other ingredients."

#==============
AlcoholicProficiency2:
    type: item
    material: map
    display name: <&7>AlcoholicProficiency2
    lore:
        - Cost: 1
        - Gain permissions to
        - brew more alcoholic drinks.
AlcoholicProficiency2Learned:
    type: item
    material: filled_map
    display name: <&a>AlcoholicProficiency2
    lore:
        - Gained permissions to
        - brew more alcoholic drinks.
AlcoholicProficiency2Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!" targets:<[target]>
            - stop
        - flag <[target]> <[character]>_AlcoholicProficiency2
        - narrate "You can now craft rare-tier brewery recipes."
        - narrate "To do so, craft the Rare Brewery Base item."
        - narrate "Place the Advanced Brewery Base item in a crafting table to get it."
        - narrate "Add it to the cauldron before your other ingredients."
#==============
AlcoholicProficiency3:
    type: item
    material: map
    display name: <&7>AlcoholicProficiency3
    lore:
        - Cost: 1
        - Gain permissions to
        - brew the rarest
        - alcoholic drinks.
AlcoholicProficiency3Learned:
    type: item
    material: filled_map
    display name: <&a>AlcoholicProficiency3
    lore:
        - Gained permissions to
        - brew the rarest
        - alcoholic drinks.
AlcoholicProficiency3Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!" targets:<[target]>
            - stop
        - flag <[target]> <[character]>_AlcoholicProficiency3
        - narrate "You can now craft exotic-tier brewery recipes."
        - narrate "To do so, craft the Exotic Brewery Base item."
        - narrate "Place the Rare Brewery Base item in a crafting table to get it."
        - narrate "Add it to the cauldron before your other ingredients."
#==============
CookingProficiency1:
    type: item
    material: map
    display name: <&7>CookingProficiency1
    lore:
        - Cost: 1
        - Learn how to create
        - several new recipes with
        - unqiue effects.
CookingProficiency1Learned:
    type: item
    material: filled_map
    display name: <&a>CookingProficiency1
    lore:
        - Learned how to create
        - several new recipes with
        - unqiue effects.
CookingProficiency1Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!" targets:<[target]>
            - stop
        - flag <[target]> <[character]>_CookingProficiency1
        - narrate "You can now craft the first selection of Cooking Recipes."
#==============
CookingProficiency2:
    type: item
    material: map
    display name: <&7>CookingProficiency2
    lore:
        - Cost: 1
        - Learn how to create
        - several newer recipes with
        - unqiue effects.
CookingProficiency2Learned:
    type: item
    material: filled_map
    display name: <&a>CookingProficiency2
    lore:
        - Learned how to create
        - several newer recipes with
        - unqiue effects.
CookingProficiency2Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!" targets:<[target]>
            - stop
        - flag <[target]> <[character]>_CookingProficiency2
        - narrate "You can now craft the second selection of Cooking Recipes."
#==============
CookingProficiency3:
    type: item
    material: map
    display name: <&7>CookingProficiency3
    lore:
        - Cost: 1
        - Learn how to secretly
        - add poisons to learned
        - meals.
CookingProficiency3Learned:
    type: item
    material: filled_map
    display name: <&a>CookingProficiency3
    lore:
        - Learned how to secretly
        - add poisons to learned
        - meals.
CookingProficiency3Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!" targets:<[target]>
            - stop
        - flag <[target]> <[character]>_CookingProficiency3
        - narrate "You can now craft the third selection of Cooking Recipes."
#==============
Toxic Safety:
    type: item
    material: map
    display name: <&7>Toxic Safety
    lore:
        - Cost: 1
        - Cast to test the item in
        - your hand for poison.
Toxic SafetyLearned:
    type: item
    material: filled_map
    display name: <&a>Toxic Safety
    lore:
        - Cast to test the item in
        - your hand for poison.
Toxic SafetyCast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!" targets:<[target]>
            - stop
        - if <[target].item_in_hand.script.name||null.contains_text[poisoned]>:
            - narrate "<&c>This item has been poisoned."
        - else:
            - narrate "<&a>This item has not been poisoned."
