using System.Collections;

namespace Business
{
    public interface ISomeService
    {
        string GetHostName();
        string GetMainProjectName();
        IDictionary GetAllEnvironmentVariables();
    }
}