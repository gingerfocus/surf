{
  inputs.nixpkgs.url = "nixpkgs";

  outputs = { self, nixpkgs, }:
    let
      lib = nixpkgs.lib;
      systems = [ "aarch64-linux" "x86_64-linux" ];
      eachSystem = f:
        lib.foldAttrs lib.mergeAttrs { }
        (map (s: lib.mapAttrs (_: v: { ${s} = v; }) (f s)) systems);
    in eachSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        mypkgs = self.packages."${system}";
      in {
        devShells.default = pkgs.mkShell {
          inputsFrom = with mypkgs; [ surf ];
          packages = with pkgs; [ ];
        };

        formatter = pkgs.alejandra;

        packages = rec {
          default = mypkgs.surf;
          surf = pkgs.callPackage ./surf.nix { };
        };
      });
}
