using MTG_Card_Checker.Model;

namespace MTG_Card_Checker.Repository;

public class ImportRepository(AppDbContext context)
{
    public async Task Import(IList<Card> cards)
    {
        await context.Card.AddRangeAsync(cards);
        await context.SaveChangesAsync();
    }
}