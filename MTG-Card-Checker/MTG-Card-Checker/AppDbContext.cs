using Microsoft.EntityFrameworkCore;
using MTG_Card_Checker.Controllers;
using MTG_Card_Checker.Model;

namespace MTG_Card_Checker;

public class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
    public DbSet<Card> Card { get; set; }
    public DbSet<User> User { get; set; }
    public DbSet<Deck> Deck { get; set; }
}