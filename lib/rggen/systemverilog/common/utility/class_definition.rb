# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module Common
      module Utility
        class ClassDefinition < StructureDefinition
          define_attribute :name
          define_attribute :base
          define_attribute :parameters
          define_attribute :variables

          private

          def header_code(code)
            code << [:class, space, name]
            parameter_declarations(code)
            class_inheritance(code)
            code << semicolon
          end

          def parameter_declarations(code)
            declarations = Array(parameters)
            declarations.empty? || wrap(code << space, '#(', ')') do
              add_declarations_to_header(code, declarations)
            end
          end

          def class_inheritance(code)
            return unless base
            code << [space, :extends, space, base]
          end

          def pre_body_code(code)
            add_declarations_to_body(code, Array(variables))
          end

          def footer_code
            :endclass
          end
        end
      end
    end
  end
end
