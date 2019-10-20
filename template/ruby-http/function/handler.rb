class Handler
  def run(body, headers)
    status_code = 200 # Optional status code, defaults to 200
    response_headers = {"content-type" => "text/plain"}
    body = "Hello world from the Ruby template"

    return body, response_headers, status_code
  end
end
