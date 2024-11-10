using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc;
using MTG_Card_Checker.Model;
using MTG_Card_Checker.Repository;

namespace MTG_Card_Checker.Controllers;


[ApiController]
[Route("api/[controller]")]

public class DeckController(DeckService deckService) : ControllerBase
{
    [HttpPost]
    public async Task<IActionResult> Create([Required] Deck deck)
    {
        await deckService.AddDeck(deck);
        
        return Created();
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