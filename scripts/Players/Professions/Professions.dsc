#===========================================#
#===============[ Engineer ]================#
#===========================================#
# Class dedicated to the construction of complex mechanisms,
# airship parts, and other tinkering-based-goods

#===========================================#
#===============[ Pilot ]===================#
#===========================================#
# Class dedicated to the controlling, flying, and maintaining of
# airships. Capable of constructing their own as well. (Maybe)

#===========================================#
#===============[ Weaponsmith ]=============#
#===========================================#
# Class responsible for the creation of new weapons for use in battle.
# Works closely with the raw materials created by blacksmiths and the
# contraptions made from Engineers.
# Focus mainly on Guns, Cannons.

#===========================================#
#===============[ Pioneer ]=================#
#===========================================#
# Class blending Builders and Mayor concepts.
# Prioritize the creation of towns, maintaining of towns, and
# inspiring their followers to create custom TBCs.

#===========================================#
#=================[ Miner ]=================#
#===========================================#
# They mine. They can collect rare ores - basically the same as V1.
# They can create Miner's backpacks as well.

#===========================================#
#==============[ Blacksmith ]===============#
#===========================================#
# Class which has been nerfed significantly. Rather than creating
# full swords and weaponry, they create the components necessarily for assembly.
# Smiths can create the Pommels, Hilts, and Blades. When put together
# raw, they form a regular sword. Weaponsmiths can make the custom
# swords and whatnot.

#===========================================#
#===============[ Tradesman ]===============#
#===========================================#
# A merchant class with better NPC negotiation, but
# also access to the original tailor class to make clothes
# and trade exclusive items.

#===========================================#
#==============[ Apothecary ]===============#
#===========================================#
# The medical class. Craft cures and remedies from
# scientific sources (base), magical sources (Arcanist),
# or natural sources (Naturalist)

#===========================================#
#================[ Arcanist ]===============#
#===========================================#
# Alchemy. Good lord.

#===========================================#
#==============[ Naturalist ]===============#
#===========================================#
# Class responsible for researching nature, beasts,
# pets, flora and fauna of all types. As a result, they can
# grow plants others may never be able to grow. (Farming base).

#===========================================#
#=============[ System Info ]===============#
#===========================================#
ProfessionFormat:
    type: format
    format: "<&c>[Professions]<&co><&f> <text>"

# Profession Checks. Get the level of the profession, use that as a modifier. lvl 1 is +5, lvl2 is +10... lvl 10 is + 100
# Each level 1-30 grants +3 to every roll (/100)
# At lvl 30, you roll a bare minimum of 99
# At lvl 20, bare minimum of 60.
ProfessionRoll:
    type: command
    name: proll
    description: null
    usage: /proll
    permission: Aetheria.proll
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - define bonus:0
        - if <player.has_flag[<[character]>_Engineer]>:
            - define bonus:<player.flag[<[character]>_Engineer].mul_int[3]>
        - narrate "Your profession rolled a <util.random.int[1].to[100].add_int[<[bonus]>]>/100" format:ProfessionFormat

Profession:
    type: command
    name: profession
    description: null
    usage: /profession
    permission: Aetheria.profession
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - if !<player.has_flag[<[character]>_Profession]>:
            - inject ProfessionSetup
        - inventory clear d:in@<[character]>_ProfessionMenu
        - foreach li@Engineer|Blacksmith|Apothecary|Tradesman|Weaponsmith|Miner|Pilot|Arcanist|Naturalist|Pioneer as:item:
            - if <player.has_flag[<[character]>_<[item]>]>:
                - inventory add d:in@<[character]>_ProfessionMenu o:<[item]>Item
        - if <player.flag[<[character]>_Profession]> == 2:
            - inventory add d:in@<[character]>_ProfessionMenu o:EmptySlotItem s:2
        - if <player.flag[<[character]>_Profession]> == 1:
            - inventory add d:in@<[character]>_ProfessionMenu o:EmptySlotItem s:1
            - inventory add d:in@<[character]>_ProfessionMenu o:EmptySlotItem s:2
        - inventory open d:in@<[character]>_ProfessionMenu
