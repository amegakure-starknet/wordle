use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde)]
struct PlayerWordAttempts {
    #[key]
    player: ContractAddress,
    #[key]
    epoc_day: u64,
    #[key]
    attempt_number: u8,
    word_attempt: u32,
    word_hits: u32
}