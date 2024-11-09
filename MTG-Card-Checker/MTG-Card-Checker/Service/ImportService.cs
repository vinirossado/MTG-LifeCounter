using System.Globalization;
using CsvHelper;
using CsvHelper.Configuration;
using MTG_Card_Checker.Model;

namespace MTG_Card_Checker.Repository;

public class ImportService
{
    private readonly ImportRepository _cardRepository;

    public ImportService(ImportRepository cardRepository)
    {
        _cardRepository = cardRepository;
    }

    public async Task Import(IFormFile file)
    {
        List<Card> cards;

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

        cards = csv.GetRecords<Card>().ToList();

        await _cardRepository.Import(cards);
    }
}