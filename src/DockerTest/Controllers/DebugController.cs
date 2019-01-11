using Microsoft.AspNetCore.Mvc;
using System;
using Business;

namespace DockerTest.Controllers
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
        public ActionResult<string> Get()
        {
            var host = _service.GetHostName();
            return $"Host is: {host}";
        }

    }
}
