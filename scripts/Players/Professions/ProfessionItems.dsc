# Darksteel Series
DarksteelOre:
    type: item
    material: iron_ore
    display name: <&8>Darksteel Ore
    lore:
        - A dense and heavy ore
        - carefully extracted from
        - damp caves.
DarksteelIngot:
    type: item
    material: iron_ingot
    display name: <&8>Darksteel Ingot
    lore:
        - A polished, but heavy
        - bar gleaned from darksteel
        - ore.
    recipes:
        1:
            type: blast
            cook_time: 1s
            experience: 5
            input: DarksteelOre
DarksteelPickaxe:
    type: item
    material: stone_pickaxe[flags=hide_enchants]
    display name: <&7>Darksteel Pickaxe
    lore:
        - A heavy, blunt, and
        - brutal looking pickaxe.
        - While it may shatter perfectly
        - good ore, it's great for long
        - term clearing.
    enchantments:
        - DIG_SPEED:4
        - DURABILITY:10
    # recipes:
    #     1:
    #         type: shaped
    #         input:
    #         - DarksteelIngot|DarksteelIngot|DarksteelIngot
    #         - air|stick|air
    #         - air|stick|air
DarksteelAxe:
    type: item
    material: stone_axe[flags=hide_enchants]
    display name: <&8>Darksteel Axe
    lore:
        - A heavy, blunt, and
        - brutal looking pickaxe.
        - It appears sturdy and takes
        - a long time to break.
    enchantments:
        - DIG_SPEED:4
        - DURABILITY:10
        - KNOCKBACK:3
DarksteelSword:
    type: item
    material: stone_sword[flags=HIDE_ENCHANTS]
    display name: <&8>Darksteel Sword
    lore:
        - A meaty, gritty, and
        - fearsome blade that must
        - be held with two hands.
    enchantments:
        - DAMAGE_ALL:4
        - KNOCKBACK:3
DarksteelHelmet:
    type: item
    material: leather_helmet
    display name: <&8>Darksteel Helmet
    mechanisms:
        color: co@60,66,69
        flags:
            - hide_enchants
        nbt_attributes:
            - generic.maxHealth/head/0/2.5
            - generic.armor/head/0/1
    lore:
        - A heavy, padded, and
        - layered darksteel helmet.
    enchantments:
        - DURABILITY:5
DarksteelChestplate:
    type: item
    material: leather_chestplate
    display name: <&8>Darksteel Chestplate
    mechanisms:
        color: co@60,66,69
        flags:
            - hide_enchants
        nbt_attributes:
            - generic.maxHealth/chest/0/2.5
            - generic.armor/chest/0/1
    lore:
        - A heavy, padded, and
        - layered darksteel helmet.
    enchantments:
        - DURABILITY:5
DarksteelLeggings:
    type: item
    material: leather_leggings
    display name: <&8>Darksteel Leggings
    mechanisms:
        color: co@60,66,69
        flags:
            - hide_enchants
        nbt_attributes:
            - generic.maxHealth/legs/0/2.5
            - generic.armor/legs/0/1
    lore:
        - A heavy, padded, and
        - layered darksteel helmet.
    enchantments:
        - DURABILITY:5
DarksteelBoots:
    type: item
    material: leather_boots
    display name: <&8>Darksteel Boots
    mechanisms:
        color: co@60,66,69
        flags:
            - hide_enchants
        nbt_attributes:
            - generic.maxHealth/feet/0/2.5
            - generic.armor/feet/0/1
    lore:
        - A heavy, padded, and
        - layered darksteel helmet.
    enchantments:
        - DURABILITY:5
#= Skysteel
SkysteelOre:
    type: item
    material: iron_ore
    display name: <&9>Skysteel Ore
    lore:
        - The lightweight and flexible
        - cousin to Darksteel ore, taken
        - from the sky.
SkysteelIngot:
    type: item
    material: iron_ingot
    display name: <&9>Skysteel Ingot
    lore:
        - A lightweight, silvery ingot
        - used in many engineering based
        - projects.
    recipes:
        1:
            type: blast
            cook_time: 1s
            experience: 5
            input: SkysteelOre
SkysteelPickaxe:
    type: item
    material: iron_pickaxe[flags=HIDE_ENCHANTS]
    display name: <&9>Skysteel Pickaxe
    lore:
        - A lightweight and durable
        - pick forged from pure skysteel.
    enchantments:
        - DIG_SPEED:2
        - DURABILITY:2
