using Microsoft.EntityFrameworkCore;
using MTG_Card_Checker.Model;

namespace MTG_Card_Checker.Repository;

public class UserRepository(AppDbContext context)
{
    public async Task Create(User user)
    {  
        await context.User.AddAsync(user);
        await context.SaveChangesAsync();
    }

    public async Task<List<User>> Get()
    {
       return await context.User.ToListAsync();
    }

    public async Task<User?> GetById(int id)
    {
        return await context.User.FirstOrDefaultAsync(x => x.Id == id);
    }
}