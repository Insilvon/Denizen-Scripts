# Telegraph System
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.2
# Allows players to place custom items to create Morse Code Stations with custom channels
# Last Change: Added Generalized World Script subtasks
# TODO://
TelegraphHandler:
    type: task
    script:
        # Left click for channel change - clear current flags, Shift left click to send message
        # Right click for ".", Shift right click for "-"
        - define location:<context.location.simple>
        # Left Click
        - if <[click]> == left:
            # Transmitter
            - if <player.item_in_hand.script.name> == TelegraphTransmitter:
                - inject SendScript
            # Shift Left
            - if <player.is_sneaking>:
                - inject ChannelScript
            # Regular Left
            - else:
                - inject DotScript
        # Right Click
        - else:
            # Transmitter
            - if <player.item_in_hand.script.name> == TelegraphTransmitter:
                - inject SendScript
            # Shift Right
            - if <player.is_sneaking>:
                - inject SpaceScript
            # Regular Right
            - else:
                - inject DashScript
DotScript:
    type: task
    script:
        - flag server Telegraph_<[location]>:<server.flag[Telegraph_<[location]>]>.
        - narrate "<&a>Current Message<&co> <server.flag[Telegraph_<[location]>]>"
DashScript:
    type: task
    script:
        - flag server Telegraph_<[location]>:<server.flag[Telegraph_<[location]>]>-
        - narrate "<&a>Current Message<&co> <server.flag[Telegraph_<[location]>]>"
SpaceScript:
    type: task
    script:
        - flag server Telegraph_<[location]>:<server.flag[Telegraph_<[location]>]><&sp>
        - narrate "<&a>Current Message<&co> <server.flag[Telegraph_<[location]>]>"
SendScript:
    type: task
    script:
        - define message:<server.flag[Telegraph_<[location]>]>
        #- define channel:<server.flag[Telegraph_<[location]>_Channel]>
        - narrate "Broadcasting on channel <server.flag[Telegraph_<[location]>_Channel]> with message <[message]>"
        - run TelegraphBroadcast def:<server.flag[Telegraph_<[location]>_Channel]>|<[message]>
        - flag server Telegraph_<[location]>:<&gt>
        - stop
ChannelScript:
    type: task
    script:
        - if <server.flag[Telegraph_<[location]>_Channel]> == 10:
            - flag server Telegraph_<[location]>_Channel:1
        - else:
            - flag server Telegraph_<[location]>_Channel:++
        - narrate "<&a>Channel Changed! Current Channel:<server.flag[Telegraph_<[location]>_Channel]>"
        - flag server Telegraph_<[location]>:<&gt>
TelegraphBroadcast:
    type: task
    definitions: channel|message
    script:
        # Get the list of all active Telegraph Stations
        - narrate "<&a>*You fiddle with the dials and transmit your signal out to the world.*"
        - foreach <server.flag[Telegraph_List]> as:station:
            - if <server.flag[Telegraph_<[station]>_Channel]> == <[channel]>:
                - define locale:l@<[station]>
                - random:
                    - narrate "<&a>*The Telegraph Line whirrs to life.*" targets:<[locale].find.players.within[<5.5>]>
                    - narrate "<&a>*--Whirr--*" targets:<[locale].find.players.within[<5.5>]>
                    - narrate "<&a>*--Bzzt!--*" targets:<[locale].find.players.within[<5.5>]>
                    - narrate "<&a>*The box begins to hum: a transmission?*" targets:<[locale].find.players.within[<5.5>]>
                    - narrate "<&a>*The red light on the Telegraph box begins to blink!*" targets:<[locale].find.players.within[<5.5>]>
            - narrate <[message]> targets:<[locale].find.players.within[<5.5>]>
  # Telegraph_Location
  # Telegraph_Location_Channel
  # Telegraph_List: location|location|location
TelegraphSetup:
    type: task
    script:
        - define location:<context.location.simple>
        - flag server Telegraph_<[location]>:<&gt>
        - flag server Telegraph_<[location]>_Channel:1
        - flag server Telegraph_List:->:<[location]>
        - narrate "<&a>*The Telegraph Line whirrs to life.*" target:<[location].find.players.within[<5.5>]>
        - narrate "<&a>Usage: Left Click to send a dot, Right Click to send a dash. Shift-Right Click to add a space, Shift-Left Click to Change Current Channel."
        - narrate "<&a>To broadcast, click the Junction with your Transmitter!"

# =================================================================================
# ====================================Items========================================
# =================================================================================

TelegraphTransmitter:
    type: item
    material: TRIPWIRE_HOOK
    display name: Telegraph Transmitter
Telegraph:
    type: item
    material: player_head[skull_skin=a1b7aae8-4303-4275-b760-214e64198582|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOGIwYTEzMGIzYjFiMjk3YWNkY2ZlMjM4MzZiNDY0MjQwMDdlMjQ3OTg1Yzc0MWFhNGEyMTRhMTBjOThlZDE2OSJ9fX0=]
    display name: Telegraph Junction
# =================================================================================
# ====================================World========================================
# =================================================================================
TelegraphWorld:
    type: world
    events:
        on player places Telegraph:
            - inject CustomItemPlaced
            - narrate "Telegraph Placed! Tune into a channel by punching the box!"
            - inject TelegraphSetup
TelegraphOnPlayerRightClicksPlayer_Head:
    type: task
    script:
        - if <[customItem].contains_text[Telegraph]>:
            - define click:right
            - inject TelegraphHandler
TelegraphOnPlayerBreaksBlock:
    type: task
    script:
        - if <[itemDrop].contains_text[Telegraph]>:
            - flag server Telegraph_<context.location.simple>:!
TelegraphOnPlayerLeftClicksPlayer_Head:
    type: task
    script:
        - if <[customItem].contains_text[Telegraph]>:
            - define click:left
            - inject TelegraphHandler