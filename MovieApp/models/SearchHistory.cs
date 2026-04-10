public class SearchHistory
{
    public int Id { get; set; }

    public int ItemId { get; set; }
    public string Title { get; set; }
    public string Image { get; set; }
    public string SearchType { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.Now;

    public int UserId { get; set; }
    public User User { get; set; }
}