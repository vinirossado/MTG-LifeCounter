namespace MTG_Card_Checker.Model;

public class CardDeck 
{
    public int Id { get; set; }
    public int DeckId { get; set; }
    public int CardId { get; set; }
    
    public Card Card { get; set; } = null!;
    public Deck Deck { get; set; } = null!;
}
