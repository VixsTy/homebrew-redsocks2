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
  revision 1

  stable do
    url 'https://github.com/VixsTy/redsocks.git',
      :using => GitNoDepthDownloadStrategy, :shallow => false, :tag => "0.7.6-macos"
    version "0.7.6-macos"
  end

  head do
    url 'https://github.com/VixsTy/redsocks.git',
      :using => GitNoDepthDownloadStrategy, :shallow => false
  end

  bottle do
    root_url "https://github.com/VixsTy/redsocks/releases/download/0.7.6-macos"
    sha256 "2390068306b4079770732a5b6ca608a69ed0a7ba74d6f4d89ea627c84922fc65" => :high_sierra
    sha256 "efc80cb05381e7ee2a617655eb163ee352d607247662516b0897377f2a307484" => :sierra
    sha256 "57bd8491c3e080f5af6de9e7ba80e1dc7d9a49770e2e22fab7419caf6d50e5bd" => :el_capitan
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
