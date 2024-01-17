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
    use wordle::models::data::wordle::NextWord;
    use wordle::constants::{DAY_EPOC_DIVISOR, WORDLE_KEY, WORDS_LEN};
    use debug::PrintTrait;

    mod Errors {
        const WRONG_WORD_LEN: felt252 = 'ERR: Word len must be 5';
        const INVALID_CHARACTER: felt252 = 'ERR: Invalid character';
    }

    #[external(v0)]
    impl WordSystem of IWordSystem<ContractState> {
        fn add(self: @ContractState, word: u32) {
            assert_valid_word(word);

            // [Setup] Datastore
            let mut store: Store = StoreTrait::new(self.world());
            let epoc_day = starknet::get_block_timestamp() / DAY_EPOC_DIVISOR;
            let mut next_word = store.get_next_word(WORDLE_KEY);

            let word = Word { epoc_day: epoc_day + next_word.day, characters: word}; 
            store.set_word(word);

            next_word.day += 1; 
            store.set_next_word(next_word);
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

    fn assert_valid_word(word: u32) {
        let mut ret = ArrayTrait::<u32>::new();
        let mut iterable = word;
        loop {
            if iterable < 10 {
                break;
            }
            let last_digit = iterable % 10;
            let penultimate_digit = (iterable / 10) % 10;
            let character = penultimate_digit * 10 + last_digit;
            assert(character.is_non_zero() && character <= 26, Errors::INVALID_CHARACTER);
            ret.append(character);
            iterable /= 100;
        };

        if iterable > 0 {
            ret.append(iterable);
        }
        assert(ret.len() == WORDS_LEN, Errors::WRONG_WORD_LEN);
    }
}
