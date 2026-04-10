using System.ComponentModel.DataAnnotations;

public class User
{
    [Key]
    public int Id{get;set;}
    [Required]
    [EmailAddress]
    [MaxLength(255)]
    public string Email{get;set;}
    [Required]
    public string Password{get;set;}
    public string Image{get;set;}="";
    public string SearchHistory{get;set;}="[]";

}