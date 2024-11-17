using Microsoft.EntityFrameworkCore;
using MTG_Card_Checker.Model;

namespace MTG_Card_Checker.Repository;

public class CardRepository(AppDbContext context)
{
    public async Task Add(IList<Card> cards)
    {
        await context.Card.AddRangeAsync(cards);
        await context.SaveChangesAsync();
    }

    public async Task Add(Card card)
    {
        await context.Card.AddAsync(card);
        await context.SaveChangesAsync();
    }

    public async Task<List<Card>> Get()
    {
        return await context.Card.ToListAsync();
    }

    public async Task<List<Card>> GetMissingSyncCards()
    {
        return await context.Card.Where(x => x.TypeLine == null).ToListAsync();
    }

    public async Task<List<Card>> GetMissingCards(IList<Card> cards)
    {
        var cardNames = cards.Select(c => c.Name).ToList();

        return await context.Card
            .Where(dbCard => !cardNames.Contains(dbCard.Name))
            .ToListAsync();
    }


    public async Task Update(Card card)
    {
        context.Card.Update(card);
        await context.SaveChangesAsync();
    }

    public async Task Update(IList<Card> cards)
    {
        context.Card.UpdateRange(cards);
        await context.SaveChangesAsync();
    }

    public async Task<List<Card>> SelectXCards(int amount)
    {
        return await context.Card.Take(amount).ToListAsync();
    }
}