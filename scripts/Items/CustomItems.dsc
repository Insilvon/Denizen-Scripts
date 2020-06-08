# Custom Items
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.2.3
# All Scripts relating to handling Custom Items, Saving Custom Blocks, and the individual Item Scripts

CustomItemController2:
    type: world
    debug: false
    events:
        on DeclansLove recipe formed:
            - if <player.name> != Scrimjaw__:
                - determine cancelled
        on player places block priority:1:
            - if <context.item_in_hand.script.name||null> == MobCage:
                - determine cancelled
        on player right clicks air with MobCage priority:2:
            - narrate "Right click with your egg to throw it!"
            - take MobCage
            - execute as_server "uc give <player.name> Insane"
        on player right clicks with OverboardItem:
            - execute as_op "manoverboard"

Harvenger:
    type: item
    material: iron_axe[flags=HIDE_ENCHANTS]
    display name: <&5>Harvenger
    lore:
        - A finely crafted yet
        - cruel looking cleaver,
        - designed to separate
        - skin from bone.
    enchantments:
        - SHARPNESS:1

SunpeakSword:
    type: item
    material: stone_sword
    display name: <&e>Sunpeak Sword
    lore:
        - A rugged, but decorated
        - sword belonging to the colony
        - at Cape Sunpeak.

OverboardItem:
    type: item
    material: lead
    display name: <&b>Emergency Rope
    lore:
        - A rope that, when right clicked
        - will return you to the top center
        - of the last airship that moved you.
        - Only works if you are the pilot.

MobCage:
    type: item
    material: mob_spawner
    display name: <&3>Animal Cage
    lore:
        - A cage used to transport
        - animals across the sky.
PirateCoin:
    type: item
    material: gold_nugget
    display name: <&6>Coin of the Order
    lore:
        - One of several coins
        - made by the Pirates
        - of Miasmyyn Cove.
CustomBlackDye:
    type: item
    material: black_dye
    recipes:
        1:
            type: shapeless
            output_quantity: 1
            input: coal
        2:
            type: shapeless
            output_quantity: 1
            input: charcoal

CustomGreenDye:
    type: item
    material: green_dye
    recipes:
        1:
            type: shapeless
            output_quantity: 1
            input: oak_leaves
        2:
            type: shapeless
            output_quantity: 1
            input: dark_oak_leaves
        3:
            type: shapeless
            output_quantity: 1
            input: spruce_leaves
        4:
            type: shapeless
            output_quantity: 1
            input: birch_leaves
        5:
            type: shapeless
            output_quantity: 1
            input: acacia_leaves
        6:
            type: shapeless
            output_quantity: 1
            input: jungle_leaves




GrogRecipe:
    type: book
    title: Grog Recipe
    author: Unknown
    signed: true
    text:
        - 2 Sugar<&nl>1 Lime<&nl>2 Sugarcane<&nl>3 Snowberries
        - 10 minutes
        - 2 Distills

RattleSkullRecipe:
    type: book
    title: Rattle Skull Recipe
    author: Unknown
    signed: true
    text:
        - 3 Hops<&nl>3 Sugarcane<&nl>3 Lime<&nl>3 Snowberries
        - 5 minutes
        - 1 Distill

BloodlustRumRecipe:
    type: book
    title: Bloodlust Rum Recipe
    author: Unknown
    signed: true
    text:
        - 1 Red Dye<&nl>1 Redstone<&nl>3 Apples<&nl>3 Snowberries<&nl>3 Sugar
        - 8 minutes
        - 3 Distills

BlitzkriegSlammerRecipe:
    type: book
    title: Blitzkrieg Slammer Recipe
    author: Unknown
    signed: true
    text:
        - 4 Potatoes<&nl>4 Sugar<&nl>4 Hops<&nl>4 Apples
        - 10 minutes
        - 3 Distills



DeclansLove:
    type: item
    material: emerald
    display name: <&b>Declans Love
    recipes:
        1:
            type: shapeless
            input: emerald

