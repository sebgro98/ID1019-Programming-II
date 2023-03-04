defmodule Philos do

  def start(hunger, strength, right, left, name, ctrl) do
    spawn_link(fn -> init(hunger, strength, left, right, name, ctrl) end)
  end

  def init(hunger, strength, left, right, name, ctrl) do
    dreaming(hunger, strength, left, right, name, ctrl)
  end

  # Philosopher is in a dreaming state.
  def dreaming(0, strength, _left, _right, name, ctrl) do
    IO.puts("#{name} is happy, strength is still #{strength}!")
    send(ctrl, :done)
  end

  def dreaming(hunger, 0, _left, _right, name, ctrl) do
    IO.puts("#{name} is starved to death, hunger is down to #{hunger}!")
    send(ctrl, :done)
  end

  def dreaming(hunger, strength, left, right, name, ctrl) do
    IO.puts("#{name} is dreaming!")

    ##  this is where we sleep
    #sleep(30)

    IO.puts("#{name} wakes up")
    waiting(hunger, strength, left, right, name, ctrl)
  end

  # Philosopher is waiting for chopsticks.
  def waiting(hunger, strength, left, right, name, ctrl) do
    IO.puts("#{name} is waiting, #{hunger} to go!")
    ref = make_ref()
    Chopsticks.asynch(left, ref)
    Chopsticks.asynch(right, ref)

    case Chopsticks.synch(ref, 1000) do
      :ok ->
        IO.puts("#{name} received left stick")
        #sleep(50)
        case Chopsticks.synch(ref, 1000) do
          :ok ->
            IO.puts("#{name} received both sticks!")
            eat(hunger, strength, left, right, name, ctrl, ref)
          :no ->
            IO.puts("#{name} timed out on right stick")
            Chopsticks.return(left, ref)
            dreaming(hunger, strength-1, left, right, name, ctrl)
        end
      :no ->
        IO.puts("#{name} timed out on left stick")
        dreaming(hunger, strength-1, left, right, name, ctrl)
    end
  end

  # Philosopher is eating.
  def eat(hunger, strength, left, right, name, ctrl, ref) do
     IO.puts("#{name} is eating...")

    #sleep(50)

    Chopsticks.return(left,ref)
    Chopsticks.return(right,ref)

    dreaming(hunger - 1, strength, left, right, name, ctrl)
  end


  def sleep(0) do
    :ok
  end

  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end
end
