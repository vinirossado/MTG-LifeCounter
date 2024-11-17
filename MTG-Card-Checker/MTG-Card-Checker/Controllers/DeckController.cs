using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc;
using MTG_Card_Checker.Model;
using MTG_Card_Checker.Repository;
using MTG_Card_Checker.Repository.External.Scryfall;

namespace MTG_Card_Checker.Controllers;

[ApiController]
[Route("api/[controller]")]
public class DeckController(DeckService deckService, CardService cardService, ScryfallService scryfallService) : ControllerBase
{
    [HttpPost]
    public async Task<IActionResult> Create([Required] Deck deck)
    {
        await deckService.AddDeck(deck);

        return Created();
    }

    [HttpPost("/upload-deck")]
    public async Task<IActionResult> UploadDeck([Required] int deckId, IFormFile file)
    {
        // Read cards from the uploaded file
        var cards = await cardService.ReadCardsFromTextFile(file);
        if (!cards.Any())
            return BadRequest("No valid cards found in the file.");

        // Fetch missing cards
        var (newCards, existingCardIds) = await cardService.GetMissingCards(cards);

        // Fetch details for new cards from Scryfall and save them
        var fetchAndSaveNewCardsTask = FetchAndSaveNewCardsAsync(newCards);

        // Prepare deck-card associations
        var cardsDeck = PrepareCardDeckAssociations(deckId, newCards, existingCardIds);

        // Save cards in the deck
        var uploadCardsTask = deckService.UploadCards(cardsDeck);

        // Wait for all tasks to complete
        await Task.WhenAll(fetchAndSaveNewCardsTask, uploadCardsTask);

        return CreatedAtAction(nameof(UploadDeck), new { deckId }, null);
    }

    private async Task FetchAndSaveNewCardsAsync(IList<Card> newCards)
    {
        if (!newCards.Any())
            return;

        await scryfallService.GetCard(newCards);
        await cardService.Add(newCards);
    }

    private List<CardDeck> PrepareCardDeckAssociations(int deckId, IEnumerable<Card> newCards, IEnumerable<int> existingCardIds)
    {
        var cardsDeck = new List<CardDeck>();

        // Add new cards
        cardsDeck.AddRange(newCards.Select(card => new CardDeck
        {
            DeckId = deckId,
            CardId = card.Id
        }));
        
        // Add existing cards
        cardsDeck.AddRange(existingCardIds.Select(cardId => new CardDeck
        {
            DeckId = deckId,
            CardId = cardId
        }));

        return cardsDeck;
    }

    [HttpPut]
    public async Task<IActionResult> Update([Required] Deck deck)
    {
        await deckService.UpdateDeck(deck);

        return Ok(deck);
    }

    [HttpGet]
    public async Task<ActionResult<IList<Deck>>> Get()
    {
        var decks = await deckService.GetDecks();

        return Ok(decks);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById([Required] int id)
    {
        var deck = await deckService.GetDeckById(id);
        if (deck is null)
        {
            return NotFound("Deck not found");
        }

        return Ok(deck);
    }
}