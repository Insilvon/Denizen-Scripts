#= Miner
MinerManagerAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on click:
            - define npcType:Miner
            - inject ManagerClickEvent
    interact scripts:
    - 1 MinerManagerInteract

MinerManagerInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hi|Hey/.
                    script:
                        - chat "Greetings there. *They wipe off their dirty hands.*"
                        - wait 1.5s
                        - chat "I'm your Mining manager, if not one of them."
                        - wait 1.5s
                        - chat "What can I do for you, <player.flag[CharaterSheet_CurrentCharacter]||<player.display_name>>?"
                        - narrate "((Right click to view Workers)) | <&hover[Click to send them to a node.]><&click[I'd like to send you to a Node.]><&a>[Ask About Nodes]<&f><&end_click><&end_hover> |  <&hover[Click to send them home.]><&click[I'd like you to come Home.]><&c>[Ask them to go home.]<&f><&end_click><&end_hover>"
                2:
                    trigger: I'd like to send you to a /Regex:Node/.
                    script:
                        - chat "Where would you like me to go?"
                        - wait 2s
                        - inventory open d:DiscoveredNodeInventory
                3:
                    trigger: I'd like you to come /Regex:Home/.
                    script:
                        - chat "Sure thing - see you there."
                        - inject RemoveNodeManager
MinerManagerVoucher:
    type: item
    material: paper
    display name: Miner Manager Voucher
    lore:
        - Right click to spawn
        - a Miner manager 
        - for your town.