using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc;
using MTG_Card_Checker.Model;
using MTG_Card_Checker.Repository;

namespace MTG_Card_Checker.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PlayerController(PlayerService playerService, DeckService deckService) : ControllerBase
{
    //DATA TRANSFER OBJECT(Dto)
    [HttpPost]
    public async Task<IActionResult> Create([Required] PlayerDto playerDto)
    {
        var player = new Player()
        {
            Name = playerDto.Name,
            Nationality = playerDto.Nationality,
        };
        
        var playerId = await playerService.Create(player);
        
        var deck = new Deck()
        {
            Name = playerDto.DeckName,
            Strategy = playerDto.Strategy,
            PlayerId = playerId,
        };
        
        await deckService.AddDeck(deck);
        
        return Created();
    }
    
    [HttpGet]
    public async Task<ActionResult<IList<Card>>> Get()
    {
        var players = await playerService.Get();
            
        return Ok(players);
    }
    
    [HttpGet("{id}")]
    public async Task<IActionResult> GetById([Required] int id)
    {
        var player = await playerService.GetById(id);
        if (player is null)
        {
            return NotFound("Player not found");
        }
        
        return Ok(player);
    }
}