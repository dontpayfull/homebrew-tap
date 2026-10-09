class Ainotate < Formula
  desc "Annotated screenshots for AI agents: steps, arrows, boxes, labels, redaction"
  homepage "https://github.com/dontpayfull/AInotate"
  url "https://files.pythonhosted.org/packages/a2/9f/8c62968ccb76ebb5bc0de9681f312b341d55880aee9b213983f1cbb40289/ainotate-0.1.5.tar.gz"
  sha256 "ea85ecb58e77636a2965c44a1ccdf9faba673912b929ab8077f5422bff0f9319"
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
