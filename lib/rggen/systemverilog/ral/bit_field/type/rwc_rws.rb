# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:rwc, :rws]) do
  sv_ral { access 'RW' }
end
