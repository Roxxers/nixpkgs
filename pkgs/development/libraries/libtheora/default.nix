{stdenv, fetchurl, libogg, libvorbis, pkg-config}:

stdenv.mkDerivation rec {
  name = "libtheora-1.1.1";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/theora/${name}.tar.gz";
    sha256 = "0swiaj8987n995rc7hw0asvpwhhzpjiws8kr3s6r44bqqib2k5a0";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputDoc = "devdoc";

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ libogg libvorbis ];

  # GCC's -fforce-addr flag is not supported by clang
  # It's just an optimization, so it's safe to simply remove it
  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace "-fforce-addr" ""
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.theora.org/";
    description = "Library for Theora, a free and open video compression format";
    license = licenses.bsd3;
    maintainers = with maintainers; [ spwhitt ];
    platforms = platforms.unix;
  };
}
