using MTG_Card_Checker.Model;

namespace MTG_Card_Checker.Repository;

public class PlayerService(PlayerRepository playerRepository)
{
    public async Task<int> Create(Player player)
    {
        return await playerRepository.Create(player);
    }

    public async Task<IList<Player>> Get()
    {
       return await playerRepository.Get();
    }

    public async Task<Player?> GetById(int id)
    {
        return await playerRepository.GetById(id);
    }
}