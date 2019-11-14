# Character Name: Durilgalyn
# Age: 31
# Gender: Female
# Outward appearance: Red head, dark green eyes, wears a dress with armor on top.
# Character Traits: Crabby, likes to get drunk (alot) knows how to fight well.
# Quirk (At least one): Beautiful 
# Equipment/Tools they carry: An axe and hammer
# Opinions on magic/technology: Doesn't care for either
# Link to Minecraft Skin (optional, but preferred)
DurilgalynVoucher:
    type: item
    material: paper
    display name: Durilgalyn
    lore:
    - Spawns a Durilgalyn

DurilgalynTask:
    type: task
    script:
        - create player <proc[GetRandomName]> <player.location.cursor_on.add[0,1,0]> traits:Sentinel save:temp
        - adjust <entry[temp].created_npc> lookclose:TRUE
        - adjust <entry[temp].created_npc> set_assignment:DurilgalynAssignment
        - equip <entry[temp].created_npc> hand:diamond_sword
        - execute as_server "npc select <entry[temp].created_npc.id>"
        - execute as_server "sentinel guard <player.name>"

DurilgalynAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "assignment set"
    interact scripts:
    - 1 DurilgalynInteract

DurilgalynInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hello!"