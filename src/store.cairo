//! Store struct and component management methods.

// Dojo imports

use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

// Components imports
use wordle::models::data::wordle::{GameStats, PlayerStats};
use wordle::models::entities::{
    player::Player,
    ranking::Ranking,
    ranking::RankingCount,
    word::Word,
};
use wordle::models::states::word_attemps::PlayerWordAttempts;

use starknet::ContractAddress;

/// Store struct.
#[derive(Drop)]
struct Store {
    world: IWorldDispatcher
}

/// Trait to initialize, get and set components from the Store.
trait StoreTrait {
    fn new(world: IWorldDispatcher) -> Store;
    // data
    fn get_game_stats(ref self: Store, id: u32) -> GameStats;
    fn set_game_stats(ref self: Store, game_stats: GameStats);
    fn get_player_stats(ref self: Store, player: ContractAddress, epoc_day: u64) -> PlayerStats;
    fn set_player_stats(ref self: Store, player_stats: PlayerStats);
    
    // entities
    fn get_player(ref self: Store, player: ContractAddress) -> Player;
    fn set_player(ref self: Store, player: Player);
    fn get_word(ref self: Store, epoc_day: u64) -> Word;
    fn set_word(ref self: Store, word: Word);
    
    // states
    fn get_player_word_attempts(ref self: Store, player: ContractAddress, epoc_day: u64, attempt_number: u8) -> PlayerWordAttempts;
    fn set_player_word_attempts(ref self: Store, player_word_attempts: PlayerWordAttempts);

    fn get_ranking(ref self: Store, ranking_id: u32) -> Ranking;
    fn set_ranking(ref self: Store, ranking: Ranking);
    fn get_ranking_count(ref self: Store, id: felt252) -> RankingCount;
    fn set_ranking_count(ref self: Store, ranking_count: RankingCount);
}

/// Implementation of the `StoreTrait` trait for the `Store` struct.
impl StoreImpl of StoreTrait {
    #[inline(always)]
    fn new(world: IWorldDispatcher) -> Store {
        Store { world: world }
    }

    // data
    fn get_game_stats(ref self: Store, id: u32) -> GameStats {
        get!(self.world, id, (GameStats))
    }

    fn set_game_stats(ref self: Store, game_stats: GameStats) {
        set!(self.world, (game_stats));
    }

    fn get_player_stats(ref self: Store, player: ContractAddress, epoc_day: u64) -> PlayerStats {
        let player_stats_key = (player, epoc_day);
        get!(self.world, player_stats_key.into(), (PlayerStats))
    }

    fn set_player_stats(ref self: Store, player_stats: PlayerStats) {
        set!(self.world, (player_stats));
    }

    // entities

    fn get_player(ref self: Store, player: ContractAddress) -> Player {
        get!(self.world, player, (Player))
    }

    fn set_player(ref self: Store, player: Player) {
        set!(self.world, (player));
    }

    fn get_word(ref self: Store, epoc_day: u64) -> Word {
        get!(self.world, epoc_day, (Word))
    }

    fn set_word(ref self: Store, word: Word) {
        set!(self.world, (word));
    }

    // states

    fn get_player_word_attempts(ref self: Store, player: ContractAddress, epoc_day: u64, attempt_number: u8) -> PlayerWordAttempts {
        let player_word_attempts_key = (player, epoc_day, attempt_number);
        get!(self.world, player_word_attempts_key.into(), (PlayerWordAttempts))
    }

    fn set_player_word_attempts(ref self: Store, player_word_attempts: PlayerWordAttempts) {
        set!(self.world, (player_word_attempts));
    }


    fn get_ranking(ref self: Store, ranking_id: u32) -> Ranking {
        get!(self.world, ranking_id, (Ranking))
    }
    
    fn set_ranking(ref self: Store, ranking: Ranking) {
        set!(self.world, (ranking));
    }

    fn get_ranking_count(ref self: Store, id: felt252) -> RankingCount {
        get!(self.world, id, (RankingCount))
    }

    fn set_ranking_count(ref self: Store, ranking_count: RankingCount) {
        set!(self.world, (ranking_count));
    }
}