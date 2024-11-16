using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc;
using MTG_Card_Checker.Model;
using MTG_Card_Checker.Repository;

namespace MTG_Card_Checker.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PlayerController(PlayerService playerService) : ControllerBase
{

    [HttpPost]
    public async Task<IActionResult> Create([Required] PlayerDto playerDto)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest("Invalid data");
        }
        
        var user = new Player()
        {
            Name = playerDto.Name,
            DeckName = playerDto.DeckName,
            Nationality = playerDto.Nationality,
        };
        
        await playerService.Create(user);
        
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