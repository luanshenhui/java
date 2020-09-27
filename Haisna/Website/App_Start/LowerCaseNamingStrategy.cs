using Newtonsoft.Json.Serialization;

#pragma warning disable CS1591

namespace Website
{
    public class LowerCaseNamingStrategy : DefaultNamingStrategy
    {
        protected override string ResolvePropertyName(string name)
        {
            return name.ToLower();
        }
    };
}