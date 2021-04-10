## Basic Web Framework

Rack-based framework, uses Sinatra-style routing syntax

## Setup / Process

### RouteTable

1. Create gemfile to include rack
2. Within `config.ru`, you need to set `run APP`
3. Within APP, it needs a call method
4. Upon initializing App, it creates a new RouteTable
	* The RouteTable initializes each Route
	* Then it will dynamically call the block once a request for that is received
		* It calls it by iterating through the RoutesTable then returning 200 upon match then calling the block
		* Otherwise, it returns a 404

### Database Class

1. Use the pg gem to be able to create a database
2. You add sql queries then apply a wrapper around it
3. You then pass it to something like `exec_sql`
4. The above (1-3) still has SQL injection vulnerabilities


## Other stuff learnt

* When defining methods for an object, you'll need to distinguish bewteen generic use case Objects and domain-specific Objects (e.g. database class vs postgres class)

## Credits

[destroyallsoftware.com](https://www.destroyallsoftware.com/screencasts)
