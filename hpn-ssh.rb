require 'formula'

class HpnSsh < Formula
  homepage 'http://www.openssh.com/'
  url 'http://ftp5.usa.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.5p1.tar.gz'
  version '6.5p1'
  sha1 '3363a72b4fee91b29cf2024ff633c17f6cd2f86d'

  option 'with-brewed-openssl', 'Build with Homebrew OpenSSL instead of the system version'
  option 'with-keychain-support', 'Add native OS X Keychain and Launch Daemon support to ssh-agent'

  depends_on 'openssl' if build.with? 'brewed-openssl'
  depends_on 'autoconf' => :build if build.with? 'keychain-support'
  depends_on 'ldns' => :optional
  depends_on 'pkg-config' => :build if build.with? "ldns"

  conflicts_with 'openssh'

  patch do
    # Apply Kenny Root's revised version of Simon Wilkinson's gsskex patch (http://www.sxw.org.uk/computing/patches/openssh.html),
    # which has also been included in Apple's openssh for a while.
    # https://gist.github.com/kruton/8951373
    url 'https://gist.github.com/kruton/8951373/raw/a05b4a2d50bbac68e97d4747c1a34b53b9a941c4/openssh-6.5p1-apple-keychain.patch'
    sha1 '28b175507688db38a8c543f4afdb31b5ca994eeb'
  end if build.with? 'keychain-support'

  patch do
    # The HPN-SSH patch installs over the Apple Keychain patch
    url 'http://downloads.sourceforge.net/project/hpnssh/HPN-SSH%2014v4%206.5p1/openssh-6.5p1-hpnssh14v4.diff.gz'
    sha1 '63080015f0222bd7a0726da59b397230e0a81bc4'
  end

  def install
    system "autoreconf -i" if build.with? 'keychain-support'

    if build.with? "keychain-support"
      ENV.append "CPPFLAGS", "-D__APPLE_LAUNCHD__ -D__APPLE_KEYCHAIN__"
      ENV.append "LDFLAGS", "-framework CoreFoundation -framework SecurityFoundation -framework Security"
    end

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

  def caveats
    if build.with? "keychain-support" then <<-EOS.undent
        For complete functionality, please modify:
          /System/Library/LaunchAgents/org.openbsd.ssh-agent.plist

        and change ProgramArguments from
          /usr/bin/ssh-agent
        to
          #{HOMEBREW_PREFIX}/bin/ssh-agent

        After that, you can start storing private key passwords in
        your OS X Keychain.
      EOS
    end
  end
end
