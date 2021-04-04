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
            return [200, {}, [content]] if content
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
        def match(request)
            if request.path == route_spec
                block.call
            else
                nil
            end
        end
    end
end