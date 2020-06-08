MiasmyynGunner:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
        on click:
            - define inv:MiasmyynGunnerInventory
            - inject NewMerchantFlagSetup
    interact scripts:
    - 1 MiasmyynGunnerI
MiasmyynGunnerI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - wait 1s
                        - chat "Come for some firepower?"
                        - wait 1s
                        - define inv:MiasmyynGunnerInventory
                        - inject NewMerchantFlagSetup

MiasmyynScavenger:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
        on click:
            - define inv:MiasmyynScavengerInventory
            - inject NewMerchantFlagSetup
    interact scripts:
    - 1 MiasmyynScavI
MiasmyynScavI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - define inv:MiasmyynScavengerInventory
                        - inject NewMerchantFlagSetup


MiasmyynArmorer:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on exit proximity:
            - inject SaveNPCStep
            - inject RandomWalk
    interact scripts:
    - 1 MiasmyynAI
MiasmyynAI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hi|Hey|Greetings/.
                    script:
                        - chat "I'm waiting on a supply... but when it's ready... I'll sell ya adventuring packs..."

MiasmyynCannoneer:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on exit proximity:
            - inject SaveNPCStep
            - inject RandomWalk
    interact scripts:
    - 1 MiasmyynCI
MiasmyynCI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hi|Hey|Greetings/.
                    script:
                        - chat "Oi, come back later. I'm still gathering my stock. Do come tho' - I'll be selling exclusive ammunition!"

MiasmyynSkull:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
    interact scripts:
    - 1 MiasmyynSkullI

MiasmyynSkullI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hail. You come to see the Skull too?"
                        - narrate "<&click[What's with the skull?]><&a>[Ask about the Skull]<&f><&end_click> | <&click[Goodbye.]><&c>[Leave]<&f><&end_click>"
                2:
                    trigger: What's with the /skull/?
                    script:
                        - chat "It's old, for sure. Far back, way back, many of the pirates that came, they created it. Meant to scare off the ghosts, of, well, those who lived here."
                        - wait 5s
                        - chat "Now, well, I suppose, when a new Captain declares their blood, they go through the ceremony, right?"
                        - wait 3s
                        - chat "They're taken, well, into this large area, where they show off their prize to the Order. If, IF, the Order accepts it, then the Captain will emerge from those jaws."
                        - wait 5s
                        - chat "I think it's cool!"
                        - narrate "<&click[Goodbye]><&c>[Leave]<&f><&end_click>"
                3:
                    trigger: /Regex:Goodbye|Bye/.
                    script:
                        - chat "See you, in the future. "


MiasmyynFisherman:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
            - animate <npc> animation:ARM_SWING
        on click:
            - define inv:MiasmyynFishermanInventory
            - inject NewMerchantFlagSetup
    interact scripts:
    - 1 MiasmyynFishermanI

MiasmyynFishermanI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "I'm busy, unless you've come here to sell some fish."
                        - narrate "<&click[What have you got to trade?]><&a>[Trade]<&f><&end_click> | <&click[Tell me about yourself.]><&c>[Ask about them]<&f><&end_click>"
                2:
                    trigger: What have you got to /trade/?
                    script:
                        - define inv:MiasmyynFishermanInventory
                        - inject NewMerchantFlagSetup
                3:
                    trigger: Tell me about /yourself/.
                    script:
                        - chat "I've been working for the Order here a couple years now, a proud member of the Catjaw Blood."
                        - wait 1s
                        - chat "I really do mind my peace - if you could please let me be or buy some fish, I'd appreciate it."
                        - narrate "<&click[What have you got to trade?]>[Trade]<&end_click> | <&click[Tell me about yourself.]>[Ask about them]<&end_click>"

MiasmyynHerbalist:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
        on click:
            - define inv:MiasmyynHerbalistInventory
            - inject NewMerchantFlagSetup
    interact scripts:
    - 1 MiasmyynHerbalistInteract
MiasmyynHerbalistInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - define inv:MiasmyynHerbalistInventory
                        - inject NewMerchantFlagSetup

