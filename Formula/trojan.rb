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
    system "cmake", ".", *std_cmake_args, "-DENABLE_MYSQL=OFF"
    system "make", "install"
  end

  service do
     run [opt_bin/"trojan", etc/"trojan/config.json"]
     run_type :immediate
     keep_alive true
  end
end
