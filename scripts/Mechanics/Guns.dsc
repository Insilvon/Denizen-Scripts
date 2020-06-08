Gun:
    type: item
    material: stick
    display name: A Gun
Ammo:
    type: item
    material: clay_ball
    display name: Ammo
AlishaGunleg:
    type: item
    material: iron_ingot[flags=HIDE_ENCHANTS]
    display name: <&a>Alisha<&sq>s Gun Leg
    lore:
        - A handcrafted artificial
        - leg. It's girth is quickly understood
        - when the barrel of the gun is
        - seen.
    enchantments:
        - INFINITY:1
FlintlockPistol:
    type: item
    material: stick
    display name: <&6>Flintlock Pistol
    lore:
        - A Stratum-made flintlock
        - pistol. Consumes premade
        - paper cartridges for ammunition.
FlintlockAmmo:
    type: item
    material: name_tag
    display name: <&6>Paper Cartridge
    lore:
        - A paper cartridge,
        - used as ammunition for
        - many flintlock weapons.
    recipes:
        1:
            type: shapeless
            input: paper|gunpowder|paper
PirateFlintlockPistol:
    type: item
    material: stick
    display name: <&6>Black Powder Pistol
    lore:
        - A crudely crafted pistol
        - made for devestation. The
        - sigil of the Pirate<&sq>s Order
        - is displayed on the side.
        - Consumes gunpowder on use.

GunController:
    type: world
    debug: false
    events:
        on player right clicks with FlintlockPistol:
            - if !<player.inventory.contains[FlintlockAmmo]>:
                - narrate "You have no ammo to load this!"
                - stop
            - if <player.has_flag[gun_cooldown]>:
                - narrate "You must wait to fire again!"
                - stop
            - take FlintlockAmmo
            - define origin:<player.eye_location>
            - playsound <player.location.find.players.within[20]> sound:ENTITY_DRAGON_FIREBALL_EXPLODE pitch:4
            - playeffect lava at:<[origin].points_between[<player.location.cursor_on>].distance[5]> offset:0.0 quantity:1
            - playeffect smoke at:<[origin].points_between[<player.location.cursor_on>].distance[0.1]> offset:0.1 quantity:15
            - shoot dropped_item[item=fire_charge] origin:<[origin].forward.forward> destination:<player.location.cursor_on> script:GunScript def:<[origin]> speed:3
            - shoot arrow origin:<[origin]> destination:<player.eye_location.precise_cursor_on> script:GunScript def:<[origin]> speed:3 save:theammo no_rotate
            - flag <entry[theammo].shot_entity> gun:flintlockpistol
            - flag player gun_cooldown d:6s
        on player right clicks with PirateFlintlockPistol:
            - if !<player.inventory.contains[gunpowder]>:
                - narrate "You have no ammo to load this!"
                - stop
            - if <player.has_flag[gun_cooldown]>:
                - narrate "You must wait to fire again!"
                - stop
            - take gunpowder
            - define origin:<player.eye_location>
            - playsound <player.location.find.players.within[20]> sound:ENTITY_DRAGON_FIREBALL_EXPLODE pitch:4
            - playeffect flame at:<[origin].points_between[<player.location.cursor_on>].distance[5]> offset:0.5 quantity:10
            - playeffect smoke at:<[origin].points_between[<player.location.cursor_on>].distance[0.1]> offset:0.1 quantity:15
            - shoot dropped_item[item=fire_charge] origin:<[origin].forward.forward> destination:<player.location.cursor_on> script:GunScript def:<[origin]> speed:3
            - shoot arrow origin:<[origin]> destination:<player.eye_location.precise_cursor_on> script:GunScript def:<[origin]> speed:3 save:theammo no_rotate
            - flag <entry[theammo].shot_entity> gun:blackpowder
            - flag player gun_cooldown d:4s
        on player right clicks with gun:
            - if !<player.inventory.contains[ammo]>:
                - narrate "You have no ammo to load this!"
                - stop
            - if <player.has_flag[gun_cooldown]>:
                - narrate "You must wait to fire again!"
                - stop
            - take ammo
            - define origin:<player.eye_location>
            - playeffect lava at:<[origin].points_between[<player.location.cursor_on>].distance[5]> offset:0.0 quantity:1
            - playeffect smoke at:<[origin].points_between[<player.location.cursor_on>].distance[0.1]> offset:0.1 quantity:15
            - shoot dropped_item[item=fire_charge] origin:<[origin].forward.forward> destination:<player.location.cursor_on> script:GunScript def:<[origin]> speed:3
            - shoot arrow origin:<[origin]> destination:<player.eye_location.precise_cursor_on> script:GunScript def:<[origin]> speed:3 save:theammo no_rotate
            - flag <entry[theammo].shot_entity> gun:testgun
            - flag player gun_cooldown d:6s
        # on entity
        on entity damaged by projectile:
            - if <context.damager.has_flag[gun]>:
                - choose <context.damager.flag[gun]||null>:
                    - case testgun:
                        - determine 5
                    - case cotsstone:
                        - determine 1 passively
                        - burn <context.entity> duration:9s
                    - case flintlockpistol:
                        - determine 8
                    - case blackpowder:
                        - determine 6
                        

GunScript:
    type: task
    definitions: locale
    script:
        - remove <[shot_entities]>
