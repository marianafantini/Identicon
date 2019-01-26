defmodule Identicon do
  require Integer
  @moduledoc """
    This module creates an Identicon, which is an image created
    using a grid of 5x5 squares. The Identicon is generated based
    on an input string, and the image should be the same every time a 
    specific string is passed as input. 
  """

  @doc """
  
  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({code, _index}) -> 
      rem(code, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

  def build_grid(%Identicon.Image{hex: hex_list} = image) do
    grid = 
      hex_list
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    # input: [145, 46, 200]
    [first, second | _tail] = row

    # output: [145, 46, 200, 46, 145]
    row ++ [second, first]
  end

  @doc """
    Received the hash and pick a color for the identicon based on its data
  """
  def pick_color(%Identicon.Image{hex: [red, green, blue | _tail]} = image) do
    %Identicon.Image{image | color: {red, green, blue}}
  end

  ### first version of pick_color: 
  # refactor: it is possible to use pattern matching as we pass an argument to the function
  # def pick_color(image) do
  #   %Identicon.Image{hex: [red, green, blue | _tail]} = image
    
  #   # adding a color value to this struct
  #   %Identicon.Image{image | color: {red, green, blue}}

  #   # changed from list to tuple because lists have elements with no special meaning,
  #   # tuples are used for data with special meaning (first is red, second is green, third is blue)
  # end
  
  @doc """
    Received an input and returns its hash as a list of numbers
  """
  def hash_input(input) do
    hex_list = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex_list}
  end
end