MiasmyynSmithy:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 MiasmyynSmithyInteract
MiasmyynSmithyInteract:
    type: interact
    steps:
        1:
            proximity trigger:
                exit:
                    script:
                        - inject RandomWalk
                        - inject ClearRepairFlag
                        - zap 1
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Greetings there. I'm <npc.name><&f>, at your service."
                        - wait 1s
                        - chat "How can I assist you today?"
                        - wait 1s
                        - narrate "<&hover[Click Me!]><&click[Can you repair this?]>Ask to repair your held item.<&end_click><&end_hover>"
                2:
                    trigger: Can you /repair/ this?
                    script:
                        - define item:<player.item_in_hand>
                        - if <[item].material.name> != air && <[item].durability> != 0:
                            - chat "So let's see, you've got this <[item].material.name> here..."
                            - wait 1s
                            - if <[item].script.name> == SkyborneParafoil:
                                - chat "A parafoil for sure. I believe I can repair this for some goods."
                                - wait 1s
                                - chat "I'll need 16 diamonds, 8 iron ingots, and 4 emeralds for now."
                                - wait 1s
                                - flag player <npc>_RepairItem:<[item]>
                                - flag player <npc>_RepairRequirements:i@Diamond
                                - flag player <npc>_RepairRequirements:->:i@Iron_Ingot
                                - flag player <npc>_RepairRequirements:->:i@Emerald
                                - flag player <npc>_RepairQuantities:16
                                - flag player <npc>_RepairQuantities:->:8
                                - flag player <npc>_RepairQuantities:->:4
                                - chat "Does this sound fair to you?"
                                - wait 1s
                                - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&a>Agree and trade the items.<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[No thanks.]><&c>Decline and leave.<&end_click><&end_hover>"
                                - zap 3
                            - else:
                                - if <[item].material.name.contains[iron]>:
                                    - chat "I can repair this for two iron ingots and an emerald."
                                    - wait 1s
                                    - chat "Does this sound good to you?"
                                    - flag player <npc>_RepairItem:<[item]>
                                    - flag player <npc>_RepairRequirements:i@iron_ingot
                                    - flag player <npc>_RepairRequirements:->:i@Emerald
                                    - flag player <npc>_RepairQuantities:2
                                    - flag player <npc>_RepairQuantities:->:1
                                    - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&a>Agree and trade the items.<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[No thanks.]><&c>Decline and leave.<&end_click><&end_hover>"
                                    - zap 3
                                    - stop
                                - if <[item].material.name.contains[bow]>:
                                    - chat "I can repair this for 16 dark oak logs and an emerald."
                                    - wait 1s
                                    - chat "Does this sound good to you?"
                                    - flag player <npc>_RepairItem:<[item]>
                                    - flag player <npc>_RepairRequirements:i@dark_oak_log
                                    - flag player <npc>_RepairRequirements:->:i@Emerald
                                    - flag player <npc>_RepairQuantities:16
                                    - flag player <npc>_RepairQuantities:->:1
                                    - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&a>Agree and trade the items.<&f><&end_click><&end_hover> | <&hover[Click Me!]><&click[No thanks.]><&c>Decline and leave.<&end_click><&end_hover>"
                                    - zap 3
                                    - stop
                                - chat "I'm not sure I can repair this yet. Come back later."
                                - chat "((If you think I should repair this, tell Sil!))"

MiasmyynTavern:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
        on click:
            - define inv:MiasmyynTavernInventory
            - inject NewMerchantFlagSetup
    interact scripts:
    - 1 MiasmyynTavernInteract
MiasmyynTavernInteract:
    type: interact
    steps:
        1:
            trigger: /Regex:Hello|Hey|Hi/.
            script:
                - chat "Hail. What can I do you for?"
                - narrate "<&click[What have you got to trade?]>[Trade]<&end_click> | <&click[Tell me about yourself.]>[Ask about them]<&end_click>"
        2:
            trigger: What have you got to /trade/?
            script:
                - chat "Take a look."
                - define inv:MiasmyynTavernInventory
                - inject NewMerchantFlagSetup
        3:
            trigger: Tell me about /yourself/.
            script:
                - chat "I've been here for a good while now. Used to run around with the old Tavern owner from up top."
                - wait 2s
                - chat "Since they died, been down here, selling some of the inventory."
                - wait 2s
                - chat "Not a whole lot left. Every so often we get more supplies in. Nothing else."
MiasmyynRandom:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on enter proximity:
            - random:
                - chat "<&8>*They make a low grumble.*"
                - chat "<&8>I heard there's a purification coming. Not sure when that'll be."
                - chat "<&8>All these new faces recently... must be looking for a fight."
            

