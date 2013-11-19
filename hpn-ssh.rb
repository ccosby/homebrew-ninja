require 'formula'

class HpnSsh < Formula
  homepage 'http://www.openssh.com/'
  url 'http://ftp5.eu.openbsd.org/ftp/pub/OpenBSD/OpenSSH/portable/openssh-6.3p1.tar.gz'
  version '6.3p1'
  sha1 '70845ca79474258cab29dbefae13d93e41a83ccb'

  option 'with-brewed-openssl', 'Build with Homebrew OpenSSL instead of the system version'

  depends_on 'openssl' if build.with? 'brewed-openssl'
  depends_on 'ldns' => :optional
  depends_on 'pkg-config' => :build if build.with? "ldns"

  conflicts_with 'openssh'

  def patches
    'http://downloads.sourceforge.net/project/hpnssh/HPN-SSH%2014v2%206.3p1/openssh-6.3p1-hpnssh14v2.diff.gz'
  end

  def install

    args = %W[
      --with-libedit
      --prefix=#{prefix}
    ]

    args << "--with-ssl-dir=#{Formula.factory('openssl').opt_prefix}" if build.with? 'brewed-openssl'
    args << "--with-ldns" if build.with? "ldns"
    args << "--without-openssl-header-check"

    system "./configure", *args
    system "make"
    system "make install"
  end
end
