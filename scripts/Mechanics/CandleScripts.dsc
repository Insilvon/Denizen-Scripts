# Candles
# Made and designed for AETHERIA
# @author Insilvon
# @version 2.1.2
# Allows players to place custom candle items which can be lit and snuffed
# When lit, the candles will narrate a lore description to the surrounding area.
# Last Change: Prevented Flint and Steel from starting fires when lighting candles
# TODO:// Allow Candles to be Craftable
    
CandleHandler:
    type: task
    debug: true
    speed: 3t
    script:
      # Do we have a flag for this candle?
      - if <server.has_flag[<[customItem]>_<context.location.simple>]>:
        # Yes? Okay, activate it.
        - if <server.flag[<[customItem]>_<context.location.simple>]> != snuffed:
          # Remove the thing
          - narrate "Your candle has flickered out."
          - define theThing <server.flag[<[customItem]>_<context.location.simple>]>
          - note remove as:<[theThing]>
          - flag server <[customItem]>_<context.location.simple>:snuffed
        - else:
          - if <player.item_in_hand.simple> == i@torch:
            - determine passively cancelled
            - define origin:<context.location.add[0,-1,0]>
            - define pos1:<[origin].add[4,-3,4]>
            - define pos2:<[origin].add[-4,3,-4]>
            - define id:<util.random.uuid>
            - note cu@<[pos1].world>,<[pos1].xyz>,<[pos2].xyz> as:<[customItem]>_<[id]>
            - flag server <[customItem]>_<context.location.simple>:<[customItem]>_<[id]>
            # - execute as_server "denizen save"
            - narrate "*You light the candle. Its aroma fills the air.*"
            - run CandleScentText def:<[customItem]>
CandleScentText:
    type: task
    debug: off
    definitions: cuboid
    speed: 1t
    script:
        - if <[cuboid].contains_text[sweet]>:
            - narrate "<&a>*A satisfying sweet smell fills the air*"
            - stop
        - if <[cuboid].contains[foul]>:
            - narrate "<&c>*Your nostrils are also appalled with the scent of guck*"
            - stop
        - if <[cuboid].contains[freshlinen]>:
            - narrate "<&7>*As you enter the space, the smell of fresh linen fills the air*"
            - stop
        - if <[cuboid].contains[cherryblossom]>:
            - narrate "<&d>*The scent of cherry blossoms lingers in the air*"
            - stop
        - if <[cuboid].contains[bonfire]>:
            - narrate "<&6>*You notice the room smells like a lovely bonfire and burning oak*"
            - stop
        - if <[cuboid].contains[oceanbreeze]>:
            - narrate "<&b>*The smell of saltwater and ocean wind fills the area*"
            - stop
        - if <[cuboid].contains[vanilla]>:
            - narrate "<&a>*The scent of French Vanilla is strong and impressive here*"
            - stop
        - if <[cuboid].contains[gingerbread]>:
            - narrate "<&6>*The smell of Gingerbread cookies brings a smile to your face*"
            - stop
        - if <[cuboid].contains[pumpkinspice]>:
            - narrate "<&6>*The autumnal aroma of Pumpkin Spice warms the area*"
            - stop
        - if <[cuboid].contains[pine]>:
            - narrate "<&2>*The scent of Pine Trees and Fresh Dew fills the air*"
            - stop
        - if <[cuboid].contains[applecinnamon]>:
            - narrate "<&c>*A taste of apple cinnamon dances on your tongue as you smell the air*"
            - stop
        - if <[cuboid].contains[chocolatechip]>:
            - narrate "<&6>*The smell of warm and melted chocolate fills the area as your mouth waters for cookies*"
            - stop
        - if <[cuboid].contains[lavender]>:
            - narrate "<&d>*The scent of fresh lavender fills the air... and your nose*"
            - stop
        - if <[cuboid].contains[lemongrass]>:
            - narrate "<&e>*The citrusy air smells of lemongrass and other fruits*"
            - stop
        - if <[cuboid].contains[honeydew]>:
            - narrate "<&e>*The soft smell of honeydew and watermelon lingers in the air*"
            - stop
        - if <[cuboid].contains[gardenia]>:
            - narrate "<&a>*The exotic and powerful smell of Gardenia fills the area*"
            - stop
        - if <[cuboid].contains[sugarcookie]>:
            - narrate "<&e>*The smell of freshly cooked sugarcookies makes your mouth water*"
            - stop
        - if <[cuboid].contains[redwood]>:
            - narrate "<&6>*The area smells of a rich, damp, and wild redwood forest*"
            - stop
        - if <[cuboid].contains[peach]>:
            - narrate "<&c>*The fruity smell of freshly cut peach fills the area*"
            - stop
        - if <[cuboid].contains[honeysuckle]>:
            - narrate "<&e>*The sweet smell of sugar and honeysuckle fills the air*"
            - stop
        - if <[cuboid].contains[wheat]>:
            - narrate "<&e>*The smell of fresh wheat radiates around you.*"
            - stop
        - if <[cuboid].contains[bourbon]>:
            - narrate "<&6>*The rich, sophisticated smell of bourbon fills the air.*"
            - stop

CandleOnPlayerRightClicksPlayer_Head:
    type: task
    debug: off
    script:
        # - narrate "<[customItem]>"
        - if <[customItem].contains_text[Candle]>:
            - inject CandleHandler
CandleOnPlayerBreaksBlock:
    type: task
    debug: true
    script:
        - if <[itemDrop].contains_text[Candle]>:
            - define customitem:<[itemdrop]>
            - inject CandleHandler

