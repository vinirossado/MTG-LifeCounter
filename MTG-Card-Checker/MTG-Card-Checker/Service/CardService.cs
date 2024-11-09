using System.Globalization;
using CsvHelper;
using CsvHelper.Configuration;
using Microsoft.Extensions.Caching.Memory;
using MTG_Card_Checker.Model;

namespace MTG_Card_Checker.Repository;

public class CardService(CardRepository cardRepository, IMemoryCache memoryCache)
{
    private const string CacheKey = "AllCardsCache";

    public async Task ImportDatabase(IFormFile file)
    {
        var cards = await CsvReader(file);
        await cardRepository.Import(cards);
    }

    public async Task<(List<Card> foundCards, List<Card> missingCards)> CompareWantListWithDb(IFormFile file)
    {
        var cardsFromFile = await TextReader(file);

        var allCardsInDb = await GetCardsFromCache();

        var foundCards = cardsFromFile
            .Where(card => allCardsInDb.Any(dbCard => dbCard.Name == card.Name))
            .ToList();

        var missingCards = cardsFromFile
            .Where(card => allCardsInDb.All(dbCard => dbCard.Name != card.Name))
            .ToList();

        return (foundCards, missingCards);
    }

    private async Task<List<Card>> GetCardsFromCache()
    {
        if (memoryCache.TryGetValue(CacheKey, out List<Card> cachedCards)) return cachedCards;

        cachedCards = await cardRepository.GetCards();
        memoryCache.Set(CacheKey, cachedCards);

        return cachedCards;
    }

    public async Task UpdateCard(Card card)
    {
        await cardRepository.UpdateCard(card);
        await RefreshCache();
    }

    public async Task AddCard(Card card)
    {
        await cardRepository.AddCard(card);
        await RefreshCache();
    }

    private async Task RefreshCache()
    {
        var updatedCards = await cardRepository.GetCards();
        memoryCache.Set(CacheKey, updatedCards);
    }

    private async Task<IList<Card>> CsvReader(IFormFile file)
    {
        using var reader = new StreamReader(file.OpenReadStream());
        using var csv = new CsvReader(reader, new CsvConfiguration(CultureInfo.InvariantCulture)
        {
            HasHeaderRecord = true,
            Delimiter = ",",
            TrimOptions = TrimOptions.Trim,
            MissingFieldFound = null,
            HeaderValidated = null,
            PrepareHeaderForMatch = args => args.Header.Trim(),
            BadDataFound = null
        });

        return csv.GetRecords<Card>().ToList();
    }

    private async Task<IList<Card>> TextReader(IFormFile file)
    {
        List<Card> cards = new List<Card>();
        
        using (var reader = new StreamReader(file.OpenReadStream()))
        {
            while (reader.Peek() >= 0)
            {
                string line = await reader.ReadLineAsync();
                string[] parts = line.Split(new[] { ' ' }, 2);

                if (parts.Length == 2 && int.TryParse(parts[0], out int quantity))
                {
                    cards.Add(new Card
                    {
                        Quantity = quantity,
                        Name = parts[1].Trim()
                    });
                }
            }
        }

        return cards;
    }
}