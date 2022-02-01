using Pkg
Pkg.activate(".")
using HTTP, JSON

println("Example actor written in Julia")

if !haskey(ENV, "APIFY_DEFAULT_KEY_VALUE_STORE_ID") || !haskey(ENV, "APIFY_TOKEN")
    println("Missing required env vars")
    exit(1)
end
default_kvs = ENV["APIFY_DEFAULT_KEY_VALUE_STORE_ID"]
token = ENV["APIFY_TOKEN"]

response = HTTP.get("https://api.apify.com/v2/key-value-stores/$default_kvs/records/INPUT")
if response.status != 200
    println("Error while trying to fetch the input. Status code: $(response.status)")
    exit(1)
end
json = JSON.parse(String(response.body))

response = HTTP.get(json["url"])
if response.status != 200
    println("Error while trying to fetch the HTML. Status code: $(response.status)")
    exit(1)
end

url = "https://api.apify.com/v2/key-value-stores/$default_kvs/records/OUTPUT?token=$token"
response = HTTP.put(url, ["Content-Type" => "text/html; charset=utf-8"], response.body)
if response.status != 201
    println("Error while trying to save data to key-value store. Status code: $(response.status)")
    exit(1)
end

println("Saved fetched HTML to OUTPUT in key-value store")
