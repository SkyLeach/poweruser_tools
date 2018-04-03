class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/archive/ecb09b14ee2706eecee026cee2478049586d8646.tar.gz"
  version "6.4.2"
  sha256 "6afb5f0a1e61726342b93148a335473839ee5257f6ad294ce0e70757a112c065"
  # sha256 "28a13699726c9fec5fc93ed70e7213cb3a2608f3a4ffbaf8bdccb7c63b12df53"

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "frei0r"
  depends_on "libdv"
  depends_on "libsamplerate"
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "sox"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-jackrack",
                          "--disable-swfdec",
                          "--disable-gtk",
                          "--enable-gpl"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/melt", "-version"
  end
end
