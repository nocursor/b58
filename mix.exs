defmodule B58.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/nocursor/b58"

  def project do
    [
      app: :basefiftyeight,
      version: @version,
      elixir: ">= 1.6.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Hex
      description: "Elixir library for encoding and decoding Base58 and Base58Check using the Bitcoin/IPFS, Ripple, and Flickr alphabets.",
      package: package(),

      # Docs
      name: "Base Fifty Eight",
      source_url: @source_url,
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  defp package do
    [
      maintainers: [
        "nocursor",
      ],
      licenses: ["MIT"],
      links: %{github: @source_url},
      files: ~w(lib NEWS.md LICENSE.md mix.exs README.md)
    ]
  end

  defp docs do
    [
      source_ref: "v#{@version}",
      main: "b58",
      extra_section: "PAGES",
      extras: extras(),
      groups_for_extras: groups_for_extras()
    ]
  end

  defp extras do
    [
      "docs/FAQ.md",
    ]
  end

  defp groups_for_extras do
    [
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:benchee, "~> 0.13.2", only: [:dev]},
      {:dialyxir, "~> 1.0.0-rc.3", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.13", only: [:dev], runtime: false},
    ]
  end
end
