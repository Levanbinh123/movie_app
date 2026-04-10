using Microsoft.AspNetCore.Mvc;
using System.Text.Json;

[ApiController]
[Route("api/v1/movie")]
public class MovieController : ControllerBase
{
    private readonly TmdbService _tmdb;

    public MovieController(TmdbService tmdb)
    {
        _tmdb = tmdb;
    }

    // ================= TRENDING =================
    [HttpGet("trending")]
    public async Task<IActionResult> Trending()
    {
        var json = await _tmdb.Fetch("https://api.themoviedb.org/3/trending/movie/day?language=en-US");

        using var doc = JsonDocument.Parse(json);

        if (!doc.RootElement.TryGetProperty("results", out var results))
            return StatusCode(500, new { success = false });

        var data = results
            .EnumerateArray()
            .Take(5)
            .Select(x => x.Clone())
            .ToList();

        return Ok(new
        {
            success = true,
            content = data
        });
    }

    // ================= NOW PLAYING =================
    [HttpGet("nowplaying")]
    public async Task<IActionResult> NowPlaying()
    {
        var json = await _tmdb.Fetch("https://api.themoviedb.org/3/movie/now_playing");

        using var doc = JsonDocument.Parse(json);

        if (!doc.RootElement.TryGetProperty("results", out var results))
            return StatusCode(500, new { success = false });

        return Ok(new
        {
            success = true,
            content = results.Clone()
        });
    }

    // ================= DETAIL =================
    [HttpGet("{id}")]
    public async Task<IActionResult> Detail(int id)
    {
        try
        {
            var json = await _tmdb.Fetch($"https://api.themoviedb.org/3/movie/{id}?language=en-US");

            using var doc = JsonDocument.Parse(json);

            return Ok(new
            {
                success = true,
                content = doc.RootElement.Clone()
            });
        }
        catch (Exception e)
        {
            if (e.Message.Contains("404"))
                return NotFound();

            return StatusCode(500, new { success = false });
        }
    }

    // ================= TRAILER =================
    [HttpGet("{id}/trailer")]
    public async Task<IActionResult> Trailer(int id)
    {
        try
        {
            var json = await _tmdb.Fetch(
                $"https://api.themoviedb.org/3/movie/{id}/videos?language=en-US"
            );

            using var doc = JsonDocument.Parse(json);

            if (!doc.RootElement.TryGetProperty("results", out var results))
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = "Invalid TMDB response"
                });
            }

            var videos = results.EnumerateArray().ToList();

            // Ưu tiên Trailer
            var trailer = videos.FirstOrDefault(x =>
                x.TryGetProperty("type", out var type) &&
                type.GetString() == "Trailer" &&
                x.TryGetProperty("site", out var site) &&
                site.GetString() == "YouTube"
            );

            // fallback Teaser
            if (trailer.ValueKind == JsonValueKind.Undefined)
            {
                trailer = videos.FirstOrDefault(x =>
                    x.TryGetProperty("type", out var type) &&
                    type.GetString() == "Teaser" &&
                    x.TryGetProperty("site", out var site) &&
                    site.GetString() == "YouTube"
                );
            }

            if (trailer.ValueKind == JsonValueKind.Undefined)
            {
                return NotFound(new
                {
                    success = false,
                    message = "Trailer not found"
                });
            }

            return Ok(new
            {
                success = true,
                trailer = trailer.Clone()
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
        var json = await _tmdb.Fetch($"https://api.themoviedb.org/3/movie/{id}/similar?language=en-US&page=1");

        using var doc = JsonDocument.Parse(json);

        if (!doc.RootElement.TryGetProperty("results", out var results))
            return StatusCode(500, new { success = false });

        return Ok(new
        {
            success = true,
            content = results.Clone()
        });
    }

    // ================= RECOMMEND =================
    [HttpGet("{id}/recommend")]
    public async Task<IActionResult> Recommend(int id)
    {
        var json = await _tmdb.Fetch($"https://api.themoviedb.org/3/movie/{id}/recommendations?language=en-US&page=1");

        using var doc = JsonDocument.Parse(json);

        if (!doc.RootElement.TryGetProperty("results", out var results))
            return StatusCode(500, new { success = false });

        return Ok(new
        {
            success = true,
            content = results.Clone()
        });
    }

    // ================= CATEGORY =================
    [HttpGet("category/{category}")]
    public async Task<IActionResult> Category(string category)
    {
        var json = await _tmdb.Fetch($"https://api.themoviedb.org/3/movie/{category}?language=en-US&page=1");

        using var doc = JsonDocument.Parse(json);

        if (!doc.RootElement.TryGetProperty("results", out var results))
            return StatusCode(500, new { success = false });

        return Ok(new
        {
            success = true,
            content = results.Clone()
        });
    }
}