#[derive(Model, Copy, Drop, Serde)]
struct Word {
    #[key]
    epoc_day: u64,
    characters: u32,
}
