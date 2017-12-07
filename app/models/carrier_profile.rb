class CarrierProfile
  include PlanModelConcerns::CarrierProfileConcern
  include SetCurrentUser

  # has_many Plans
  def plans
    Plan.where(carrier_profile_id: self._id)
  end

  ## Class methods
  class << self

    def carriers_for(employer_profile)
      servicing_hios_ids = employer_profile.service_areas.collect { |service_area| service_area.issuer_hios_id }.uniq
      self.all.reject { |cp| (cp.issuer_hios_ids & servicing_hios_ids).empty? }
    end

    def carrier_profile_service_area_pairs_for(employer_profile, start_on)
     hios_carrier_id_mapping = Organization.where("carrier_profile" => {"$exists" => true}).inject({}) do |acc, org|
       next acc if org.fein == '800721489'

       cp = org.carrier_profile

       cp.issuer_hios_ids.each do |ihid|
         acc[ihid] = cp.id
       end
       acc
     end
     employer_profile.service_areas_available_on(DateTime.new(start_on.to_i)).map do |service_area|
       [hios_carrier_id_mapping[service_area.issuer_hios_id], service_area.service_area_id]
     end.uniq
   end
  end

end
