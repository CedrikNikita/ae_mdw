defmodule AeMdwWeb.UtilController do
  use AeMdwWeb, :controller
  use PhoenixSwagger

  swagger_path :status do
    get("/status")
    description("Get middleware status.")
    produces(["application/json"])
    deprecated(false)
    operation_id("get_status")
    tag("Middleware")
    response(200, "Returns the status of the MDW.", %{})
  end

  def status(conn, _params) do
    {:ok, top_kb} = :aec_chain.top_key_block()
    {_, _, node_vsn} = Application.started_applications() |> List.keyfind(:aecore, 0)
    node_height = :aec_blocks.height(top_kb)
    mdw_height = AeMdw.Db.Util.last_gen()

    status = %{
      node_version: to_string(node_vsn),
      node_height: node_height,
      mdw_version: AeMdw.MixProject.project()[:version],
      mdw_height: mdw_height,
      mdw_tx_index: AeMdw.Db.Util.last_txi(),
      mdw_synced: node_height == mdw_height
    }

    json(conn, status)
  end

  def no_route(conn, _params),
    do: conn |> AeMdwWeb.Util.send_error(404, "no such route")
end
