require File.join(Rails.root, "lib/mongoid_migration_task")
class UpdateFamilyMembers < MongoidMigrationTask
  def migrate
    p1=Person.where(hbx_id: ENV['hbx_id_1']).first
    p2=Person.where(hbx_id: ENV['hbx_id_2']).first
    if p1.present? && p2.present?
      if p1.primary_family.present?
        family_member1=p1.primary_family.family_members[0]
        family_member1.update_attributes(person_id: ENV['person_id_2'])
        family_member2=p1.primary_family.family_members[1]
        family_member2.update_attributes(person_id: ENV['person_id_1'])
      end
      if p2.primary_family.present?
        family_member1=p2.primary_family.family_members[0]
        family_member1.update_attributes(is_primary_applicant: true)
        family_member2=p1.primary_family.family_members[1]
        family_member2.update_attributes(is_primary_applicant: false)
      end
      if p1.person_relationship.any?
        p1.person_relationships[1].delete
        p1.person_relationships[3].delete
      end
      if p2.person_relationship.any?
        p2.person_relationships.delete_all
      end
    else
      raise "some error person with hbx_id:#{ENV['hbx_id_1']} and hbx_id:#{ENV['hbx_id_2']} not found"
    end
  end
end