MiasmyynLoreKeeper:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 MiasmyynLoreKeeperInteract
MiasmyynLoreKeeperInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hi|Hey/
                    script:
                        - chat "Good-day... how can I help you?"
                        - narrate "<&click[Tell me about Bloods.]>[Ask about Bloods]<&end_click> | <&click[Tell me about the Order]>[Ask about the Order]<&end_click> | <&click[Tell me about the Cove.]>[Ask about the Cove]<&end_click>"
                2:
                    trigger: Tell me about /Regex:Blood/s.
                    script:
                        - chat "Blood is a personl term we use to describe a Captain and their Crew. We don't like it when Captains get all the glory, because they rarely do anything except plan."
                        - wait 2s
                        - chat "Blood is used to say that a ship is fueled by a family, one bloodline."
                        - wait 2s
                        - chat "Now not every ship and crew count as a blood - you have to be inducted into the Order in order to declare a Bloodline. That's how we keep the rabble out of our cause."
                        - narrate "<&click[Tell me about Bloods.]>[Ask about Bloods]<&end_click> | <&click[Tell me about the Order]>[Ask about the Order]<&end_click> | <&click[Tell me about the Cove.]>[Ask about the Cove]<&end_click>"

                3:
                    trigger: Tell me about the /Regex:Order/.
                    script:
                        - chat "Back when our group started developing, a few renown pirates were said to come together and form The Order of Miasmyyn. Legend says that Captain Miasmyyn lead it himself for a time, but that's myth."
                        - wait 2s
                        - chat "You never see the Order, but you must prove yourself to them to become a pirate. Captains must show a great feat before being inducted, where crew must be initated by a Captain."
                        - wait 2s
                        - chat "When a Blood suffers mutiny, rioting, and in-fighting, the Order sometimes issues a note for Purification. When that happens... well... let's just say the Corrupted Blood is cleaned up quickly."
                        - wait 2s
                        - chat "They say all good Captains pray to the Order before their heists. Get their blessing, you know."
                        - narrate "<&click[Tell me about Bloods.]>[Ask about Bloods]<&end_click> | <&click[Tell me about the Order]>[Ask about the Order]<&end_click> | <&click[Tell me about the Cove.]>[Ask about the Cove]<&end_click>"

                4:
                    trigger: Tell me about the /Regex:Cove/.
                    script:
                        - chat "The cove here was initially some sort of ruin, from what I've learned. Those towers in the front still show that architecture."
                        - wait 2s
                        - chat "Some of the pirates landed here to use it as a hideout from the factions at the time. Over time it became the place to go for black market dealings and storing one's rewards."
                        - wait 2s
                        - chat "Then, when joining our cause became something a bit more presitgious, the pirates gave the cove a bit of an overhaul. Now, because of all the firepower littered about, Stratum or Sotiria won't dare attack."
                        - narrate "<&click[Tell me about Bloods.]>[Ask about Bloods]<&end_click> | <&click[Tell me about the Order]>[Ask about the Order]<&end_click> | <&click[Tell me about the Cove.]>[Ask about the Cove]<&end_click>"
                5:
                    trigger: Tell me about Captain /Regex:Miasmyyn/.
                    script:
                        - chat "Ah, our namesake."
                        - wait 1s
                        - chat "Captain Miasmyyn is said to be the first pirate to found the Order. They say that he abandoned his colony back when the colonies of the sky were first starting to form - stealing one of the few airships at the time."
                        - wait 2s
                        - chat "With that ship, he went around looting and pillaging from bastardized settlements until he made a good lif for himself."
                        - wait 2s
                        - chat "Over time, the colonies sent men and women after him, but he never faltered. He was unbeatable, ruling the sky until he began to get old."
                        - wait 2s
                        - chat "They say that he buried half of his [treasure] somewhere out there in the world, then left the rest to his crew. That crew split apart, eventually going to found Miasmyyn Cove."
                        - narrate "<&click[Tell me about Bloods.]>[Ask about Bloods]<&end_click> | <&click[Tell me about the Order]>[Ask about the Order]<&end_click> | <&click[Tell me about the Cove.]>[Ask about the Cove]<&end_click>"
                6:
                    trigger: Is there any information on his /Regex:Treasure|treasure/?
                    script:
                        - chat "You might as well stop yourself now - nobody's ever found it. There's not even a hint as to where he put it. They say he didn't even bring his crew with him when he went."
                        - wait 2s
                        - chat "Countless Bloods have been searching for it for years now - scavenging every known Pirate outpost. Nothing. Absolutely nothing."
                        - wait 2s
                        - chat "We can only dream of what prized goods he must have put there - ancient relics for sure. They say he even left his sword."
                        - wait 2s
                        - chat "If you manage to find a lead... you'll be the first."
                        - narrate "<&click[Tell me about Bloods.]>[Ask about Bloods]<&end_click> | <&click[Tell me about the Order]>[Ask about the Order]<&end_click> | <&click[Tell me about the Cove.]>[Ask about the Cove]<&end_click>"
                5:
                    trigger: /Regex:Goodbye/.
                    script:
                        - chat "See you around, Stranger."