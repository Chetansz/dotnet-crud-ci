using Microsoft.AspNetCore.Mvc;
using DotnetCrudApi.Models;

namespace DotnetCrudApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TodoController : ControllerBase
    {
        private static List<TodoItem> todos = new();

        [HttpGet]
        public ActionResult<IEnumerable<TodoItem>> Get() => todos;

        [HttpGet("{id}")]
        public ActionResult<TodoItem> Get(long id)
        {
            var item = todos.FirstOrDefault(x => x.Id == id);
            if (item == null) return NotFound();
            return item;
        }

        [HttpPost]
        public ActionResult<TodoItem> Post(TodoItem item)
        {
            item.Id = todos.Count + 1;
            todos.Add(item);
            return CreatedAtAction(nameof(Get), new { id = item.Id }, item);
        }

        [HttpPut("{id}")]
        public IActionResult Put(long id, TodoItem item)
        {
            var existing = todos.FirstOrDefault(x => x.Id == id);
            if (existing == null) return NotFound();
            existing.Name = item.Name;
            existing.IsComplete = item.IsComplete;
            return NoContent();
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(long id)
        {
            var item = todos.FirstOrDefault(x => x.Id == id);
            if (item == null) return NotFound();
            todos.Remove(item);
            return NoContent();
        }
    }
}
