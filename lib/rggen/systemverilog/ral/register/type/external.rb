# frozen_string_literal: true

RgGen.define_list_item_feature(:register, :type, :external) do
  sv_ral do
    build do
      parameter :register_block, :model_type, {
        name: model_name,
        data_type: 'type',
        default: 'rggen_ral_block'
      }
      parameter :register_block, :integrate_model, {
        name: "INTEGRATE_#{model_name}",
        data_type: 'bit',
        default: 1
      }
    end

    model_name { register.name.upcase }

    constructor do
      macro_call(
        'rggen_ral_create_block_model',
        [ral_model, offset_address, 'this', integrate_model]
      )
    end
  end
end
