using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EuthanasiaMonkey
{
    public class EnvironmentVarsHelper : IEnvironmentVarsHelper
    {
        public const string ImmunityTagsEnv = "IMMUNITY_TAG_NAMES";
        public const string MaxAgeEnv = "MAX_AGE_IN_DAYS";
        public const string DryRunEnv = "DRY_RUN";
        public const string IgnoreATPEnv = "IGNORE_ATP";

        public const int MaxAgeIfNotSpecified = 7;

        public bool IsDryRun
        {
            get
            {
                bool dryRun;
                if (bool.TryParse(Environment.GetEnvironmentVariable(DryRunEnv), out dryRun))
                {
                    return dryRun;
                }
                else
                {
                    return true;
                }
            }
        }

        public bool IgnoreApiTerminationProtection
        {
            get
            {
                bool ignoreATP;
                if (bool.TryParse(Environment.GetEnvironmentVariable(IgnoreATPEnv), out ignoreATP))
                {
                    return ignoreATP;
                }
                else
                {
                    return true;
                }
            }
        }

        public DateTime GetMaxAge()
        {
            int maxAge;
            if (int.TryParse(Environment.GetEnvironmentVariable(MaxAgeEnv), out maxAge))
            {
                return DateTime.UtcNow.AddDays(-maxAge);
            }
            return DateTime.UtcNow.AddDays(-MaxAgeIfNotSpecified);
        }

        public IEnumerable<string> GetImmunities()
        {
            var qry = from t in Environment.GetEnvironmentVariable(ImmunityTagsEnv).Split(',')
                      select t.Trim().ToLower();
            return qry.ToList();
        }
    }
}