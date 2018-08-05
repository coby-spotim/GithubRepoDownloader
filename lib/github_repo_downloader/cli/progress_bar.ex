defmodule GithubRepoDownloader.CLI.ProgressBar do
  use GenServer

  def start_link(total) do
    GenServer.start_link(__MODULE__, total, [])
  end

  def update_progress(server) do
    GenServer.cast(server, {:update_progress})
  end

  def init(total) do
    format = [
      bar_color: [IO.ANSI.white(), IO.ANSI.green_background()],
      blank_color: IO.ANSI.red_background()
    ]

    ProgressBar.render(0, total, format)
    {:ok, %{total: total, progress: 0, format: format}}
  end

  def handle_cast({:update_progress}, state) do
    updated_progress = state.progress + 1

    if updated_progress <= state.total do
      ProgressBar.render(updated_progress, state.total, state.format)
      {:noreply, %{state | progress: updated_progress}}
    else
      {:stop, :normal, state}
    end
  end
end