SkysteelAxe:
    type: item
    material: iron_axe[flags=HIDE_ENCHANTS]
    display name: <&9>Skysteel Axe
    lore:
        - A lightweight and durable
        - axe forged from pure skysteel.
    enchantments:
        - DIG_SPEED:2
        - DURABILITY:3
SkysteelHatchet:
    type: item
    material: iron_axe[flags=HIDE_ENCHANTS]
    display name: <&9>Skysteel Hatchet
    lore:
        - A custom-made hatchet, forged
        - from fine Skysteel during the
        - Brewhaven market bonanza.
        - With a serrated edge, the hatchet
        - is lethal and useful! The initials
        - <&sq>DT<&dq> are inscribed into it.
    enchantments:
        - DIG_SPEED:2
        - DURABILITY:4
        - DAMAGE_ALL:1
SkysteelSword:
    type: item
    material: iron_sword[flags=HIDE_ENCHANTS]
    display name: <&9>Skysteel Sword
    lore:
        - A lightweight and durable shortsword
        - pick forged from pure skysteel.
    enchantments:
        - DAMAGE_ALL:3
        - DURABILITY:3
        - SWEEPING_EDGE:1
#= Copper
CopperOre:
    type: item
    material: gold_ore
    display name: <&6>Copper Ore
    lore:
        - An orangish rock with
        - many promises inside.
CopperIngot:
    type: item
    material: gold_ingot
    display name: <&6>Copper Ingot
    lore:
        - A metallic, orangish ore
        - used in a lot of engineering
        - based projects.
    recipes:
        1:
            type: blast
            cook_time: 3s
            experience: 5
            input: CopperOre
CopperPickaxe:
    type: item
    material: gold_pickaxe[flags=HIDE_ENCHANTS]
    display name: <&6>Copper Pickaxe
    lore:
        - A shining copper pickaxe.
        - While not the best pick made
        - in the sky, it does have a knack
        - for getting the most ore out of
        - things.
    enchantments:
        - DURABILITY:5
        - LOOT_BONUS_BLOCKS:1
CopperAxe:
    type: item
    material: gold_axe[flags=HIDE_ENCHANTS]
    display name: <&6>Copper Axe
    lore:
        - A shining copper axe,
        - made only from the
        - principle and excess of
        - molds.
    enchantments:
        - DURABILITY:5
        - LOOT_BONUS_BLOCKS:1
CopperSword:
    type: item
    material: gold_sword[flags=HIDE_ENCHANTS]
    display name: <&6>Copper Sword
    lore:
        - A specialized copper sword.
        - After various tests, Skyborne
        - technicians found that it was
        - the most conductive material
        - for future prismatech enhancement.
    enchantments:
        - DURABILITY:5
        - DAMAGE_ALL:2
TingrumOre:
    type: item
    material: redstone_ore
    display name: <&d>Tingrum Ore
    lore:
        - A strange, glowing ore
        - with red and purple flecks.
    
TingrumIngot:
    type: item
    material: nether_brick
    display name: <&d>Tingrum Ingot
    lore:
        - A refined Tingrum ingot.
        - A large red core is surrounded
        - by a purple transparent shell.
    recipes:
        1:
            type: blast
            cook_time: 6s
            experience: 5
            input: TingrumOre
PrometheumOre:
    type: item
    material: coal_ore
    display name: <&8>Prometheum Ore
    lore:
        - A scaled and dark ore
        - commonly found in the sky
        - and surface.
PromethiumIngot:
    type: item
    material: coal
    display name: <&8>Prometheum Ingot
    lore:
        - A chunk of Prometheum taken
        - from Prometheum ore. When
        - refined, it is less prone
        - to cracking and crumbling.
    recipes:
        1:
            type: blast
            cook_time: 6s
            experience: 5
            input: PrometheumOre
SilverlickOre:
    type: item
    material: lapis_ore
    display name: <&7>Silverlick Ore
    lore:
        - A shimmering blue-silver ore
        - embedded in stone and rock.
SilverlickIngot:
    type: item
    material: iron_nugget[flags=HIDE_ENCHANTS]
    display name: <&7>Silverlick Ingot
    enchantments:
        - DURABILITY:1
    lore:
        - A shining stone with a silvery
        - teal exterior. Despite its gemlike
        - appearance, it is commonly used
        - due to its low friction.
    recipes:
        1:
            type: blast
            cook_time: 1s
            experience: 5
            input: SilverlickOre
