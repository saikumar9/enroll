module TransportGateway
  class Steps::CreateFile < Step

    def initialize(path, contents)
      super("Create file: #{path}")
      @path = path
      @contents = contents
    end

    def execute
      File.write(@path, @contents)
    end


  end
end
