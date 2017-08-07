require 'uri/generic'
module URI
  class AWS3 < Generic
    DEFAULT_PORT = 443

    def initialize(*args)
      super(*args)

      # @region = @user
      # self.region = self.user
      # @site = @password
      # self.site = self.password

      @bucket_name = @host
      self.bucket_name = self.host

      @object_collection = @path
      self.object_collection = self.path

    end


    # An Array of the available components for URI::FTP
    #

    # COMPONENT = [
    #   :scheme,
    #   :region, :site,
    #   :bucket_name, :object_collection,
    #   :object_name

    #   # :userinfo, :host, :port,
    #   # :path, :typecode
    # ].freeze


    # self.new('aws3',
    #           [region, site],
    #           bucket_name, object_collection,  nil,
    #           object_name,
    #           nil, nil, nil, arg_check
    #         )

    #          # [user, password],
             # host, port, nil,
             # typecode ? path + TYPECODE_PREFIX + typecode : path,
             # nil, nil, nil, arg_check)

    # def self.build(args)
    #   # Fix the incoming path to be generic URL syntax
    #   # FTP path  ->  URL path
    #   # foo/bar       /foo/bar
    #   # /foo/bar      /%2Ffoo/bar
    #   #
    #   if args.kind_of?(Array)
    #     args[3] = '/' + args[3].sub(/^\//, '%2F')
    #   else
    #     args[:path] = '/' + args[:path].sub(/^\//, '%2F')
    #   end

    #   tmp = Util::make_components_hash(self, args)

    #   return super(tmp)
    # end


    # def initialize(*args)
    #   raise InvalidURIError unless args[5]
    #   args[5] = args[5].sub(/^\//,'').sub(/^%2F/,'/')

    #   @region = nil
    #   @site = nil
    #   @bucket_name = nil
    #   @object_collection = nil
    #   @object_name = nil

    #   if arg_check
    #     self.region = region
    #     self.site = site
    #     self.bucket_name = bucket_name
    #     self.object_collection = object_collection
    #     self.object_name = object_name
    #   else
    #     self.set_region(region)
    #     self.set_site(site)
    #     self.set_bucket_name(bucket_name)
    #     self.set_object_collection(object_collection) 
    #     self.set_object_name(object_name)
    #   end

    #   @scheme.freeze if @scheme

    #   super(*args)
    # end


    # URIREGEX = /^(([^:\/?#]+):)?(\/\/([^\/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?$/
    # EMPTY_STR = ''
    
    ##
    # Creates a new uri object from component parts.
    #
    # @option [String, #to_str] scheme The scheme component.
    # @option [String, #to_str] user The user component.
    # @option [String, #to_str] password The password component.
    # @option [String, #to_str] userinfo
    #   The userinfo component. If this is supplied, the user and password
    #   components must be omitted.
    # @option [String, #to_str] host The host component.
    # @option [String, #to_str] port The port component.
    # @option [String, #to_str] authority
    #   The authority component. If this is supplied, the user, password,
    #   userinfo, host, and port components must be omitted.
    # @option [String, #to_str] path The path component.
    # @option [String, #to_str] query The query component.
    # @option [String, #to_str] fragment The fragment component.
    #
    # @return [Addressable::URI] The constructed URI object.
    # def initialize(options={})
      # if options.has_key?(:authority)
      #   if (options.keys & [:userinfo, :user, :password, :host, :port]).any?
      #     raise ArgumentError,
      #       "Cannot specify both an authority and any of the components " +
      #       "within the authority."
      #   end
      # end
      # if options.has_key?(:userinfo)
      #   if (options.keys & [:user, :password]).any?
      #     raise ArgumentError,
      #       "Cannot specify both a userinfo and either the user or password."
      #   end
      # end

      # self.defer_validation do
      #   # Bunch of crazy logic required because of the composite components
      #   # like userinfo and authority.
      #   self.scheme = options[:scheme] if options[:scheme]
      #   self.user = options[:user] if options[:user]
      #   self.password = options[:password] if options[:password]
      #   self.userinfo = options[:userinfo] if options[:userinfo]
      #   self.host = options[:host] if options[:host]
      #   self.port = options[:port] if options[:port]
      #   self.authority = options[:authority] if options[:authority]
      #   self.path = options[:path] if options[:path]
      #   self.query = options[:query] if options[:query]
      #   self.query_values = options[:query_values] if options[:query_values]
      #   self.fragment = options[:fragment] if options[:fragment]
      # end
    #   self.to_s
    # end



    # def self.parse(uri)
    #   # If we were given nil, return nil.
    #   return nil unless uri
    #   # If a URI object is passed, just return itself.
    #   return uri.dup if uri.kind_of?(self)

    #   # If a URI object of the Ruby standard library variety is passed,
    #   # convert it to a string, then parse the string.
    #   # We do the check this way because we don't want to accidentally
    #   # cause a missing constant exception to be thrown.
    #   if uri.class.name =~ /^URI\b/
    #     uri = uri.to_s
    #   end

    #   # Otherwise, convert to a String
    #   begin
    #     uri = uri.to_str
    #   rescue TypeError, NoMethodError
    #     raise TypeError, "Can't convert #{uri.class} into String."
    #   end if not uri.is_a? String

    #   # This Regexp supplied as an example in RFC 3986, and it works great.
    #   scan = uri.scan(URIREGEX)
    #   fragments = scan[0]
    #   scheme = fragments[1]
    #   authority = fragments[3]
    #   path = fragments[4]
    #   query = fragments[6]
    #   fragment = fragments[8]
    #   user = nil
    #   password = nil
    #   host = nil
    #   port = nil
    #   if authority != nil
    #     # The Regexp above doesn't split apart the authority.
    #     userinfo = authority[/^([^\[\]]*)@/, 1]
    #     if userinfo != nil
    #       user = userinfo.strip[/^([^:]*):?/, 1]
    #       password = userinfo.strip[/:(.*)$/, 1]
    #     end
    #     host = authority.gsub(
    #       /^([^\[\]]*)@/, EMPTY_STR
    #     ).gsub(
    #       /:([^:@\[\]]*?)$/, EMPTY_STR
    #     )
    #     port = authority[/:([^:@\[\]]*?)$/, 1]
    #   end
    #   if port == EMPTY_STR
    #     port = nil
    #   end

    #   return new(
    #     :scheme => scheme,
    #     :user => user,
    #     :password => password,
    #     :host => host,
    #     # :port => port,
    #     :port => 111,
    #     :path => path,
    #     :query => query,
    #     :fragment => fragment
    #   )
    # end


  end

  @@schemes['AWS3'] = AWS3

end