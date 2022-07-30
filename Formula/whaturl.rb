# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class Whaturl < Formula
  desc "A CLI for creating titled markup language links out of text containing raw URLs"
  homepage "https://github.com/staticaland/go-whaturl"
  version "0.3.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/staticaland/go-whaturl/releases/download/v0.3.0/go-whaturl_0.3.0_darwin_arm64.tar.gz"
      sha256 "8b6bb5642b0bd61ca75462aa3c5bfacdc2dac1879184c19da148322b39d7e9ee"

      def install
        bin.install "whaturl"
      end
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/staticaland/go-whaturl/releases/download/v0.3.0/go-whaturl_0.3.0_linux_arm64.tar.gz"
      sha256 "4e9a05c6393d4985a88f8060193f0a6349f4cb50d1b74b181bf03a17fef6ca14"

      def install
        bin.install "whaturl"
      end
    end
  end
end
