{
  stdenv,
  lib,
  web-ext
}:

stdenv.mkDerivation {
  name = "i2p-2.0.0";
  src = ./.;

  buildInputs = [
    web-ext
  ];

  buildPhase = ''
    web-ext build
  '';

  installPhase = ''
    dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
    mkdir -p "$dst"
    install -v -m644 "web-ext-artifacts/i2p-2.0.0.zip" "$dst/i2p@polybit.xpi"
  '';

  meta = with lib; {
    license = with licenses; [ gpl3 ];
  };
}

