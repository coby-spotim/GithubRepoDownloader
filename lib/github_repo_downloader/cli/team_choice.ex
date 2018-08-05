defmodule GithubRepoDownloader.CLI.TeamChoice do
  alias Mix.Shell.IO, as: Shell
  import GithubRepoDownloader.CLI.BaseCommands

  def start do
    Shell.cmd("clear")
    Shell.info("Choose a team:")

    teams = GithubRepoDownloader.list_org_teams()
    find_team_by_index = &Enum.at(teams, &1)

    teams
    |> display_options
    |> generate_question
    |> Shell.prompt()
    |> parse_answer
    |> find_team_by_index.()
    |> confirm_team
  end

  defp confirm_team(chosen_team) do
    Shell.cmd("clear")
    Shell.info(chosen_team.team)
    if Shell.yes?("Confirm this team?"), do: chosen_team, else: start()
  end
end
