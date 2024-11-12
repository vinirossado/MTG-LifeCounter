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
        var cards = await ReadCardsFromCsv(file);
        await cardRepository.Import(cards);
        await RefreshCache();
    }

    public async Task<(List<FilteredCard> foundCards, List<FilteredCard> missingCards)> CompareWantListWithDb(IFormFile file)
    {
        var cardsFromFile = await ReadCardsFromTextFile(file);
        var allCardsInDb = await GetCardsFromCache();

        var missingCards = GetMissingCards(cardsFromFile, allCardsInDb);
        var foundCards = GetFoundCards(cardsFromFile, allCardsInDb);

        return (foundCards, missingCards);
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

    public async Task<List<Card>> SelectXCards(int amount)
    {
        return await cardRepository.SelectXCards(amount);
    }

    private async Task<IList<Card>> GetCardsFromCache()
    {
        if (memoryCache.TryGetValue(CacheKey, out IList<Card> cachedCards)) return cachedCards;

        cachedCards = await cardRepository.GetCards();
        memoryCache.Set(CacheKey, cachedCards);

        return cachedCards;
    }

    private async Task RefreshCache()
    {
        var updatedCards = await cardRepository.GetCards();
        memoryCache.Set(CacheKey, updatedCards);
    }

    private async Task<IList<Card>> ReadCardsFromCsv(IFormFile file)
    {
        try
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
        catch (Exception ex)
        {
            // Log or handle exception
            throw new Exception("Error reading CSV file", ex);
        }
    }

    private async Task<IList<Card>> ReadCardsFromTextFile(IFormFile file)
    {
        var cards = new List<Card>();
        using var reader = new StreamReader(file.OpenReadStream());

        while (reader.Peek() >= 0)
        {
            var line = await reader.ReadLineAsync();
            var parts = line?.Split(new[] { ' ' }, 2);
            if (parts?.Length == 2 && int.TryParse(parts[0], out var quantity))
            {
                cards.Add(new Card { Quantity = quantity, Name = parts[1].Trim() });
            }
        }

        return cards;
    }

    private List<FilteredCard> GetMissingCards(IList<Card>? cardsFromFile, IList<Card> allCardsInDb)
    {
        var missingCards = cardsFromFile
            .Where(card => allCardsInDb.All(dbCard => dbCard.Name != card.Name))
            .Select(card => new FilteredCard
            {
                Name = card.Name,
                Quantity = card.Quantity
            })
            .ToList();

        missingCards.AddRange(cardsFromFile
            .Where(card => allCardsInDb.Any(dbCard =>
                dbCard.Name == card.Name &&
                card.Quantity > dbCard.Quantity - dbCard.InUse))
            .Select(card =>
            {
                var dbCard = allCardsInDb.FirstOrDefault(dbCard => dbCard.Name == card.Name);
                return new FilteredCard
                {
                    Name = card.Name,
                    Quantity = card.Quantity - ((dbCard?.Quantity ?? 0) - (dbCard?.InUse ?? 0))
                };
            })
            .ToList());

        return missingCards;
    }

    private List<FilteredCard> GetFoundCards(IList<Card> cardsFromFile, IList<Card> allCardsInDb)
    {
        return cardsFromFile
            .Where(card => allCardsInDb.Any(dbCard => dbCard.Name == card.Name && card.Quantity <= dbCard.Quantity - dbCard.InUse))
            .Select(card => new FilteredCard
            {
                Name = card.Name,
                Quantity = card.Quantity
            })
            .ToList();
    }
}