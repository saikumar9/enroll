module SponsoredApplications
  class SponsorBenefits::CompositeTask < SponsorBenefits::Task

    def initialize(name)
      @subtasks = []
      super(name)
    end

    def add_subtask(new_task)
      @subtasks << new_task
      task.parent = self
    end

    def <<(new_task)
      add_subtask(new_task)
    end

    def remove_subtask(task)
      @subtasks.delete(task)
      task.parent = nil
    end

    def [](index)
      @subtasks[index]
    end

    def []=(index, new_task)
      @subtasks[index] = new_task
    end

  end
end
