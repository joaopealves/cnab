defmodule ExCnab.Cnab240.Services.VerifyFile do
  @moduledoc """
  Service to verify file and return some fields to client
  """
  alias ExCnab.Cnab240.Services.ProcessFile

  @spec run(String.t()) :: {:ok, Map.t()}
  def run(file) do
    file
    |> ProcessFile.run()
    |> build_response()
  end

  defp build_response({:ok, processed_file}) do
    cnab240 = processed_file.cnab240
    client = cnab240.arquivo_header.empresa.nome_empresa
    cooperativa = cnab240.arquivo_header.nome_banco

    amount = amount_template(cnab240.detalhes)

    {
      :ok,
      %{
        cooperativa: cooperativa,
        cliente: client,
        arquivo: processed_file.informacoes_extras.nome_arquivo,
        totais: amount
      }
    }
  end

  @payment_template %{
    doc: 0,
    op: 0,
    ted: 0,
    pix: 0,
    credito_conta: 0
  }
  defp amount_template(details) do
    Enum.reduce(details, @payment_template, fn detail, acc ->
      %{quantidade: amount, tipo: transaction_type} = detail.valor

      amount = String.to_integer(amount)

      Map.update(acc, transaction_type, amount, &(&1 + amount))
    end)
  end
end