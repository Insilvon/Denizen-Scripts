RopeArrowBow:
    type: item
    material: bow
    display name: Rope Arrow Bow
GrappleArrowBow:
    type: item
    material: bow
    display name: Grapple Arrow Bow

NewRopeBowController:
    type: world
    debug: false
    events:
        on player breaks iron_bars:
            - if <player.location.cuboids.contains_text[ROPE_ARROW]>:
                - determine cancelled
        on player shoots bow:
            - if <context.bow.script.name||null> == RopeArrowBow:
                - determine cancelled passively
                - shoot arrow origin:<player.location.above> speed:<context.force> no_rotate script:NewRopeBowTaskScript def:<player> save:theArrow
                - define id:rope_arrow_<util.random.uuid>
                - flag <entry[theArrow].shot_entity> id:<[id]> d:10s
                - while <server.entity_is_spawned[<entry[theArrow].shot_entity>]> && <entry[theArrow].shot_entity.has_flag[id]>:
                    - playeffect <entry[theArrow].shot_entity.location> effect:spit offset:0.0
                    - wait 0.1t

            - if <context.bow.script.name||null> == GrappleArrowBow:
                - determine cancelled passively
                - if <player.has_flag[GrappleArrowCooldown]>:
                    - narrate "<&c>You are grappling too quickly! Please wait!"
                - else:
                    - flag player GrappleArrowCooldown duration:9s
                    - shoot arrow origin:<player.location.above> speed:<context.force> no_rotate script:NewGrappleBowTaskScript def:<player> save:theArrow
                    - define id:rope_arrow_<util.random.uuid>
                    - flag <entry[theArrow].shot_entity> id:<[id]> d:10s
                    - while <entry[theArrow].shot_entity.has_flag[id]>:
                        - playeffect <entry[theArrow].shot_entity.location> effect:spit offset:0.0
                        - wait 0.1t

        on player starts sneaking:
            - if <player.location.cuboids.contains_text[ROPE_ARROW]>:
                - cast levitation duration:40s power:1 hide_particles
                - while <player.location.cuboids.contains_text[ROPE_ARROW]>:
                    - wait 1t
                    - if <player.is_sneaking> == false || <player.location.cuboids.contains_text[ROPE_ARROW]> == false:
                        - cast levitation remove <player>

NewRopeBowTaskScript:
    type: task
    debug: false
    definitions: shooter
    script:
        - flag <[last_entity]> id:!
        - if !<[last_entity].is_on_ground>:
            - stop
        - define hook:<[location].block>
        - define bottomHook:<[hook].below>
        - define value:0
        - while <[value]> != 64 && <[hook].relative[0,-<[value]>,0].block.material> == m@air:
            - modifyblock <[hook].relative[0,-<[value]>,0]> iron_bars
            - define value:++
            - wait 2t
        - define start_location:<[hook].relative[-2,1,2]>
        - define end_location:<[hook].relative[2,-<[value]>,-2]>
        - define rope_arrow:rope_arrow_<util.random.uuid>
        - note cu@<[start_location].world.name>,<[start_location].xyz>,<[end_location].xyz> as:<[rope_arrow]>
        # Wait for a period, then remove
        - wait <[value]>s
        - define theCuboid:cu@<[rope_arrow]>
        - narrate "*The rope is beginning to shudder!*" targets:<[theCuboid].list_players>
        - wait 5s
        - note remove as:<[rope_arrow]>
        - repeat <[value]> as:offset:
            - define offset:<[offset].sub_int[1]>
            - if <[hook].relative[0,-<[offset]>,0].block.material.name> == IRON_BARS:
                - modifyblock <[hook].relative[0,-<[offset]>,0]> air
        - cast levitation remove <[shooter]>

NewGrappleBowTaskScript:
    type: task
    debug: false
    definitions: shooter
    script:
        - flag <[last_entity]> id:!
        - if !<[last_entity].is_on_ground>:
            # - narrate "You hit air!!!" targets:<server.match_player[Insilvon]>
            - stop
        - shoot <[shooter]> origin:<[shooter].location> destination:<[location]> speed:2.3
