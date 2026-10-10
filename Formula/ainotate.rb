class Ainotate < Formula
  desc "Annotated screenshots for AI agents: steps, arrows, boxes, labels, redaction"
  homepage "https://github.com/dontpayfull/AInotate"
  url "https://files.pythonhosted.org/packages/9f/84/7c7fbe5c4ac058e0d7eeda1b5f8a0a25af2b47c0cb7da82f5ef58d95df8c/ainotate-0.1.8.tar.gz"
  sha256 "0328ec66f2f7f327a79d4a5c5ff5e5c1970651cea17d2f444ebb3c6c549b61df"
  license "AGPL-3.0-or-later"

  depends_on "python@3.13"

  def install
    # AInotate and its extras (Playwright, MCP, Vision OCR, Quartz) come from PyPI as wheels,
    # pinned to this formula's version, into a private virtualenv.
    python = Formula["python@3.13"].opt_bin/"python3.13"
    system python, "-m", "venv", libexec
    system libexec/"bin/python", "-m", "pip", "install", "--upgrade", "--quiet", "pip"
    system libexec/"bin/python", "-m", "pip", "install", "--quiet", "ainotate[all]==#{version}"
    bin.install_symlink libexec/"bin/ainotate"
  end

  def caveats
    <<~EOS
      Web capture needs Chromium once:
        #{opt_libexec}/bin/python -m playwright install chromium
      Then check everything:
        ainotate doctor
      Agent skill for Claude Code and Codex:
        ainotate install-skill
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ainotate --version")
    system bin/"ainotate", "info", test_fixtures("test.png")
  end
end
