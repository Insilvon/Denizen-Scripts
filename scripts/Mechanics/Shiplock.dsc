Shiplock:
    type: command
    name: shiplock
    description: locks your ship, obviously
    usage: /shiplock
    permission: aetheria.shiplock
    script:
        - define character:<proc[GetCharacterName].context[<player>]>

        - if <player.has_flag[<[character]>_Shiplocked]>:
            - define blockLocation:<player.flag[<[character]>_Shiplocked]>
            - flag player <[character]>_Shiplocked:!
            - note remove as:<[character]>_shiplock
            - modifyblock <[blockLocation]> air
        - else:
            - flag player <[character]>_Shiplocked:<player.location>
            - modifyblock <player.location> obsidian
            - if !<player.has_flag[<[character]>_shiplock]>:
                - flag player <[character]>_shiplock:1
            # - define id:<player.flag[<[character]>_shiplock]>
            - define world:<player.location.world>
            - define pos1:<player.location.left.backward.down>
            - define pos2:<player.location.right.forward.up>
            - note cu@<player.location.world>,<[pos1].xyz>,<[pos2].xyz> as:<[character]>_shiplock
ShiplockOnPlayerBreaksBlock:
    type: task
    debug: off
    speed: instant
    script:
        - if <context.location.cuboids.contains_text[shiplock]>:
            - determine cancelled passively
            - narrate "You cannot remove this lock - this ship belongs to someone else."