dString:
    type: item
    material: string
    recipes:
        1:
            type: shapeless
            output_quantity: 4
            input: white_wool
        2:
            type: shapeless
            output_quantity: 4
            input: orange_wool
        3:
            type: shapeless
            output_quantity: 4
            input: magenta_wool
        4:
            type: shapeless
            output_quantity: 4
            input: light_blue_wool
        5:
            type: shapeless
            output_quantity: 4
            input: yellow_wool
        6:
            type: shapeless
            output_quantity: 4
            input: lime_wool
        7:
            type: shapeless
            output_quantity: 4
            input: pink_wool
        8:
            type: shapeless
            output_quantity: 4
            input: gray_wool
        9:
            type: shapeless
            output_quantity: 4
            input: light_gray_wool
        10:
            type: shapeless
            output_quantity: 4
            input: cyan_wool
        11:
            type: shapeless
            output_quantity: 4
            input: purple_wool
        12:
            type: shapeless
            output_quantity: 4
            input: blue_wool
        13:
            type: shapeless
            output_quantity: 4
            input: brown_wool
        14:
            type: shapeless
            output_quantity: 4
            input: green_wool
        15:
            type: shapeless
            output_quantity: 4
            input: red_wool
        16:
            type: shapeless
            output_quantity: 4
            input: black_wool

            

ScrapMetal:
    type: item
    material: i@iron_nugget
    display name: Scrap Metal
    lore:
        - Chunks of broken down metal,
        - typically iron and steel,
        - used to construct new machines
        - and parts. Frequently called
        - <&dq>Scrap<&dq> for short.

Sphteven:
    type: item
    material: flower_pot
    display name: <&a>Sphteven
    lore:
        - Collect them all!
    
SimpleKineticOre:
    type: item
    material: i@stone
    display name: Simple Kinetic Ore
    lore:
        - PLACEHOLDER
BurntOutTorch:
    type: item
    material: stick
    display name: <&e>Burnt Out Torch
    lore:
    - A torch that has lost
    - its burnable material.
RemadeTorch:
    type: item
    material: torch
    recipes:
        1:
            type: shapeless
            input: BurntOutTorch|coal
        2:
            type: shapeless
            input: BurntOutTorch|charcoal

ParafoilBoostCanister:
    type: item
    material: firework_rocket
    display name: <&e>Skyborne Boost Canister
    lore:
    - A boost canister for the parafoil
    - used to grant the user instant
    - lift while airborne.

CrystalShard:
    type: item
    material: prismarine_crystals
    display name: <&b>Crystalline Shards
    lore:
    - Shards of the mysterious
    - crystal hidden in the
    - Mountainglade bluffs.
    - They have a faint blue
    - glow.
# Skyforged Items

# Eldergleam:
#   type: item
#   material: prisamarine_crystals
#   display name: <&b>Eldergleam Crystals
# Darkgleam:
#   type: item
#   material: quartz
#   display name: <&>Darkgleam Crystals
# Shimmergleam:
#   type: item
#   material: nether_star
#   display name:
# Paragleam:
#   type: item
#   material: heart_of_the_sea
#     display name:
FactionToken:
    type: item
    material: 433[flags=HIDE_ENCHANTS]
    display name: <&b>Supply Token
    enchantments:
    - lure:1
    lore:
    - The Currency of The War.
    - Can be exchanged for numerous
    - advantages.
FireCrystal:
    type: item
    material: prismarine_crystals[flags=HIDE_ENCHANTS]
    display name: <&c>Fire Crystal
    lore:
    - One of the major elemental crystals.
    - It is said that each tribe held control over
    - one specific crystal, as it was a gift from the
    - heavens and their gods above.
    - This crystal shimmers with a red glow.
    enchantments:
    - lure:1
WaterCrystal:
    type: item
    material: prismarine_crystals[flags=HIDE_ENCHANTS]
    display name: <&3>Water Crystal
    lore:
    - One of the major elemental crystals.
    - It is said that each tribe held control over
    - one specific crystal, as it was a gift from the
    - heavens and their gods above.
    - This crystal shimmers with a blue glow.
    enchantments:
    - lure:1
