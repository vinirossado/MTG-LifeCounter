using MTG_Card_Checker.Model;

namespace MTG_Card_Checker.Repository;

public class CardDeckRepository (AppDbContext context)
{
    public async Task AddCardsToDeck(List<CardDeck> cards)
    {
        await context.CardDeck.AddRangeAsync(cards);
        await context.SaveChangesAsync();
    }
}