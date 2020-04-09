module SpreePayuGateway
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_payu_gateway'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

     initializer "spree.register.payment_methods" do |app|
      app.config.spree.payment_methods << Spree::Gateway::PayuInGateway
    end

    initializer "spree.payment.permit_params" do |app|
      Spree::PermittedAttributes.payment_attributes << :response_code
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
