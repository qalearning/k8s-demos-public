using System;
using System.Collections.Generic;

namespace EuthanasiaMonkey
{
    public interface IEnvironmentVarsHelper
    {

        bool IsDryRun { get; }
        bool IgnoreApiTerminationProtection { get; }

        IEnumerable<string> GetImmunities();
        DateTime GetMaxAge();
    }
}