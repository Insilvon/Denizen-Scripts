CompanionController:
    type: world
    events:
        on player right clicks with CompanionVoucher:
            - inject CompanionTask
        on player right clicks with RequiemVoucher:
            - inject RequiemTask
        on player right clicks with InfantryVoucher:
            - inject InfantryTask
        on player right clicks with BodyGuardVoucher:
            - inject BodyGuardTask