# NPC Vouchers
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.1
# Proof of Concept to show "hirable" npcs to bring to your town

NPCVoucher:
    type: item
    material: emerald
    display name: Test Voucher

NPCVoucherController:
    type: world
    events:
      on player right clicks with NPCVoucher:
        - create player "TestDummy" <player.location> save:temp
        - adjust <entry[temp].created_npc> lookclose:TRUE
        - adjust <entry[temp].created_npc> set_sneaking:TRUE
        - adjust <entry[temp].created_npc> vulnerable:TRUE
        #- adjust <entry[temp].created_npc> skin:HeroicKnight -p
        - adjust <entry[temp].created_npc> set_assignment:NPCVoucherAssignment
      on player right clicks with RobotmanVoucher:
        - create player "Robotman" <player.location> save:temp
        - adjust <entry[temp].created_npc> lookclose:TRUE
        - adjust <entry[temp].created_npc> set_sneaking:TRUE
        - adjust <entry[temp].created_npc> vulnerable:TRUE
        #- adjust <entry[temp].created_npc> skin:HeroicKnight -p
        - adjust <entry[temp].created_npc> set_assignment:RobotmanTownAssignment
        - define url:<proc[GetTownNPCSkin].context[Automata]>
        - define counter:0
        - define success:false
        - while <[success].matches[false]> && <[counter].as_int> <= 10:
            - define counter:<[counter].add_int[1]>
            - define url:<proc[GetTownNPCSkin].context[Automata]>
            - inject SetNPCURLSkin

NPCVoucherAssignment:
    type: assignment
    actions:
      on assignment:
        - narrate "Assignment Set!"
    interact scripts:
      - 1 NPCVoucherInteract

NPCVoucherInteract:
    type: interact
    steps:
      1:
        chat trigger:
          1:
            trigger: /Hello/
            script:
              - chat "Hello"
          2:
            trigger: /Goodbye/
            script:
              - chat "Goodbye"

TownFarmerVoucher:
    type: item
    material: paper
    display name: Town Farmer Voucher
TownBlacksmithVoucher:
    type: item
    material: paper
    display name: Town Blacksmith Voucher
TownWoodcutterVoucher:
    type: item
    material: paper
    display name: Town Woodcutter Voucher
TownAlchemistVoucher:
    type: item
    material: paper
    display name: Town Alchemist Voucher
TownTrainerVoucher:
    type: item
    material: paper
    display name: Town Trainer Voucher
TownMinerVoucher:
    type: item
    material: paper
    display name: Town Miner Voucher
TownInfantryVoucher:
    type: item
    material: paper
    display name: Town Infantry Voucher

RobotmanVoucher:
    type: item
    material: paper
    display name: Robotman Voucher