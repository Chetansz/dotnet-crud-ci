using System.ComponentModel.DataAnnotations;

namespace DotnetCrudApi.Models
{
    public class TodoItem
    {
        public long Id { get; set; }
        
        [Required]
        [StringLength(100)]
        public string Name { get; set; } = string.Empty;
        
        public bool IsComplete { get; set; }
    }
}
