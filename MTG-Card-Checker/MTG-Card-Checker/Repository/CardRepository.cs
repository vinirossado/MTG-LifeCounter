using Microsoft.EntityFrameworkCore;
using MTG_Card_Checker.Model;

namespace MTG_Card_Checker.Repository;

public class CardRepository(AppDbContext context)
{
    public async Task Import(IList<Card> cards)
    {
        await context.Card.AddRangeAsync(cards);
        await context.SaveChangesAsync();
    }
    
    public async Task<List<Card>> GetCards()
    {
        return await context.Card.ToListAsync();
    }
    
    public async Task<List<Card>> GetMissingSyncCards()
    {
        return await context.Card.Where(x => x.TypeLine == null).ToListAsync();
    }
    
    public async Task UpdateCard(Card card)
    {
        context.Card.Update(card);
        await context.SaveChangesAsync();
    }
    
    public async Task UpdateCard(IList<Card> cards)
    {
        context.Card.UpdateRange(cards);
        await context.SaveChangesAsync();
    }
    
    public async Task AddCard(Card card)
    {
        await context.Card.AddAsync(card);
        await context.SaveChangesAsync();
    }

    public async Task <List<Card>> SelectXCards(int amount)
    {
        return await context.Card.Take(amount).ToListAsync();
    }
    
}