using Microsoft.EntityFrameworkCore;
using MTG_Card_Checker.Model;

namespace MTG_Card_Checker.Repository;

public class PlayerRepository(AppDbContext context)
{
    public async Task<int> Create(Player user)
    {  
        await context.Player.AddAsync(user); 
        await context.SaveChangesAsync();
        return user.Id;
    }

    public async Task<List<Player>> Get()
    {
       return await context.Player.ToListAsync();
    }

    public async Task<Player?> GetById(int id)
    {
        return await context.Player.FirstOrDefaultAsync(x => x.Id == id);
    }
}