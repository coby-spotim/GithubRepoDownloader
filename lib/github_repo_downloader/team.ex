defmodule GithubRepoDownloader.Team do
  defstruct team: nil, id: nil

  def new({team, id}) do
    %GithubRepoDownloader.Team{team: team, id: id}
  end

  defimpl String.Chars do
    def to_string(team), do: team.team
  end
end
