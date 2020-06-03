"""
Nasdaq

This provides instance types to represent the stocks listed on the Nasdaq stock exchange

See README.md for the full documentation

Copyright 2020, Eric Forgy, Scott P. Jones and other contributors

Licensed under MIT License, see LICENSE.md
"""
module Nasdaq

using Assets, HTTP, JSON3

const _nasdaq_data = Dict{Symbol,Tuple{ListedEquity,String}}()

allsymbols() = keys(_nasdaq_data)
allpairs() = pairs(_nasdaq_data)

#__init__() = load()

function load(;host="localhost", port=8000, force=false, name="Nasdaq", currency=:USD)
    exch = lowercase(name)
    jsondir = joinpath(@__DIR__, "..", "data")
    jsonfile = joinpath(jsondir, exch * ".json")
    if !force && isfile(jsonfile)
        body = read(jsonfile)
    else
        body = HTTP.get("http://$host:$port/api/$exch/list").body
        ispath(jsondir) || mkpath(jsondir)
        open(io -> write(io, body), jsonfile, "w")
    end
    response = JSON3.read(body)
    exchsym = Symbol(name)
    for stock in response
        sym = Symbol(stock.Symbol)
        _nasdaq_data[sym] = (ListedEquity(exchsym, sym, currency), stock.Description)
    end
end

end # module Nasdaq
