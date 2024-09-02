using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;

public class PythonApiService
{
    private readonly HttpClient _httpClient;
    private readonly ILogger<PythonApiService> _logger;

    public PythonApiService(HttpClient httpClient, ILogger<PythonApiService> logger)
    {
        _httpClient = httpClient;
        _logger = logger;
    }

    public async Task<string> GetRecommendationsAsync(string query)
    {
        try
        {
            var response = await _httpClient.GetAsync($"http://127.0.0.1:5000/recommend?query={query}");

            response.EnsureSuccessStatusCode();
            return await response.Content.ReadAsStringAsync();
        }
        catch (HttpRequestException e)
        {
            _logger.LogError(e, "Error while calling Python API");
            return null;
        }
    }
}
