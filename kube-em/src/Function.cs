using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EuthanasiaMonkey
{
    public class Function
    {
        public async Task FunctionHandler(Dictionary<string, object> input, ILambdaContext context)
        {
            var config = KubernetesClientConfiguration.InClusterConfig()

            // Use the config object to create a client.
            var client = new Kubernetes(config);

            var namespaces = client.ListNamespace();

            var victims = new List<string>();

            var immunities = Env.GetImmunities();
            DateTime maxAge = Env.GetMaxAge();

            foreach (var ns in namespaces.Items) {
                Console.WriteLine(ns.Metadata.Name);
                var list = client.ListNamespacedPod(ns.Metadata.Name);
                foreach (var item in list.Items)
                {
                    response = await K8s.DescribePodsAsync(req);

                    var newVictims = from i in list.Items
                                        where i.LaunchTime < maxAge && i.Labels.Count(t => immunities.Contains(t.Key.ToLower())) == 0
                                        select i.Name;

                    victims.AddRange(newVictims);
                }
            }

            if (victims.Count > 0)
            {
                if (Env.IsDryRun)
                {
                    context.Logger.LogLine($"I would have terminated {string.Join(", ", victims)} if this had been for real...");
                }
                else
                {
                    context.Logger.LogLine($"I'm terminating {string.Join(", ", victims)}.");
                    victims.ForEach(v => client.DeleteNamespacedPod(v));
                }
            }
            else
            {
                context.Logger.LogLine("Nothing to euthanise");
            }
        }

        /// <summary>
        /// property injection
        /// </summary>
        public KubernetesSDK K8s
        {
            get
            {
                if (k8s == null)
                {
                    k8s = new AmazonEC2Client();
                }
                return k8s;
            }

            set { k8s = value; }
        }
        private KubernetesSDK k8s;


        public IEnvironmentVarsHelper Env
        {
            get
            {
                if (env == null)
                {
                    env = new EnvironmentVarsHelper();
                }
                return env;
            }
            set
            {
                env = value;
            }
        }
        private IEnvironmentVarsHelper env;

    }
}