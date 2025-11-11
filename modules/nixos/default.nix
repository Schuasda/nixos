{
  lib,
  ...
}:
with lib;
{
  options.deskenv = {
    HYPR = mkOption {
      type = types.bool;
      default = false;
    };
    KDE = mkOption {
      type = types.bool;
      default = false;
    };

    packages = mkOption {
      type = types.listOf types.package;
      default = [];
    };
  };
}
