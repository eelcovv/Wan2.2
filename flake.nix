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
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python312;
        cudaPackages = pkgs.cudaPackages_12_4;
        wan22Shell = pkgs.mkShell {
          buildInputs = with pkgs; [
            python
            uv

            # CUDA & cuDNN
            cudaPackages.cudatoolkit
            cudaPackages.cudnn
            cudaPackages.nccl

            # GPU libraries
            libcublas

            # Build tools
            gcc
            pkg-config
            cmake
            ninja

            # System libraries
            zlib
            openssl
            libffi

            # Video/Media
            ffmpeg
          ];

          shellHook = ''
            export CUDA_PATH=${cudaPackages.cudatoolkit}
            export CUDA_HOME=${cudaPackages.cudatoolkit}
            export CUDNN_PATH=${cudaPackages.cudnn}
            export LD_LIBRARY_PATH=${
              pkgs.lib.makeLibraryPath [
                cudaPackages.cudatoolkit
                cudaPackages.cudnn
                cudaPackages.nccl
                pkgs.libcublas
              ]
            }:$LD_LIBRARY_PATH

            # Create/activate Python venv if needed
            if [ ! -d .venv ]; then
              ${python}/bin/python -m venv .venv
            fi
            source .venv/bin/activate

            echo "🎉 NixOS DevShell active with CUDA 12.4"
            echo "Python: $(python --version)"
            echo "CUDA: $CUDA_PATH"
          '';
        };
      in
      {
        devShells.default = wan22Shell;
        devShells.wan22_build = wan22Shell;
    );
}
