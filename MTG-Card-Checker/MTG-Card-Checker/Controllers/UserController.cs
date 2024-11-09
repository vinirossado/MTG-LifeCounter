using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc;
using MTG_Card_Checker.Model;
using MTG_Card_Checker.Repository;

namespace MTG_Card_Checker.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UserController(UserService userService) : ControllerBase
{

    [HttpPost]
    public async Task<IActionResult> Create([Required] User user)
    {
        await userService.Create(user);
        
        return Created();
    }
    
    [HttpGet]
    public async Task<ActionResult<IList<Card>>> Get()
    {
        var users = await userService.Get();
            
        return Ok(users);
    }
    
    [HttpGet("{id}")]
    public async Task<IActionResult> GetById([Required] int id)
    {
        var user = await userService.GetById(id);
        if (user is null)
        {
            return NotFound("User not found");
        }
        
        return Ok(user);
    }
}