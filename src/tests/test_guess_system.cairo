// Core imports
use debug::PrintTrait;
use starknet::get_block_timestamp;

// Dojo imports
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

// Internal imports
use wordle::store::{Store, StoreTrait};
use wordle::systems::word_system::IWordSystemDispatcherTrait;
use wordle::systems::guess_system::IGuessSystemDispatcherTrait;
use wordle::models::data::wordle::NextWord;
use wordle::models::entities::word::Word;
use wordle::constants::{DAY_EPOC_DIVISOR, WORDLE_KEY};

use wordle::tests::setup::{setup, setup::Systems, setup::PLAYER};

#[test]
#[available_gas(1_000_000_000)]
fn test_guess_happy_path() {
    // [Setup]
    let (world, systems) = setup::spawn_game();
    let mut store = StoreTrait::new(world);

    starknet::testing::set_block_timestamp(1705496971);

    let new_word = 0401120505;
    systems.word_system.add(new_word);

    let attempt = 0401120505;
    systems.guess_system.update(attempt);

    let day = get_block_timestamp() / DAY_EPOC_DIVISOR;
    let player_daily_state = store.get_player_daily_state(PLAYER(), day);
    assert(player_daily_state.won, 'err won');
    assert(player_daily_state.remaining_tries == 5, 'err remaining_tries');
}

#[test]
#[available_gas(1_000_000_000)]
#[should_panic(expected: ('ERR: You have no more attempts', 'ENTRYPOINT_FAILED'))]
fn test_fail_when_use_guess_when_no_more_attempts() {
    // [Setup]
    let (world, systems) = setup::spawn_game();
    let mut store = StoreTrait::new(world);

    starknet::testing::set_block_timestamp(1705496971);

    let new_word = 0401120505;
    systems.word_system.add(new_word);

    // You have only 6 tries by day
    let wrong_attempt = 0101010101;
    systems.guess_system.update(wrong_attempt);
    systems.guess_system.update(wrong_attempt);
    systems.guess_system.update(wrong_attempt);
    systems.guess_system.update(wrong_attempt);
    systems.guess_system.update(wrong_attempt);
    systems.guess_system.update(wrong_attempt);

    // This should be fail (its the 7th attempt)
    systems.guess_system.update(wrong_attempt);

    let day = get_block_timestamp() / DAY_EPOC_DIVISOR;
    let player_daily_state = store.get_player_daily_state(PLAYER(), day);
    assert(player_daily_state.won, 'err won');
    assert(player_daily_state.remaining_tries == 5, 'err remaining_tries');
}


#[test]
#[available_gas(1_000_000_000)]
fn test_won_in_last_attempt() {
    // [Setup]
    let (world, systems) = setup::spawn_game();
    let mut store = StoreTrait::new(world);

    starknet::testing::set_block_timestamp(1705496971);

    let new_word = 0401120505;
    systems.word_system.add(new_word);

    let mut attempt = 0101010101;
    systems.guess_system.update(attempt);
    systems.guess_system.update(attempt);
    systems.guess_system.update(attempt);
    systems.guess_system.update(attempt);
    systems.guess_system.update(attempt);

    attempt = 0401120505;
    systems.guess_system.update(attempt);
}

#[test]
#[available_gas(1_000_000_000)]
#[should_panic(expected: ('ERR: You already won today', 'ENTRYPOINT_FAILED'))]
fn test_fail_when_use_guess_when_won() {
    // [Setup]
    let (world, systems) = setup::spawn_game();
    let mut store = StoreTrait::new(world);

    starknet::testing::set_block_timestamp(1705496971);

    let new_word = 0401120505;
    systems.word_system.add(new_word);

    let attempt = 0401120505;
    systems.guess_system.update(attempt);
    systems.guess_system.update(attempt);
}
