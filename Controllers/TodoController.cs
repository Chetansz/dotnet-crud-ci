using Microsoft.AspNetCore.Mvc;
using DotnetCrudApi.Models;
using System.Collections.Concurrent;

namespace DotnetCrudApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TodoController : ControllerBase
    {
        private static readonly ConcurrentDictionary<long, TodoItem> _todos = new();
        private static long _lastId = 0;

        [HttpGet]
        public ActionResult<IEnumerable<TodoItem>> Get() => Ok(_todos.Values);

        [HttpGet("{id}")]
        public ActionResult<TodoItem> Get(long id)
        {
            if (_todos.TryGetValue(id, out var item))
            {
                return Ok(item);
            }
            return NotFound(new { message = $"Todo item with ID {id} not found" });
        }

        [HttpPost]
        public ActionResult<TodoItem> Post([FromBody] TodoItem item)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            item.Id = Interlocked.Increment(ref _lastId);
            
            if (!_todos.TryAdd(item.Id, item))
            {
                return StatusCode(500, new { message = "Failed to create todo item" });
            }

            return CreatedAtAction(nameof(Get), new { id = item.Id }, item);
        }

        [HttpPut("{id}")]
        public IActionResult Put(long id, [FromBody] TodoItem item)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (!_todos.TryGetValue(id, out var existingItem))
            {
                return NotFound(new { message = $"Todo item with ID {id} not found" });
            }

            var updatedItem = new TodoItem
            {
                Id = id,
                Name = item.Name,
                IsComplete = item.IsComplete
            };

            if (!_todos.TryUpdate(id, updatedItem, existingItem))
            {
                return StatusCode(500, new { message = "Failed to update todo item" });
            }

            return NoContent();
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(long id)
        {
            if (!_todos.TryRemove(id, out _))
            {
                return NotFound(new { message = $"Todo item with ID {id} not found" });
            }

            return NoContent();
        }
    }
}
