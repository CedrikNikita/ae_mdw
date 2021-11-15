defmodule AeMdw.Sync.AsyncTasks.UpdateAex9Presence do

  alias AeMdw.Node.Db, as: DBN

  alias AeMdw.Db.Contract
  alias AeMdw.Db.Model
  alias AeMdw.Log

  require Model
  require Logger

  @microsecs 1_000_000

  @spec process(Model.async_tasks_record()) :: :ok
  def process(
         Model.async_tasks(
           index: {_ts, __MODULE__},
           args: [contract_pk]
         )
       ) do
    Log.info("[update_aex9_presence] #{inspect(contract_pk)} ...")
    {time_delta, {amounts, _last_block_tuple}} = :timer.tc(fn -> DBN.aex9_balances(contract_pk) end)
    Log.info("[update_aex9_presence] #{inspect(contract_pk)} after #{time_delta / @microsecs}s")

    :mnesia.sync_transaction(fn ->
      Enum.each(amounts, fn {{:address, account_pk}, _amount} ->
        Contract.aex9_write_new_presence(contract_pk, -1, account_pk)
      end)
    end)
  end
end
