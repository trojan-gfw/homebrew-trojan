class Trojan < Formula
  desc "An unidentifiable mechanism that helps you bypass GFW."
  homepage "https://trojan-gfw.github.io/trojan/"
  url "https://github.com/trojan-gfw/trojan/archive/v1.16.0.tar.gz"
  sha256 "86cdb2685bb03a63b62ce06545c41189952f1ec4a0cd9147450312ed70956cbc"
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl@1.1"
  depends_on "python" => :test
  depends_on "coreutils" => :test

  def install
    system "sed", "-i", "", "s/server\\.json/client.json/", "CMakeLists.txt"
    system "sed", "-i", "", "s:${CMAKE_INSTALL_FULL_SYSCONFDIR}:#{etc}:", "CMakeLists.txt"
    system "cmake", ".", *std_cmake_args, "-DENABLE_MYSQL=OFF"
    system "make", "install"
  end

  plist_options :manual => "trojan #{HOMEBREW_PREFIX}/etc/trojan/config.json"

  def plist; <<~EOS
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>RunAtLoad</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/trojan</string>
        <string>#{etc}/trojan/config.json</string>
      </array>
    </dict>
  </plist>
  EOS
  end
end
