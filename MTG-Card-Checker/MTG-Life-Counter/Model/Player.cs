namespace MTG_Card_Checker.Model;

public class Player
{
    public int Id { get; set; }
    public required string Name { get; init; } = "";
    public string Nationality { get; init; } = "";
    
    public ICollection<Deck> Decks { get; init; } = new List<Deck>();
}

public class PlayerDto
{
    public required string Name { get; set; }
    public required string DeckName { get; set; }
    public string Nationality { get; set; } = "";
    public string Strategy { get; set; } = "";
}