ProfessionSetup:
    type: task
    script:
        - flag player <proc[GetCharacterName].context[<player>]>_Profession:1
        - note in@ProfessionMenu as:<proc[GetCharacterName].context[<player>]>_ProfessionMenu
ProfessionReset:
    type: task
    speed: instant
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - note remove as:<[character]>_ProfessionMenu
        - flag player <[character]>_Profession:!
        - flag player <[character]>_Engineer:!
        - flag player <[character]>_Blacksmith:!
        - flag player <[character]>_Apothecary:!
        - flag player <[character]>_Tradesman:!
        - flag player <[character]>_Weaponsmith:!
        - flag player <[character]>_Miner:!
        - flag player <[character]>_Arcanist:!
        - flag player <[character]>_Pilot:!
        - flag player <[character]>_Naturalist:!
        - flag player <[character]>_Pioneer:!
        - narrate "Your profession Info has been reset" format:ProfessionFormat

ClicksItemInCharacterProfessionMenu:
    type: task
    speed: instant
    script:
        - determine cancelled passively
        - if <li@EngineerItem|BlacksmithItem|ApothecaryItem|TradesmanItem|WeaponsmithItem|MinerItem|PilotItem|ArcanistItem|NaturalistItem|PioneerItem|EmptySlotItem.contains[<context.item.script.name>]>:
            - choose <context.item.script.name>:
                - case EngineerItem:
                    - inventory close
                    - inventory open d:in@<[character]>_EngineerMenu
                - case BlacksmithItem:
                    - inventory close
                    - inventory open d:in@<[character]>_BlacksmithMenu
                - case ApothecaryItem:
                    - inventory close
                    - inventory open d:in@<[character]>_ApothecaryMenu
                - case WeaponsmithItem:
                    - inventory close
                    - inventory open d:in@<[character]>_WeaponsmithMenu
                - case TradesmanItem:
                    - inventory close
                    - inventory open d:in@<[character]>_TradesmanMenu
                - case MinerItem:
                    - inventory close
                    - inventory open d:in@<[character]>_MinerMenu
                - case PilotItem:
                    - inventory close
                    - inventory open d:in@<[character]>_PilotMenu
                - case ArcanistItem:
                    - inventory close
                    - inventory open d:in@<[character]>_ArcanistMenu
                - case NaturalistItem:
                    - inventory close
                    - inventory open d:in@<[character]>_NaturalistMenu
                - case PioneerItem:
                    - inventory close
                    - inventory open d:in@<[character]>_PioneerMenu
                - case EmptySlotItem:
                    - inventory close
                    - inventory open d:in@ProfessionSelectMenu
                - default:
ClicksConfirmItemInInventory:
    type: task
    speed: instant
    script:
        - define name:Null
        - if <context.inventory.contains_text[Engineer]>:
            - define name:Engineer
        - if <context.inventory.contains_text[Blacksmith]>:
            - define name:Blacksmith
        - if <context.inventory.contains_text[Apothecary]>:
            - define name:Apothecary
        - if <context.inventory.contains_text[Tradesman]>:
            - define name:Tradesman
        - if <context.inventory.contains_text[Miner]>:
            - define name:Miner
        - if <context.inventory.contains_text[Pilot]>:
            - define name:Pilot
        - if <context.inventory.contains_text[Arcanist]>:
            - define name:Arcanist
        - if <context.inventory.contains_text[Weaponsmith]>:
            - define name:Weaponsmith
        - if <context.inventory.contains_text[Naturalist]>:
            - define name:Naturalist
        - if <context.inventory.contains_text[Pioneer]>:
            - define name:Pioneer
        - inject AddProfession
