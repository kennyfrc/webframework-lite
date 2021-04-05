## Basic Web Framework

Rack-based framework, uses Sinatra-style routing syntax

## Setup / Process
1. Create gemfile to include rack
2. Within `config.ru`, you need to set `run APP`
3. Within APP, it needs a call method
4. Upon initializing App, it creates a new RouteTable
	* The RouteTable initializes each Route
	* Then it will dynamically call the block once a request for that is received
		* It calls it by iterating through the RoutesTable then returning 200 upon match then calling the block
		* Otherwise, it returns a 404


## Credits

[destroyallsoftware.com](https://www.destroyallsoftware.com/screencasts)
