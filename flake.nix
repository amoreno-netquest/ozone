{
  inputs = {
    mach-nix.url = "mach-nix/3.5.0";
  };

  outputs = {self, nixpkgs, mach-nix }@inp:
    let
      l = nixpkgs.lib // builtins;
      supportedSystems = [ "aarch64-darwin" ];
      forAllSystems = f: l.genAttrs supportedSystems
        (system: f system (import nixpkgs {inherit system;}));
    in
    {
      # enter this python environment by executing `nix shell .`
      defaultPackage = forAllSystems (system: pkgs: mach-nix.lib."${system}".mkPython {
        requirements = ''
          pandas
          numpy
          requests
          datafusion
        '';
      });
    };
}
