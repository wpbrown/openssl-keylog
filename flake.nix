{
  description = "Add SSLKEYLOGFILE support to any dynamically linked app using OpenSSL 1.1.1+";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs =
    { nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = f: lib.genAttrs supportedSystems (system: f nixpkgs.legacyPackages.${system});
      scriptToolsFor =
        pkgs: with pkgs; [
          bash
          coreutils
          util-linux
          wireshark-cli
        ];
    in
    {
      packages = forAllSystems (pkgs: {
        default =
          let
            scriptTools = scriptToolsFor pkgs;
          in
          pkgs.stdenv.mkDerivation {
            pname = "openssl-keylog";
            version = "0.1";

            src = ./.;

            nativeBuildInputs = [ pkgs.makeWrapper ];

            installPhase = ''
              runHook preInstall

              install -Dm644 libsslkeylog.so $out/share/sslkeylog/preload/libsslkeylog.so
              install -Dm755 sslkeylogged $out/bin/sslkeylogged
              install -Dm755 dumpcapssl $out/bin/dumpcapssl

              wrapProgram $out/bin/sslkeylogged \
                --prefix PATH : "${lib.makeBinPath [ pkgs.coreutils ]}"

              wrapProgram $out/bin/dumpcapssl \
                --prefix PATH : "${lib.makeBinPath scriptTools}:$out/bin"

              runHook postInstall
            '';

            meta = with lib; {
              description = "Add SSLKEYLOGFILE support to any dynamically linked app using OpenSSL";
              homepage = "https://github.com/wpbrown/openssl-keylog";
              license = licenses.gpl3Plus;
              mainProgram = "dumpcapssl";
              platforms = platforms.linux;
            };
          };
      });

      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = scriptToolsFor pkgs;
        };
      });
    };
}
