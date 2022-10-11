defmodule AeMdw.Node.ContractCallFixtures do
  @moduledoc false

  @typep pubkey :: AeMdw.Node.Db.pubkey()
  @type fname :: String.t()
  @type fun_arg_res :: map()
  @type call_record :: tuple()
  @type event_log :: {pubkey(), [binary()], binary()}

  @spec fun_args_res(fname()) :: %{arguments: list(), function: fname(), result: map()}
  def fun_args_res("mint") do
    %{
      arguments: [
        %{
          type: :address,
          value: "ak_C4UhJiMx2VEPfZ1cBtQCR6wKbA5eTVFa1ohPfuzqQJb4Lyovz"
        },
        %{type: :int, value: 70_000_000_000_000_000_000}
      ],
      function: "mint",
      result: %{type: :unit, value: ""}
    }
  end

  def fun_args_res("burn") do
    %{
      arguments: [%{type: :int, value: 2}],
      function: "burn",
      result: %{type: :unit, value: ""}
    }
  end

  def fun_args_res("transfer") do
    %{
      arguments: [
        %{
          type: :address,
          value: "ak_vPJEUjgtjNZtPy1VstfVTkdbzcsAKK1SEL54wkAKZrghcyESe"
        },
        %{type: :int, value: 2_000_000_000_000_000_000}
      ],
      function: "transfer",
      result: %{type: :unit, value: ""}
    }
  end

  def fun_args_res("transfer_allowance") do
    %{
      arguments: [
        %{
          type: :address,
          value: "ak_2ELPCWzcTdiyYuumjaV4D7kE843d1Ts27zH1Y2LBMKDbNtfq1Q"
        },
        %{
          type: :address,
          value: "ak_taR2fRi3cXYn7a7DaUNcU2KU41psa5JKmhyPC9QcER5T4efqp"
        },
        %{type: :int, value: 1}
      ],
      function: "transfer_allowance",
      result: %{type: :unit, value: ""}
    }
  end

  def fun_args_res("create_pair") do
    %{
      function: "create_pair",
      arguments: [
        %{
          type: "contract",
          value: "ct_djqMe6j8ujtfEdF8pCHXKeRZNjmuwnb1CH2QWbWRR3w514gGD"
        },
        %{
          type: "contract",
          value: "ct_2FyyQBpTyZozQxkHXFiPx7WNNzKBpajDzkzo3SS9cfEPWdG9BM"
        },
        %{
          type: "variant",
          value: [
            1,
            %{
              type: "int",
              value: 1000
            }
          ]
        },
        %{
          type: "variant",
          value: [
            1,
            %{
              type: "int",
              value: 1_636_041_331_999
            }
          ]
        }
      ],
      result: %{
        type: :contract,
        value: "ct_qtPjVVW8FPBuCD4MBQ7yfZgJNThf9owC5emXcnX1mmJfhUAep"
      }
    }
  end

  @spec call_rec(fname()) :: call_record()
  def call_rec("mint") do
    {:call,
     <<212, 32, 3, 205, 108, 129, 181, 165, 13, 42, 87, 221, 175, 30, 4, 160, 182, 188, 22, 221,
       238, 38, 181, 71, 183, 109, 12, 174, 6, 43, 7, 223>>,
     {:id, :account,
      <<177, 109, 71, 150, 121, 127, 54, 94, 201, 60, 70, 245, 34, 29, 197, 129, 184, 20, 45, 115,
        96, 123, 219, 39, 172, 49, 54, 12, 180, 88, 204, 248>>}, 27, 246_949,
     {:id, :contract,
      <<108, 159, 218, 252, 142, 182, 31, 215, 107, 90, 189, 201, 108, 136, 21, 96, 45, 160, 108,
        218, 130, 229, 90, 80, 44, 238, 94, 180, 157, 190, 40, 100>>}, 1_000_000_000, 2413, "?",
     :ok,
     [
       {<<108, 159, 218, 252, 142, 182, 31, 215, 107, 90, 189, 201, 108, 136, 21, 96, 45, 160,
          108, 218, 130, 229, 90, 80, 44, 238, 94, 180, 157, 190, 40, 100>>,
        [
          <<215, 0, 247, 67, 100, 22, 167, 140, 76, 197, 95, 144, 242, 214, 49, 111, 60, 169, 26,
            213, 244, 50, 59, 170, 72, 182, 90, 72, 178, 84, 251, 35>>,
          <<25, 28, 236, 151, 15, 221, 20, 64, 110, 174, 115, 50, 53, 233, 214, 119, 44, 124, 66,
            251, 47, 138, 163, 2, 69, 171, 46, 248, 46, 154, 37, 51>>,
          <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 203, 113, 245,
            31, 197, 88, 0, 0>>
        ], ""}
     ]}
  end

  def call_rec("burn") do
    {:call,
     <<75, 198, 182, 80, 179, 91, 73, 12, 46, 250, 26, 167, 237, 91, 109, 38, 24, 22, 142, 158,
       43, 87, 121, 61, 208, 254, 197, 73, 214, 131, 249, 230>>,
     {:id, :account,
      <<234, 90, 164, 101, 3, 211, 169, 40, 246, 51, 6, 203, 132, 12, 34, 114, 203, 201, 104, 124,
        76, 144, 134, 158, 55, 106, 213, 160, 170, 64, 59, 72>>}, 6, 255_795,
     {:id, :contract,
      <<99, 147, 221, 52, 149, 77, 197, 100, 5, 160, 112, 15, 89, 26, 213, 27, 12, 179, 74, 142,
        40, 64, 84, 157, 179, 9, 194, 215, 194, 131, 3, 108>>}, 1_000_000_000, 2960, "?", :ok,
     [
       {<<99, 147, 221, 52, 149, 77, 197, 100, 5, 160, 112, 15, 89, 26, 213, 27, 12, 179, 74, 142,
          40, 64, 84, 157, 179, 9, 194, 215, 194, 131, 3, 108>>,
        [
          <<131, 150, 191, 31, 191, 94, 29, 68, 10, 143, 62, 247, 169, 46, 221, 88, 138, 150, 176,
            154, 87, 110, 105, 73, 173, 237, 42, 252, 105, 193, 146, 6>>,
          <<234, 90, 164, 101, 3, 211, 169, 40, 246, 51, 6, 203, 132, 12, 34, 114, 203, 201, 104,
            124, 76, 144, 134, 158, 55, 106, 213, 160, 170, 64, 59, 72>>,
          <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 2>>
        ], ""}
     ]}
  end

  def call_rec("transfer") do
    {:call,
     <<167, 62, 112, 192, 204, 103, 1, 59, 141, 68, 5, 245, 105, 146, 30, 159, 153, 47, 33, 0, 69,
       184, 159, 210, 204, 20, 111, 1, 145, 139, 242, 76>>,
     {:id, :account,
      <<25, 28, 236, 151, 15, 221, 20, 64, 110, 174, 115, 50, 53, 233, 214, 119, 44, 124, 66, 251,
        47, 138, 163, 2, 69, 171, 46, 248, 46, 154, 37, 51>>}, 1, 247_411,
     {:id, :contract,
      <<108, 159, 218, 252, 142, 182, 31, 215, 107, 90, 189, 201, 108, 136, 21, 96, 45, 160, 108,
        218, 130, 229, 90, 80, 44, 238, 94, 180, 157, 190, 40, 100>>}, 1_000_000_000, 3054, "?",
     :ok,
     [
       {<<108, 159, 218, 252, 142, 182, 31, 215, 107, 90, 189, 201, 108, 136, 21, 96, 45, 160,
          108, 218, 130, 229, 90, 80, 44, 238, 94, 180, 157, 190, 40, 100>>,
        [
          <<34, 60, 57, 226, 157, 255, 100, 103, 254, 221, 160, 151, 88, 217, 23, 129, 197, 55,
            46, 9, 31, 248, 107, 58, 249, 227, 16, 227, 134, 86, 43, 239>>,
          <<25, 28, 236, 151, 15, 221, 20, 64, 110, 174, 115, 50, 53, 233, 214, 119, 44, 124, 66,
            251, 47, 138, 163, 2, 69, 171, 46, 248, 46, 154, 37, 51>>,
          <<121, 55, 68, 72, 54, 21, 164, 3, 9, 41, 192, 225, 104, 63, 125, 78, 48, 172, 76, 140,
            198, 29, 77, 28, 78, 136, 69, 142, 199, 23, 0, 121>>,
          <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 27, 193, 109,
            103, 78, 200, 0, 0>>
        ], ""}
     ]}
  end

  def call_rec("transfer_allowance") do
    {:call,
     <<162, 184, 71, 163, 53, 130, 210, 144, 20, 251, 215, 57, 185, 166, 81, 239, 251, 187, 30,
       186, 34, 211, 212, 22, 71, 5, 65, 145, 142, 106, 218, 131>>,
     {:id, :account,
      <<117, 28, 32, 5, 40, 93, 216, 179, 224, 57, 208, 77, 88, 86, 168, 136, 223, 91, 24, 79,
        252, 100, 141, 144, 124, 117, 91, 41, 115, 208, 244, 74>>}, 63, 258_867,
     {:id, :contract,
      <<172, 5, 106, 9, 237, 151, 96, 29, 163, 211, 165, 245, 93, 176, 93, 128, 24, 160, 13, 118,
        108, 184, 231, 144, 125, 26, 27, 155, 37, 148, 212, 54>>}, 1_000_000_000, 223,
     "YALLOWANCE_NOT_EXISTENT", :revert, []}
  end

  def call_rec("create_pair") do
    {:call,
     <<7, 3, 220, 129, 25, 69, 185, 205, 148, 53, 54, 115, 161, 72, 225, 149, 238, 18, 80, 50,
       185, 167, 125, 140, 71, 128, 149, 100, 229, 81, 223, 196>>,
     {:id, :account,
      <<87, 95, 129, 255, 176, 162, 151, 183, 114, 93, 198, 113, 218, 11, 23, 105, 177, 252, 92,
        190, 69, 56, 92, 123, 90, 209, 252, 46, 175, 29, 96, 157>>}, 41, 577_695,
     {:id, :contract,
      <<10, 126, 159, 135, 82, 51, 128, 194, 144, 132, 41, 25, 103, 230, 4, 179, 77, 54, 3, 118,
        14, 88, 180, 200, 222, 12, 124, 138, 3, 39, 137, 110>>}, 1_000_000_000, 22_929,
     <<159, 2, 160, 111, 0, 117, 208, 6, 235, 44, 43, 240, 108, 173, 15, 111, 153, 4, 169, 116,
       46, 60, 160, 41, 181, 143, 70, 46, 129, 67, 189, 118, 173, 96, 204>>, :ok,
     [
       {<<10, 126, 159, 135, 82, 51, 128, 194, 144, 132, 41, 25, 103, 230, 4, 179, 77, 54, 3, 118,
          14, 88, 180, 200, 222, 12, 124, 138, 3, 39, 137, 110>>,
        [
          <<165, 104, 218, 83, 242, 206, 42, 48, 134, 199, 10, 251, 46, 174, 228, 68, 181, 162,
            20, 101, 150, 189, 240, 53, 189, 254, 113, 142, 221, 171, 31, 107>>,
          <<83, 107, 86, 97, 199, 199, 69, 232, 131, 106, 241, 190, 181, 55, 62, 215, 254, 27,
            189, 54, 54, 3, 152, 10, 245, 52, 84, 143, 225, 73, 60, 7>>,
          <<165, 183, 23, 114, 145, 239, 159, 199, 241, 17, 145, 38, 165, 16, 97, 176, 78, 150,
            205, 43, 175, 9, 38, 160, 18, 49, 212, 116, 169, 115, 144, 97>>,
          <<111, 0, 117, 208, 6, 235, 44, 43, 240, 108, 173, 15, 111, 153, 4, 169, 116, 46, 60,
            160, 41, 181, 143, 70, 46, 129, 67, 189, 118, 173, 96, 204>>
        ], "1"}
     ]}
  end

  def call_rec("add_liquidity_ae") do
    {:call,
     <<63, 194, 224, 36, 97, 252, 220, 143, 221, 6, 58, 170, 109, 17, 41, 179, 9, 43, 56, 96, 155,
       30, 71, 43, 59, 197, 251, 82, 45, 8, 147, 193>>,
     {:id, :account,
      <<229, 215, 146, 118, 246, 228, 174, 101, 205, 243, 213, 145, 182, 172, 50, 97, 143, 78,
        126, 202, 101, 27, 249, 92, 126, 83, 172, 32, 158, 114, 8, 106>>}, 933, 596_118,
     {:id, :contract,
      <<46, 45, 66, 42, 171, 23, 186, 153, 167, 41, 204, 175, 3, 32, 136, 142, 172, 72, 29, 171,
        231, 25, 168, 179, 135, 26, 13, 47, 67, 25, 57, 155>>}, 1_000_000_000, 87_223,
     <<59, 111, 136, 13, 224, 182, 179, 167, 99, 255, 192, 111, 136, 13, 224, 182, 179, 167, 99,
       255, 192, 111, 136, 13, 224, 182, 179, 167, 99, 251, 216>>, :ok,
     [
       {<<65, 110, 123, 208, 148, 244, 99, 197, 242, 18, 123, 8, 185, 211, 87, 178, 24, 148, 241,
          255, 75, 209, 104, 190, 48, 36, 223, 251, 112, 185, 157, 10>>,
        [
          <<168, 150, 230, 248, 242, 47, 81, 142, 59, 217, 89, 130, 144, 3, 40, 124, 246, 97, 159,
            14, 37, 152, 69, 37, 7, 43, 6, 144, 110, 218, 143, 46>>,
          <<46, 45, 66, 42, 171, 23, 186, 153, 167, 41, 204, 175, 3, 32, 136, 142, 172, 72, 29,
            171, 231, 25, 168, 179, 135, 26, 13, 47, 67, 25, 57, 155>>,
          <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 224, 182,
            179, 167, 100, 0, 0>>,
          <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 224, 182,
            179, 167, 100, 0, 0>>
        ], ""},
       {<<65, 110, 123, 208, 148, 244, 99, 197, 242, 18, 123, 8, 185, 211, 87, 178, 24, 148, 241,
          255, 75, 209, 104, 190, 48, 36, 223, 251, 112, 185, 157, 10>>,
        [
          <<54, 4, 49, 94, 171, 25, 183, 10, 20, 145, 116, 243, 246, 190, 127, 103, 37, 247, 252,
            73, 166, 113, 182, 0, 236, 231, 26, 173, 216, 245, 249, 42>>,
          <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 224, 182,
            179, 167, 100, 0, 0>>,
          <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 224, 182,
            179, 167, 100, 0, 0>>
        ], ""},
       {<<65, 110, 123, 208, 148, 244, 99, 197, 242, 18, 123, 8, 185, 211, 87, 178, 24, 148, 241,
          255, 75, 209, 104, 190, 48, 36, 223, 251, 112, 185, 157, 10>>,
        [
          <<215, 0, 247, 67, 100, 22, 167, 140, 76, 197, 95, 144, 242, 214, 49, 111, 60, 169, 26,
            213, 244, 50, 59, 170, 72, 182, 90, 72, 178, 84, 251, 35>>,
          <<229, 215, 146, 118, 246, 228, 174, 101, 205, 243, 213, 145, 182, 172, 50, 97, 143, 78,
            126, 202, 101, 27, 249, 92, 126, 83, 172, 32, 158, 114, 8, 106>>,
          <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 224, 182,
            179, 167, 99, 252, 24>>
        ], ""},
       {<<65, 110, 123, 208, 148, 244, 99, 197, 242, 18, 123, 8, 185, 211, 87, 178, 24, 148, 241,
          255, 75, 209, 104, 190, 48, 36, 223, 251, 112, 185, 157, 10>>,
        [
          <<117, 180, 225, 85, 86, 76, 112, 120, 101, 246, 89, 142, 64, 13, 74, 204, 168, 32, 243,
            102, 226, 198, 233, 26, 27, 45, 226, 54, 200, 10, 120, 85>>,
          <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 3, 232>>
        ], ""},
       {<<65, 110, 123, 208, 148, 244, 99, 197, 242, 18, 123, 8, 185, 211, 87, 178, 24, 148, 241,
          255, 75, 209, 104, 190, 48, 36, 223, 251, 112, 185, 157, 10>>,
        [
          <<215, 0, 247, 67, 100, 22, 167, 140, 76, 197, 95, 144, 242, 214, 49, 111, 60, 169, 26,
            213, 244, 50, 59, 170, 72, 182, 90, 72, 178, 84, 251, 35>>,
          <<65, 110, 123, 208, 148, 244, 99, 197, 242, 18, 123, 8, 185, 211, 87, 178, 24, 148,
            241, 255, 75, 209, 104, 190, 48, 36, 223, 251, 112, 185, 157, 10>>,
          <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 3, 232>>
        ], ""},
       {<<39, 26, 34, 124, 164, 250, 243, 90, 198, 12, 74, 70, 137, 147, 70, 150, 174, 68, 138,
          188, 64, 12, 26, 227, 206, 15, 221, 211, 50, 4, 47, 82>>,
        [
          <<34, 60, 57, 226, 157, 255, 100, 103, 254, 221, 160, 151, 88, 217, 23, 129, 197, 55,
            46, 9, 31, 248, 107, 58, 249, 227, 16, 227, 134, 86, 43, 239>>,
          <<46, 45, 66, 42, 171, 23, 186, 153, 167, 41, 204, 175, 3, 32, 136, 142, 172, 72, 29,
            171, 231, 25, 168, 179, 135, 26, 13, 47, 67, 25, 57, 155>>,
          <<65, 110, 123, 208, 148, 244, 99, 197, 242, 18, 123, 8, 185, 211, 87, 178, 24, 148,
            241, 255, 75, 209, 104, 190, 48, 36, 223, 251, 112, 185, 157, 10>>,
          <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 224, 182,
            179, 167, 100, 0, 0>>
        ], ""},
       {<<39, 26, 34, 124, 164, 250, 243, 90, 198, 12, 74, 70, 137, 147, 70, 150, 174, 68, 138,
          188, 64, 12, 26, 227, 206, 15, 221, 211, 50, 4, 47, 82>>,
        [
          <<91, 108, 59, 228, 111, 110, 5, 174, 120, 178, 94, 251, 114, 31, 170, 166, 246, 198,
            27, 117, 40, 12, 26, 114, 91, 3, 73, 252, 168, 4, 148, 19>>,
          <<46, 45, 66, 42, 171, 23, 186, 153, 167, 41, 204, 175, 3, 32, 136, 142, 172, 72, 29,
            171, 231, 25, 168, 179, 135, 26, 13, 47, 67, 25, 57, 155>>,
          <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 224, 182,
            179, 167, 100, 0, 0>>
        ], ""},
       {<<159, 45, 233, 232, 139, 49, 143, 243, 162, 116, 97, 118, 79, 163, 196, 185, 3, 243, 121,
          66, 71, 181, 89, 59, 168, 183, 214, 117, 202, 173, 171, 171>>,
        [
          <<14, 194, 34, 177, 109, 76, 88, 255, 54, 14, 252, 160, 75, 242, 98, 84, 129, 27, 150,
            0, 85, 92, 41, 79, 86, 166, 33, 144, 114, 136, 127, 94>>,
          <<229, 215, 146, 118, 246, 228, 174, 101, 205, 243, 213, 145, 182, 172, 50, 97, 143, 78,
            126, 202, 101, 27, 249, 92, 126, 83, 172, 32, 158, 114, 8, 106>>,
          <<46, 45, 66, 42, 171, 23, 186, 153, 167, 41, 204, 175, 3, 32, 136, 142, 172, 72, 29,
            171, 231, 25, 168, 179, 135, 26, 13, 47, 67, 25, 57, 155>>,
          <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 177, 162,
            188, 46, 197, 0, 0>>
        ], ""},
       {<<159, 45, 233, 232, 139, 49, 143, 243, 162, 116, 97, 118, 79, 163, 196, 185, 3, 243, 121,
          66, 71, 181, 89, 59, 168, 183, 214, 117, 202, 173, 171, 171>>,
        [
          <<34, 60, 57, 226, 157, 255, 100, 103, 254, 221, 160, 151, 88, 217, 23, 129, 197, 55,
            46, 9, 31, 248, 107, 58, 249, 227, 16, 227, 134, 86, 43, 239>>,
          <<229, 215, 146, 118, 246, 228, 174, 101, 205, 243, 213, 145, 182, 172, 50, 97, 143, 78,
            126, 202, 101, 27, 249, 92, 126, 83, 172, 32, 158, 114, 8, 106>>,
          <<65, 110, 123, 208, 148, 244, 99, 197, 242, 18, 123, 8, 185, 211, 87, 178, 24, 148,
            241, 255, 75, 209, 104, 190, 48, 36, 223, 251, 112, 185, 157, 10>>,
          <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 224, 182,
            179, 167, 100, 0, 0>>
        ], ""},
       {<<49, 69, 201, 179, 64, 73, 251, 153, 205, 37, 147, 13, 132, 58, 150, 207, 81, 149, 186,
          147, 107, 208, 117, 185, 160, 135, 239, 247, 134, 40, 7, 80>>,
        [
          <<165, 104, 218, 83, 242, 206, 42, 48, 134, 199, 10, 251, 46, 174, 228, 68, 181, 162,
            20, 101, 150, 189, 240, 53, 189, 254, 113, 142, 221, 171, 31, 107>>,
          <<39, 26, 34, 124, 164, 250, 243, 90, 198, 12, 74, 70, 137, 147, 70, 150, 174, 68, 138,
            188, 64, 12, 26, 227, 206, 15, 221, 211, 50, 4, 47, 82>>,
          <<159, 45, 233, 232, 139, 49, 143, 243, 162, 116, 97, 118, 79, 163, 196, 185, 3, 243,
            121, 66, 71, 181, 89, 59, 168, 183, 214, 117, 202, 173, 171, 171>>,
          <<65, 110, 123, 208, 148, 244, 99, 197, 242, 18, 123, 8, 185, 211, 87, 178, 24, 148,
            241, 255, 75, 209, 104, 190, 48, 36, 223, 251, 112, 185, 157, 10>>
        ], "16"}
     ]}
  end

  @spec call_rec(fname(), pubkey(), AeMdw.Blocks.height()) :: call_record()
  def call_rec("no_log", contract_pk, height) do
    {:call,
     <<7, 3, 220, 129, 25, 69, 185, 205, 148, 53, 54, 115, 161, 72, 225, 149, 238, 18, 80, 50,
       185, 167, 125, 140, 71, 128, 149, 100, 229, 81, 223, 196>>, {:id, :account, <<1::256>>},
     41, height, {:id, :contract, contract_pk}, 1_000_000_000, 22_929,
     <<159, 2, 160, 111, 0, 117, 208, 6, 235, 44, 43, 240, 108, 173, 15, 111, 153, 4, 169, 116,
       46, 60, 160, 41, 181, 143, 70, 46, 129, 67, 189, 118, 173, 96, 204>>, :ok, []}
  end

  @spec call_rec(fname(), pubkey(), AeMdw.Blocks.height(), pubkey(), [event_log()]) ::
          call_record()
  def call_rec(fname, contract_pk, height, event_pk, extra_logs \\ [])

  def call_rec("aex141_transfer", contract_pk, height, event_pk, extra_logs) do
    {:call, :aect_call.id(<<1::256>>, 2, contract_pk), {:id, :account, <<1::256>>}, 2, height,
     {:id, :contract, contract_pk}, 1_000_000_000, 22_929, "", :ok,
     [
       {event_pk, [AeMdw.Node.aexn_transfer_event_hash(), <<1::256>>, <<2::256>>, <<1::256>>],
        <<>>}
     ] ++
       extra_logs}
  end

  def call_rec("remote_log", contract_pk, height, remote_pk, extra_logs) do
    {:call,
     <<7, 3, 220, 129, 25, 69, 185, 205, 148, 53, 54, 115, 161, 72, 225, 149, 238, 18, 80, 50,
       185, 167, 125, 140, 71, 128, 149, 100, 229, 81, 223, 196>>, {:id, :account, <<1::256>>},
     41, height, {:id, :contract, contract_pk}, 1_000_000_000, 22_929,
     <<159, 2, 160, 111, 0, 117, 208, 6, 235, 44, 43, 240, 108, 173, 15, 111, 153, 4, 169, 116,
       46, 60, 160, 41, 181, 143, 70, 46, 129, 67, 189, 118, 173, 96, 204>>, :ok,
     [
       {remote_pk,
        [
          <<165, 104, 218, 83, 242, 206, 42, 48, 134, 199, 10, 251, 46, 174, 228, 68, 181, 162,
            20, 101, 150, 189, 240, 53, 189, 254, 113, 142, 221, 171, 31, 107>>,
          <<83, 107, 86, 97, 199, 199, 69, 232, 131, 106, 241, 190, 181, 55, 62, 215, 254, 27,
            189, 54, 54, 3, 152, 10, 245, 52, 84, 143, 225, 73, 60, 7>>
        ], "1"}
     ] ++
       extra_logs}
  end
end
