defmodule Moves do
# - is track to main, and plus is main to track where one is left and two is right
def single({_, 0}, state)  do state end
def single({:one, n}, list) do

  if (n > 0 ) do
  {main, one, two} = list
  {0, remain, taken} = Train.main(main, n)
  {remain, Train.append(taken, one), two}
  else
    {main, one, two} = list
    taken = Train.take(one, -n)
    {Train.append(main, taken), Train.drop(one, -n), two} #-n so that --n gives plus otherwise we cant match
  end
end

  def single({:two, n}, list) do
    if (n > 0 ) do
      {main, one, two} = list
      {0, remain, taken} = Train.main(main, n)
      {remain, one, Train.append(taken, two)}
      else
        {main, one, two} = list
        taken = Train.take(two, -n)
        {Train.append(main, taken), one, Train.drop(two, -n)} #-n so that --n gives plus otherwise we cant match
      end
    end


  def sequence([], state) do [state] end
  def sequence([move|rest], state) do
    [state | sequence(rest, single(move, state))]
  end

  end
