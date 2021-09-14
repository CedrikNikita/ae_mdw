defmodule Mix.Tasks.MigrateDb do
  use Mix.Task

  require Ex2ms

  alias AeMdw.Db.Model
  alias AeMdw.Db.Util
  alias AeMdw.Log

  @table Model.Migrations
  @record_name Model.record(@table)
  @version_len 14

  @migrations_code_path "priv/migrations/*.ex"

  @impl Mix.Task
  def run(_) do
    :net_kernel.start([:aeternity@localhost, :shortnames])
    :ae_plugin_utils.start_aecore()
    :lager.set_loglevel(:epoch_sync_lager_event, :lager_console_backend, :undefined, :error)
    :lager.set_loglevel(:lager_console_backend, :error)
    Log.info("================================================================================")
    current_version = read_migration_version()
    Log.info("current migration version: #{current_version}")

    applied_count =
      current_version
      |> list_new_migrations()
      |> Enum.map(&apply_migration!/1)
      |> length()

    # assure filesystem sync
    if applied_count > 0 do
      :mnesia.dump_log()
    else
      Log.info("migrations are up to date")
    end

    {:ok, applied_count}
  end

  @spec read_migration_version() :: integer()
  defp read_migration_version() do
    version_spec =
      Ex2ms.fun do
        {_, version, _} -> version
      end

    Util.select(@table, version_spec) |> Enum.max(fn -> -1 end)
  end

  @spec list_new_migrations(integer()) :: [{integer(), String.t()}]
  defp list_new_migrations(current_version) do
    @migrations_code_path
    |> Path.wildcard()
    |> Enum.map(fn path ->
      version =
        path
        |> Path.basename()
        |> String.slice(0..(@version_len - 1))

      {String.to_integer(version), path}
    end)
    |> Enum.filter(fn {version, _path} -> version > current_version end)
    |> Enum.sort_by(fn {version, _path} -> version end)
  end

  # ignore for Code.compile_file
  @dialyzer {:no_return, apply_migration!: 1}

  @spec apply_migration!({integer(), String.t()}) :: :ok
  defp apply_migration!({version, path}) do
    [{module, _}] = Code.compile_file(path)
    Log.info("applying version #{version} with #{module}...")
    {:ok, _} = apply(module, :run, [])

    :mnesia.sync_dirty(fn ->
      :mnesia.write(@table, {@record_name, version, DateTime.utc_now()}, :write)
    end)

    Log.info("applied version #{version}")
    :ok
  end
end