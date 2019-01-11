using Business;
using Microsoft.AspNetCore.Mvc;

namespace MainApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DebugController : ControllerBase
    {
        private readonly ISomeService _service;

        public DebugController(ISomeService service)
        {
            _service = service;
        }

        [HttpGet]
        public ActionResult<object> Get()
        {
            return new
            {
                Host = _service.GetHostName(),
                MainProject = _service.GetMainProjectName(),
                All = _service.GetAllEnvironmentVariables()
            };
        }
    }
}
