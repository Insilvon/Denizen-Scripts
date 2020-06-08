Overseer:
    type: assignment
    events:
        on assignment:
            - narrate "Assignment set"
    interact scripts:
    - 1 OverseerInteract

OverseerInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hey|Hi|Greetings/
                    script:
                        - define character:<player.flag[CharaterSheet_CurrentCharacter]>
                        - define town:<player.flag[<[character]>_Town]||null>
                        - chat "Greetings!"
                        - chat "If you're coming to talk to me, that means you're ready to grow this town!"
                        - if <[town]> == null:
                            - chat "I'm shocked! You haven't joined the Crimson Sun?"
                            - wait 4s
                            - chat "You should definitely do so. It has great potential!"
                            - wait 4s
                            - chat "Go search out the owner of this town. Maybe if you're nice, they'll invite you."
                            - stop
                        - if <server.flag[<[Town]>]> == <[character]>:
                            - chat "What's going on big money?""
                            - chat "Are you ready to help take this town to the next level?"
                            - narrate "<&click[Yes.]><&a>[Yes]<&f><&end_click> | <&click[No.]><&c>[No]<&f><&end_click>"
                2:
                    trigger: /Regex:Yes/
                    script:
                        - chat "Great. What would you like to learn about?"
                        - wait 1s
                        - narrate "<&click[Expanding.]><&a>[Expanding]<&f><&end_click> | <&click[Managers.]><&a>[Managers]<&f><&end_click> | <&click[Workers.]><&a>[Workers]<&f><&end_click> | <&click[Income1.]><&a>[Income1]<&f><&end_click> | <&click[Income2.]><&a>[Income2]<&f><&end_click>"

                3:
                    trigger: /Regex:No/
                    script:
                        - chat "Alright then. Take it easy!"
                        - narrate "*The Overseer would turn his attention elsewhere.*"
                4:
                    trigger: /Regex:Expanding/.
                    script:
                        - inject OverseerTutorialExpansion
                5:
                    trigger: /Regex:Managers/.
                    script:
                        - inject OverseerTutorialManagers
                6:
                    trigger: /Regex:Workers/.
                    script:
                        - inject OverseerTutorialWorkers
                7:
                    trigger: /Regex:Income1/.
                    script:
                        - inject OverseerTutorialIncome1
                8:
                    trigger: /Regex:Income2/.
                    script:
                        - inject OverseerTutorialIncome2

OverseerTutorialExpansion:
    type: task
    script:
        - wait 4s
        - chat "Expanding your town is the greatest thing you can do, apart from reaping income of course."
        - wait 4s
        - chat "When you expand your town, it protects an entire chunk from enemies. However, it costs lots of emeralds to do so!"
        - wait 4s
        - chat "It's important to know that you need space in your town for your Managers and Workers though. If there's no space, how will they do their jobs?"
        - wait 6s
        - chat "Besides protection, hiring managers and workers, you can also bring other people to your town. ((Players and NPCs alike.)) As you complete jobs for others, they may offer to come stay with you. Some may be merchants, bakers, who knows!"
        - wait 6s
        - chat "No matter what, it's important to be secure. Happy expanding!"
        - narrate "<&click[Expanding.]><&a>[Expanding]<&f><&end_click> | <&click[Managers.]><&a>[Managers]<&f><&end_click> | <&click[Workers.]><&a>[Workers]<&f><&end_click> | <&click[Income1.]><&a>[Income1]<&f><&end_click> | <&click[Income2.]><&a>[Income2]<&f><&end_click>"

OverseerTutorialManagers:
    type: task
    script:
        - chat "So you want to learn about Managers, huh?"
        - wait 2s
        - chat "You can hire managers and bring them to your town. Managers are people who are experts in their field - they'll make sure you get the income of resources you need."
        - wait 3s
        - chat "You can assign workers to managers, when you get them."
        - define character:<player.flag[CharaterSheet_CurrentCharacter]>
        - define town:<player.flag[<[character]>_Town]>
        - define townOwner:<server.flag[<[town]>]>
        - if <[townOwner]> == <[character]> && !<player.has_flag[<[Character]>_ManagerTutorial]>:
            - chat "To get you started, take this Farmer Manager. Find a good place for them somewhere around your town and get them set up."
            - wait 4s
            - chat "Come back to me when you're done!"
            - flag player <[character]>_ManagerTutorial
            - give FarmerManagerVoucher
        - narrate "<&click[Expanding.]><&a>[Expanding]<&f><&end_click> | <&click[Managers.]><&a>[Managers]<&f><&end_click> | <&click[Workers.]><&a>[Workers]<&f><&end_click> | <&click[Income1.]><&a>[Income1]<&f><&end_click> | <&click[Income2.]><&a>[Income2]<&f><&end_click>"


