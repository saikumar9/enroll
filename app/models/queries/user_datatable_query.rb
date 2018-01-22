module Queries
  class UserDatatableQuery
  	attr_reader :search_string, :custom_attributes

    def datatable_search(string)
      @search_string = string
      self
    end

    def initialize(attributes)
      @custom_attributes = attributes
    end

    def build_scope()
      user = klass
      users = case @custom_attributes[:users]
        when "all_employer_staff_roles"
          if @custom_attributes[:lock_unlock] == "locked"
            user.where(:'roles'.in => ["employer_staff"], :locked_at.ne => nil)
          elsif @custom_attributes[:lock_unlock] == "unlocked"
            user.where(:'roles'.in => ["employer_staff"], locked_at: nil)
          else
            user.where(:'roles'.in => ["employer_staff"])
          end
        when "all_employee_roles"
          if @custom_attributes[:lock_unlock] == "locked"
            user.where(:'roles'.in => ["employee"], :locked_at.ne => nil)
          elsif @custom_attributes[:lock_unlock] == "unlocked"
            user.where(:'roles'.in => ["employee"], locked_at: nil)
          else
            user.where(:'roles'.in => ["employee"])
          end
        when "all_broker_roles"
          if @custom_attributes[:lock_unlock] == "locked"
            user.where(:'roles'.in => ["broker"], :locked_at.ne => nil)
          elsif @custom_attributes[:lock_unlock] == "unlocked"
            user.where(:'roles'.in => ["broker"], locked_at: nil)
          else
            user.where(:'roles'.in => ["broker"])
          end
        when "all"
          if @custom_attributes[:lock_unlock] == "locked"
            user.locked
          elsif @custom_attributes[:lock_unlock] == "unlocked"
            user.unlocked
          else
            user.all
          end
        else
          user.all
      end
      unless @search_string.nil?
        search_regex = Regexp.new(".*#{@search_string}.*")
        user_ids = Person.or({hbx_id: search_regex}, {first_name: search_regex}, {last_name: search_regex}).pluck(:user_id)
        users = users.or({oim_id: search_regex}, {email: search_regex}, {id: {"$in" => user_ids} } )
      end
      users
    end

    def skip(num)
      build_scope.skip(num)
    end

    def limit(num)
      build_scope.limit(num)
    end

    def order_by(var)
      @order_by = var
      self
    end

    def klass
      User
    end

    def size
      build_scope.count
    end
  end
end