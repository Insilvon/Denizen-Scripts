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
