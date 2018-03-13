require 'formula'

class GitNoDepthDownloadStrategy < GitDownloadStrategy
  # We need the .git folder for it's information, so we clone the whole thing
  def stage
    dst = Dir.getwd
    @clone.cd do
      reset
      safe_system 'git', 'clone', '.', dst
    end
  end
end

class Redsocks2 < Formula
  desc "Transparent socks redirector"
  homepage "https://github.com/VixsTy/redsocks"
  version "0.7.7-macos"

  stable do
    url 'https://github.com/VixsTy/redsocks.git',
      :using => GitNoDepthDownloadStrategy, :shallow => false, :tag => "0.7.7-macos"
  end

  head do
    url 'https://github.com/VixsTy/redsocks.git',
      :using => GitNoDepthDownloadStrategy, :shallow => false
  end

  bottle do
    root_url "https://github.com/VixsTy/redsocks/releases/download/0.7.7-macos"
    sha256 "7021410bd73da7c3871de0db2f91761c76265ae2227ae8613e55e653bcea7c96" => :high_sierra
    sha256 "d3e81a5a1b0fded4eb299bf0687980b31e8776733ce6086fdf2029e6747305ae" => :sierra
    sha256 "89cfd55889658fb49d0584ce0bb329cead42fd14248820370e03b0a27d31ebcf" => :el_capitan
  end


  depends_on "openssl"
  depends_on "libevent"

  def install
    system "git submodule update --init darwin-xnu/$(sw_vers -productVersion | cut -d '.' -f 1,2)"
    system "make"
    bin.install "redsocks2"
    man8.install "debian/redsocks.8"
    etc.install "darwin-xnu/redsocks.conf"
  end

  def caveats
    "Edit #{etc}/redsocks.conf to configure redsocks"
  end

  plist_options :startup => true

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/redsocks2</string>
          <string>-c</string>
          <string>#{etc}/redsocks.conf</string>
        </array>
        <key>KeepAlive</key>
        <false/>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end

end
