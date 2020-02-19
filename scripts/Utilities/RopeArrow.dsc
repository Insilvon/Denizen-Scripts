RopeArrowBow:
    type: item
    material: bow
    display name: Rope Arrow Bow
GrappleArrowBow:
    type: item
    material: bow
    display name: Grapple Arrow Bow
ClearRope:
    type: command
    name: clearrope
    description:
RopeArrowWorld:
    type: world
    debug: false
    events:
        on player shoots bow:
            - if <context.bow.script.name||null> == RopeArrowBow:
                #- if <player.inventory.contains[string]>:
                - define rope_arrow:rope_<context.projectile.entity_type>_<context.projectile.eid>
                #- narrate "<[rope_arrow]>" targets:<server.match_player[Insilvon]>
                - flag server <[rope_arrow]>
                - flag player ropearrow:<[rope_arrow]>
            - if <context.bow.script.name||null> == GrappleArrowBow:
                - if <player.has_flag[GrappleArrowCooldown]>:
                    - narrate "<&c>You are grappling too quickly! Please wait!"
                - else:
                    - define grapple_arrow:grapple_<context.projectile.entity_type>_<context.projectile.eid>
                    - flag server <[grapple_arrow]>
                    - flag player GrappleArrowCooldown duration:9s
        on entity shoots block:
            - define shooter:<context.shooter.name>
            - define custom_arrow:<context.projectile.entity_type>_<context.projectile.eid>
            - if <server.has_flag[rope_<[custom_arrow]>]>:
                - define rope_arrow:rope_<[custom_arrow]>
                - define location:<context.location.relative[0,-1,0]>
                - define value:1
                # - while <server.match_player[<[shooter]>].inventory.contains[string]> && <[value]> != 64 && <context.location.relative[0,-<[value]>,0].block.material> == m@AIR:
                - while <[value]> != 64 && <context.location.relative[0,-<[value]>,0].block.material> == m@AIR:
                    - modifyblock <context.location.relative[0,-<[value]>,0]> iron_bars
                    - define value:++
                    # - take string from:<server.match_player[<[shooter]>].inventory>
                    - wait 2t
                - flag server <[rope_arrow]>:!
                - define start_location:<[location].relative[-2,2,2]>
                - define end_location:<context.location.relative[2,-<[value]>,-2]>
                - note cu@<[start_location].world.name>,<[start_location].x>,<[start_location].Y>,<[start_location].Z>,<[end_location].x>,<[end_location].Y>,<[end_location].Z> as:<[rope_arrow]>
                # Wait for a period, then remove
                - wait <[value].as_int>s
                - define theCuboid:cu@<[rope_arrow]>
                - narrate "*The rope is beginning to shudder!*" targets:<[theCuboid].list_players>
                - wait 10s
                # Clean up
                #- drop string <[location]> quantity:<[value]>
                - note remove as:<[rope_arrow]>
                - define location:<[location].relative[0,1,0]>
                - define value:<[value].sub_int[1]>
                - repeat <[value]> as:offset:
                    - if <[location].relative[0,-<[offset]>,0].block.material.name> == IRON_BARS:
                        - modifyblock <[location].relative[0,-<[offset]>,0]> air
                - cast levitation remove <server.match_player[<[shooter]>]>
            - if <server.has_flag[grapple_<[custom_arrow]>]>:
                - define grapple_arrow:<[custom_arrow]>
                - define location:<context.location>
                - shoot <server.match_player[<[shooter]>]> origin:<server.match_player[<[shooter]>]> speed:2.2 destination:<[location]>
        on player starts sneaking:
            - if <player.location.cuboids.contains_text[ROPE_ARROW]>:
                - cast levitation duration:40s power:1 hide_particles
                - while <player.location.cuboids.contains_text[ROPE_ARROW]>:
                    - wait 1t
                    - if <player.is_sneaking> == false || <player.location.cuboids.contains_text[ROPE_ARROW]> == false:
                        - cast levitation remove <player>
        on player exits notable cuboid:
            # - if <context.cuboids.contains_text[SkyworldZone]>:
            #     - inject SkyworldTPScript
            #     - stop
            # - else:
            #     - narrate "Nope!"
            - if <context.cuboids.contains_text[ROPE_ARROW]>:
                - cast levitation remove <player>
        on player clicks block:
            - if <player.is_sneaking>:
                - if <player.has_flag[ropearrow]> && <context.location.block.material.name||null> == IRON_BARS && <player.location.cuboids.contains_text[<player.flag[ropearrow]>]>:
                    - define theCuboid:cu@<player.flag[ropearrow]>
                    - define highY:<[theCuboid].max.y>
                    - define lowY:<[theCuboid].min.y>
                    - define locY:<context.location.y>
                    - define distance:<[theCuboid].max.distance[<[theCuboid].min>].vertical>
                    - if <[theCuboid].contains_location[<context.location>]>:
                        - if <context.location.relative[0,1,0].y> == <[highY]>:
                            - execute as_server "sudo <player.name> c:*<proc[GetCharacterName].context[<player>]> yanks out the rope!*"
                            - modifyblock <context.location> air
                            - repeat <[distance]> as:value:
                                - define currentLocation:<context.location.relative[0,-<[value]>,0]>
                                - if <[currentLocation].block.material.name> == IRON_BARS <[theCuboid].contains_location[<[currentLocation]>]>:
                                    - modifyblock <[currentLocation]> air
                        - if <context.location.relative[0,-1,0].y> == <[lowY]>:
                            - execute as_server "sudo <player.name> c:*<proc[GetCharacterName].context[<player>]> yanks down the rope!*"
                            - modifyblock <context.location> air
                            - repeat <[distance]> as:value:
                                - define currentLocation:<context.location.relative[0,<[value]>,0]>
                                - if <[currentLocation].block.material.name> == IRON_BARS && <[theCuboid].contains_location[<[currentLocation]>]>:
                                    - modifyblock <[currentLocation]> air
