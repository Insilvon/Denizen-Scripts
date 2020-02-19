# Character Name: Chandler VII
# Age: 33
# Gender: Male
# Outward appearance: Wears full body armor with different medals worn on the torso, wears the family crown (which has seen better days) semi long brown hair, hazel nut eyes, 5'8.
# Character Traits: Energetic, knows how to get a crowd roaring, likes to fight and show off to impress ladies.
# Quirk (At least one): Persuasive 
# Equipment/Tools they carry: Sword and Shield, also carries an double sided axe.
# Opinions on magic/technology: Doesn't care for either.
# Link to Minecraft Skin (optional, but preferred)

ChandlerVIIVoucher:
    type: item
    material: paper
    display name: ChandlerVII
    lore:
    - Spawns a ChandlerVII

ChandlerVIITask:
    type: task
    script:
        - create player <proc[GetRandomName]> <player.location.cursor_on.add[0,1,0]> traits:Sentinel save:temp
        - adjust <entry[temp].created_npc> lookclose:TRUE
        - adjust <entry[temp].created_npc> set_assignment:ChandlerVIIAssignment
        - equip <entry[temp].created_npc> hand:diamond_sword
        - execute as_server "npc select <entry[temp].created_npc.id>"
        - execute as_server "sentinel guard <player.name>"

ChandlerVIIAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "assignment set"
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 ChandlerVIIInteract

ChandlerVIIInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hello!"