AirCrystal:
    type: item
    material: prismarine_crystals[flags=HIDE_ENCHANTS]
    display name: <&a>Air Crystal
    lore:
    - One of the major elemental crystals.
    - It is said that each tribe held control over
    - one specific crystal, as it was a gift from the
    - heavens and their gods above.
    - This crystal shimmers with a blue glow.
    enchantments:
    - lure:1
EarthCrystal:
    type: item
    material: prismarine_crystals[flags=HIDE_ENCHANTS]
    display name: <&8>Earth Crystal
    lore:
    - One of the major elemental crystals.
    - It is said that each tribe held control over
    - one specific crystal, as it was a gift from the
    - heavens and their gods above.
    - This crystal shimmers with a green glow.
    enchantments:
    - lure:1
SkyborneParafoil:
    type: item
    material: Elytra
    display name: <&e>Skyborne Parafoil
    lore:
    - A custom parafoil created
    - by the skyborne.
IvoryNightVisionMask:
    type: item
    material: skull_item[skull_skin=Syndesi|eyJ0aW1lc3RhbXAiOjE1MTExOTIzMjAxMDEsInByb2ZpbGVJZCI6ImJkM2M2NDhiZDZhMDRmMDM5NDkzMjc1MzVjYjgzMWViIiwicHJvZmlsZU5hbWUiOiJFbW1hYVBsYXl6Iiwic2lnbmF0dXJlUmVxdWlyZWQiOnRydWUsInRleHR1cmVzIjp7IlNLSU4iOnsidXJsIjoiaHR0cDovL3RleHR1cmVzLm1pbmVjcmFmdC5uZXQvdGV4dHVyZS8xNGE0MzlmOTUwM2U3ZGE0ZWE0MWVhNjM3MDk0YzM2ZGIyZDg4MTg0MzFmMTViNGI4MjNiZGEyOWI2ZGIzMmFmIn19fQ==]
    display name: <&1>Syndesi Orama
    lore:
    - A native decorated mask of sight.
    - It is said that those who wear this
    - will be granted vision even in the darkest
    - of places.
# PrometheumOre:
#     type: item
#     material: coal_ore
#     display name: <&0>Prometheum Ore
#     lore:
#     - The mineral appears to
#     - be a dark gray, opaque, 
#     - buried within crusted stone.
CommanderSabre:
    type: item
    material: stone_sword[flags=HIDE_ENCHANTS]
    display name: <&7>Commander's Sabre
    enchantments:
    - damage_all:4
    - knockback:1
    lore:
    - The sabre's hilt is made of gold. The
    - metal is of fine quality and has an 
    - engraving of a sword and shield in it.
    - It belonged to a very specific Commander
    - and is extremely rusted.
HumidityStone:
    type: item
    Material: emerald[flags=HIDE_ENCHANTS]
    display name: <&9>Humidity Stone
    lore:
    - The result of smelting <&9>Humidity Powder.
    - The area surrounding the stone starts
    - to form beads of water.
    enchantments:
    - lure:1
    
StormStone:
    type: item
    Material: emerald[flags=HIDE_ENCHANTS]
    display name: <&3>Storm Stone
    lore:
    - The result of smelting <&3>Storm Powder.
    - It gives a tingling feeling when touched.
    enchantments:
    - lure:1
    
# SandStone:
#     type: item
#     Material: emerald[flags=HIDE_ENCHANTS]
#     display name: <&6>Sand Stone
#     lore:
#     - The result of smelting <&6>Beach Powder.
#     - Appears to never stop trickling with sand
#     - but keeps its form.
#     enchantments:
#     - lure:1


ReplicationPearl:
    type: item
    material: ghast_tear[flags=HIDE_ENCHANTS]
    display name: <&b>Mysterious Pearl
    lore:
    - A bizarre gem found in your room.
    - For some reason, whenever you attempt
    - to be rid of it, it always comes back.
    - After time, begins to make you feel heavy.
    enchantments:
    - lure:2
    bound: true