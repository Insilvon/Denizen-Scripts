TPGroup:
    type: command
    name: tpgroup
    desc: teleports a group of players around the target
    usage: /tpgroup player
    permission: aetheria.tpgroup
    aliases:
    - gmv
    script:
        - define arg:<context.args.get[1]||null>
        - if <[arg]> == null:
            - narrate "/tpgroup player"
            - stop
        - define target:<server.match_player[<[arg]>]||null>
        - if <[target]> == null:
            - narrate "Error - invalid player."
            - stop
        - teleport <player.location.find.players.within[6]> <[target].location>

WarpGroup:
    type: command
    name: warpgroup
    desc: warps a group of players
    usage: /warpgroup warpname
    permission: aetheria.warpgroup
    script:
        - define arg:<context.args.get[1]||null>
        - if <[arg]> == null:
            - narrate "You must specify a warp!"
            - stop
        - define targets:<player.location.find.players.within[6]||null>
        - foreach <[targets]> as:target:
            - execute as_op "warp <[arg]> <[target].name>"