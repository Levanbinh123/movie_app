using System.Net.Http.Headers;

public class TmdbService
{
    private readonly HttpClient _http;
    private readonly IConfiguration _config;

    public TmdbService(HttpClient http, IConfiguration config)
    {
        _http = http;
        _config = config;
    }

    public async Task<string> Fetch(string url)
    {
        var req = new HttpRequestMessage(HttpMethod.Get, url);

        req.Headers.Authorization = new AuthenticationHeaderValue(
            "Bearer", _config["TMDB:ApiKey"]
        );

        var res = await _http.SendAsync(req);

        if (!res.IsSuccessStatusCode)
            throw new Exception("TMDB error");

        return await res.Content.ReadAsStringAsync();
    }
}