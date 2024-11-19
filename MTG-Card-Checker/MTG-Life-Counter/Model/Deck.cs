namespace MTG_Card_Checker.Model;

public class Deck
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Strategy { get; set; }
    public short PowerLevel { get; set; }
    
    public int PlayerId { get; set; }
    public Player Player { get; set; } = null!;
    
    public List<CardDeck> CardDecks { get; set; } = [];
    
}