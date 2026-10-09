class Ainotate < Formula
  desc "Annotated screenshots for AI agents: steps, arrows, boxes, labels, redaction"
  homepage "https://github.com/dontpayfull/AInotate"
  url "https://files.pythonhosted.org/packages/74/1f/06e79b071f7bb802f6ca5f2055d6afbd217afecfaec33663889f423922b0/ainotate-0.1.3.tar.gz"
  sha256 "35a590395527a4a9379af3bba682643c89476fbdd033bf44d08eca54ba81aa74"
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
