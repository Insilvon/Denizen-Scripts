RopeArrowBow:
    type: item
    material: bow
    display name: Rope Arrow Bow

RopeArrowWorld:
    type: world
    events:
        on player shoots bow:
            - if <context.bow.script.name> == RopeArrowBow:
                - if <player.inventory.contains[string]>:
                    - define rope_arrow:<context.projectile.entity_type>_<context.projectile.eid>
                    - flag server <[rope_arrow]>
        on entity shoots block:
            - define shooter:<context.shooter.name>
            - define rope_arrow:<context.projectile.entity_type>_<context.projectile.eid>
            - if <server.has_flag[<[rope_arrow]>]>:
                - define location:<context.location.relative[0,-1,0]>
                - if <[location].block.material.name> == air:
                    - modifyblock <context.location.relative[0,-1,0]> iron_bars
                    - define value:2
                    - while <server.match_player[<[shooter]>].inventory.contains[string]> && <[value]> != 40 && <context.location.relative[0,-<[value]>,0].block.material> == m@AIR:
                        - modifyblock <context.location.relative[0,-<[value]>,0]> iron_bars
                        - define value:++
                        - take string from:<server.match_player[<[shooter]>].inventory>
                        - wait 2t
                    - flag server <[rope_arrow]>:!
                    - define start_location:<[location].relative[-2,1,2]>
                    - define end_location:<context.location.relative[2,-<[value]>,-2]>
                    - note cu@<[start_location].world.name>,<[start_location].x>,<[start_location].Y>,<[start_location].Z>,<[end_location].x>,<[end_location].Y>,<[end_location].Z> as:ROPE<[rope_arrow]>
                    # Wait for a period, then remove
                    - wait <[value].add_int[10]>s
                    - drop string <[location]> quantity:<[value]>
                    - note remove as:ROPE<[rope_arrow]>
                    - define location:<[location].relative[0,1,0]>
                    - define value:<[value].sub_int[1]>
                    - repeat <[value]> as:offset:
                        - modifyblock <[location].relative[0,-<[offset]>,0]> air
                    - cast levitation remove <server.match_player[<[shooter]>]>
        on player starts sneaking:
            - if <player.location.cuboids.contains_text[ROPEARROW]>:
                - cast levitation duration:40s power:1 hide_particles
                - while <player.location.cuboids.contains_text[ROPEARROW]>:
                    - wait 1s
                    - if <player.is_sneaking> == false || <player.location.cuboids.contains_text[ROPEARROW]> == false:
                        - cast levitation remove <player>
        on player exits notable cuboid:
            - if <context.cuboids.contains_text[ROPEARROW]>:
                - cast levitation remove <player>

                # on entity shoots block:
                #     - define shooter:<context.shooter.name>
                #     - define rope_arrow:<context.projectile.entity_type>_<context.projectile.eid>
                #     - if <server.has_flag[<[rope_arrow]>]>:
                #         - define location:<context.location.relative[0,-1,0]>
                #         - if <[location].block.material.name> == air:
                #             - showfake iron_bars <context.location.relative[0,-1,0]> duration:30s players:<server.list_players>
                #             - define value:1
                #             - while <server.match_player[<[shooter]>].inventory.contains[string]> && <[value]> != 40 && <context.location.relative[0,-<[value]>,0].block.material> == m@AIR:
                #                 - showfake iron_bars <context.location.relative[0,-<[value]>,0]> duration:30s players:<server.list_players>
                #                 - define value:++
                #                 - take string from:<server.match_player[<[shooter]>].inventory>
                #                 - wait 2t
                #             - flag server <[rope_arrow]>:!
                #             - define start_location:<[location].relative[-2,1,2]>
                #             - define end_location:<context.location.relative[2,-<[value]>,-2]>
                #             - note cu@<[start_location].world.name>,<[start_location].x>,<[start_location].Y>,<[start_location].Z>,<[end_location].x>,<[end_location].Y>,<[end_location].Z> as:ROPE<[rope_arrow]>
                #             # - narrate "Defining <player.location.world>,<[start_location].xyz>,<[end_location].xyz> as ROPE<[rope_arrow]>" targets:<server.match_player[Insilvon]>
                #             - wait 30s
                #             - drop string <[location]> quantity:<[value]>
                #             - note remove as:ROPE<[rope_arrow]>
                #             - cast levitation remove <server.match_player[<[shooter]>]>