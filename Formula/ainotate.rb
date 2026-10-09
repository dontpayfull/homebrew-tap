class Ainotate < Formula
  desc "Annotated screenshots for AI agents: steps, arrows, boxes, labels, redaction"
  homepage "https://github.com/dontpayfull/AInotate"
  url "https://files.pythonhosted.org/packages/89/0c/c33a08904302edd3c88458a5980dd722cf3f938ad6bf6db5181f4e92ea07/ainotate-0.1.4.tar.gz"
  sha256 "d5851b8ebb9d9b5f4fdaaae9c3b112f2a33b162e3c0c265c85d79634f3b5d2cb"
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
