using CsvHelper.Configuration.Attributes;

namespace MTG_Card_Checker.Model;

public class Card
{
    public int Id { get; set; }
    public int Quantity { get; set; }
    public string Name { get; set; }
    public int CardNumber { get; set; }
    [Name("Expansion Code")] public string ExpansionCode { get; set; }
    [Name("Expansion Name")] public string ExpansionName { get; set; }
    public bool Foil { get; set; }
    public string Condition { get; set; }
    public string Language { get; set; }
}