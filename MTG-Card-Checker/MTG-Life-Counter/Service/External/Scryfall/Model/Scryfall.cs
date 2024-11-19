using System.Text.Json.Serialization;
using Newtonsoft.Json;

namespace MTG_Card_Checker.Repository.External.Scryfall.Model;

public class Scryfall
{
    [JsonProperty("object")]
    [JsonPropertyName("object")]
    public string Object { get; set; }

    [JsonProperty("id")]
    [JsonPropertyName("id")]
    public string Id { get; set; }

    [JsonProperty("oracle_id")]
    [JsonPropertyName("oracle_id")]
    public string OracleId { get; set; }

    [JsonProperty("multiverse_ids")]
    [JsonPropertyName("multiverse_ids")]
    public List<int> MultiverseIds { get; set; }

    [JsonProperty("mtgo_id")]
    [JsonPropertyName("mtgo_id")]
    public int MtgoId { get; set; }

    [JsonProperty("arena_id")]
    [JsonPropertyName("arena_id")]
    public int ArenaId { get; set; }

    [JsonProperty("tcgplayer_id")]
    [JsonPropertyName("tcgplayer_id")]
    public int TcgplayerId { get; set; }

    [JsonProperty("cardmarket_id")]
    [JsonPropertyName("cardmarket_id")]
    public int CardmarketId { get; set; }

    [JsonProperty("name")]
    [JsonPropertyName("name")]
    public string Name { get; set; }

    [JsonProperty("lang")]
    [JsonPropertyName("lang")]
    public string Lang { get; set; }

    [JsonProperty("released_at")]
    [JsonPropertyName("released_at")]
    public string ReleasedAt { get; set; }

    [JsonProperty("uri")]
    [JsonPropertyName("uri")]
    public string Uri { get; set; }

    [JsonProperty("scryfall_uri")]
    [JsonPropertyName("scryfall_uri")]
    public string ScryfallUri { get; set; }

    [JsonProperty("layout")]
    [JsonPropertyName("layout")]
    public string Layout { get; set; }

    [JsonProperty("highres_image")]
    [JsonPropertyName("highres_image")]
    public bool HighresImage { get; set; }

    [JsonProperty("image_status")]
    [JsonPropertyName("image_status")]
    public string ImageStatus { get; set; }

    [JsonProperty("image_uris")]
    [JsonPropertyName("image_uris")]
    public ImageUris ImageUris { get; set; }

    [JsonProperty("mana_cost")]
    [JsonPropertyName("mana_cost")]
    public string ManaCost { get; set; }

    [JsonProperty("cmc")]
    [JsonPropertyName("cmc")]
    public double Cmc { get; set; }

    [JsonProperty("type_line")]
    [JsonPropertyName("type_line")]
    public string TypeLine { get; set; }

    [JsonProperty("oracle_text")]
    [JsonPropertyName("oracle_text")]
    public string OracleText { get; set; }

    [JsonProperty("colors")]
    [JsonPropertyName("colors")]
    public List<object> Colors { get; set; }

    [JsonProperty("color_identity")]
    [JsonPropertyName("color_identity")]
    public string[] ColorIdentity { get; set; }

    [JsonProperty("keywords")]
    [JsonPropertyName("keywords")]
    public List<string> Keywords { get; set; }

    [JsonProperty("legalities")]
    [JsonPropertyName("legalities")]
    public Legalities Legalities { get; set; }

    [JsonProperty("games")]
    [JsonPropertyName("games")]
    public List<string> Games { get; set; }

    [JsonProperty("reserved")]
    [JsonPropertyName("reserved")]
    public bool Reserved { get; set; }

    [JsonProperty("foil")]
    [JsonPropertyName("foil")]
    public bool Foil { get; set; }

    [JsonProperty("nonfoil")]
    [JsonPropertyName("nonfoil")]
    public bool Nonfoil { get; set; }

    [JsonProperty("finishes")]
    [JsonPropertyName("finishes")]
    public List<string> Finishes { get; set; }

    [JsonProperty("oversized")]
    [JsonPropertyName("oversized")]
    public bool Oversized { get; set; }

    [JsonProperty("promo")]
    [JsonPropertyName("promo")]
    public bool Promo { get; set; }

    [JsonProperty("reprint")]
    [JsonPropertyName("reprint")]
    public bool Reprint { get; set; }

    [JsonProperty("variation")]
    [JsonPropertyName("variation")]
    public bool Variation { get; set; }

    [JsonProperty("set_id")]
    [JsonPropertyName("set_id")]
    public string SetId { get; set; }

    [JsonProperty("set")]
    [JsonPropertyName("set")]
    public string Set { get; set; }

