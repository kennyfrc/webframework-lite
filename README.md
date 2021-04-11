## Basic Web Framework

Rack-based framework, uses Sinatra-style routing syntax

## Setup / Process

### App / RouteTable Classes

Purpose: it receives a request from Rack via #call, and using the RouteTable and Route classes, it parses the request path, then returns a block.call(params) as the response. 
1. There is an app that is rack-based in that it uses #call which loops through routes
2. This app contains a RouteTable, which has a #get method, which uses a Route object to parse the developer-defined paths
3. The route object then uses developer-defined blocks to define the response for the user.

### Database Class

Purpose: 
* It allows one to establish a connection
* It then creates a new Record using an SQL Executor
* The Executor uses a regex-based template parser
* The QUERIES follow a developer-defined template
* This template is not guaranteed to be safe

1. You will need to develop it as "route first"
2. Use the pg gem to be able to create a database
3. You add sql QUERIES then apply a wrapper around it
4. You then pass it to something like `exec_sql`
5. The above (1-3) still has SQL injection vulnerabilities
6. To remove SQL injection vulnerabilities, you need to use the in-built exec_params, which replaces exec_sql
7. To allow for different order arguments within your create_submission function, what you need to do is to first define a SQL templating script then you set up an Executor class which allows you to dynamically substitute values with a regex.

### Method missing

* https://www.leighhalliday.com/ruby-metaprogramming-method-missing

## Other stuff learnt

* When defining methods for an object, you'll need to distinguish bewteen generic use case Objects and domain-specific Objects (e.g. database class vs postgres class)

## Credits

[destroyallsoftware.com](https://www.destroyallsoftware.com/screencasts)
