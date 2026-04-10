using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
[ApiController]
[Route("api/v1/auth")]
public class AuthController : ControllerBase
{
    private readonly AppDbContext _context;
    private readonly JwtService _jwt;
    public AuthController(AppDbContext context, JwtService jwt)
    {
        _context=context;
        _jwt=jwt;
    }
    
  [HttpPost("signup")]
    public async Task<IActionResult> Signup([FromBody] AuthRequest req)
    {
        if (string.IsNullOrEmpty(req.Email) || string.IsNullOrEmpty(req.Password))
            return BadRequest(new { success = false, message = "All fields are required" });

        if (!req.Email.Contains("@"))
            return BadRequest(new { success = false, message = "Invalid email" });

        if (req.Password.Length < 6)
            return BadRequest(new { success = false, message = "Password must be at least 6 characters" });

        if (_context.Users.Any(x => x.Email == req.Email))
            return BadRequest(new { success = false, message = "Email already exists" });

        var images = new[] { "/avatar1.png", "/avatar2.png", "/avatar3.png" };
        var random = new Random();

        var user = new User
        {
            Email = req.Email,
            Password = BCrypt.Net.BCrypt.HashPassword(req.Password),
            Image = images[random.Next(images.Length)]
        };

        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        var token = _jwt.GenerateToken(user.Id);

        return Ok(new
        {
            success = true,
            user = new
            {
                user.Id,
                user.Email,
                user.Image,
                token
            }
        });
    }

 [HttpPost("signin")]
    public IActionResult Login([FromBody] AuthRequest req)
    {
        if (string.IsNullOrEmpty(req.Email) || string.IsNullOrEmpty(req.Password))
            return BadRequest(new { success = false, message = "All fields are required" });

        var user = _context.Users.FirstOrDefault(x => x.Email == req.Email);

        if (user == null || !BCrypt.Net.BCrypt.Verify(req.Password, user.Password))
            return BadRequest(new { success = false, message = "Invalid credentials" });

        var token = _jwt.GenerateToken(user.Id);

        return Ok(new
        {
            success = true,
            user = new
            {
                user.Id,
                user.Email,
                user.Image,
                token
            }
        });
    }

    [HttpPost("logout")]
    public IActionResult Logout()
    {
        // Nếu dùng cookie thì clear
        Response.Cookies.Delete("jwt");

        return Ok(new { success = true, message = "Logged out" });
    }
      [Authorize]
      [HttpGet("me")]
    public IActionResult AuthCheck()
    {
        var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

        if (userId == null)
            return Unauthorized(new { success = false });
        var user = _context.Users.Find(int.Parse(userId));
        return Ok(new
        {
            success = true,
            user
        });
    }

}