ProfessionMenuController:
    type: world
    events:
        on player clicks item in ProfessionSelectMenu:
            - choose <context.item.script.name>:
                - case EngineerItem:
                    - inventory open d:in@ProfessionEngineerConfirmMenu
                - case BlacksmithItem:
                    - inventory open d:in@ProfessionBlacksmithConfirmMenu
                - case ApothecaryItem:
                    - inventory open d:in@ProfessionApothecaryConfirmMenu
                - case WeaponsmithItem:
                    - inventory open d:in@ProfessionWeaponsmithConfirmMenu
                - case TradesmanItem:
                    - inventory open d:in@ProfessionTradesmanConfirmMenu
                - case MinerItem:
                    - inventory open d:in@ProfessionMinerConfirmMenu
                - case PilotItem:
                    - inventory open d:in@ProfessionPilotConfirmMenu
                - case ArcanistItem:
                    - inventory open d:in@ProfessionArcanistConfirmMenu
                - case NaturalistItem:
                    - inventory open d:in@ProfessionNaturalistConfirmMenu
                - case PioneerItem:
                    - inventory open d:in@ProfessionPioneerConfirmMenu

RejectMenu:
    type: task
    script:
        - determine cancelled passively
        - inventory close
        - inventory open d:in@<proc[GetCharacterName].context[<player>]>_ProfessionMenu
AddProfession:
    type: task
    definitions: name
    script:
        - define character:<proc[GetCharacterName].context[<player>]>
        - determine cancelled passively
        - if <player.has_flag[<[character]>_<[name]>]>:
            - narrate "You are already a member of this profession!" format:ProfessionFormat
            - inventory close
            - stop
        - narrate "You are now a <[name]>." format:ProfessionFormat
        - define replaced:false
        - if <player.flag[<[character]>_Profession]> == 3:
            - narrate "You already have two professions!" format:ProfessionFormat
        - else:
            - define slot:<player.flag[<[character]>_Profession]>
            - inventory adjust d:in@<[character]>_ProfessionMenu o:<[name]>Item s:<[slot]>
            - note in@Profession<[name]>Menu as:<[character]>_<[name]>Menu
            - flag player <[character]>_Profession:++
        - flag player <[character]>_<[name]>:1
        - inventory close

ProfessionMenu:
    type: inventory
    inventory: CHEST
    title: Profession Menu
    size: 9
    slots:
    - "[] [] [] [] [] [] [] [] []"
ProfessionSelectMenu:
    type: inventory
    inventory: CHEST
    title: Profession Selection Menu
    size: 18
    slots:
    - "[] [EngineerItem] [BlacksmithItem] [ApothecaryItem] [TradesmanItem] [WeaponsmithItem] [PilotItem] [ArcanistItem] []"
    - "[] [] [] [NaturalistItem] [MinerItem] [PioneerItem] [] [] []"

# ENGINEER
ProfessionEngineerConfirmMenu:
    type: inventory
    inventory: CHEST
    title: "Do you want to be an Engineer?"
    size: 3
    slots:
    - "[ConfirmItem] [] [RejectItem]"
ProfessionEngineerMenu:
    type: inventory
    inventory: CHEST
    title: "Engineer Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
EngineerItem:
    type: item
    material: iron_ingot
    display name: "<&e>Engineer"

# BLACKSMITH
BlacksmithItem:
    type: item
    material: anvil
    display name: "<&d>Blacksmith"
ProfessionBlacksmithMenu:
    type: inventory
    inventory: CHEST
    title: "Blacksmith Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
ProfessionBlacksmithConfirmMenu:
    type: inventory
    inventory: CHEST
    title: "Do you want to be an Blacksmith?"
    size: 3
    slots:
    - "[ConfirmItem] [] [RejectItem]"
# APOTHECARY
ApothecaryItem:
    type: item
    material: Potion
    display name: "<&a>Apothecary"
