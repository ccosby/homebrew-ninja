class Gam < Formula
  desc 'Command line management for Google Apps'
  homepage 'https://github.com/jay0lee/GAM'
  url 'https://github.com/jay0lee/GAM/archive/v3.71.tar.gz'
  sha256 '4debbea587bbcda4cc2f52cc794af40b31f37ee25f70be9c2c439e324bb6ab49'

  depends_on :python if MacOS.version <= :snow_leopard

  resource 'httplib2' do
    url 'https://pypi.python.org/packages/source/h/httplib2/httplib2-0.9.2.tar.gz'
    sha256 'c3aba1c9539711551f4d83e857b316b5134a1c4ddce98a875b7027be7dd6d988'
  end

  resource 'googleapiclient' do
    url 'https://pypi.python.org/packages/3f/d0/2ecf9a160ebe7aba392d5bf21b616b204e2c49c79603dfb53c171e9bbe2c/google-api-python-client-1.5.3.tar.gz'
    sha256 'd916e04969cb1fd6727b9f49290828e9d7162b90c1d5b4be0aed3c171a75d8be'
  end

  resource 'uritemplate' do
    url 'https://pypi.python.org/packages/cd/db/f7b98cdc3f81513fb25d3cbe2501d621882ee81150b745cdd1363278c10a/uritemplate-3.0.0.tar.gz'
    sha256 'c02643cebe23fc8adb5e6becffe201185bf06c40bda5c0b4028a93f1527d011d'
  end

  resource 'oauth2client' do
    url 'https://pypi.python.org/packages/c0/7b/bc893e35d6ca46a72faa4b9eaac25c687ce60e1fbe978993fe2de1b0ff0d/oauth2client-3.0.0.tar.gz'
    sha256 '5b5b056ec6f2304e7920b632885bd157fa71d1a7f3ddd00a43b1541a8d1a2460'
  end

  resource 'pyasn1' do
    url 'https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.9.tar.gz'
    sha256 '853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f'
  end

  resource 'pyasn1_modules' do
    url 'https://pypi.python.org/packages/source/p/pyasn1-modules/pyasn1-modules-0.0.8.tar.gz'
    sha256 '10561934f1829bcc455c7ecdcdacdb4be5ffd3696f26f468eb6eb41e107f3837'
  end

  resource 'rsa' do
    url 'https://pypi.python.org/packages/source/r/rsa/rsa-3.4.2.tar.gz'
    sha256 '25df4e10c263fb88b5ace923dd84bf9aa7f5019687b5e55382ffcdb8bede9db5'
  end

  resource 'atom' do
    url 'https://pypi.python.org/packages/source/a/atom/atom-0.3.10.zip'
    sha256 '461ffb57ff9448242b66e08d367f9c65bfd9bf04215591e7e9580f289139debf'
  end

  resource 'gdata' do
    url 'https://pypi.python.org/packages/source/g/gdata/gdata-2.0.18.tar.gz'
    sha256 '56e7d22de819c22b13ceb0fe1869729b4287f89ebbd4bb55380d7bcf61a1fdb6'
  end

  resource 'six' do
    url 'https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz'
    sha256 '105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a'
  end

  resource 'passlib' do
    url 'https://pypi.python.org/packages/source/p/passlib/passlib-1.6.5.tar.gz'
    sha256 'a83d34f53dc9b17aa42c9a35c3fbcc5120f3fcb07f7f8721ec45e6a27be347fc'
  end


  def install
    ENV.prepend_create_path 'PYTHONPATH', libexec/'vendor/lib/python2.7/site-packages'

    %w[
      httplib2
      googleapiclient
      uritemplate
      oauth2client
      pyasn1
      pyasn1_modules
      rsa
      atom
      gdata
      six
      passlib
    ].each do |r|
      resource(r).stage do
        system 'python', *Language::Python.setup_install_args(libexec/'vendor')
      end
    end

    (libexec/'bin').install %w[
      src/LICENSE
      src/gam.py
      src/admin-settings-v2.json
      src/cloudprint-v2.json
      src/email-audit-v1.json
      src/email-settings-v2.json
    ]

    bin.install_symlink 'gam.py' => 'gam'
    bin.env_script_all_files(
      libexec/'bin',
      :PYTHONPATH => ENV['PYTHONPATH'],
      :GAMUSERCONFIGDIR => '${HOME}/.config/gam',
    )
  end

  def caveats; <<-EOS.undent
    GAM must be configured before use.
      - User configuration files should be located under ~/.config/gam
      - Global configuration files are under #{libexec}/bin


    Configuration Steps:
      1. Complete the steps at https://github.com/jay0lee/GAM/wiki/CreatingClientSecretsFile

      2. Create private configuration directory.
           mkdir -p ~/.config/gam

      3. Copy your secrets to your private configuration directory.
           cp client_secrets.json ~/.config/gam


    For more info: https://github.com/jay0lee/GAM

    EOS
  end

  test do
    system "#{bin}/gam", "-h"
  end
end
