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
  version "0.7.0-macos"

  stable do
    url 'https://github.com/VixsTy/redsocks.git',
      :using => GitNoDepthDownloadStrategy, :shallow => false, :tag => "0.7.0-macos"
  end

  head do
    url 'https://github.com/VixsTy/redsocks.git',
      :using => GitNoDepthDownloadStrategy, :shallow => false
  end

  bottle do
    root_url "https://github.com/VixsTy/redsocks/releases/download/0.7.0-macos"
    cellar :any
    sha256 "81ce1f6324ba3f034cd4b912bf7e666c889801c8fce1b4b202a0b16a48a5e120" => :high_sierra
    sha256 "d4fda826ccb9b79e573095b49931c780bafd4374f9d574afa36a92e8a7c351bf" => :sierra
    sha256 "2c678f9c1af788abb6930529a0a0ff689e32635c95a409df1e3d6bedaae2e17c" => :el_capitan
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
