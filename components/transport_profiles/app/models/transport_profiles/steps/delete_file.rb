module TransportProfiles
  # Delete a local file resource.
  class Steps::DeleteFile < Steps::Step

    # Create a new step instance.
    # @param path [URI, Symbol] represents the path of the resource to delete.
    #   If a URI, is the local file URI.
    #   If a Symbol, represents a URI or collection of URIs stored in the process context.
    # @param gateway [TransportGateway::Gateway] the transport gateway instance to use for moving of resoruces
    def initialize(path, gateway)
      super("Delete file: #{path}", gateway)
      @path = path
    end

    def execute
      File.delete(@path.path)
    end

  end
end
