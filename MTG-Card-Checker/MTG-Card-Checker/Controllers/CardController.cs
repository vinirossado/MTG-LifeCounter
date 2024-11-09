using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc;
using MTG_Card_Checker.Model;
using MTG_Card_Checker.Repository;

namespace MTG_Card_Checker.Controllers;

[ApiController]
[Route("api/[controller]")]
public class CardController(CardService cardService) : ControllerBase
{
    [HttpPost("/upload-cards")]
    [Consumes("multipart/form-data")]
    public async Task<IActionResult> UploadCards([Required] IFormFile file)
    {
        if (file.Length == 0)
        {
            return BadRequest("No file was uploaded");
        }

        if (!file.FileName.EndsWith(".csv", StringComparison.OrdinalIgnoreCase))
        {
            return BadRequest("Invalid file type");
        }

        await cardService.ImportDatabase(file);

        return Ok();
    }

    [HttpPost("/want-list")]
    [Consumes("multipart/form-data")]
    public async Task<ActionResult<(List<Card> foundCards, List<Card> missingCards)>> WantList([Required] IFormFile file)
    {
        if (file.Length == 0)
        {
            return BadRequest("No file was uploaded");
        }

        if (!file.FileName.EndsWith(".txt", StringComparison.OrdinalIgnoreCase))
        {
            return BadRequest("Invalid file type");
        }

        var (foundCards, missingCards) = await cardService.CompareWantListWithDb(file);
        
        var response = new WantListResponse
        {
            FoundCards = foundCards,
            MissingCards = missingCards
        };
        
        return Ok(response);
    }
}

public class WantListResponse
{
    public List<Card> FoundCards { get; set; }
    public List<Card> MissingCards { get; set; }
}