    [JsonProperty("set_name")]
    [JsonPropertyName("set_name")]
    public string SetName { get; set; }

    [JsonProperty("set_type")]
    [JsonPropertyName("set_type")]
    public string SetType { get; set; }

    [JsonProperty("set_uri")]
    [JsonPropertyName("set_uri")]
    public string SetUri { get; set; }

    [JsonProperty("set_search_uri")]
    [JsonPropertyName("set_search_uri")]
    public string SetSearchUri { get; set; }

    [JsonProperty("scryfall_set_uri")]
    [JsonPropertyName("scryfall_set_uri")]
    public string ScryfallSetUri { get; set; }

    [JsonProperty("rulings_uri")]
    [JsonPropertyName("rulings_uri")]
    public string RulingsUri { get; set; }

    [JsonProperty("prints_search_uri")]
    [JsonPropertyName("prints_search_uri")]
    public string PrintsSearchUri { get; set; }

    [JsonProperty("collector_number")]
    [JsonPropertyName("collector_number")]
    public string CollectorNumber { get; set; }

    [JsonProperty("digital")]
    [JsonPropertyName("digital")]
    public bool Digital { get; set; }

    [JsonProperty("rarity")]
    [JsonPropertyName("rarity")]
    public string Rarity { get; set; }

    [JsonProperty("card_back_id")]
    [JsonPropertyName("card_back_id")]
    public string CardBackId { get; set; }

    [JsonProperty("artist")]
    [JsonPropertyName("artist")]
    public string Artist { get; set; }

    [JsonProperty("artist_ids")]
    [JsonPropertyName("artist_ids")]
    public List<string> ArtistIds { get; set; }

    [JsonProperty("illustration_id")]
    [JsonPropertyName("illustration_id")]
    public string IllustrationId { get; set; }

    [JsonProperty("border_color")]
    [JsonPropertyName("border_color")]
    public string BorderColor { get; set; }

    [JsonProperty("frame")]
    [JsonPropertyName("frame")]
    public string Frame { get; set; }

    [JsonProperty("security_stamp")]
    [JsonPropertyName("security_stamp")]
    public string SecurityStamp { get; set; }

    [JsonProperty("full_art")]
    [JsonPropertyName("full_art")]
    public bool FullArt { get; set; }

    [JsonProperty("textless")]
    [JsonPropertyName("textless")]
    public bool Textless { get; set; }

    [JsonProperty("booster")]
    [JsonPropertyName("booster")]
    public bool Booster { get; set; }

    [JsonProperty("story_spotlight")]
    [JsonPropertyName("story_spotlight")]
    public bool StorySpotlight { get; set; }

    [JsonProperty("edhrec_rank")]
    [JsonPropertyName("edhrec_rank")]
    public int EdhrecRank { get; set; }

    [JsonProperty("preview")]
    [JsonPropertyName("preview")]
    public Preview Preview { get; set; }

    [JsonProperty("prices")]
    [JsonPropertyName("prices")]
    public Prices Prices { get; set; }

    [JsonProperty("related_uris")]
    [JsonPropertyName("related_uris")]
    public RelatedUris RelatedUris { get; set; }

    [JsonProperty("purchase_uris")]
    [JsonPropertyName("purchase_uris")]
    public PurchaseUris PurchaseUris { get; set; }
}

public class ImageUris
{
    [JsonProperty("small")]
    [JsonPropertyName("small")]
    public string Small { get; set; }

    [JsonProperty("normal")]
    [JsonPropertyName("normal")]
    public string Normal { get; set; }

    [JsonProperty("large")]
    [JsonPropertyName("large")]
    public string Large { get; set; }

    [JsonProperty("png")]
    [JsonPropertyName("png")]
    public string Png { get; set; }

    [JsonProperty("art_crop")]
    [JsonPropertyName("art_crop")]
    public string ArtCrop { get; set; }

    [JsonProperty("border_crop")]
    [JsonPropertyName("border_crop")]
    public string BorderCrop { get; set; }
}

public class Legalities
{
    [JsonProperty("standard")]
    [JsonPropertyName("standard")]
    public string Standard { get; set; }

    [JsonProperty("future")]
    [JsonPropertyName("future")]
    public string Future { get; set; }

    [JsonProperty("historic")]
    [JsonPropertyName("historic")]
    public string Historic { get; set; }

    [JsonProperty("timeless")]
    [JsonPropertyName("timeless")]
    public string Timeless { get; set; }

    [JsonProperty("gladiator")]
    [JsonPropertyName("gladiator")]
    public string Gladiator { get; set; }

    [JsonProperty("pioneer")]
    [JsonPropertyName("pioneer")]
    public string Pioneer { get; set; }

