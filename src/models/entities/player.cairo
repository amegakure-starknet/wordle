use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde)]
struct Player {
    #[key]
    player: ContractAddress,
    points: u64,
    last_try: u64
}
