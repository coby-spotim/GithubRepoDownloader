defmodule GithubRepoDownloader.CLI.Main do
  alias Mix.Shell.IO, as: Shell

  def start do
    welcome_message()
    Shell.prompt("Press Enter to continue")
    team = team_choice()
    download_repos(team)
    Shell.info("All repositories for the #{team.team} team have been downloaded into the following directory:")
    Shell.info(Path.expand("../#{team.team}"))
  end

  defp welcome_message do
    Shell.info("=== GitHub Organization Repo Downloader ===")
    Shell.info("Make sure to define your access token and organization in the config.exs file.")
  end

  defp team_choice do
    GithubRepoDownloader.CLI.TeamChoice.start()
  end

  defp download_repos(team) do
    Shell.cmd("clear")
    Shell.info("I will now download all of the #{team.team} repositories from GitHub into a #{team.team} folder")

    if File.exists?("../#{team.team}") do
      Shell.info("Downloading...")
    else
      Shell.info("Creating a folder for #{team.team}")
      File.mkdir!("../#{team.team}")
      Shell.info("Downloading...")
    end

    GithubRepoDownloader.download_team_repos(team.id, "../#{team.team}")
  end
end
