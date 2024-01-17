use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde)]
struct PlayerScore {
    #[key]
    player: ContractAddress,
    score: u64,
}
