defmodule Challenge_1 do
  @moduledoc """
  Documentation for `Challenge_1`.
  Este modulo consta de 5 funciones, las cuales son utilizadas para la solucion
  del reto con nombre "Guilty Prince" de la plataforma https://lightoj.com/
  """

  @doc """
  Funcion que inicia el flujo de la solución, haciendo la lectura de la primera entrada cantidad de casos de prueba, para posterior mente solucionar uno por uno.
  """
  @spec solve_cases() :: String.t()
  def solve_cases() do
    {cases, _} = IO.gets("")
               |> Integer.parse
    Enum.each(1..cases, fn(c) ->
      [_, b] = IO.gets("")
             |> String.split
             |> Enum.map(&String.to_integer/1)
      read_case(b,[], c)
    end)
  end

  @doc """
  Funcion que lee un caso de prueba y hace el llamado a las respecitvas funcionas para dar solución.
  """
  @spec read_case(limit :: integer(), case_built :: list(), count :: integer()) :: String.t()
  def read_case( 0, case_built, count) do
    {:ok, matrix} = create_matrix(case_built, {})
    {i, j} = find_prince(matrix, 0, 0)
    amount_land =  count_land(matrix, [], i, j, 0)
    IO.puts("Case #{count}: #{amount_land}")
  end
  def read_case( limit, case_built, count), do: read_case(limit-1, [ IO.gets("") | case_built], count)

  @doc """
  Funcion recibe una lista con todas las filas del caso de prueba y procede a convertir la lista en una tupla de tuplas.
  """
  @spec create_matrix(list :: list(), matrix :: tuple()) :: tuple()
  def create_matrix([], matrix), do: {:ok, matrix}
  def create_matrix([head | tail], matrix), do: create_matrix(tail,  Tuple.append( matrix, List.to_tuple(String.to_charlist(head))))

  @doc """
  Funcion recibe la matriz del caso de prueba y la recorre hasta encontrar la posición del caracter '@'.
  """
  @spec find_prince(matrix :: tuple(), i :: integer(), j :: integer()) :: tuple()
  def find_prince(matrix, i, j) do
    cond do
      elem(elem(matrix, i), j) == ?@ -> {i, j}
      i == tuple_size(matrix)-1 && j == tuple_size(elem(matrix, 0))-1 -> IO.puts("Prince not found")
      j == tuple_size(elem(matrix, 0))-1 -> find_prince(matrix, i+1, 0)
      true -> find_prince(matrix, i, j+1)
    end
  end

  @doc """
  Funcion recibe la matriz del caso de prueba, para posterior mente contar las catidades de tierra accesible desde la posicion inicial del principe.
  """
  @spec count_land(matrix :: tuple(), position_history :: list(), i :: integer(), j :: integer(), count :: integer()) :: integer()
  def count_land(matrix, [], i, j, 0) do
    cond do
      i > 0 && elem(elem(matrix, i-1), j) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [{i, j} | []], i-1, j, 1)
      j < tuple_size(elem(matrix, 0))-1 && elem(elem(matrix, i), j+1) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [{i, j} | []], i, j+1, 1)
      i < tuple_size(matrix)-1 && elem(elem(matrix, i+1), j) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [{i, j} | []], i+1, j, 1)
      j > 0 && elem(elem(matrix, i), j-1) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [], i, j-1, 1)
      true -> 1
    end
  end
  def count_land(matrix, [], i, j, count)do
    if elem(elem(matrix, i), j) != :counted do
      cond do
        i > 0 && elem(elem(matrix, i-1), j) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [{i, j} | []], i-1, j, count+1)
        j < tuple_size(elem(matrix, 0))-1 && elem(elem(matrix, i), j+1) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [{i, j} | []], i, j+1, count+1)
        i < tuple_size(matrix)-1 && elem(elem(matrix, i+1), j) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [{i, j} | []], i+1, j, count+1)
        j > 0 && elem(elem(matrix, i), j-1) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [], i, j-1, count+1)
        true -> count+1
      end
    else
      cond do
        i > 0 && elem(elem(matrix, i-1), j) == ?. -> count_land(matrix, [{i, j} | []], i-1, j, count)
        j < tuple_size(elem(matrix, 0))-1 && elem(elem(matrix, i), j+1) == ?. -> count_land(matrix, [{i, j} | []], i, j+1, count)
        i < tuple_size(matrix)-1 && elem(elem(matrix, i+1), j) == ?. -> count_land(matrix, [{i, j} | []], i+1, j, count)
        j > 0 && elem(elem(matrix, i), j-1) == ?. -> count_land(matrix, [], i, j-1, count)
        true -> count
      end
    end
  end
  def count_land(matrix, position_history, i, j, count)do
    if elem(elem(matrix, i), j) != :counted do
      cond do
        i > 0 && elem(elem(matrix, i-1), j) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [{i, j} | position_history], i-1, j, count+1)
        j < tuple_size(elem(matrix, 0))-1 && elem(elem(matrix, i), j+1) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [{i, j} | position_history], i, j+1, count+1)
        i < tuple_size(matrix)-1 && elem(elem(matrix, i+1), j) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [{i, j} | position_history], i+1, j, count+1)
        j > 0 && elem(elem(matrix, i), j-1) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), position_history, i, j-1, count+1)
        true -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), tl(position_history), elem(hd(position_history), 0), elem(hd(position_history), 1), count+1)
      end
    else
      cond do
        i > 0 && elem(elem(matrix, i-1), j) == ?. -> count_land(matrix, [{i, j} | position_history], i-1, j, count)
        j < tuple_size(elem(matrix, 0))-1 && elem(elem(matrix, i), j+1) == ?. -> count_land(matrix, [{i, j} | position_history], i, j+1, count)
        i < tuple_size(matrix)-1 && elem(elem(matrix, i+1), j) == ?. -> count_land(matrix, [{i, j} | position_history], i+1, j, count)
        j > 0 && elem(elem(matrix, i), j-1) == ?. -> count_land(matrix, position_history, i, j-1, count)
        true -> count_land(matrix, tl(position_history), elem(hd(position_history), 0), elem(hd(position_history), 1), count)
      end
    end
  end
end

Challenge_1.solve_cases()
