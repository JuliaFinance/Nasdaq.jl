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

function load(; host="localhost", port=8000, force=false, name="Nasdaq", symbols=[], currency=:USD)
    exch = lowercase(name)
    jsondir = joinpath(@__DIR__, "..", "data")
    jsonfile = joinpath(jsondir, string(exch,"-",join(symbols,"-"),".json"))
    if !force && isfile(jsonfile)
        body = read(jsonfile)
    else
        body = HTTP.get("http://$host:$port/api/$exch", query=Dict(:symbols => join(symbols,","))).body
        ispath(jsondir) || mkpath(jsondir)
        open(io -> write(io, body), jsonfile, "w")
    end
    response = JSON3.read(body, Dict{Symbol,String})
    exchsym = Symbol(uppercase(name))
    stocks = ListedEquity[]
    for key in keys(response)
        symbol = Symbol(key)
        push!(stocks, ListedEquity(exchsym, symbol, currency))
        _nasdaq_data[symbol] = (ListedEquity(exchsym, symbol, currency), response[symbol])
    end
    stocks
end

end # module Nasdaq
