using SPTarkov.Server.Core.Models.Spt.Mod;
using Range = SemanticVersioning.Range;

namespace Epic_Shaders;

public record ModMetadata : AbstractModMetadata
{
    public override string ModGuid { get; init; } = "com.epicrangetime.shaders";
    public override string Name { get; init; } = "Epic Shaders";
    public override string Author { get; init; } = "EpicRangeTime";
    public override List<string>? Contributors { get; init; } = null;
    public override SemanticVersioning.Version Version { get; init; } = new(typeof(ModMetadata).Assembly.GetName().Version?.ToString(3));
    public override Range SptVersion { get; init; } = new("~4.0.0");
    public override List<string>? Incompatibilities { get; init; }
    public override Dictionary<string, Range>? ModDependencies { get; init; } = new() 
        {};
    public override string? Url { get; init; }
    public override bool? IsBundleMod { get; init; } = true;
    public override string License { get; init; } = "CC BY-NC-ND 4.0";
}