KineticOre:
    type: item
    material:
    display name: <&3>Kinetic Ore
    lore:
        - A strange piece of rock
        - exclusive to the sky. It shakes
        - and moves constantly. Depending on
        - its strength, it may even fly away.
MithrilOre:
    type: item
    material: diamond_ore
    display name: <&b>Mithril Ore
    lore:
        - A fabled ore. It's glowing blue
        - light is extremely difficult to
        - refine and utilize.
MithrilIngot:
    type: item
    material: diamond
    display name: <&b>Mithril Ingot
    lore:
        - A masterwork mithril ingot.
        - The shining teal light taunts
        - you with its powerful applications.
    recipes:
        1:
            type: blast
            cook_time: 15s
            experience: 5
            input: MithrilOre
Skyglass:
    type: item
    material: quartz[flags=HIDE_ENCHANTS]
    display name: <&b>Skyglass Pane
    lore:
        - A masterwork component forged
        - in a hidden forge in the Sky.
        - The material is tough and light,
        - making it extremely popular.
    enchantments:
        - LUCK:1
SkyglassPickaxe:
    type: item
    material: diamond_pickaxe[flags=HIDE_ENCHANTS]
    display name: <&b>Skyglass Pickaxe
    lore:
        - <&4>~* Masterwork *~
        - A skyglass pick. Strong, reliable,
        - and easy to carry, this pick inspires
        - owners to name it.
SkyglassAxe:
    type: item
    material: diamond_axe[flags=HIDE_ENCHANTS]
    display name: <&b>Skyglass Axe
    lore:
        - <&4>~* Masterwork *~
        - A skyglass axe. Strong, reliable,
        - and easy to carry, this axe shines
        - in the sun a brilliant blue, a side
        - effect of the forging process.
SkyglassBardiche:
    type: item
    material: diamond_axe[flags=HIDE_ENCHANTS]
    display name: <&b>Skyglass Bardiche
    lore:
        - <&4>~* Masterwork *~
        - An expertly crafted weapon.
        - Despite the heft of its appearance,
        - the weapon is lightweight and easy
        - to wield. The handle has been shorted
        - to be held with one hand.
    enchantments:
        - DAMAGE_ALL:2
SkyglassSword:
    type: item
    material: diamond_sword[flags=HIDE_ENCHANTS]
    display name: <&b>Skyglass Sword
    lore:
        - <&4>~* Masterwork *~
        - An electric blue sword - curved
        - like a scimitar, made of reinforced
        - Skyglass. It's strong, impossibly light,
        - and a spectacle to the eye.
    enchantments:
        - DAMAGE_ALL:2
    

# ==================================================== #
# ========================= Pilot ==================== #
# ==================================================== #
# General Items
PilotStick:
    type: item
    material: blaze_rod
    display name: <&e>Pilot<&sq>s Baton
    lore:
    - A stick granted to distinguised
    - pilots of the Skyborne or
    - Children of the Sun. It is said
    - that those who earned this item
    - can fly any vessel, as it is a
    - trademark of an ancient pilot long
    - past.
PilotCompass:
    type: item
    material: compass
    display name: <&e>Pilot<&sq>s Compass
    lore:
    - A compass commonly used by Pilots
    - in the sky. Weathered, silver, and
    - intricate, they are said to always
    - guide one back home.
PilotWatch:
    type: item
    material: clock
    display name: <&e>Pilot<&sq>s Watch
    lore:
    - A small watch which is known to come
    - in a variety of forms. Using rough
    - skyborne technology, it shows an
    - estimated time of daylight left.
# ==================================================== #
# ======================= Engineer =================== #
# ==================================================== #
# General Items
ClockworkBag:
    type: item
    material: player_head[skull_skin=914e68b0-4550-4c2c-bbee-dc903e8485f5|eyJ0aW1lc3RhbXAiOjE1NjM2MzE3NTA0ODksInByb2ZpbGVJZCI6ImIwZDRiMjhiYzFkNzQ4ODlhZjBlODY2MWNlZTk2YWFiIiwicHJvZmlsZU5hbWUiOiJ4RmFpaUxlUiIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNzYwYTA4ZGE4ZDNlNzNjNWFkZGNjMTAzODk1NjU2YWM0MDRmZjQyZjJkNWI1Yjc0NmNjZGU2MDdjZTkwNDQzYyJ9fX0=]
    display name: <&3>Bag of Clockwork Parts
    lore:
    - A small bag, no larger than a coinpurse,
    - containing several knick-knacks used in
    - clockwork-based tinkering. Peering inside
    - would reveal small gears, latches, wires,
    - bushings, and more.
