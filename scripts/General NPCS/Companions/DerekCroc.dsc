# Character Name: Derek Croc
# Age: 35
# Gender: Male
# Outward appearance: Lumberjack outfit, breast plate, knees, and elbow armor, light brown hair and green eyes.
# Character Traits: Strict, overprotective, cautious, knows how to fight.
# Quirk (At least one): ???
# Equipment/Tools they carry: backpack, wood cutters axe, Bowie knife.
# Opinions on magic/technology: Okay with technology, big no for magic.
# Link to Minecraft Skin (optional, but preferred)

DerekCrocVoucher:
    type: item
    material: paper
    display name: DerekCroc
    lore:
    - Spawns a DerekCroc

DerekCrocTask:
    type: task
    script:
        - create player <proc[GetRandomName]> <player.location.cursor_on.add[0,1,0]> traits:Sentinel save:temp
        - adjust <entry[temp].created_npc> lookclose:TRUE
        - adjust <entry[temp].created_npc> set_assignment:DerekCrocAssignment
        - equip <entry[temp].created_npc> hand:diamond_sword
        - execute as_server "npc select <entry[temp].created_npc.id>"
        - execute as_server "sentinel guard <player.name>"

DerekCrocAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "assignment set"
    interact scripts:
    - 1 DerekCrocInteract

DerekCrocInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hello!"