
import Foundation


var arr: [String] = ["apple", "orange", "mandarin", "strawberry", "banana"]
print(arr[2])

var favNums: Set<Int> = [1,2,3,4]
favNums.insert(7)
print(favNums)

var prLangs: [String: Int] = ["Swift":2014, "C++": 1985, "Python":1989]
print(prLangs["Swift"] ?? 0)

var colors : [String] = ["red", "white", "black", "green"]
colors[1] = "blue"
print(colors)


var first:Set<Int> = [1,2,3,4]
var second:Set<Int> = [3,4,5,6]
var intersection = first.intersection(second)
print(intersection)

var students: [String: Int] = ["Nurali": 96, "Temirlan": 72, "Erniaz":54]
students["Temirlan"] = 12
print(students)

var arr1: [String] = ["apple","banana"]
var arr2: [String] = ["cherry","date"]
var merged = arr1 + (arr2)
print(merged)

var countries: [String: Int] = ["Kazakhstan": 20600000, "Russia": 14000000, "USA":342000000]
countries["Canada"] = 40000000
print(countries)


var hardSet: Set<String> = ["cat","dog"]
var hardSet2: Set<String> = ["dog","mouse"]
hardSet.formUnion(hardSet2)
hardSet.subtract(hardSet2)
print(hardSet)
 
let grades = [
    "Ali": [85, 90, 78],
    "Dana": [92, 88, 95],
    "Murat": [75, 80, 85]
]
print(grades["Ali"]![1])
