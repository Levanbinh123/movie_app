using Microsoft.EntityFrameworkCore;

public class AppDbContext : DbContext
{
    public DbSet<User>Users{get;set;}
    public DbSet<SearchHistory> SearchHistories{get;set;}
    public AppDbContext(DbContextOptions<AppDbContext>options):base(options){}
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<User>()
            .HasIndex(u => u.Email)
            .IsUnique();
    }
}