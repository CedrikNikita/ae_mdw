defmodule AeMdw.Migrations.CreateAccountTransactionsCountStats do
  @moduledoc false
  alias AeMdw.Collection
  alias AeMdw.Db.StatisticsMutation
  alias AeMdw.Db.State
  alias AeMdw.Db.Model
  alias AeMdw.Db.Sync.Stats

  require Model
  require Logger

  @spec run(State.t(), boolean()) :: {:ok, non_neg_integer()}
  def run(state, _from_start?) do
    {:ok, counter_agent} = Agent.start_link(fn -> 0 end)

    _state =
      state
      |> Collection.stream(Model.Tx, :forward, nil, nil)
      |> Stream.chunk_every(1000)
      |> Task.async_stream(
        fn txis ->
          txis
          |> Task.async_stream(
            fn txi ->
              Model.tx(id: tx_id, time: time) = State.fetch!(state, Model.Tx, txi)

              tx =
                tx_id
                |> :aec_db.get_signed_tx()
                |> :aetx_sign.tx()

              {tx_type, _tx} = :aetx.specialize_type(tx)
              account_id = :aetx.origin(tx)

              time
              |> Stats.time_intervals()
              |> Enum.flat_map(fn {interval_by, interval_start} ->
                [
                  {{{:transactions, account_id, tx_type}, interval_by, interval_start}, 1},
                  {{{:transactions, account_id, :all}, interval_by, interval_start}, 1}
                ]
              end)
              |> StatisticsMutation.new()
            end,
            timeout: :infinity,
            ordered: false
          )
          |> Enum.map(fn {:ok, mutation} -> mutation end)
        end,
        timeout: :infinity,
        ordered: false
      )
      |> Enum.map(fn {:ok, mutations} ->
        len = length(mutations)

        Agent.update(
          counter_agent,
          fn count ->
            total_count = count + len

            tap(total_count, &Logger.info("Processed transactions: #{&1}"))
          end,
          :infinity
        )

        _state = State.commit_db(state, mutations)
      end)

    count = Agent.get(counter_agent, & &1)

    {:ok, count}
  end
end
