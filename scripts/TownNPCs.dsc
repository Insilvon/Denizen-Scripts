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
TownNPCController:
    type: world
    events:
        on player places TownFarmerVoucher:
            - if <player.has_flag[CurrentCharacter]>:
                - narrate "You do not have an active character. Please fix this first!"
                - stop
            # create the npc
            - define id:<player.flag[CurrentCharacter]>
            - yaml load:CharacterSheets/<player.uuid>/<[id]>.yml id:<[id]>
            - define townID: <yaml[<[id]>].read[Town.Name]>
            - yaml load:Towns/<[townID]>.yml id:<[townID]>
            - yaml id:<[id]> set NPC.Farmers:++
            - 