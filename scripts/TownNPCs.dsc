FarmerNPCAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment Set!"
    interact scripts:
        - 1 FarmerNPCInteract
FarmerNPCInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "I am a farmer. I want to help you. Want me to help?"
                        - narrate "YES|NO"
                2:
                    trigger: /Regex:Yes/
                    script:
                        - chat "Excellent, I am now yours."
                        - chat "Take this voucher. Place it where you want me to work."
                        - give TownFarmerVoucher
TownFarmerVoucher:
    type: item
    material: paper
    display name: Town Farmer Voucher
TownNPCController:
    type: world
    events:
        on player right clicks with TownFarmerVoucher:
            - if <player.has_flag[CurrentCharacter]>:
                - narrate "You do not have an active character. Please fix this first!"
                - stop
            # inc town file
            - define id:<player.flag[CurrentCharacter]>
            - yaml load:CharacterSheets/<player.uuid>/<[id]>.yml id:<[id]>
            - define townID: <yaml[<[id]>].read[Town.Name]>
            - yaml load:Towns/<[townID]>.yml id:<[townID]>
            - yaml id:<[townID]> set NPC.Farmers:++
            - yaml "savefile:/Towns/<[id]>.yml" id:<[townID]>
            - yaml unload id:<[townID]>
            - yaml unload id:<[id]>
            # create DNPC
            - define name:<proc[GetRandomName]>
            - create player <[name]> <player.location> save:temp
            - adjust <entry[temp].created_npc> lookclose:TRUE
            - adjust <entry[temp].created_npc> set_sneaking:TRUE
            - adjust <entry[temp].created_npc> vulnerable:TRUE
            #- adjust <entry[temp].created_npc> skin:HeroicKnight -p
            - adjust <entry[temp].created_npc> set_assignment:PlacedTownFarmerAssignment

PlacedTownFarmerAssignment:
    type: assignment
    interact scripts:
        - 1 PlacedTownFarmerInteract
PlacedTownFarmerInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hello!"