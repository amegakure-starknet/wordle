// Core imports
use debug::PrintTrait;

// Dojo imports
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

// Internal imports
use wordle::store::{Store, StoreTrait};
use wordle::systems::word_system::IWordSystemDispatcherTrait;
use wordle::models::data::wordle::NextWord;
use wordle::models::entities::word::Word;
use wordle::constants::{DAY_EPOC_DIVISOR, WORDLE_KEY};

use wordle::tests::setup::{setup, setup::Systems, setup::PLAYER};

#[test]
#[available_gas(1_000_000_000)]
fn test_add_word_happy_path() {
    // [Setup]
    let (world, systems) = setup::spawn_game();
    let mut store = StoreTrait::new(world);

    let new_word = 0401120505;
    systems.word_system.add(new_word);

    let day = 0;
    let word = store.get_word(day);
    assert(word.characters == new_word, 'err characters');

    let next_word = store.get_next_word(WORDLE_KEY);
    assert(next_word.day == day + 1, 'err next_word');
}

#[test]
#[available_gas(1_000_000_000)]
fn test_add_words_happy_path() {
    // [Setup]
    let (world, systems) = setup::spawn_game();
    let mut store = StoreTrait::new(world);

    // starknet::testing::set_block_timestamp(1000);

    let new_word_1 = 0401120505;
    let new_word_2 = 0101010101;
    let new_words = array![new_word_1, new_word_2];
    systems.word_system.add_many(new_words.span());

    let mut day = 0;
    let word_1 = store.get_word(day);
    assert(word_1.characters == new_word_1, 'err word_1');

    let word_2 = store.get_word(day + 1);
    assert(word_2.characters == new_word_2, 'err word_2');
    
    let next_word = store.get_next_word(WORDLE_KEY);
    assert(next_word.day == day + 2, 'err next_word');
}

#[test]
#[available_gas(1_000_000_000)]
#[should_panic(expected: ('ERR: Invalid character', 'ENTRYPOINT_FAILED'))]
fn test_fail_when_word_contains_an_invalid_character() {
    // [Setup]
    let (world, systems) = setup::spawn_game();
    let mut store = StoreTrait::new(world);

    // 34 isnt a valid character
    let invalid_word = 3401120505;
    systems.word_system.add(invalid_word);
}

#[test]
#[available_gas(1_000_000_000)]
#[should_panic(expected: ('ERR: Word len must be 5', 'ENTRYPOINT_FAILED'))]
fn test_fail_when_word_has_less_than_5_characters() {
    // [Setup]
    let (world, systems) = setup::spawn_game();
    let mut store = StoreTrait::new(world);

    let invalid_word = 01120505;
    systems.word_system.add(invalid_word);
}
