namespace MTG_Card_Checker.FileHelper;

public static class FileHelper
{
    // public async Task<IList<Card>> ReadCardsFromTextFile(IFormFile file)
    // {
    //     var cards = new List<Card>();
    //     using var reader = new StreamReader(file.OpenReadStream());
    //
    //     while (reader.Peek() >= 0)
    //     {
    //         var line = await reader.ReadLineAsync();
    //         var parts = line?.Split(new[] { ' ' }, 2);
    //         if (parts?.Length == 2 && int.TryParse(parts[0], out var quantity))
    //         {
    //             cards.Add(new Card { Quantity = quantity, Name = parts[1].Trim() });
    //         }
    //     }
    //
    //     return cards;
    // }

}