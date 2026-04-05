{
  description = "Add SSLKEYLOGFILE support to any dynamically linked app using OpenSSL 1.1.1+";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.stdenv.mkDerivation {
            pname = "openssl-keylog";
            version = "0.1";

            src = ./.;

            nativeBuildInputs = [ pkgs.makeWrapper ];

            buildPhase = ''
              runHook preBuild
              make
              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall

              mkdir -p $out/bin
              mkdir -p $out/share/sslkeylog/preload

              cp libsslkeylog.so $out/share/sslkeylog/preload/
              cp sslkeylogged $out/bin/
              cp dumpcapssl $out/bin/

              chmod +x $out/bin/sslkeylogged $out/bin/dumpcapssl

              wrapProgram $out/bin/dumpcapssl \
                --prefix PATH : "${pkgs.lib.makeBinPath [ pkgs.wireshark-cli pkgs.util-linux pkgs.coreutils ]}:$out/bin"

              runHook postInstall
            '';

            meta = with pkgs.lib; {
              description = "Add SSLKEYLOGFILE support to any dynamically linked app using OpenSSL";
              homepage = "https://github.com/wpbrown/openssl-keylog";
              license = licenses.gpl3Plus;
              platforms = platforms.linux;
            };
          };
        });
    };
}
