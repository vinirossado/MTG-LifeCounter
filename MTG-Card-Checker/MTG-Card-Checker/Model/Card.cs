using CsvHelper.Configuration.Attributes;

namespace MTG_Card_Checker.Model;

public class Card
{
    public int Id { get; set; }
    public string Name { get; set; }
    public int Quantity { get; set; }
    public int InUse { get; set; }
    public int CardNumber { get; set; }
    [Name("Expansion Code")] public string ExpansionCode { get; set; }
    [Name("Expansion Name")] public string ExpansionName { get; set; }
    public bool Foil { get; set; }
    public string Condition { get; set; }
    public string Language { get; set; }
    
    //TODO: Add more properties
    //TODO: Add CMC, ColorArray, IsCommander,
    
}

public class FilteredCard 
{
    public string Name { get; set; }
    public int Quantity { get; set; }
}

public class WantListResponse
{
    public List<FilteredCard> FoundCards { get; set; }
    public List<FilteredCard> MissingCards { get; set; }
}