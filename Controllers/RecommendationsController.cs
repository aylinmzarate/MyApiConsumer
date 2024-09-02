using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

[Route("api/[controller]")]
[ApiController]
public class RecommendationsController : ControllerBase
{
    private readonly PythonApiService _pythonApiService;

    public RecommendationsController(PythonApiService pythonApiService)
    {
        _pythonApiService = pythonApiService;
    }

    [HttpGet]
    public async Task<IActionResult> Get(string query)
    {
        if (string.IsNullOrEmpty(query))
        {
            return BadRequest("Query parameter is required");
        }

        var recommendations = await _pythonApiService.GetRecommendationsAsync(query);
        if (recommendations == null)
        {
            return StatusCode(500, "Error retrieving data from Python API");
        }

        return Ok(recommendations);
    }
}
