# Character Name: Shelby Croc
# Age: 14
# Gender: Male
# Outward appearance: Basic lumber jack clothing, blonde hair, green eyes.
# Character Traits: obedient, cheery, good listener, troublesome.
# Quirk (At least one): Curious and 
# Equipment/Tools they carry: A backpack and wood cutters axe.
# Opinions on magic/technology: Interested in technology more than magic.
# Link to Minecraft Skin (optional, but preferred)
ShelbyCrocVoucher:
    type: item
    material: paper
    display name: ShelbyCroc
    lore:
    - Spawns a ShelbyCroc

ShelbyCrocTask:
    type: task
    script:
        - create player <proc[GetRandomName]> <player.location.cursor_on.add[0,1,0]> traits:Sentinel save:temp
        - adjust <entry[temp].created_npc> lookclose:TRUE
        - adjust <entry[temp].created_npc> set_assignment:ShelbyCrocAssignment
        - equip <entry[temp].created_npc> hand:diamond_sword
        - execute as_server "npc select <entry[temp].created_npc.id>"
        - execute as_server "sentinel guard <player.name>"

ShelbyCrocAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "assignment set"
    interact scripts:
    - 1 ShelbyCrocInteract

ShelbyCrocInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hello!"