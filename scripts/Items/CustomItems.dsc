# Custom Items
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.2.3
# All Scripts relating to handling Custom Items, Saving Custom Blocks, and the individual Item Scripts


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
COTSSkyStone:
    type: item
    material: prismarine_shard
    display name: <&a>Skystone
    lore:
    - Use to give yourself a short boost.
    - 5
    - charges remaining.
COTSSkyStoneBroken:
    type: item
    material: prismarine_crystals
    display name: <&a>Shattered Skystone
    lore:
    - A broken skystone.
    - Needs to be recharged.
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
PrometheumOre:
    type: item
    material: coal_ore
    display name: <&0>Prometheum Ore
    lore:
    - The mineral appears to
    - be a dark gray, opaque, 
    - buried within crusted stone.
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
    shapeless_recipe: i@HumidityPowder|i@263
    
StormStone:
    type: item
    Material: emerald[flags=HIDE_ENCHANTS]
    display name: <&3>Storm Stone
    lore:
    - The result of smelting <&3>Storm Powder.
    - It gives a tingling feeling when touched.
    enchantments:
    - lure:1
    
SandStone:
    type: item
    Material: emerald[flags=HIDE_ENCHANTS]
    display name: <&6>Sand Stone
    lore:
    - The result of smelting <&6>Beach Powder.
    - Appears to never stop trickling with sand
    - but keeps its form.
    enchantments:
    - lure:1


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