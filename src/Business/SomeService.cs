using System;
using System.Collections;

namespace Business
{
    public class SomeService : ISomeService
    {
        public string GetHostName() => 
            Environment.GetEnvironmentVariable("COMPUTERNAME") ??
            Environment.GetEnvironmentVariable("HOSTNAME");

        public string GetMainProjectName() =>
            Environment.GetEnvironmentVariable("MAIN_PROJECT_NAME");

        public IDictionary GetAllEnvironmentVariables() =>
            Environment.GetEnvironmentVariables();
    }
}
