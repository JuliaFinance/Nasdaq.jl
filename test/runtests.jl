using Assets, Nasdaq

using Test

response = Nasdaq.load(symbols=[:MSFT,:GOOG,:AAPL], force=true)

# Check that some basic stocks listed on Nasdaq have been loaded correctly
const stocks = ((:MSFT, "Microsoft Corp"),
                (:GOOG, "Alphabet Cl C"),
                (:AAPL, "Apple Inc"))

@testset "Basic currencies" begin
    for (sym, nam) in stocks
        @test response[sym] == nam
    end
end