OverseerTutorialWorkers:
    type: task
    script:
        - chat "Managers are nothing without people to manage. You can hire workers as well - that's who gets the real work done. When you have a voucher for a worker, take them to their corresponding manager."
        - wait 4s
        - chat "For example - a Farm worker can only be assigned to a Farm manager, a Mine worker to a Mine manager, and so on."
        - wait 2s
        - narrate ">> If you have a worker voucher, approach the related manager and right click. This will assign the worker to that manager."
        - wait 4s
        - if <[townOwner]> == <[character]> && !<player.has_flag[<[Character]>_WorkerTutorial]>:
            - chat "To get you started, take this Farmer Worker. Find a good place for them somewhere around your town and get them set up."
            - wait 4s
            - chat "Come back to me when you're done!
            - flag player <[character]>_WorkerTutorial
            - give FarmerWorkerVoucher
        - narrate "<&click[Expanding.]><&a>[Expanding]<&f><&end_click> | <&click[Managers.]><&a>[Managers]<&f><&end_click> | <&click[Workers.]><&a>[Workers]<&f><&end_click> | <&click[Income1.]><&a>[Income1]<&f><&end_click> | <&click[Income2.]><&a>[Income2]<&f><&end_click>"

OverseerTutorialIncome:
    type: task
    script:
        - chat "Income! That's the whole reason you have a town in the first place, right?"
        - wait 4s
        - chat "Assumming that you're taking my advice in order and the owner of the town has assigned the Farmer Manager and Worker, then you should be ready!"
        - wait 4s
        - chat "Every worker and manager has two statistics you can follow - their resources and their bonuses."
        - wait 4s
        - chat "When you hire a new set of hands, they automatically add 5 to your stat in their type. For example, if you hire one Farm Manager, you now have 5 Farmer resources. If you hire a farmworker, you have 10, so on and so forth."
        - wait 5s
        - chat "However! You can choose to spend some emeralds and upgrade various workers too. If you decide to do that, they generate bonus resources. For example, a Manager and a level one Worker generate 10 resources and no bonus. A Manager and a level two Worker generate 10 resources and 5 bonus, meaning 15 overall."
        - wait 6s
        - chat "Since managers can only hold so many workers, it's important to upgrade some from time to time to maximize your yield! Every 12 hours, every town collects their yield. Depending on the max number of resources and bonus stats, your"
        - chat "workers will send items, money, and goods to your town bank! Isn't that nifty?"
        - wait 8s
        - chat "You can check out what's in your town bank at anytime by running /t inventory."
        - narrate "<&click[Expanding.]><&a>[Expanding]<&f><&end_click> | <&click[Managers.]><&a>[Managers]<&f><&end_click> | <&click[Workers.]><&a>[Workers]<&f><&end_click> | <&click[Income1.]><&a>[Income1]<&f><&end_click> | <&click[Income2.]><&a>[Income2]<&f><&end_click>"

OverseerTutorialIncome2:
    type: task
    script:
        - chat "So you're ready to start reaping some resources, yeah? Great!"
        - wait 4s
        - chat "There's two types of Workers - Gatherers and Produces. Gatherers are workers who collect resources from the wilderness. These are your farmers, your woodcutters, and your miners. The producers make stuff with those resources: your blacksmiths, alchemists, builders, and so on."
        - wait 8s
        - chat "Gatherers need to have a place to go to collect their materials, especially if you want them to send supply to the town bank. You must assign them a <&c>Node<&f>. As you explore, you'll discover Nodes around the world. Nodes come in three types - Forest, Farmland, and Mines."
        - wait 8s
        - chat "After you have discovered a node, you can talk to the Manager of that node type and assign them to take all their workers to that node. As long as you have a Manager/Worker team at a node, you'll generate resources."
        - wait 8s
        - chat "If you haven't already, assign your Farm Manager to your local farm node!"
        - narrate "<&click[Expanding.]><&a>[Expanding]<&f><&end_click> | <&click[Managers.]><&a>[Managers]<&f><&end_click> | <&click[Workers.]><&a>[Workers]<&f><&end_click> | <&click[Income1.]><&a>[Income1]<&f><&end_click> | <&click[Income2.]><&a>[Income2]<&f><&end_click>"
