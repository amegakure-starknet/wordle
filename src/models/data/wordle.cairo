use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde)]
struct NextWord {
    #[key]
    id: u64,
    day: u64,
}

#[derive(Model, Copy, Drop, Serde)]
struct PlayerDailyState {
    #[key]
    player: ContractAddress,
    #[key]
    epoc_day: u64,
    won: bool,
    remaining_tries: u8,
}
