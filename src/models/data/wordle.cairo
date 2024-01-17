use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde)]
struct GameStats {
    #[key]
    id: u32,
    next_word_position: u32,
}

#[derive(Model, Copy, Drop, Serde)]
struct PlayerStats {
    #[key]
    player: ContractAddress,
    #[key]
    epoc_day: u64,
    won: bool,
    remaining_tries: u8
}
