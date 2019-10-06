## ruby-http

### Usage:

```
faas template pull https://github.com/openfaas-incubator/ruby-http
faas new --lang ruby-http homepage
```

#### Example:

Edit the `homepage/handler.rb` file to return some HTML:

```ruby
class Handler
  def run(body, headers)
    response_headers = {"content-type": "text/html"}
    body = "<html>Hello world from the Ruby template</html>"

    return body, response_headers
  end
end
```

Add a gem to the `homepage/Gemfile` if you need additional dependencies.

Deploy:

```sh
faas-cli up -f homepage.yml
```

