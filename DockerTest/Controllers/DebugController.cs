using Microsoft.AspNetCore.Mvc;
using System;

namespace DockerTest.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DebugController : ControllerBase
    {
        [HttpGet]
        public ActionResult<string> Get()
        {
            return Environment.GetEnvironmentVariable("COMPUTERNAME") ??
                   Environment.GetEnvironmentVariable("HOSTNAME");
        }

    }
}
