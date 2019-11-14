# Character Name: Father Rogers
# Age: 36
# Gender: Male
# Outward appearance: priest clothing and basic civilian wear underneath. Black hair and blue eyes.
# Character Traits: Calm, kind to children, very insightful 
# Quirk (At least one): secretive 
# Equipment/Tools they carry: A bible and a knife he keeps hidden.
# Opinions on magic/technology: Considers magic taboo and a sin, doesn’t care too much for technology.
# Link to Minecraft Skin (optional, but preferred)

FatherRogersVoucher:
    type: item
    material: paper
    display name: FatherRogers
    lore:
    - Spawns a FatherRogers

FatherRogersTask:
    type: task
    script:
        - create player <proc[GetRandomName]> <player.location.cursor_on.add[0,1,0]> traits:Sentinel save:temp
        - adjust <entry[temp].created_npc> lookclose:TRUE
        - adjust <entry[temp].created_npc> set_assignment:FatherRogersAssignment
        - equip <entry[temp].created_npc> hand:diamond_sword
        - execute as_server "npc select <entry[temp].created_npc.id>"
        - execute as_server "sentinel guard <player.name>"

FatherRogersAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "assignment set"
    interact scripts:
    - 1 FatherRogersInteract

FatherRogersInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hello!"