# frozen_string_literal: true

RgGen.define_list_feature(:register_block, :protocol) do
  shared_context do
    def feature_registry(registry = nil)
      @registry = registry if registry
      @registry
    end

    def available_protocols
      feature_registry
        .enabled_features(:protocol)
        .select(&method(:valid_protocol?))
    end

    def valid_protocol?(protocol)
      feature_registry.feature?(:protocol, protocol)
    end
  end

  configuration do
    base_feature do
      property :protocol
      build { |protocol| @protocol = protocol }
      printable :protocol
    end

    default_feature do
    end

    factory do
      convert_value do |value, position|
        protocol = find_protocol(value)
        protocol ||
          (error "unknown protocol: #{value.inspect}", position)
      end

      default_value do |position|
        default_protocol ||
          (error 'no protocols are available', position)
      end

      def target_feature_key(data)
        data.value
      end

      private

      def find_protocol(value)
        available_protocols.find(&value.to_sym.method(:casecmp?))
      end

      def default_protocol
        available_protocols.first
      end

      def available_protocols
        @available_protocols ||= shared_context.available_protocols
      end
    end
  end

  sv_rtl do
    shared_context.feature_registry(registry)

    base_feature do
      build do
        parameter :register_block, :error_status, {
          name: 'ERROR_STATUS', data_type: :bit, width: 1, default: 0
        }
        parameter :register_block, :default_read_data, {
          name: 'DEFAULT_READ_DATA', data_type: :bit, width: bus_width,
          default: hex(0, bus_width)
        }
      end

      private

      def address_width
        configuration.address_width
      end

      def bus_width
        configuration.bus_width
      end

      def byte_width
        configuration.byte_width
      end

      def local_address_width
        register_block.local_address_width
      end

      def total_registers
        register_block.total_registers
      end

      def clock
        register_block.clock
      end

      def reset
        register_block.reset
      end

      def register_if
        register_block.register_if
      end
    end

    factory do
      def target_feature_key(configuration, _register_block)
        configuration.protocol
      end
    end
  end
end
