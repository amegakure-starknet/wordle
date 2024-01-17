//! Store struct and component management methods.

// Dojo imports

use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

// Components imports
use wordle::models::data::wordle::{NextWord, PlayerDailyState};
use wordle::models::entities::{
    player::Player,
    ranking::Ranking,
    ranking::RankingCount,
    word::Word,
};
use wordle::models::states::word_attemps::PlayerWordAttempts;
use wordle::models::states::player_score::PlayerScore;

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
    fn get_next_word(ref self: Store, id: u64) -> NextWord;
    fn set_next_word(ref self: Store, next_word: NextWord);
    fn get_player_daily_state(ref self: Store, player: ContractAddress, epoc_day: u64) -> PlayerDailyState;
    fn set_player_daily_state(ref self: Store, player_daily_state: PlayerDailyState);
    
    // entities
    fn get_player(ref self: Store, player: ContractAddress) -> Player;
    fn set_player(ref self: Store, player: Player);
    fn get_word(ref self: Store, epoc_day: u64) -> Word;
    fn set_word(ref self: Store, word: Word);
    fn get_ranking(ref self: Store, ranking_id: u32) -> Ranking;
    fn set_ranking(ref self: Store, ranking: Ranking);
    fn get_ranking_count(ref self: Store, id: felt252) -> RankingCount;
    fn set_ranking_count(ref self: Store, ranking_count: RankingCount);
    
    // states
    fn get_player_word_attempts(ref self: Store, player: ContractAddress, epoc_day: u64, attempt_number: u8) -> PlayerWordAttempts;
    fn set_player_word_attempts(ref self: Store, player_word_attempts: PlayerWordAttempts);
    fn get_player_score(ref self: Store, player: ContractAddress) -> PlayerScore;
    fn set_player_score(ref self: Store, player_score: PlayerScore);
}

/// Implementation of the `StoreTrait` trait for the `Store` struct.
impl StoreImpl of StoreTrait {
    #[inline(always)]
    fn new(world: IWorldDispatcher) -> Store {
        Store { world: world }
    }

    // data
    fn get_next_word(ref self: Store, id: u64) -> NextWord {
        get!(self.world, id, (NextWord))
    }

    fn set_next_word(ref self: Store, next_word: NextWord) {
        set!(self.world, (next_word));
    }

    fn get_player_daily_state(ref self: Store, player: ContractAddress, epoc_day: u64) -> PlayerDailyState {
        let player_stats_key = (player, epoc_day);
        get!(self.world, player_stats_key.into(), (PlayerDailyState))
    }

    fn set_player_daily_state(ref self: Store, player_daily_state: PlayerDailyState) {
        set!(self.world, (player_daily_state));
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

    // states

    fn get_player_word_attempts(ref self: Store, player: ContractAddress, epoc_day: u64, attempt_number: u8) -> PlayerWordAttempts {
        let player_word_attempts_key = (player, epoc_day, attempt_number);
        get!(self.world, player_word_attempts_key.into(), (PlayerWordAttempts))
    }

    fn set_player_word_attempts(ref self: Store, player_word_attempts: PlayerWordAttempts) {
        set!(self.world, (player_word_attempts));
    }

    fn get_player_score(ref self: Store, player: ContractAddress) -> PlayerScore {
        get!(self.world, player, (PlayerScore))
        
    }

    fn set_player_score(ref self: Store, player_score: PlayerScore) {
         set!(self.world, (player_score));
    }
}