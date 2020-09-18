defmodule AeMdwWeb.OracleController do
  use AeMdwWeb, :controller

  alias :aeser_api_encoder, as: Enc
  alias AeMdw.Validate
  alias AeMdw.Db.Model
  alias AeMdw.Db.Format
  alias AeMdw.Db.Oracle
  alias AeMdw.Db.Stream, as: DBS
  alias AeMdw.Error.Input, as: ErrInput
  alias AeMdwWeb.Continuation, as: Cont
  require Model

  import AeMdwWeb.Util
  import AeMdw.Db.Util

  ##########

  def stream_plug_hook(%Plug.Conn{params: params} = conn) do
    alias AeMdwWeb.DataStreamPlug, as: P

    rem = rem_path(conn.path_info)

    P.handle_assign(
      conn,
      (rem == [] && {:ok, {:gen, last_gen()..0}}) || P.parse_scope(rem, ["gen"]),
      P.parse_offset(params),
      {:ok, %{}}
    )
  end

  defp rem_path(["oracles", x | rem]) when x in ["inactive", "active"], do: rem
  defp rem_path(["oracles" | rem]), do: rem

  ##########

  def oracle(conn, %{"id" => id} = params),
    do: handle_input(conn, fn ->
          oracle_reply(conn, Validate.id!(id, [:oracle_pubkey]), expand?(params))
        end)

  def inactive_oracles(conn, _req),
    do: handle_input(conn, fn -> Cont.response(conn, &json/2) end)

  def active_oracles(conn, _req),
    do: handle_input(conn, fn -> Cont.response(conn, &json/2) end)

  def oracles(conn, _req),
    do: handle_input(conn, fn -> Cont.response(conn, &json/2) end)

  ##########

  # scope is used here only for identification of the continuation
  def db_stream(:inactive_oracles, params, _scope),
    do: do_inactive_oracles_stream(validate_params!(params), expand?(params))

  def db_stream(:active_oracles, params, _scope),
    do: do_active_oracles_stream(validate_params!(params), expand?(params))

  def db_stream(:oracles, params, _scope),
    do: do_oracles_stream(validate_params!(params), expand?(params))

  ##########

  def oracle_reply(conn, pubkey, expand?) do
    with {m_oracle, source} <- Oracle.locate(pubkey) do
      json(conn, Format.to_map(m_oracle, source, expand?))
    else
      nil ->
        raise ErrInput.NotFound, value: Enc.encode(:oracle_pubkey, pubkey)
    end
  end

  ##########

  def do_inactive_oracles_stream(dir, expand?),
    do: DBS.Oracle.inactive_oracles(dir, exp_to_formatted_oracle(Model.InactiveOracle, expand?))

  def do_active_oracles_stream(dir, expand?),
    do: DBS.Oracle.active_oracles(dir, exp_to_formatted_oracle(Model.ActiveOracle, expand?))

  def do_oracles_stream(:forward, expand?),
    do: Stream.concat(
          do_inactive_oracles_stream(:forward, expand?),
          do_active_oracles_stream(:forward, expand?))

  def do_oracles_stream(:backward, expand?),
    do: Stream.concat(
          do_active_oracles_stream(:backward, expand?),
          do_inactive_oracles_stream(:backward, expand?))

  ##########

  def validate_params!(params),
    do: do_validate_params!(Map.delete(params, "expand"))

  def do_validate_params!(%{"direction" => [dir]}) do
    dir in ["forward", "backward"] || raise ErrInput.Query, value: "direction=#{dir}"
    String.to_atom(dir)
  end

  def do_validate_params!(_params),
    do: :backward

  def exp_to_formatted_oracle(table, expand?) do
    fn {:expiration, {_, pubkey}, _} ->
      case Oracle.locate(pubkey) do
        {m_oracle, ^table} -> Format.to_map(m_oracle, table, expand?)
        _ -> nil
      end
    end
  end
end
