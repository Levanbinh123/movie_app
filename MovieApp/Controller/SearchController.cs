using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Text.Json;
[Authorize]
[ApiController]
[Route("api/v1/search")]
public class SearchController : ControllerBase
{
    private readonly TmdbService _tmdb;
    private readonly AppDbContext _context;

    public SearchController(TmdbService tmdb, AppDbContext context)
    {
        _tmdb = tmdb;
        _context = context;
    }
        private int GetUserId()
    {
        return int.Parse(User.FindFirst(ClaimTypes.NameIdentifier).Value);
    }


      [HttpGet("movie/{query}")]
    public async Task<IActionResult> SearchMovie(string query)
    {
        var json = await _tmdb.Fetch(
            $"https://api.themoviedb.org/3/search/movie?query={query}&language=en-US&page=1"
        );

        var doc = JsonDocument.Parse(json);

        if (!doc.RootElement.TryGetProperty("results", out var results))
            return StatusCode(500);

        var list = results.EnumerateArray().ToList();

        if (list.Count == 0)
            return NotFound();

        var first = list[0];

        var history = new SearchHistory
        {
            Id = first.GetProperty("id").GetInt32(),
            Image = first.GetProperty("poster_path").GetString(),
            Title = first.GetProperty("title").GetString(),
            SearchType = "movie",
            UserId = GetUserId()
        };

        _context.Add(history);
        await _context.SaveChangesAsync();

        return Ok(new
        {
            success = true,
            content = list
        });
    }
      [HttpGet("person/{query}")]
    public async Task<IActionResult> SearchPerson(string query)
    {
        var json = await _tmdb.Fetch(
            $"https://api.themoviedb.org/3/search/person?query={query}&language=en-US&page=1"
        );

        var doc = JsonDocument.Parse(json);
        var list = doc.RootElement.GetProperty("results").EnumerateArray().ToList();

        if (list.Count == 0)
            return NotFound();

        var first = list[0];

        var history = new SearchHistory
        {
            Id = first.GetProperty("id").GetInt32(),
            Image = first.GetProperty("profile_path").GetString(),
            Title = first.GetProperty("name").GetString(),
            SearchType = "person",
            UserId = GetUserId()
        };

        _context.Add(history);
        await _context.SaveChangesAsync();

        return Ok(new { success = true, content = list });
    }

 [HttpGet("tv/{query}")]
    public async Task<IActionResult> SearchTv(string query)
    {
        var json = await _tmdb.Fetch(
            $"https://api.themoviedb.org/3/search/tv?query={query}&language=en-US&page=1"
        );

        var doc = JsonDocument.Parse(json);
        var list = doc.RootElement.GetProperty("results").EnumerateArray().ToList();

        if (list.Count == 0)
            return NotFound();

        var first = list[0];

        var history = new SearchHistory
        {
            Id = first.GetProperty("id").GetInt32(),
            Image = first.GetProperty("poster_path").GetString(),
            Title = first.GetProperty("name").GetString(),
            SearchType = "tv",
            UserId = GetUserId()
        };

        _context.Add(history);
        await _context.SaveChangesAsync();

        return Ok(new { success = true, content = list });
    }
      [HttpGet("history")]
    public IActionResult GetHistory()
    {
        var userId = GetUserId();

        var history = _context.Set<SearchHistory>()
            .Where(x => x.UserId == userId)
            .OrderByDescending(x => x.CreatedAt)
            .ToList();

        return Ok(new { success = true, content = history });
    }
 [HttpDelete("history/{id}")]
    public async Task<IActionResult> DeleteHistory(int id)
    {
        var userId = GetUserId();

        var item = _context.Set<SearchHistory>()
            .FirstOrDefault(x => x.Id == id && x.UserId == userId);

        if (item == null)
            return NotFound();

        _context.Remove(item);
        await _context.SaveChangesAsync();

        return Ok(new { success = true });
    }
}