use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use wordle::models::entities::ranking::Ranking;

#[starknet::interface]
trait IWordSystem<TContractState> {
    fn add(self: @TContractState, word: u32);
    fn add_many(self: @TContractState, words: Span<u32>);
}

#[dojo::contract]
mod word_system {
    use core::array::SpanTrait;
    use super::IWordSystem;
    use wordle::store::{Store, StoreTrait};
    use wordle::models::entities::word::Word;
    use wordle::models::data::wordle::GameStats;

    const WORDLE_KEY: felt252 = 'WORDLE_KEY';
    const DAY_TIMESTAMP: u64 = 86400;

    #[external(v0)]
    impl WordSystem of IWordSystem<ContractState> {
        fn add(self: @ContractState, word: u32) {
            // [Setup] Datastore
            let mut store: Store = StoreTrait::new(self.world());
            let epoc_day = starknet::get_block_timestamp() / DAY_TIMESTAMP;

            let word = Word { epoc_day, characters: word}; 
            store.set_word(word);

            let mut game_stats = store.get_game_stats(WORDLE_KEY.try_into().unwrap());
            game_stats.next_word_position += 1; 
            store.set_game_stats(game_stats);
        }

        fn add_many(self: @ContractState, mut words: Span<u32>) {
            loop {
                match words.pop_front() {
                    Option::Some(word) => self.add(*word), 
                    Option::None => { break; }
                }
            }
        }
    }
}
