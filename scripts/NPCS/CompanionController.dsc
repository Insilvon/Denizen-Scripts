CompanionController:
    type: world
    events:
        on player right clicks with CompanionVoucher:
            - inject CompanionTask
        on player right clicks with RequiemVoucher:
            - inject RequiemTask