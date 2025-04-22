## ruby-http

This template uses [Sinatra internally](https://sinatrarb.com/intro.html), and the slim Docker image for Ruby to keep the image small. A native build toolchain is installed, which still results in a smaller image than the standard Ruby image on the Docker Hub.

Ruby version: 3.4.3.

### Usage:

```bash
faas template pull https://github.com/openfaas/ruby-http
faas new --lang ruby-http homepage
```

#### Example:

Edit the `homepage/handler.rb` file to return some HTML:

```ruby
class Handler
  def run(body, headers)
    status_code = 200 # Optional status code, defaults to 200
    response_headers = {"content-type" => "text/html"}
    body = "<html>Hello world from the Ruby template</html>"

    return body, response_headers, status_code
  end
end
```

Add a gem to the `homepage/Gemfile` if you need additional dependencies.

Deploy:

```sh
faas-cli up -f homepage.yml
```

