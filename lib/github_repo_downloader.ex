defmodule GithubRepoDownloader do
  alias GithubRepoDownloader.Team

  @access_token Application.get_env(:github_repo_downloader, :access_token)
  @organization Application.get_env(:github_repo_downloader, :organization)

  def list_org_teams do
    client = Tentacat.Client.new(%{access_token: @access_token})

    {200, teams, _response} = Tentacat.Organizations.Teams.list(client, @organization)
    Enum.map(teams, fn team -> %Team{team: team["name"], id: team["id"]} end)
  end

  def list_team_repos(team_id) do
    client = Tentacat.Client.new(%{access_token: @access_token})

    Tentacat.Teams.Repositories.list(client, team_id)
    |> Enum.map(fn repo -> %{name: repo["name"], ssh_url: repo["ssh_url"]} end)
  end

  def download_team_repos(team_id, dir) do
    repos = list_team_repos(team_id)

    Enum.map(repos, fn repo -> Task.async(fn -> download_repo(repo, dir) end) end)
    |> Enum.each(&Task.await(&1, 120_000))
  end

  def download_repo(%{name: name, ssh_url: ssh_url}, dir) do
    :ok = File.cd(dir)
    System.cmd("git", ["clone", ssh_url])
    {:ok, name}
  end
end
