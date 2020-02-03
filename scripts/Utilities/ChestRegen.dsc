ChestRegen:
    type: command
    name: chestregen
    desc: sh
    usage: /chestregen
    aliases:
    - cr
    permission: aetheria.cr
    script:
        - define command:<context.args.get[1]||regen>
        - define chest:<player.location.cursor_on.block>
        - if <[chest].material.name> != chest:
            - narrate "<&6>You must be looking at a chest."
        # Disable
        - if <[command]> == regen:
            - if <server.flag[ChestRegenLocations].contains[<[chest]>]>:
                - define index:<server.flag[ChestRegenLocations].index_of[<[chest]>]>
                - if <[index]> != 0:
                    - define inventory:<server.flag[ChestRegenInventories].get[<[index]>]>
                    - flag server ChestRegenLocations:<-:<[chest]>
                    - flag server ChestRegenInventories:<-:<[inventory]>
                    - narrate "<&6>This chest will no longer regen."
            # Enable
            - else:
                - define inventory:<[chest].inventory>
                - flag server ChestRegenLocations:->:<[chest]>
                - flag server ChestRegenInventories:->:<[inventory].list_contents>
                - narrate "<&6>This chest will now regen."
        - if <[command]> == restock:
            - if <server.flag[ChestRegenLocations].contains[<[chest]>]>:
            - define index:<server.flag[ChestRegenLocations].index_of[<[chest]>]>
            - if <[index]> != 0:
                - define inventory:<server.flag[ChestRegenInventories].get[<[index]>]>
                - foreach <[inventory]> as:item:
                    - inventory set d:<[chest].inventory> o:<[item]> slot:<[loop_index]>
                - narrate "<&6>This chest has regenerated."
ChestRegenRegen:
    type: world
    events:
        on system time hourly every:12:
            - repeat <server.flag[ChestRegenLocations].size>:
                - define chest:<server.flag[ChestRegenLocations].get[<[value]>]>
                - narrate "<[chest].inventory>"
                - define inventory:<server.flag[ChestRegenInventories].get[<[value]>]>
                - inventory clear d:<[chest].inventory>
                - foreach <[inventory]> as:item:
                    - inventory set d:<[chest].inventory> o:<[item]> slot:<[loop_index]>
                - narrate "<&6>The chest has regenerated."

        
