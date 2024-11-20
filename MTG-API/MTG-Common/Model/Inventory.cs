using CsvHelper.Configuration.Attributes;

namespace MTG_Card_Checker.Model;

public class Inventory
{
    public int Id { get; set; }
    public int Quantity { get; set; }
    public int? CardNumber { get; set; }
    [Name("Expansion Code")] public string? ExpansionCode { get; set; }
    [Name("Expansion Name")] public string? ExpansionName { get; set; }
    public bool? Foil { get; set; }
    public string? Condition { get; set; }
    public string? Language { get; set; }
    public int InUse { get; set; }
    
    public int CardId { get; set; }
    public Card Card { get; set; } = null!;
}