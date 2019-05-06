class Trojan < Formula
  desc "An unidentifiable mechanism that helps you bypass GFW."
  homepage "https://trojan-gfw.github.io/trojan/"
  url "https://github.com/trojan-gfw/trojan/archive/v1.12.2.tar.gz"
  sha256 "f0d5379787d0aa66a952b1b3f7777f5f8c0b818d5c49b2ca67820076d8abe74b"
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl@1.1"
  depends_on "python" => :test
  depends_on "coreutils" => :test

  def install
    system "sed", "-i", "", "s/server\\.json/client.json/", "CMakeLists.txt"
    system "sed", "-i", "", "s/\"cert\": \"\"/\"cert\": \"\\/etc\\/ssl\\/cert.pem\"/", "examples/client.json-example"
    system "cmake", ".", *std_cmake_args, "-DENABLE_MYSQL=OFF"
    system "make", "install"
  end

  plist_options :manual => "trojan -c #{HOMEBREW_PREFIX}/etc/trojan/config.json"

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
        <string>#{bin}/trojan</string>
        <string>-c</string>
        <string>#{etc}/trojan/config.json</string>
      </array>
    </dict>
  </plist>
  EOS
  end

  test do
    system "git", "clone", "--branch=v1.12.2", "https://github.com/trojan-gfw/trojan.git"
    system "sh", "-c", "cd trojan/tests/LinuxSmokeTest && ./basic.sh /usr/local/bin/trojan"
    system "sh", "-c", "cd trojan/tests/LinuxSmokeTest && ./fake-client.sh /usr/local/bin/trojan"
  end
end
