class ClaudeTools < Formula
  desc "Unix-style utilities for managing Claude Code conversations"
  homepage "https://github.com/dlond/claude-tools"
  url "https://github.com/dlond/claude-tools/archive/refs/tags/v1.0.0.tar.gz"

  # Update after release
  sha256 "717f933c82ed7ee04437e75df7397b7b71b33e7839e86dfdc76db81938ae81dd"
  license "MIT"

  depends_on "dune" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build

  def install
    # Install OCaml dependencies via opam
    ENV["OPAMROOT"] = buildpath/".opam"
    ENV["OPAMYES"] = "1"

    system "opam", "init", "--no-setup", "--disable-sandboxing"
    system "opam", "install", "yojson", "cmdliner", "uuidm", "--yes"

    # Build with dune
    system "opam", "exec", "--", "dune", "build", "--release"

    # Install binaries
    bin.install "_build/default/bin/claude_ls.exe" => "claude-ls"
    bin.install "_build/default/bin/claude_cp.exe" => "claude-cp"
    bin.install "_build/default/bin/claude_mv.exe" => "claude-mv"
    bin.install "_build/default/bin/claude_rm.exe" => "claude-rm"
    bin.install "_build/default/bin/claude_clean.exe" => "claude-clean"

    # Install completions
    bash_completion.install "completions/claude-tools.bash" => "claude-tools"
    zsh_completion.install "completions/claude-tools.zsh" => "_claude-tools"
  end

  test do
    system "#{bin}/claude-ls", "--help"
  end
end
