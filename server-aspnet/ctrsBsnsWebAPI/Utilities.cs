using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Threading.Tasks;

namespace CtrsBsnsWebAPI
{
    public static class Utilities
    {

        public static Dictionary<string, JsonElement> GetFlat(string json)
        {
            IEnumerable<(string Path, JsonProperty P)> GetLeaves(string path, JsonProperty p)
                => p.Value.ValueKind != JsonValueKind.Object
                    ? new[] { (Path: path == null ? p.Name : path + "." + p.Name, p) }
                    : p.Value.EnumerateObject().SelectMany(child => GetLeaves(path == null ? p.Name : path + "." + p.Name, child));

            using (JsonDocument document = JsonDocument.Parse(json)) // Optional JsonDocumentOptions options
                return document.RootElement.EnumerateObject()
                    .SelectMany(p => GetLeaves(null, p))
                    .ToDictionary(k => k.Path, v => v.P.Value.Clone()); //Clone so that we can use the values outside of using
        }

        static IEnumerable<(string Path, JsonProperty P)> GetLeaves(string path, JsonProperty p)
        {
            path = (path == null) ? p.Name : path + "." + p.Name;
            if (p.Value.ValueKind != JsonValueKind.Object)
                yield return (Path: path, P: p);
            else
                foreach (JsonProperty child in p.Value.EnumerateObject())
                    foreach (var leaf in GetLeaves(path, child))
                        yield return leaf;
        }

    }
}
