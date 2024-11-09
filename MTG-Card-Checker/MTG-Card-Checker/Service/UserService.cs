using MTG_Card_Checker.Model;

namespace MTG_Card_Checker.Repository;

public class UserService(UserRepository userRepository)
{
    public async Task Create(User user)
    {
        await userRepository.Create(user);
    }

    public async Task<IList<User>> Get()
    {
       return await userRepository.Get();
    }

    public async Task<User?> GetById(int id)
    {
        return await userRepository.GetById(id);
    }
}