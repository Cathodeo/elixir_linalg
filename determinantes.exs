defmodule Determinantes do

  #Modulo para utilizarse con otros modulos en los que se calcula
  #la independencia lineal de una matriz.

  #Utilizamos la regla de que una matriz con determinante diferente a 0
  #tiene independencia lineal por filas y columnas.

  #Esto a su vez implica que la matriz introducida,
  #de tener determinante =! 0, se puede expresar
  #como un conjunto de vectores que son base generadora

  #El determinante distinto a 0 tambien implica que una matriz es
  #invertible. Podemos usar el modulo por ende para.

  #-Determinar la independencia lineal / si un conjunto de vectores es base generadora
  #-Determinar si una matriz es invertible

  def pedir_vector(n) do
    #Pedimos la entrada de un vector en un espacio n
    #La entrada se divide en tres String y se convierte en
    #un enum formado por tres integer.
      input =
      IO.gets("Escribe #{n} elementos separados por espacio:")
      |> String.trim()
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)

      if length(input) == n do
      input
    else
      IO.puts("Error: Debes introducir exactamente #{n} números.")
      leer_vector(n)  # pedir de nuevo
    end
  end


  def leer_matriz(filas, columnas) do
  #Iteramos n filas, pidiendo vectores con n dimension (n columnas)
  #y formamos una matriz
  Enum.map(1..filas, fn _ -> pedir_vector(columnas) end)
  end


  def calcular_menor(matriz, fila_idx, col_idx) do
  #Esta funcion elimina la fila y columna del indice seleccionado.
  #Con esta funcion, podemos calcular los cofactores iterando la matriz
  matriz
  |> Enum.with_index()
  |> Enum.reject(fn {_fila, idx} -> idx == fila_idx end)       # eliminar la fila
  |> Enum.map(fn {fila, _idx} ->
       fila
       |> Enum.with_index()
       |> Enum.reject(fn {_elem, c_idx} -> c_idx == col_idx end)  # eliminar columna
       |> Enum.map(fn {elem, _} -> elem end)
     end)
end


def signo_cofactor_menor(menor, fila_idx, col_idx) do
  #ESta funcion calcula el signo del cofactor para el menor adjunto
  signo = if rem(fila_idx + col_idx, 2) == 0, do: 1, else: -1
  det = determinante(menor)
  signo * det
end

#Caso base final, cuando la matriz ha sido reducida a 1x1
def determinante([[x]]), do: x

#Caso en el que la matriz es mayor a 1x1, ejecutado recursivamente
def determinante(matriz) do
    fila = hd(matriz)
    Enum.with_index(fila)
    |> Enum.reduce(0, fn {elem, col_idx}, acc ->
      menor = calcular_menor(matriz, 0, col_idx)
      acc + signo_cofactor_menor(menor, 0, col_idx) * elem
    end)
end


#Ejecucion propiamente dicha en la que pedimos la matriz y
#escupimos el determinante
    def main() do
      filas = 3
      columnas = 3

      IO.puts("Introduce una matriz #{filas}x#{columnas}:")
      matriz = leer_matriz(filas, columnas)

      det = determinante(matriz)
      IO.puts("El determinante es: #{det}")
  end


end
