using Microsoft.AspNetCore.Mvc;
using System.Text.Json;

[ApiController]
[Route("api/v1/tv")]
public class TvController : ControllerBase
{
    private readonly TmdbService _tmdb;

    public TvController(TmdbService tmdb)
    {
        _tmdb = tmdb;
    }

    // ================= TRENDING =================
    [HttpGet("trending")]
    public async Task<IActionResult> Trending()
    {
        var json = await _tmdb.Fetch("https://api.themoviedb.org/3/trending/tv/day?language=en-US");

        var doc = JsonDocument.Parse(json);
        var results = doc.RootElement.GetProperty("results").EnumerateArray().ToList();

        if (results.Count == 0)
            return NotFound();

        var random = results[new Random().Next(results.Count)];

        return Ok(new
        {
            success = true,
            content = random
        });
    }

    // ================= POPULAR =================
    [HttpGet("popular")]
    public async Task<IActionResult> Popular()
    {
        var json = await _tmdb.Fetch("https://api.themoviedb.org/3/tv/popular?language=en-US&page=1");

        var doc = JsonDocument.Parse(json);

        return Ok(new
        {
            success = true,
            content = doc.RootElement.GetProperty("results")
        });
    }

    // ================= DETAIL =================
    [HttpGet("{id}")]
    public async Task<IActionResult> Detail(int id)
    {
        try
        {
            var json = await _tmdb.Fetch($"https://api.themoviedb.org/3/tv/{id}?language=en-US");

            return Ok(new
            {
                success = true,
                content = JsonDocument.Parse(json).RootElement
            });
        }
        catch (Exception e)
        {
            if (e.Message.Contains("404"))
                return NotFound();

            return StatusCode(500, new { success = false });
        }
    }

[HttpGet("{id}/trailer")]
public async Task<IActionResult> Trailer(int id)
{
    try
    {
        var json = await _tmdb.Fetch(
            $"https://api.themoviedb.org/3/tv/{id}/videos?language=en-US"
        );

        using var doc = JsonDocument.Parse(json);

       
       
        var trailers = doc.RootElement
            .GetProperty("results")
            .EnumerateArray()
            .Select(x =>
            {
                string GetString(string name)
                {
                    return x.TryGetProperty(name, out var val) && val.ValueKind != JsonValueKind.Null
                        ? val.GetString()
                        : null;
                }

                int? GetInt(string name)
                {
                    return x.TryGetProperty(name, out var val) && val.ValueKind != JsonValueKind.Null
                        ? val.GetInt32()
                        : null;
                }

                bool? GetBool(string name)
                {
                    return x.TryGetProperty(name, out var val) && val.ValueKind != JsonValueKind.Null
                        ? val.GetBoolean()
                        : null;
                }

                return new
                {
                    iso_639_1 = GetString("iso_639_1"),
                    iso_3166_1 = GetString("iso_3166_1"),
                    name = GetString("name"),
                    key = GetString("key"),
                    site = GetString("site"),
                    size = GetInt("size"),
                    type = GetString("type"),
                    official = GetBool("official"),
                    published_at = GetString("published_at"),
                    id = GetString("id")
                };
            })
            .ToList();
            
            if (!doc.RootElement.TryGetProperty("results",out var rawResults))
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = "Invalid TMDB response"
                });
            }

        return Ok(new
        {
            success = true,
            trailers = trailers
        });
    }
    catch (Exception e)
    {
        return StatusCode(500, new
        {
            success = false,
            message = e.Message
        });
    }
}
    // ================= SIMILAR =================
    [HttpGet("{id}/similar")]
    public async Task<IActionResult> Similar(int id)
    {
        var json = await _tmdb.Fetch($"https://api.themoviedb.org/3/tv/{id}/similar?language=en-US&page=1");

        var doc = JsonDocument.Parse(json);

        return Ok(new
        {
            success = true,
            content = doc.RootElement.GetProperty("results")
        });
    }

    // ================= RECOMMEND =================
    [HttpGet("{id}/recommendations")]
    public async Task<IActionResult> Recommend(int id)
    {
        var json = await _tmdb.Fetch($"https://api.themoviedb.org/3/tv/{id}/recommendations?language=en-US&page=1");

        var doc = JsonDocument.Parse(json);

        return Ok(new
        {
            success = true,
            content = doc.RootElement.GetProperty("results")
        });
    }

    // ================= CATEGORY =================
    [HttpGet("category/{category}")]
    public async Task<IActionResult> Category(string category)
    {
        var json = await _tmdb.Fetch($"https://api.themoviedb.org/3/tv/{category}?language=en-US&page=1");

        var doc = JsonDocument.Parse(json);

        return Ok(new
        {
            success = true,
            content = doc.RootElement.GetProperty("results")
        });
    }

    // ================= KEYWORDS =================
    [HttpGet("{id}/keywords")]
    public async Task<IActionResult> Keywords(int id)
    {
        var json = await _tmdb.Fetch($"https://api.themoviedb.org/3/tv/{id}/keywords");

        var doc = JsonDocument.Parse(json);

        return Ok(new
        {
            success = true,
            content = doc.RootElement.GetProperty("results")
        });
    }
}