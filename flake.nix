{
  description = "My server infrastructure";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        element = pkgs.fetchurl {
          url = "https://github.com/vector-im/element-web/releases/download/v1.11.34/element-v1.11.34.tar.gz";
          hash = "sha256-Yn4C80RpcHEA2n32CqoVWZp+mVE60RXvFh3/LqEds1w=";
        };

        homepage-builder = pkgs.buildGoModule {
          name = "homepage-builder";
          src = ./homepage;
          vendorHash = null;
        };
      in
      {
        devShell = pkgs.mkShell {
          packages = with pkgs; [
            bashInteractive
            caddy
            glibcLocalesUtf8
            go
            gopls
            homepage-builder
            rsync
            tree
          ];

          ELEMENT = "${element}";
        };
      });
}
