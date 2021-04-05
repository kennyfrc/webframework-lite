# Framework stuff
class App
    # Defines the routes defined when you do App.new do...end
    def initialize(&block)
        @routes = RouteTable.new(block)
    end

    # env = a hash of various keys containing
    # info about the incoming HTTP request
    def call(env)
        # Rack::Request provides convenient methods
        # for the incoming request
        request = Rack::Request.new(env)

        # return a 200 status for all matching routes
        @routes.each do |route|
            content = route.match(request)
            # [][-1] is an enumerable of stringable objects
            # => sometimes you want to return responses lazily (through an enumerable)
			# .to_s because you don't want this to blow up when 
			# a route handler returns an array or other format
            return [200, {'Content-Type' => 'text/plain'}, [content.to_s]] if content
        end

        # otherwise, return 404
        [404, {}, ["Not Found"]]
    end

    class RouteTable
        # instance_eval allows you to run the methods within
        # the incoming block parameter
        def initialize(block)
            # means run this block as if it's inside method
            # of this class. that means that the code inside
            # the block can call methods on the RouteTable
            @routes = []
            instance_eval(&block)
        end

        def get(route_spec, &block)
            @routes << Route.new(route_spec, block)
        end

        def each(&block)
            @routes.each(&block)
        end

    end

    class Route < Struct.new(:route_spec, :block)
        # this parses the route spec 
		# and ensures that it matches with the incoming request path
		def match(request)
			path_components = request.path.split('/')
			spec_components = route_spec.split('/')
        	
			params = {}

			return nil unless path_components.length == spec_components.length
			
			# this checks if the path contains a variable, then set it within the params
			# and it will invoke block.call(params) accordingly
			path_components.zip(spec_components).each do |path_comp, spec_comp|
				is_variable = spec_comp.start_with?(':')
				if is_variable
					key = spec_comp.sub(/\A:/, "")
					params[key] = URI.decode(path_comp)
				else
					return nil unless path_comp == spec_comp
				end
			end	
		
			block.call(params)
		end
    end
end
