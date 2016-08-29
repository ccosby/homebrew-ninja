class HpnSsh < Formula
  desc "OpenBSD freely-licensed SSH connectivity tools"
  homepage "http://www.psc.edu/index.php/hpn-ssh"
  url "http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.2p2.tar.gz"
  mirror "https://www.mirrorservice.org/pub/OpenBSD/OpenSSH/portable/openssh-7.2p2.tar.gz"
  version "7.2p2"
  sha256 "a72781d1a043876a224ff1b0032daa4094d87565a68528759c1c2cab5482548c"

  conflicts_with 'openssh'

  # The keychain support patch was removed in homebrew-dupes/openssh. We'll follow their lead.
  # https://github.com/Homebrew/homebrew-dupes/pull/482#issuecomment-118994372
  option "with-libressl", "Build with LibreSSL instead of OpenSSL"

  depends_on "openssl" => :recommended
  depends_on "libressl" => :optional
  depends_on "ldns" => :optional
  depends_on "pkg-config" => :build if build.with? "ldns"
  unless OS.mac?
    depends_on "homebrew/dupes/libedit"
    depends_on "homebrew/dupes/krb5"
  end

  if OS.mac?
    # Both these patches are applied by Apple.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/1860b0a74/openssh/patch-sandbox-darwin.c-apple-sandbox-named-external.diff"
      sha256 "d886b98f99fd27e3157b02b5b57f3fb49f43fd33806195970d4567f12be66e71"
    end

    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/d8b2d8c2/openssh/patch-sshd.c-apple-sandbox-named-external.diff"
      sha256 "3505c58bf1e584c8af92d916fe5f3f1899a6b15cc64a00ddece1dc0874b2f78f"
    end

    # Patch for SSH tunnelling issues caused by launchd changes on Yosemite
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/d8b2d8c2/OpenSSH/launchd.patch"
      sha256 "df61404042385f2491dd7389c83c3ae827bf3997b1640252b018f9230eab3db3"
    end

    # Patch enabling High Performance SSH (hpn-ssh)
    patch do
      url 'http://downloads.sourceforge.net/project/hpnssh/HPN-SSH%2014v10%207.2p2/openssh-7_2_P2-hpn-KitchenSink-14.10.diff'
      sha256 "f083d4c4a2054808386e974accda385542ce150f0c0f079ec1a0d4fa78888b17"
    end
  end

  def install
    ENV.append "CPPFLAGS", "-D__APPLE_SANDBOX_NAMED_EXTERNAL__" if OS.mac?

    args = %W[
      --with-libedit
      --with-kerberos5
      --prefix=#{prefix}
      --sysconfdir=#{etc}/ssh
    ]
    args << "--with-pam" if OS.mac?
    args << "--with-privsep-path=#{var}/lib/sshd" if OS.linux?

    if build.with? "libressl"
      args << "--with-ssl-dir=#{Formula["libressl"].opt_prefix}"
    else
      args << "--with-ssl-dir=#{Formula["openssl"].opt_prefix}"
    end

    args << "--with-ldns" if build.with? "ldns"

    system "./configure", *args
    system "make"
    system "make", "install"

    # This was removed by upstream with very little announcement and has
    # potential to break scripts, so recreate it for now.
    # Debian have done the same thing.
    bin.install_symlink bin/"ssh" => "slogin"
  end
end
