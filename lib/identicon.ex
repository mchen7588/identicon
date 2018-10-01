defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
  end

  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image_struct) do
    %Identicon.Image{image_struct | color: {r, g, b}}
  end

  def build_grid(%Identicon.Image{hex: hex} = image_struct) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image_struct | grid: grid}
  end

  def mirror_row([x, y, z]) do
    [x, y, z, y, x]
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image_struct) do
    filtered_grid = Enum.filter grid, fn({value, _index}) ->
      rem(value, 2) == 0
    end

    %Identicon.Image{image_struct | grid: filtered_grid}
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image_struct) do
    pixel_map = Enum.map grid, fn({_value, index}) ->
      x = rem(index, 5) * 50
      y = div(index, 5) * 50

      top_left = {x, y}
      bottom_right = {x + 50, y + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image_struct | pixel_map: pixel_map}
  end


end
