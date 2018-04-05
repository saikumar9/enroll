module BenefitMarkets
  module Products
    module ProductPackages
      class IssuerHealthProductPackageForm < ProductPackageForm
        attr_accessor :issuer_id

        validates_presence_of :issuer_id, :allow_blank => false

        def has_additional_attributes?
          true
        end

        def additional_form_fields_partial
          "issuer_health_additional_form_fields"
        end

        def build_object_using_factory
          product_package_factory.build_issuer_product_package(
            benefit_catalog_id,
            title,
            contribution_model_id,
            pricing_model_id,
            product_year,
            issuer_id
          )
        end
      end
    end
  end
end