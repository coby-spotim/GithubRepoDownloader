defmodule GithubRepoDownloader.MixProject do
  use Mix.Project

  def project do
    [
      app: :github_repo_downloader,
      version: "2.0.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :tentacat]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tentacat, ">= 0.0.0"},
      {:git_cli, ">= 0.0.0"},
      {:progress_bar, "> 0.0.0"}
    ]
  end
end
