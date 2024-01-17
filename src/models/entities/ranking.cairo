const RANKING_COUNT_KEY: felt252 = 'ranking_key';

#[derive(Model, Copy, Drop, Serde)]
struct Ranking {
    #[key]
    id: u32,
    player: felt252,
    score: u64
}

trait RankingTrait {
    fn new(id: u32, player: felt252, score: u64) -> Ranking;
}

impl RankingImpl of RankingTrait {
    fn new(id: u32, player: felt252, score: u64) -> Ranking {
        Ranking { id, player, score }
    }
}

impl RankingPartialEq of PartialEq<Ranking> {
    fn eq(lhs: @Ranking, rhs: @Ranking) -> bool {
        lhs.player == rhs.player
    }

    fn ne(lhs: @Ranking, rhs: @Ranking) -> bool {
        lhs.player != rhs.player
    }
}

impl RankingPartialOrd of PartialOrd<Ranking> {
    #[inline(always)]
    fn le(lhs: Ranking, rhs: Ranking) -> bool {
        lhs.score <= rhs.score
    }
    fn ge(lhs: Ranking, rhs: Ranking) -> bool {
        lhs.score >= rhs.score
    }
    fn lt(lhs: Ranking, rhs: Ranking) -> bool {
        lhs.score < rhs.score
    }
    fn gt(lhs: Ranking, rhs: Ranking) -> bool {
        lhs.score > rhs.score
    }
}

#[derive(Model, Copy, Drop, Serde)]
struct RankingCount {
    #[key]
    id: felt252,
    index: u32,
}

trait RankingCountTrait {
    fn new(index: u32) -> RankingCount;
}

impl RankingCountImpl of RankingCountTrait {
    fn new(index: u32) -> RankingCount {
        RankingCount { id: RANKING_COUNT_KEY, index }
    }
}
