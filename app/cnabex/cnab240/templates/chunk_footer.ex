defmodule ExCnab.Cnab240.Templates.ChunkFooter do
  @moduledoc """
  Template for rendering a cnab240 chunk footer from a file
  """

  import Helpers.ConvertPosition

  @doc """
  This function generate a Chunk Footer Map from a Cnab240 file, using the **FEBRABAN** convention. The fields follows the convention hierarchy.
  and the returns is in PT BR.

  You can see all hierarchy in the FEBRABAN documentation.

  ```md
  CNAB
  ├── Controle
  │   ├── Banco (1..3)
  │   ├── Lote (4..7)
  │   └── Registro (8..8)
  │
  ├── CNAB - USO FEBRABAN (9..17)
  │
  ├── Totais
  │   ├── Qtde. de registros (18..23)
  │   ├── Somatória dos valores (24..41)
  │   └── Somatória quantidade de moedas (42..59)
  │
  ├── Número aviso débito (60..65)
  │
  ├── CNAB (66..230)
  │
  └── Ocorrências (231..240)
  ```
  """
  @spec generate(String.t(), String.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def generate("J52", raw_string) do
    control_field = control_fields(raw_string)
    total = total_fields(raw_string)

    {:ok,
     %{
       controle: control_field,
       uso_febraban_1: convert_position(raw_string, 9, 17),
       total: total,
       numero_aviso_debito: convert_position(raw_string, 60, 65),
       uso_febraban_2: convert_position(raw_string, 66, 230),
       ocorrencias: convert_position(raw_string, 231, 240)
     }}
  end

  def generate(_, raw_string) do
    control_field = control_fields(raw_string)
    total = total_fields(raw_string)

    {:ok,
     %{
       controle: control_field,
       uso_febraban_1: convert_position(raw_string, 9, 17),
       total: total,
       numero_aviso_previo: convert_position(raw_string, 60, 65),
       uso_febraban_2: convert_position(raw_string, 66, 230),
       ocorrencias: convert_position(raw_string, 231, 240)
     }}
  end

  defp control_fields(raw_string) do
    %{
      codigo_do_banco: convert_position(raw_string, 1, 3),
      lote: convert_position(raw_string, 4, 7),
      registro: convert_position(raw_string, 8, 8)
    }
  end

  defp total_fields(raw_string) do
    %{
      qnt_registros: convert_position(raw_string, 18, 23),
      valor: convert_position(raw_string, 24, 41),
      qnt_moeda: convert_position(raw_string, 42, 59)
    }
  end

  def encode("J52", footer) do
    %{
      controle: %{
        codigo_do_banco: codigo_do_banco,
        lote: lote,
        registro: registro
      },
      uso_febraban_1: uso_febraban_1,
      total: %{
        qnt_registros: qnt_registros,
        valor: valor,
        qnt_moeda: qnt_moeda
      },
      numero_aviso_debito: numero_aviso_debito,
      uso_febraban_2: uso_febraban_2,
      ocorrencias: ocorrencias
    } = footer

    [
      codigo_do_banco,
      lote,
      registro,
      uso_febraban_1,
      qnt_registros,
      valor,
      qnt_moeda,
      numero_aviso_debito,
      uso_febraban_2,
      ocorrencias
    ]
    |> Enum.join()
  end

  def encode(_type, footer) do
    %{
      controle: %{
        codigo_do_banco: codigo_do_banco,
        lote: lote,
        registro: registro
      },
      uso_febraban_1: uso_febraban_1,
      total: %{
        qnt_registros: qnt_registros,
        valor: valor,
        qnt_moeda: qnt_moeda
      },
      numero_aviso_previo: numero_aviso_previo,
      uso_febraban_2: uso_febraban_2,
      ocorrencias: ocorrencias
    } = footer

    [
      codigo_do_banco,
      lote,
      registro,
      uso_febraban_1,
      qnt_registros,
      valor,
      qnt_moeda,
      numero_aviso_previo,
      uso_febraban_2,
      ocorrencias
    ]
    |> Enum.join()
  end
end