ClockworkArithmeticUnit:
    type: item
    material: clock
    display name: <&3>Clockwork Arithmetic Unit
    lore:
    - A complex clockwork component which
    - serves as the core for many autonomous
    - and individual mechanical parts in the sky.
    - By calculating differences between given inputs,
    - the unit can send outputs accordingly.
Musicbox:
    type: item
    material: stone_button
    display name: <&3>Musicbox
    lore:
    - A small musicbox created by
    - a bored engineer. It supports
    - paper musicsheets, allowing the box
    - to play a variety of melodies.
# Machine Components
Crankshaft:
    type: item
    material: stone
    display name: <&3>Crankshaft
    lore:
    - A clockwork device used to convert
    - piston based kinetic force into
    - rotational force.
SteamPort:
    type: item
    material: stone
    display name: <&3>Steam Port
    lore:
    - A standalone component used to
    - control steam access to and from
    - core pistons.
KineticConverter:
    type: item
    material: stone
    display name: <&3>Kinetic Converter
    lore:
    - A standalone component used to
    - convert raw motion from kinetic ore fuel
    - into usable kinetic or electric energy.
    - An absolute must-have in the sky.
PrismatechSheath:
    type: item
    material: iron_ingot
    display name: <&3>Prismatech Sheath
    lore:
    - A standalone component used to
    - add prismatech functionality to
    - a given base item. Engineers from
    - Stratum are said to use these on
    - new prototype weaponry.
# Airship Components

# Gasbags require custom fabric/rubber hybrid from Merchants
AirshipGasBag:
    type: item
    material: stone
    display name: <&3>Airship Gas Bag Design
    lore:
    - An airship component.
    - The balloon<&sq>s gas bag is one
    - of the most critical pieces of the ship.
    - After all, no balloon, no hull!
    - This fabric/rubber hybrid holds the gas which
    - keeps the ships aloft.

AirshipSphereBalloon:
    type: item
    material: stone
    display name: <&3>Spherical Airship Balloon
    lore:
    - An airship component.
    - Airship balloons come in two primary shapes,
    - a spherical shape and oval shape. Spherical shapes
    - tend to slow the ship down, however are easier to
    - pair together to generate stronger lift.
    recipes:
        1:
            type: shaped
            group: airship_sphere_balloon
            input:
            - white_wool|AirshipBalloonPlating|white_wool
            - white_wool|AirshipGasBag|white_wool
            - white_wool|AirshipBalloonPlating|white_wool
AirshipOvalBalloon:
    type: item
    material: stone
    display name: <&3>Oval Airship Balloon
    lore:
    - An airship component.
    - Airship balloons come in two primary shapes,
    - a spherical shape and oval shape. Oval shapes
    - are far more aerodynamic, but may rely on more
    - internal gasbags.
    recipes:
        1:
            type: shaped
            group: airship_oval_balloon
            input:
            - white_wool|AirshipBalloonPlating|white_wool
            - AirshipGasBag|AirshipGasBag|AirshipGasBag
            - white_wool|AirshipBalloonPlating|white_wool
AirshipTurbineEngine:
    type: item
    material: stone
    display name: <&3>Airship Turbine Engine
    lore:
    - An airship component.
    - Many airships use different types of engines depending
    - on the job they serve. After all, a small speedy engine
    - can't lug around cargo! Luckily, the internal mechanism
    - core frameworks are all the same.
    recipes:
        1:
            type: shaped
            group: airship_turbine_engine
            input:
            - piston|piston|piston
            - SteamPort|Crankshaft|SteamPort
            - redstone|piston|redstone
# Weaponsmith

# Blacksmith
# ==================================================== #
# ===================== Blacksmith =================== #
# ==================================================== #
# Airship Components
AirshipBalloonPlating:
    type: item
    material: white_carpet
    display name: <&d>Airship Balloon Plating
    lore:
    - A lightweight secret blend of sources which
    - provides sturdy, flexible, and reliable protection
    - to the balloons of various airships.

#ScrapMetal