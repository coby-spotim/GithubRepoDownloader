defmodule GithubRepoDownloaderTest do
  use ExUnit.Case
  doctest GithubRepoDownloader

  test "greets the world" do
    assert GithubRepoDownloader.hello() == :world
  end
end
