require 'formula'

class Buck < Formula
  homepage 'http://facebook.github.io/buck/'
  url 'https://github.com/facebook/buck.git', :tag => 'master'
  version 'master'

  def install

    # Copy the downloaded .git to prefix
    cp_r cached_download/'.git', prefix

    Dir.chdir prefix do
      # Reset and checkout the code to cleanup the tree
      system 'git', 'reset', '--hard'
      system 'git', 'checkout'

      # Build buck with ant
      system "ant"
    end

    #(prefix+'.git').mkdir unless File.exists?((prefix+'.git'))
    #prefix.install cached_download/'.git'

#    Dir.chdir prefix do
#      puts "pwd: #{Dir.getwd}"
#      system "ant"
#    end
  end

  test do
    system "buck", "--version"
  end
end