ProfessionApothecaryMenu:
    type: inventory
    inventory: CHEST
    title: "Apothecary Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
ProfessionApothecaryConfirmMenu:
    type: inventory
    inventory: CHEST
    title: "Do you want to be an Apothecary?"
    size: 3
    slots:
    - "[ConfirmItem] [] [RejectItem]"
# TRADESMAN
TradesmanItem:
    type: item
    material: Blue_Banner
    display name: "<&3>Tradesman"
ProfessionTradesmanMenu:
    type: inventory
    inventory: CHEST
    title: "Tradesman Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
ProfessionTradesmanConfirmMenu:
    type: inventory
    inventory: CHEST
    title: "Do you want to be an Tradesman?"
    size: 3
    slots:
    - "[ConfirmItem] [] [RejectItem]"
# WEAPONSMITH
WeaponsmithItem:
    type: item
    material: Crossbow
    display name: "<&d>Weaponsmith"
ProfessionWeaponsmithMenu:
    type: inventory
    inventory: CHEST
    title: "Weaponsmith Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
ProfessionWeaponsmithConfirmMenu:
    type: inventory
    inventory: CHEST
    title: "Do you want to be an Weaponsmith?"
    size: 3
    slots:
    - "[ConfirmItem] [] [RejectItem]"

# MINER
MinerItem:
    type: item
    material: Iron_Pickaxe
    display name: "<&e>Miner"
ProfessionMinerMenu:
    type: inventory
    inventory: CHEST
    title: "Miner Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
ProfessionMinerConfirmMenu:
    type: inventory
    inventory: CHEST
    title: "Do you want to be an Miner?"
    size: 3
    slots:
    - "[ConfirmItem] [] [RejectItem]"

# PILOT
PilotItem:
    type: item
    material: Blaze_Rod
    display name: "<&b>Pilot"
ProfessionPilotMenu:
    type: inventory
    inventory: CHEST
    title: "Pilot Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
ProfessionPilotConfirmMenu:
    type: inventory
    inventory: CHEST
    title: "Do you want to be an Pilot?"
    size: 3
    slots:
    - "[ConfirmItem] [] [RejectItem]"

# ARCANIST
ArcanistItem:
    type: item
    material: Nether_Star
    display name: "<&c>Arcanist"
ProfessionArcanistMenu:
    type: inventory
    inventory: CHEST
    title: "Arcanist Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
ProfessionArcanistConfirmMenu:
    type: inventory
    inventory: CHEST
    title: "Do you want to be an Arcanist?"
    size: 3
    slots:
    - "[ConfirmItem] [] [RejectItem]"

# NATURALIST
NaturalistItem:
    type: item
    material: Oak_Leaves
    display name: "<&a>Naturalist"
ProfessionNaturalistMenu:
    type: inventory
    inventory: CHEST
    title: "Naturalist Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
ProfessionNaturalistConfirmMenu:
    type: inventory
    inventory: CHEST
    title: "Do you want to be an Naturalist?"
    size: 3
    slots:
    - "[ConfirmItem] [] [RejectItem]"

# PIONEER
PioneerItem:
    type: item
    material: Feather
    display name: "<&d>Pioneer"
ProfessionPioneerMenu:
    type: inventory
    inventory: CHEST
    title: "Pioneer Skills"
    size: 27
    slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
ProfessionPioneerConfirmMenu:
    type: inventory
    inventory: CHEST
    title: "Do you want to be an Pioneer?"
    size: 3
    slots:
    - "[ConfirmItem] [] [RejectItem]"

# misc
EmptySlotItem:
    type: item
    material: barrier
    display name: <&c>Empty Slot
    lore:
    - Empty profession slot.
    - Click to fill!
ConfirmItem:
    type: item
    material: green_stained_glass
    display name: "<&a>Confirm"
RejectItem:
    type: item
    material: red_stained_glass
    display name: "<&c>Cancel"