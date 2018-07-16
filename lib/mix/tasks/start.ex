defmodule Mix.Tasks.Start do
  use Mix.Task

  def run(_) do
    Application.ensure_all_started(:tentacat)
    Application.ensure_all_started(:hackney)
    GithubRepoDownloader.CLI.Main.start()
  end
end
