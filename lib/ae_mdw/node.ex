defmodule AeMdw.Node do
  @moduledoc """
  Sample module to understand all of the functions the AwMdw.Node module
  provides. Including it's specs as well.

  Right now this module and its functions are defined using the
  SmartGlobal library at runtime. The purpose of the module is to make
  all of these functions more explicit.
  """

  defmodule Oracle do
    def get!(_a, _b), do: 0
  end

  @spec aens_tree_pos(:cache | :mtree) :: non_neg_integer()
  def aens_tree_pos(_tree_type) do
    0
  end

  @spec aeo_tree_pos(:cache | :otree) :: non_neg_integer()
  def aeo_tree_pos(_tree_type) do
    0
  end

  @spec aex9_signatures :: %{binary() => term()}
  def aex9_signatures do
    %{}
  end

  @spec aex9_transfer_event_hash :: binary()
  def aex9_transfer_event_hash do
    ""
  end

  @spec hdr_fields(:key | :micro) :: [atom()]
  def hdr_fields(_arg) do
    ~w(height prev_hash)a
  end

  @spec height_proto :: [{non_neg_integer(), non_neg_integer()}]
  def height_proto do
    []
  end

  @spec id_field_type(atom()) :: %{atom() => non_neg_integer()} | nil
  def id_field_type(_field) do
    %{}
  end

  @spec id_fields :: MapSet.t()
  def id_fields do
    MapSet.new()
  end

  @spec id_prefix(binary()) :: atom()
  def id_prefix(_arg) do
  end

  @spec id_prefixes :: MapSet.t()
  def id_prefixes do
    MapSet.new()
  end

  @spec id_type(atom()) :: atom()
  def id_type(_arg) do
  end

  @spec lima_height :: non_neg_integer()
  def lima_height do
    0
  end

  @spec lima_vsn :: non_neg_integer()
  def lima_vsn do
    0
  end

  @spec max_blob :: binary()
  def max_blob do
    ""
  end

  @spec min_block_reward_height :: non_neg_integer()
  def min_block_reward_height do
    0
  end

  @spec stream_mod(module()) :: module()
  def stream_mod(mod) do
    mod
  end

  @spec token_supply_delta(non_neg_integer()) :: non_neg_integer()
  def token_supply_delta(_arg) do
    0
  end

  @spec tx_field_types(atom()) :: MapSet.t()
  def tx_field_types(_arg) do
    MapSet.new()
  end

  @spec tx_fields(atom()) :: [atom()]
  def tx_fields(_arg) do
    []
  end

  @spec tx_group(atom()) :: [atom()]
  def tx_group(_arg) do
    []
  end

  @spec tx_groups :: MapSet.t()
  def tx_groups do
    MapSet.new()
  end

  @spec tx_ids(atom()) :: %{atom() => non_neg_integer()}
  def tx_ids(_arg) do
    %{}
  end

  @spec tx_mod(module()) :: module()
  def tx_mod(_arg) do
    :foo
  end

  @spec tx_name(atom()) :: binary()
  def tx_name(_arg) do
    ""
  end

  @spec tx_prefixes :: MapSet.t()
  def tx_prefixes do
    MapSet.new()
  end

  @spec tx_type(binary()) :: atom()
  def tx_type(_arg) do
    :foo
  end

  @spec tx_types :: MapSet.t()
  def tx_types do
    MapSet.new()
  end

  @spec type_id(atom()) :: atom()
  def type_id(_arg) do
  end
end