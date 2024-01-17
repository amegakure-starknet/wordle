mod setup {
    // Starknet imports

    use starknet::ContractAddress;
    use starknet::testing::set_contract_address;

    // Dojo imports

    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
    use dojo::test_utils::{spawn_test_world, deploy_contract};

    // Internal imports

    use wordle::models::data::wordle::{GameStats, PlayerStats};
    use wordle::models::entities::{
        player::Player,
        ranking::Ranking,
        ranking::RankingCount,
        word::Word,
    };
    use wordle::models::states::word_attemps::PlayerWordAttempts;

    use wordle::systems::guess_system::{guess_system, IGuessSystemDispatcher};
    use wordle::systems::ranking_system::{ranking_system, IRankingSystemDispatcher};
    use wordle::systems::word_system::{word_system, IWordSystemDispatcher};

    // Constants

    fn PLAYER() -> ContractAddress {
        starknet::contract_address_const::<'PLAYER'>()
    }

    #[derive(Drop)]
    struct Systems {
        guess_system: IGuessSystemDispatcher,
        ranking_system: IRankingSystemDispatcher,
        word_system: IWordSystemDispatcher,
    }

    fn spawn_game() -> (IWorldDispatcher, Systems) {
        // [Setup] World
        let models = array![
            GameStats::TEST_CLASS_HASH,
            PlayerStats::TEST_CLASS_HASH,
            Player::TEST_CLASS_HASH,
            Ranking::TEST_CLASS_HASH,
            Word::TEST_CLASS_HASH,
            PlayerWordAttempts::TEST_CLASS_HASH,
        ];

        let world = spawn_test_world(models);

        // [Setup] Systems
        let systems = Systems {
            guess_system: IGuessSystemDispatcher {
                contract_address: world
                    .deploy_contract('paper', guess_system::TEST_CLASS_HASH.try_into().unwrap())
            },
            ranking_system: IRankingSystemDispatcher {
                contract_address: world
                    .deploy_contract('paper', ranking_system::TEST_CLASS_HASH.try_into().unwrap())
            },
            word_system: IWordSystemDispatcher {
                contract_address: world
                    .deploy_contract('paper', word_system::TEST_CLASS_HASH.try_into().unwrap())
            },
        };

        // [Return]
        set_contract_address(PLAYER());
        (world, systems)
    }
}