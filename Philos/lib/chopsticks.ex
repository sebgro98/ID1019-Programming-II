defmodule Chopsticks do
  def start do
    stick = spawn_link(fn -> available() end)
    {:stick, stick}
  end

  def available() do
    receive do
      {:request, ref, from} ->
        send(from, {:granted, ref})
        gone(ref)

      :quit ->
        :ok
    end
  end

  def gone(ref) do
    receive do
      {:return, ^ref} -> available()
      :quit -> :ok
    end
  end

  def request({:stick, pid}) do
    send(pid, {:request, self()})

    receive do
      :granted -> :ok
    end
  end

  # Using a timeout to detect deadlock, does it work?
  def request({:stick, pid}, timeout) when is_number(timeout) do
    send(pid, {:request, self()})

    receive do
      :granted ->
        :ok
    after
      timeout ->
        :no
    end
  end

  def quit({:stick, pid}) do
    send(pid, :quit)
  end

  def return({:stick, pid}) do
    send(pid, :return)
  end

  # Return a ref taged stick
  def return({:stick, pid}, ref) do
    send(pid, {:return, ref})
  end

  # A asynchronous request, divided into sending the
  # request and waiting for the reply.
  def asynch({:stick, pid}, ref) do
    send(pid, {:request, ref, self()})
  end

  # Don't throw anything away (since there are no old messages)
  def synch(ref, timeout) when is_number(timeout) do
    receive do
      {:granted, ^ref} ->
        :ok

      {:granted, _} ->
        ## this is an old message that we must ignore
        synch(ref, timeout)
    after
      timeout ->
        :no
    end
  end
  def terminate({:stick, stick}) do
    send(stick, :quit)
  end
end
