defmodule AeMdwWeb.Aex9Controller do
  use AeMdwWeb, :controller
  use PhoenixSwagger

  alias AeMdw.Validate
  alias AeMdw.Error.Input, as: ErrInput
  alias AeMdw.Db.{Format, Model, Contract}
  alias AeMdwWeb.SwaggerParameters
  alias AeMdwWeb.DataStreamPlug, as: DSPlug

  import AeMdwWeb.Util

  ##########

  def by_names(conn, params),
    do:
     handle_input(
       conn,
       fn -> by_names_reply(conn, search_mode!(params), list_all(params)) end
     )

  def by_symbols(conn, params),
    do:
     handle_input(
       conn,
       fn -> by_symbols_reply(conn, search_mode!(params), list_all(params)) end
     )

  def balance(conn, %{"contract_id" => contract_id, "account_id" => account_id}),
    do:
      handle_input(
        conn,
        fn ->
          balance_reply(
            conn,
            ensure_aex9_contract_pk!(contract_id),
            Validate.id!(account_id, [:account_pubkey])
          )
        end
      )

  def balance_range(conn, %{
        "range" => range,
        "contract_id" => contract_id,
        "account_id" => account_id
      }),
      do:
        handle_input(
          conn,
          fn ->
            balance_range_reply(
              conn,
              ensure_aex9_contract_pk!(contract_id),
              Validate.id!(account_id, [:account_pubkey]),
              parse_range!(range)
            )
          end
        )

  def balance_for_hash(conn, %{
        "blockhash" => block_hash_enc,
        "contract_id" => contract_id,
        "account_id" => account_id
      }),
      do:
        handle_input(
          conn,
          fn ->
            balance_for_hash_reply(
              conn,
              ensure_aex9_contract_pk!(contract_id),
              Validate.id!(account_id, [:account_pubkey]),
              ensure_block_hash_and_height!(block_hash_enc)
            )
          end
        )

  def balances(conn, %{"contract_id" => contract_id}),
    do: handle_input(conn, fn -> balances_reply(conn, ensure_aex9_contract_pk!(contract_id)) end)

  def balances_range(conn, %{"range" => range, "contract_id" => contract_id}),
    do:
      handle_input(
        conn,
        fn ->
          balances_range_reply(
            conn,
            ensure_aex9_contract_pk!(contract_id),
            parse_range!(range)
          )
        end
      )

  def balances_for_hash(conn, %{"blockhash" => block_hash_enc, "contract_id" => contract_id}),
    do:
      handle_input(
        conn,
        fn ->
          balances_for_hash_reply(
            conn,
            ensure_aex9_contract_pk!(contract_id),
            ensure_block_hash_and_height!(block_hash_enc)
          )
        end
      )

  ##########

  def by_names_reply(conn, prefix, all?) do
    entries =
      Contract.aex9_search_name(prefix, all?)
      |> Enum.map(&Format.to_map(&1, Model.Aex9Contract))

    json(conn, entries)
  end

  def by_symbols_reply(conn, prefix, all?) do
    entries =
      Contract.aex9_search_symbol(prefix, all?)
      |> Enum.map(&Format.to_map(&1, Model.Aex9ContractSymbol))

    json(conn, entries)
  end

  def balance_reply(conn, contract_pk, account_pk) do
    {amount, {height, hash}} = AeMdw.Node.Db.aex9_balance(contract_pk, account_pk)
    json(conn, balance_to_map({amount, {:key, height, hash}}, contract_pk, account_pk))
  end

  def balance_range_reply(conn, contract_pk, account_pk, range) do
    json(
      conn,
      %{
        contract_id: enc_ct(contract_pk),
        account_id: enc_id(account_pk),
        range:
          map_balances_range(
            range,
            fn height_hash ->
              {amount, _} = AeMdw.Node.Db.aex9_balance(contract_pk, account_pk, height_hash)
              {:amount, amount}
            end
          )
      }
    )
  end

  def balance_for_hash_reply(conn, contract_pk, account_pk, {block_type, block_hash, height}) do
    {amount, _} = AeMdw.Node.Db.aex9_balance(contract_pk, account_pk, {height, block_hash})

    json(
      conn,
      balance_to_map({amount, {block_type, height, block_hash}}, contract_pk, account_pk)
    )
  end

  def balances_reply(conn, contract_pk) do
    {amounts, {height, hash}} = AeMdw.Node.Db.aex9_balances(contract_pk)
    json(conn, balances_to_map({amounts, {:key, height, hash}}, contract_pk))
  end

  def balances_range_reply(conn, contract_pk, range) do
    json(
      conn,
      %{
        contract_id: enc_ct(contract_pk),
        range:
          map_balances_range(
            range,
            fn height_hash ->
              {amounts, _} = AeMdw.Node.Db.aex9_balances(contract_pk, height_hash)
              {:amounts, normalize_balances(amounts)}
            end
          )
      }
    )
  end

  def balances_for_hash_reply(conn, contract_pk, {block_type, block_hash, height}) do
    {amounts, _} = AeMdw.Node.Db.aex9_balances(contract_pk, {height, block_hash})
    json(conn, balances_to_map({amounts, {block_type, height, block_hash}}, contract_pk))
  end

  ##########

  def search_mode!(%{"prefix" => _, "exact" => _}),
    do: raise ErrInput.Query, value: "can't use both `prefix` and `exact` parameters"
  def search_mode!(%{"exact" => exact}),
    do: {:exact, exact}
  def search_mode!(%{} = params),
    do: {:prefix, Map.get(params, "prefix", "")}


  def list_all(%{"all" => x}) when x in [nil, "true", [nil], ["true"]], do: true
  def list_all(%{}), do: false

  def parse_range!(range) do
    case DSPlug.parse_range(range) do
      {:ok, %Range{first: f, last: l}} ->
        {:ok, top_kb} = :aec_chain.top_key_block()
        max(0, f)..min(l, :aec_blocks.height(top_kb))

      {:error, _detail} ->
        raise ErrInput.NotAex9, value: range
    end
  end

  def ensure_aex9_contract_pk!(ct_ident) do
    pk = Validate.id!(ct_ident, [:contract_pubkey])
    AeMdw.Contract.is_aex9?(pk) || raise ErrInput.NotAex9, value: ct_ident
    pk
  end

  def ensure_block_hash_and_height!(block_ident) do
    case :aeser_api_encoder.safe_decode(:block_hash, block_ident) do
      {:ok, block_hash} ->
        case :aec_chain.get_block(block_hash) do
          {:ok, block} ->
            {:aec_blocks.type(block), block_hash, :aec_blocks.height(block)}

          :error ->
            raise ErrInput.NotFound, value: block_ident
        end

      _ ->
        raise ErrInput.Query, value: block_ident
    end
  end

  ##########

  def normalize_balances(bals) do
    for {{:address, pk}, amt} <- bals, reduce: %{} do
      acc ->
        Map.put(acc, :aeser_api_encoder.encode(:account_pubkey, pk), amt)
    end
  end

  def balance_to_map({amount, {block_type, height, block_hash}}, contract_pk, account_pk) do
    %{
      contract_id: enc_ct(contract_pk),
      block_hash: enc_block(block_type, block_hash),
      height: height,
      account_id: enc_id(account_pk),
      amount: amount
    }
  end

  def balances_to_map({amounts, {block_type, height, block_hash}}, contract_pk) do
    %{
      contract_id: enc_ct(contract_pk),
      block_hash: enc_block(block_type, block_hash),
      height: height,
      amounts: normalize_balances(amounts)
    }
  end

  def map_balances_range(range, f) do
    Stream.map(
      height_hash_range(range),
      fn {height, hash} ->
        {k, v} = f.({height, hash})
        Map.put(%{height: height, block_hash: enc_block(:key, hash)}, k, v)
      end
    )
    |> Enum.to_list()
  end

  def height_hash_range(range) do
    Stream.map(
      range,
      fn h ->
        {:ok, block} = :aec_chain.get_key_block_by_height(h)
        {:ok, hash} = :aec_headers.hash_header(:aec_blocks.to_header(block))
        {h, hash}
      end
    )
  end

  def enc_block(:key, hash), do: :aeser_api_encoder.encode(:key_block_hash, hash)
  def enc_block(:micro, hash), do: :aeser_api_encoder.encode(:micro_block_hash, hash)

  def enc_ct(pk), do: :aeser_api_encoder.encode(:contract_pubkey, pk)
  def enc_id(pk), do: :aeser_api_encoder.encode(:account_pubkey, pk)

  # TODO: swagger

  # def swagger_definitions do
  #   %{
  #     Aex9Response:
  #       swagger_schema do
  #         title("Aex9Response")
  #         description("Schema for AEX9 contract")

  #         properties do
  #           name(:string, "The name of AEX9 token", required: true)
  #           symbol(:string, "The symbol of AEX9 token", required: true)
  #           decimals(:integer, "The number of decimals for AEX9 token", required: true)
  #           txi(:integer, "The transaction index of contract create transction", required: true)
  #         end

  #         example(%{
  #               decimals: 18,
  #               name: "testnetAE",
  #               symbol: "TTAE",
  #               txi: 11145713
  #         })
  #       end
  #   }
  # end
end
