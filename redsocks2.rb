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
      :using => GitNoDepthDownloadStrategy, :shallow => false, :tag => "0.7.2-macos"
    version "0.7.2-macos"
  end

  head do
    url 'https://github.com/VixsTy/redsocks.git',
      :using => GitNoDepthDownloadStrategy, :shallow => false
  end


  depends_on "openssl"
  depends_on "libevent"

  def install
    system "git submodule update --init --recursive"
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
