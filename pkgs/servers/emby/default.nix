{ stdenv, fetchurl, unzip, sqlite }:

stdenv.mkDerivation rec {
  name = "emby-${version}";
  version = "3.0.5932";

  src = fetchurl {
    url = "https://github.com/MediaBrowser/Emby/releases/download/${version}/Emby.Mono.zip";
    sha256 = "1m6p52q2y0rd8m1488h1cgfq7m6y5njlln73n4lmi0knrmlq3w7r";
  };

  buildInputs = [ unzip ];
  propagatedBuildInputs = [ sqlite ];

  # Need to set sourceRoot as unpacker will complain about multiple directory output
  sourceRoot = ".";

  patchPhase = ''
    substituteInPlace System.Data.SQLite.dll.config --replace libsqlite3.so ${sqlite.out}/lib/libsqlite3.so
    substituteInPlace MediaBrowser.Server.Mono.exe.config --replace ProgramData-Server "/var/lib/emby/ProgramData-Server"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin
  '';

  meta = {
    description = "MediaBrowser - Bring together your videos, music, photos, and live television";
    homepage = http://emby.media/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.fadenb ];
    platforms = stdenv.lib.platforms.all;
  };
}
