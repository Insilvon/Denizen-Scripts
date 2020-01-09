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
    material: stone
    display name: <&3>Bag of Clockwork Parts
    lore:
    - A small bag, no larger than a coinpurse,
    - containing several knick-knacks used in
    - clockwork-based tinkering. Peering inside
    - would reveal small gears, latches, wires,
    - bushings, and more.
ClockworkArithmeticUnit:
    type: item
    material: stone
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