    [JsonProperty("explorer")]
    [JsonPropertyName("explorer")]
    public string Explorer { get; set; }

    [JsonProperty("modern")]
    [JsonPropertyName("modern")]
    public string Modern { get; set; }

    [JsonProperty("legacy")]
    [JsonPropertyName("legacy")]
    public string Legacy { get; set; }

    [JsonProperty("pauper")]
    [JsonPropertyName("pauper")]
    public string Pauper { get; set; }

    [JsonProperty("vintage")]
    [JsonPropertyName("vintage")]
    public string Vintage { get; set; }

    [JsonProperty("penny")]
    [JsonPropertyName("penny")]
    public string Penny { get; set; }

    [JsonProperty("commander")]
    [JsonPropertyName("commander")]
    public string Commander { get; set; }

    [JsonProperty("oathbreaker")]
    [JsonPropertyName("oathbreaker")]
    public string Oathbreaker { get; set; }

    [JsonProperty("standardbrawl")]
    [JsonPropertyName("standardbrawl")]
    public string Standardbrawl { get; set; }

    [JsonProperty("brawl")]
    [JsonPropertyName("brawl")]
    public string Brawl { get; set; }

    [JsonProperty("alchemy")]
    [JsonPropertyName("alchemy")]
    public string Alchemy { get; set; }

    [JsonProperty("paupercommander")]
    [JsonPropertyName("paupercommander")]
    public string Paupercommander { get; set; }

    [JsonProperty("duel")]
    [JsonPropertyName("duel")]
    public string Duel { get; set; }

    [JsonProperty("oldschool")]
    [JsonPropertyName("oldschool")]
    public string Oldschool { get; set; }

    [JsonProperty("premodern")]
    [JsonPropertyName("premodern")]
    public string Premodern { get; set; }

    [JsonProperty("predh")]
    [JsonPropertyName("predh")]
    public string Predh { get; set; }
}

public class Preview
{
    [JsonProperty("source")]
    [JsonPropertyName("source")]
    public string Source { get; set; }

    [JsonProperty("source_uri")]
    [JsonPropertyName("source_uri")]
    public string SourceUri { get; set; }

    [JsonProperty("previewed_at")]
    [JsonPropertyName("previewed_at")]
    public string PreviewedAt { get; set; }
}

public class Prices
{
    [JsonProperty("usd")]
    [JsonPropertyName("usd")]
    public string Usd { get; set; }

    [JsonProperty("usd_foil")]
    [JsonPropertyName("usd_foil")]
    public string UsdFoil { get; set; }

    [JsonProperty("usd_etched")]
    [JsonPropertyName("usd_etched")]
    public object UsdEtched { get; set; }

    [JsonProperty("eur")]
    [JsonPropertyName("eur")]
    public string Eur { get; set; }

    [JsonProperty("eur_foil")]
    [JsonPropertyName("eur_foil")]
    public string EurFoil { get; set; }

    [JsonProperty("tix")]
    [JsonPropertyName("tix")]
    public string Tix { get; set; }
}

public class PurchaseUris
{
    [JsonProperty("tcgplayer")]
    [JsonPropertyName("tcgplayer")]
    public string Tcgplayer { get; set; }

    [JsonProperty("cardmarket")]
    [JsonPropertyName("cardmarket")]
    public string Cardmarket { get; set; }

    [JsonProperty("cardhoarder")]
    [JsonPropertyName("cardhoarder")]
    public string Cardhoarder { get; set; }
}

public class RelatedUris
{
    [JsonProperty("gatherer")]
    [JsonPropertyName("gatherer")]
    public string Gatherer { get; set; }

    [JsonProperty("tcgplayer_infinite_articles")]
    [JsonPropertyName("tcgplayer_infinite_articles")]
    public string TcgplayerInfiniteArticles { get; set; }

    [JsonProperty("tcgplayer_infinite_decks")]
    [JsonPropertyName("tcgplayer_infinite_decks")]
    public string TcgplayerInfiniteDecks { get; set; }

    [JsonProperty("edhrec")]
    [JsonPropertyName("edhrec")]
    public string Edhrec { get; set; }
}

public class Root
{
    [JsonProperty("object")]
    [JsonPropertyName("object")]
    public string Object { get; set; }

    [JsonProperty("total_cards")]
    [JsonPropertyName("total_cards")]
    public int TotalCards { get; set; }

    [JsonProperty("has_more")]
    [JsonPropertyName("has_more")]
    public bool HasMore { get; set; }

    [JsonProperty("data")]
    [JsonPropertyName("data")]
    public List<Scryfall> Data { get; set; }
}