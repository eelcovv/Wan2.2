{
  description = "Wan2.2 - Video Generation with PyTorch + CUDA";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        python = pkgs.python312;
        wan22Shell = pkgs.mkShell {
          buildInputs = with pkgs; [
            python
            uv

            # System libraries
            zlib
            openssl
            libffi

            # Video/Media
            ffmpeg
          ];

          shellHook = ''
            prepend() { export LD_LIBRARY_PATH="$1''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"; }

            [ -d /run/opengl-driver/lib ] && prepend /run/opengl-driver/lib
            [ -d /run/opengl-driver-32/lib ] && prepend /run/opengl-driver-32/lib

            # Create/activate Python venv if needed
            if [ ! -d .venv ]; then
              ${python}/bin/python -m venv .venv
            fi
            source .venv/bin/activate

            echo "🎉 NixOS DevShell active (lightweight)"
            echo "Python: $(python --version)"
            echo "CUDA toolkit is not loaded by default; use your system CUDA or a separate CUDA shell if needed"
          '';
        };
      in
      {
        devShells.default = wan22Shell;
        devShells.wan22_build = wan22Shell;
      }
    );
}
