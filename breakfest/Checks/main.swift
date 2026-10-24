import Foundation
precondition(Favorite.all.count == 10)
var roulette = FavoriteRoulette(count: Favorite.all.count)
var seen = Set<Int>()
for _ in 0..<10000 {
    let previous = roulette.currentIndex
    let next = roulette.next()
    precondition(next != previous)
    precondition(Favorite.all.indices.contains(next))
    seen.insert(next)
}
precondition(seen.count == 10)
print("PASS: 10 favorites; 10,000 selections in range without consecutive repeats; all 10 reached.")
