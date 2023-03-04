defmodule Dinner do
  def start(hunger), do: spawn(fn -> init(hunger) end)

  def init(hunger) do
    c1 = Chopsticks.start()
    c2 = Chopsticks.start()
    c3 = Chopsticks.start()
    c4 = Chopsticks.start()
    c5 = Chopsticks.start()
    ctrl = self()
    Philos.start(hunger, 5, c1, c2, :arendt, ctrl)
    Philos.start(hunger, 5, c2, c3, :hypatia, ctrl)
    Philos.start(hunger, 5,c3, c4, :simone, ctrl)
    Philos.start(hunger, 5,c4, c5, :elisabeth, ctrl)
    Philos.start(hunger, 5,c5, c1, :ayn, ctrl)
    t0 = :os.system_time(:second)
    wait(5, [c1, c2, c3, c4, c5], t0)
  end

  # Everyone is done, terminate alla chopsticks
  # Philosophers are done, have returned :ok to motherprocess
  def wait(0, chopsticks, t0) do
    Enum.each(chopsticks, fn(c) -> Chopsticks.terminate(c) end)
    IO.puts("Dinner completed in #{:os.system_time(:second) - t0}s")
  end

  # Motherprocess can send :abort to kill everything
  def wait(n, chopsticks, t0) do
    receive do
      :done ->
        wait(n - 1, chopsticks, t0)
      :abort ->
        Process.exit(self(), :kill)
    end
  end
end
