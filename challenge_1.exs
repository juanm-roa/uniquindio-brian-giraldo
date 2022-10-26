defmodule Challenge_1 do
  @moduledoc """
  Documentation for `Challenge`.

  Este modulo consta de 5 funciones, las cuales son utilizadas para la solucion
  del reto con nombre "Guilty Prince"; como entrada recibe en la primera linea la
  cantidad de casos de prueba a evaluar, posteriormente recibe dos enterios en una
  linea que hacen referencia a la cantidad de filas y comunas del caso de prueba, y
  por ultimo el caso de prueba linea por linea, asi hasta llegar a la cantidad de
  casos de prueba especificada al inicio de la entrada; como salida imprime por cada
  caso la cantidad de tierra que puede recorrer incluida en la que se encuentra el
  principe, de forma que se pone el numero de caso y la cantidad de tierra accesible
  como se ve a conjtinuación -> "Case 1: 45"
  """

  @doc """
  Funcion que inicia el flujo de la solución, haciendo la lectura de la primera entrada
  cantidad de casos de prueba, para posterior mente solucionar uno por uno.
  """
  def solve_cases() do
    {cases, _} = IO.gets("") |> Integer.parse
    Enum.each(1..cases, fn(c) ->
      [_, b] = IO.gets("") |> String.split |> Enum.map(&String.to_integer/1)
      read_case(b,[], c)
    end)
  end

  @doc """
  Funcion que lee un caso de prueba y hace el llamado a las respecitvas funcionas para dar
  solución.
  Funcionamiento: obtiene repetidas veces las entradas de casa linea del caso de prueba,
  descontando de uno en uno al parametro limite que es la cantidad de filas, una vez llega
  a 0, se detiene e imprime la solucion de ese caso de prueba.
  Parametros:
  limit = cantidad de filas del caso de prueba.
  case_built = lista con todas las filas del caso de prueba.
  count = el numero de caso de prueba para imprimir la salida.
  """
  def read_case( 0, case_built, count) do
    {:ok, matrix} = create_matrix(case_built, {})
    {i, j} = find_prince(matrix, 0, 0)
    amount_land =  count_land(matrix, [], i, j, 0)
    IO.puts("Case #{count}: #{amount_land}")
  end
  def read_case( limit, case_built, count), do: read_case(limit-1, [ IO.gets("") | case_built], count)

  @doc """
  Funcion recibe una lista con todas las filas del caso de prueba y procede a convertir
  la lista en una tupla de tuplas.
  Funcionamiento: recorre uno a uno los elementos de la lista, convierte el elemento a un charlist
  para posterior mente convertirlo a una tupla y luego mediante la funcion Tuple.append se crea una
  copia de la tupla matrix con la tupla recien agregada y se invoca el metodo nuevamente, enviando
  como parametro la cola de la lista y la nueva tupla, se detiene una vez la lista este vacia,
  retornando una tupla con el atomo :ok y la matrix generada.
  Parametros:
  [head|tail] = lista de las filas del caso de prueba, dividida en cabeza y cola.
  matrix = tupla donde se agrega cada elemento de la lista convertido a tupla.
  """
  def create_matrix([], matrix), do: {:ok, matrix}
  def create_matrix([head | tail], matrix), do: create_matrix(tail,  Tuple.append( matrix, List.to_tuple(String.to_charlist(head))))

  @doc """
  Funcion recibe la matriz del caso de prueba y la recorre hasta encontrar la posición del caracter
  '@'.
  Funcionamiento: recorre uno a uno los elementos de la tupla de tuplas (matriz) del caso de prueba
  comparando cada elemento con el caracter '@' que representa al principe, en caso de llegar a la
  posicion final de la matriz se imprime "Prince not found" y en caso de que un elemento coincida
  se retorna una tupla con los dos elemento i y j (posicion del principe).
  Parametros:
  matrix= tupla de tuplas (matriz) donde se encuentra representado del caso de prueba.
  i = posición del recorrido actual en filas
  j = posición del recorrido actual en columnas
  """
  def find_prince(matrix, i, j) do
    cond do
      elem(elem(matrix, i), j) == ?@ -> {i, j}
      i == tuple_size(matrix)-1 && j == tuple_size(elem(matrix, 0))-1 -> IO.puts("Prince not found")
      j == tuple_size(elem(matrix, 0))-1 -> find_prince(matrix, i+1, 0)
      true -> find_prince(matrix, i, j+1)
    end
  end

  @doc """
  Funcion recibe la matriz del caso de prueba, una lista de posiciones, la position inicial del
  principe i y j, y un contador, para posterior mente contar las catidades de tierra accesible
  desde la posicion inicial del principe.
  Funcionamiento: inicialmente se inicia el recorrido de la matriz desde la posicion inicial
  i, j donde se encuentra el caracter '@' (principe), el algoritmo de recorrido se realiza
  de la siguiente forma, verifica primero si se puede avanzar primero arriba, luego derecha,
  luego abajo y por ultimo izquierda, en la primera iteración se verifica el movimiento, una
  vez encontrado un movimiento, una vez se encuentra se llama al metodo nuevamente pasando
  como parametros la matriz cambiando el elemento actual a un atomo :counted, una lista con
  la posicion actual como cabeza y dependiendo del tipo de movimiento se modifica el i y j,
  y se envia 1 como contador.
  Para las demás iteraciones se realiza inicialmente una validacion, si al posicion actual
  ya esta contada, es decir si es un atomo :counted, entonces se realiza la verificion de
  movimiento sin sumar nada al contador, en caso de no estar contada se procede a
  verificar el proximo movimiento, y se llama al metodo nuevamente, esta vez enviando como
  parametro la matriz modificada, la ubicacion actual como cabeza de position_history,
  dependiendo del movimiento de resta o suma en i y j, y sumamos uno al contador.
  Se detiene cuando no tiene mas elementos en position_history y no hay posibles movimientos
  retornando el countador, en caso de que la posicion actual no este contada seria el
  contador + 1.
  Parametros:
  matrix= tupla de tuplas (matriz) donde se encuentra representado del caso de prueba.
  position_history = lista de celdas con movimientos pendientes, la lista es utilizada como pila.
  i = posición actual del principe en fila
  j = posición actual del principe en columna
  count = suma de los caracteres '.' accesibles desde la posición inicial del principe.
  """
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

alias Challenge_1

Challenge_1.solve_cases()
