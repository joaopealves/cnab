defmodule Cnab.Cnab240.Services.GetFileInfo do
  @moduledoc """
  Service to get file infos from filename
  """

  import Helpers.ConvertPosition

  @spec run(String.t()) :: {:ok, Map.t()}
  def run(filename) do
    filename
    |> String.slice(0..3)
    |> String.match?(~r/\d+/)
    |> filename_template(filename)
  end

  defp filename_template(true, filename) do
    {:ok,
     %{
       codigo_convenio: convert_position(filename, 1, 3),
       dia_geracao_arquivo: convert_position(filename, 4, 5),
       codigo_mes_geracao_arquivo: convert_position(filename, 6),
       sequencia_arquivo: convert_position(filename, 7, 8)
     }}
  end

  defp filename_template(false, filename) do
    {:ok,
     %{
       codigo_convenio: convert_position(filename, 1, 4),
       dia_geracao_arquivo: convert_position(filename, 5, 6),
       sequencia_arquivo: convert_position(filename, 7, 8)
     }}
  end
end
