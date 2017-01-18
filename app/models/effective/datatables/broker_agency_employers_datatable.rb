
module Effective
  module Datatables
    class BrokerAgencyEmployersDatatable < Effective::MongoidDatatable
      datatable do


        # bulk_actions_column do
        #    bulk_action 'Generate Invoice', generate_invoice_exchanges_hbx_profiles_path, data: { confirm: 'Generate Invoices?', no_turbolink: true }
        #    bulk_action 'Mark Binder Paid', binder_paid_exchanges_hbx_profiles_path, data: {  confirm: 'Mark Binder Paid?', no_turbolink: true }
        # end

        table_column :hbx_id, :proc => Proc.new { |row|
          row.employer_profile.hbx_id
          }, :sortable => false, :filter => false

        table_column :legal_name, :proc => Proc.new { |row|
          row.legal_name
          }, :sortable => false, :filter => false

        table_column :FEIN, proc: Proc.new { |row| number_to_obscured_fein(row.employer_profile.fein)}, :sortable => false, :filter => false
        table_column :EE_Count, :label => "EE Count", proc: Proc.new { |row| row.employer_profile.roster_size}, :sortable => false, :filter => false

      end

      def collection
        return @employer_profiles if defined? @employer_profiles

        if attributes[:current_user].has_broker_agency_staff_role? || attributes[:current_user].has_hbx_staff_role?
          @orgs = Organization.by_broker_agency_profile(attributes[:broker_agency_profile_id])
        else
          broker_role_id = attributes[:current_user].person.broker_role.id
          @orgs = Organization.by_broker_role(broker_role_id)
        end
        @employer_profiles = @orgs#.map {|o| o.employer_profile} unless @orgs.blank?

      end

      def global_search?
        true
      end


      def search_column(collection, table_column, search_term, sql_column)
          super
      end

      def nested_filter_definition


        filters = {
        broker_agencies:
         [
           {scope:'all', label: 'All'},
         ],
        top_scope: :broker_agencies
        }

      end
    end
  end
end
