defmodule AeMdw.Db.Sync.StatsTest do
  use ExUnit.Case

  import Mock
  alias AeMdw.Db.StatisticsMutation
  alias AeMdw.Db.StatsMutation
  alias AeMdw.Db.Sync.Stats

  describe "micro_block_mutations/2" do
    test "when no count, it returns block counts only" do
      mutation =
        StatisticsMutation.new([
          {{{:blocks, :micro}, :day, 0}, 1},
          {{{:blocks, :all}, :day, 0}, 1},
          {{{:blocks, :micro}, :week, 0}, 1},
          {{{:blocks, :all}, :week, 0}, 1},
          {{{:blocks, :micro}, :month, 0}, 1},
          {{{:blocks, :all}, :month, 0}, 1}
        ])

      time = 2
      assert ^mutation = Stats.micro_block_mutations(time, %{}, %{})
    end

    test "when count > 0, it returns a mutation with all stats changes" do
      time1 = 0
      time2 = 31_536_000_000
      account_id1 = <<1::256>>
      account_id2 = <<2::256>>

      type_counts = [
        oracle_register_tx: 18,
        spend_tx: 1
      ]

      account_type_counts = %{
        account_id1 => [oracle_register_tx: 9, spend_tx: 1],
        account_id2 => [oracle_register_tx: 9]
      }

      mutation1 =
        [
          {{{:blocks, :micro}, :day, 0}, 1},
          {{{:blocks, :all}, :day, 0}, 1},
          {{{:blocks, :micro}, :week, 0}, 1},
          {{{:blocks, :all}, :week, 0}, 1},
          {{{:blocks, :micro}, :month, 0}, 1},
          {{{:blocks, :all}, :month, 0}, 1},
          {{{:transactions, :all}, :day, 0}, 19},
          {{{:transactions, :oracle_register_tx}, :day, 0}, 18},
          {{{:transactions, :spend_tx}, :day, 0}, 1},
          {{{:transactions, :all}, :week, 0}, 19},
          {{{:transactions, :oracle_register_tx}, :week, 0}, 18},
          {{{:transactions, :spend_tx}, :week, 0}, 1},
          {{{:transactions, :all}, :month, 0}, 19},
          {{{:transactions, :oracle_register_tx}, :month, 0}, 18},
          {{{:transactions, :spend_tx}, :month, 0}, 1}
        ]

      mutation2 =
        [
          {{{:blocks, :micro}, :day, 365}, 1},
          {{{:blocks, :all}, :day, 365}, 1},
          {{{:blocks, :micro}, :week, 52}, 1},
          {{{:blocks, :all}, :week, 52}, 1},
          {{{:blocks, :micro}, :month, 12}, 1},
          {{{:blocks, :all}, :month, 12}, 1},
          {{{:transactions, :all}, :day, 365}, 19},
          {{{:transactions, :oracle_register_tx}, :day, 365}, 18},
          {{{:transactions, :spend_tx}, :day, 365}, 1},
          {{{:transactions, :all}, :week, 52}, 19},
          {{{:transactions, :oracle_register_tx}, :week, 52}, 18},
          {{{:transactions, :spend_tx}, :week, 52}, 1},
          {{{:transactions, :all}, :month, 12}, 19},
          {{{:transactions, :oracle_register_tx}, :month, 12}, 18},
          {{{:transactions, :spend_tx}, :month, 12}, 1}
        ]

      %StatisticsMutation{statistics: actual1} =
        Stats.micro_block_mutations(time1, type_counts, account_type_counts)

      %StatisticsMutation{statistics: actual2} =
        Stats.micro_block_mutations(time2, type_counts, account_type_counts)

      Enum.each(mutation1, fn m1 ->
        assert m1 in actual1
      end)

      Enum.each(mutation2, fn m2 ->
        assert m2 in actual2
      end)

      assert {{{:transactions, account_id1, :all}, :day, 0}, 10} in actual1
      assert {{{:transactions, account_id1, :oracle_register_tx}, :day, 0}, 9} in actual1
      assert {{{:transactions, account_id1, :spend_tx}, :day, 0}, 1} in actual1
      assert {{{:transactions, account_id1, :all}, :week, 0}, 10} in actual1
      assert {{{:transactions, account_id1, :oracle_register_tx}, :week, 0}, 9} in actual1
      assert {{{:transactions, account_id1, :spend_tx}, :week, 0}, 1} in actual1

      assert {{{:transactions, account_id2, :all}, :day, 0}, 9} in actual1
      assert {{{:transactions, account_id2, :oracle_register_tx}, :day, 0}, 9} in actual1
      refute {{{:transactions, account_id2, :spend_tx}, :day, 0}, 0} in actual1
      assert {{{:transactions, account_id2, :all}, :week, 0}, 9} in actual1
      assert {{{:transactions, account_id2, :oracle_register_tx}, :week, 0}, 9} in actual1
      refute {{{:transactions, account_id2, :spend_tx}, :week, 0}, 0} in actual1
    end
  end

  describe "key_block_mutations/2" do
    test "it returns a mutation with all the statistics changes" do
      time1 = 0
      time2 = 31_536_000_000

      with_mocks([{:aec_blocks, [:passthrough], [difficulty: fn _block -> 2 end]}]) do
        [key_block1, key_block2] =
          Enum.map([time1, time2], fn time ->
            :aec_blocks.new_key(
              1,
              <<0::256>>,
              <<1::256>>,
              <<2::256>>,
              2,
              3,
              time,
              :default,
              1,
              <<3::256>>,
              <<4::256>>
            )
          end)

        mutation1 =
          StatisticsMutation.new([
            {{{:blocks, :key}, :day, 0}, 1},
            {{{:blocks, :all}, :day, 0}, 1},
            {{:difficulty, :day, 0}, 2},
            {{:hashrate, :day, 0}, 0},
            {{{:blocks, :key}, :week, 0}, 1},
            {{{:blocks, :all}, :week, 0}, 1},
            {{:difficulty, :week, 0}, 2},
            {{:hashrate, :week, 0}, 0},
            {{{:blocks, :key}, :month, 0}, 1},
            {{{:blocks, :all}, :month, 0}, 1},
            {{:difficulty, :month, 0}, 2},
            {{:hashrate, :month, 0}, 0}
          ])

        mutation2 =
          StatisticsMutation.new([
            {{{:blocks, :key}, :day, 365}, 1},
            {{{:blocks, :all}, :day, 365}, 1},
            {{:difficulty, :day, 365}, 2},
            {{:hashrate, :day, 365}, 0},
            {{{:blocks, :key}, :week, 52}, 1},
            {{{:blocks, :all}, :week, 52}, 1},
            {{:difficulty, :week, 52}, 2},
            {{:hashrate, :week, 52}, 0},
            {{{:blocks, :key}, :month, 12}, 1},
            {{{:blocks, :all}, :month, 12}, 1},
            {{:difficulty, :month, 12}, 2},
            {{:hashrate, :month, 12}, 0}
          ])

        key_block1_mutations = Stats.key_block_mutations(1, key_block1, [], 1, 2, false)
        assert mutation1 in key_block1_mutations
        assert mutation2 in Stats.key_block_mutations(1, key_block2, [], 1, 2, false)

        assert Enum.count(key_block1_mutations) == 2

        assert Enum.filter(
                 key_block1_mutations,
                 fn
                   %StatsMutation{} -> true
                   %StatisticsMutation{} -> true
                   _otherwise -> false
                 end
               ) == key_block1_mutations
      end
    end
  end
end
