
Lute:
    type: item
    material: wooden_shovel
    display name: <&c>Fancy Lute
    lore:
        - A weathered, but ornate lute.
MusicController:
    type: world
    debug: false
    events:
        on player right clicks with Lute:
            - determine cancelled passively
            - random:
                - playsound <player.location.find.players.within[10]> sound:block_note_block_banjo pitch:1
                - playsound <player.location.find.players.within[10]> sound:block_note_block_banjo pitch:1.2
                - playsound <player.location.find.players.within[10]> sound:block_note_block_banjo pitch:1.3
                - playsound <player.location.find.players.within[10]> sound:block_note_block_banjo pitch:1.4
                - playsound <player.location.find.players.within[10]> sound:block_note_block_banjo pitch:1.5
                - playsound <player.location.find.players.within[10]> sound:block_note_block_banjo pitch:1.6
                - playsound <player.location.find.players.within[10]> sound:block_note_block_banjo pitch:1.7
                - playsound <player.location.find.players.within[10]> sound:block_note_block_banjo pitch:1.8
                - playsound <player.location.find.players.within[10]> sound:block_note_block_banjo pitch:1.9
                - playsound <player.location.find.players.within[10]> sound:block_note_block_banjo pitch:2
        on player left clicks with Lute:
            - determine cancelled passively
            - random:
                - playsound <player.location.find.players.within[10]> sound:block_note_block_banjo pitch:0
                - playsound <player.location.find.players.within[10]> sound:block_note_block_banjo pitch:0.2
                - playsound <player.location.find.players.within[10]> sound:block_note_block_banjo pitch:0.3
                - playsound <player.location.find.players.within[10]> sound:block_note_block_banjo pitch:0.4
                - playsound <player.location.find.players.within[10]> sound:block_note_block_banjo pitch:0.5
                - playsound <player.location.find.players.within[10]> sound:block_note_block_banjo pitch:0.6
                - playsound <player.location.find.players.within[10]> sound:block_note_block_banjo pitch:0.7
                - playsound <player.location.find.players.within[10]> sound:block_note_block_banjo pitch:0.8
                - playsound <player.location.find.players.within[10]> sound:block_note_block_banjo pitch:0.9
                - playsound <player.location.find.players.within[10]> sound:block_note_block_banjo pitch:1