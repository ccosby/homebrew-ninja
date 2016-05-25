require 'formula'

class Gam < Formula
  desc 'Command line management for Google Apps'
  homepage 'https://github.com/jay0lee/GAM'
  url 'https://github.com/jay0lee/GAM/archive/v3.65.tar.gz'
  sha256 '02ee1a5f5fcff5cd65a73786221a3a35fab38c12675060f8d0a0331216ca141c'

  depends_on :python if MacOS.version <= :snow_leopard

  resource 'httplib2' do
    url 'https://pypi.python.org/packages/source/h/httplib2/httplib2-0.9.2.tar.gz'
    sha256 'c3aba1c9539711551f4d83e857b316b5134a1c4ddce98a875b7027be7dd6d988'
  end

  resource 'googleapiclient' do
    url 'https://pypi.python.org/packages/source/g/google-api-python-client/google-api-python-client-1.4.2.tar.gz'
    sha256 '2cd7ccc797b0f5d1ef75ea1ebf749da47c4972daf534d22fd3c6b4dfbd9a88ee'
  end

  resource 'uritemplate' do
    url 'https://pypi.python.org/packages/source/u/uritemplate/uritemplate-0.6.tar.gz'
    sha256 'a30e230aeb7ebedbcb5da9999a17fa8a30e512e6d5b06f73d47c6e03c8e357fd'
  end

  resource 'oauth2client' do
    url 'https://pypi.python.org/packages/source/o/oauth2client/oauth2client-2.0.2.tar.gz'
    sha256 'c9f7bf68e9d0f9ec055f1f2f487e5ea53b97b7a2b82f01d48d9a9bb68239535a'
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
    url 'https://pypi.python.org/packages/source/r/rsa/rsa-3.3.tar.gz'
    sha256 '03f3d9bebad06681771016b8752a40b12f615ff32363c7aa19b3798e73ccd615'
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

    (libexec/'bin').install %w[src/gam.py]

    bin.install_symlink 'gam.py' => 'gam'
    bin.env_script_all_files(libexec/'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    system "#{bin}/gam", "-h"
  end
end
