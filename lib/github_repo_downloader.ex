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
    format = [
      frames: :bars,
      text: "Loading repositories metadata from GitHub...",
      done: [IO.ANSI.green(), "✓", IO.ANSI.reset(), " Loaded."],
      spinner_color: IO.ANSI.magenta()
    ]

    repos = ProgressBar.render_spinner(format, fn -> list_team_repos(team_id) end)
    {:ok, progress_bar} = GithubRepoDownloader.CLI.ProgressBar.start_link(length(repos))

    Enum.map(repos, fn repo -> Task.async(fn -> download_repo(repo, dir, progress_bar) end) end)
    |> Enum.each(fn task -> Task.await(task, 120_000) end)
  end

  def download_repo(%{name: name, ssh_url: ssh_url}, dir, progress_bar) do
    :ok = File.cd(dir)
    repo_path = Path.join(dir, name)

    if File.exists?(repo_path) do
      repo = Git.new(repo_path)
      {:ok, _output} = Git.fetch(repo)
      {:ok, _output} = Git.pull(repo)
    else
      {:ok, _repo} = Git.clone(ssh_url)
    end

    GithubRepoDownloader.CLI.ProgressBar.update_progress(progress_bar)
  end
end
