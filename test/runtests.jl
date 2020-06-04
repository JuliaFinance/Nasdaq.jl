using Assets, Nasdaq

using Test

# Check that some basic stocks listed on Nasdaq have been loaded correctly
const stocks = ((:MSFT, "Microsoft Corp"),
                (:GOOG, "Alphabet Cl C"),
                (:AAPL, "Apple Inc"))

@testset "Basic currencies" begin
    for (sym, nam) in stocks
        @test Nasdaq._nasdaq_data[sym].Description == nam
    end
end
