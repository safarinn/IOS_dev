// =============================================================
//  Station ALMA-7: Rescue Protocol
//  iOS Mobile Development · Module 3 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER CODE section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Use the exact function names from the assignment PDF.
// =============================================================


// MARK: - =================== STARTER CODE ===================
// MARK: - Do not modify anything in this section

typealias Reading = (sensor: String, value: Int)

/// Splits a string at the first occurrence of the separator.
/// splitOnce("O2:87", by: ":") -> ("O2", "87")
/// splitOnce("hello", by: ":") -> nil
func splitOnce(_ line: String, by separator: Character) -> (String, String)? {
    guard let index = line.firstIndex(of: separator) else { return nil }
    let left = String(line[..<index])
    let right = String(line[line.index(after: index)...])
    return (left, right)
}

let rawLog = [
    "O2:87", "TEMP:-12", "O2:9x", "PRESS:101", "TEMP:abc", "O2:",
    "RAD:3", "O2:64", ":55", "TEMP:31", "PRESS:98", "O2:71",
    "RAD:-1", "TEMP:4", "PRESS:1o2", "O2:90"
]

class Tank {
    var level: Int
    init(level: Int) { self.level = level }
}

class Module {
    let name: String
    var oxygenTank: Tank?
    init(name: String, oxygenTank: Tank?) {
        self.name = name
        self.oxygenTank = oxygenTank
    }
}

class CrewMember {
    let name: String
    let role: String
    let priority: Int      // 1 = evacuated first
    var module: Module?    // nil = in open space
    init(name: String, role: String, priority: Int, module: Module?) {
        self.name = name
        self.role = role
        self.priority = priority
        self.module = module
    }
}

let lab  = Module(name: "Lab",  oxygenTank: Tank(level: 40))
let hab  = Module(name: "Hab",  oxygenTank: Tank(level: 12))
let dock = Module(name: "Dock", oxygenTank: nil)

let crew = [
    CrewMember(name: "Timur",   role: "Engineer",  priority: 3, module: lab),
    CrewMember(name: "Dana",    role: "Scientist", priority: 4, module: dock),
    CrewMember(name: "Aigerim", role: "Commander", priority: 1, module: hab),
    CrewMember(name: "Nurlan",  role: "Pilot",     priority: 2, module: nil)
]

var roster: [String: CrewMember] = [:]
for member in crew { roster[member.name] = member }

print("ALMA-7 systems online: \(rawLog.count) log lines, \(crew.count) crew members.")

// MARK: - ================= END OF STARTER CODE =================


// MARK: - =================== YOUR SOLUTION ===================

// MARK: Level 1 · Decoding Telemetry

// 1.1
func parseReading(_ raw: String) -> Reading? {
    guard let parts = splitOnce(raw, by: ":"),
          !parts.0.isEmpty,
          let value = Int(parts.1),
          value >= 0 || parts.0 == "TEMP" else {
        return nil
    }

    return (sensor: parts.0, value: value)
}

// 1.2
func parseLog(_ lines: [String]) -> (valid: [Reading], invalidCount: Int) {
    var valid: [Reading] = []
    var invalidCount = 0

    for line in lines {
        if let reading = parseReading(line) {
            valid.append(reading)
        } else {
            invalidCount += 1
        }
    }

    return (valid: valid, invalidCount: invalidCount)
}

print("1.1 O2:87:", parseReading("O2:87") as Any)
print("1.1 TEMP:-12:", parseReading("TEMP:-12") as Any)
print("1.1 RAD:-1:", parseReading("RAD:-1") as Any)
print("1.1 :55:", parseReading(":55") as Any)

let logResult = parseLog(rawLog)
print("Valid readings:", logResult.valid)
print("Invalid count:", logResult.invalidCount)

let A = logResult.invalidCount


// MARK: Level 2 · Analysis

// 2.1
func select(_ readings: [Reading], where isIncluded: (Reading) -> Bool) -> [Reading] {
    var result: [Reading] = []

    for reading in readings {
        if isIncluded(reading) {
            result.append(reading)
        }
    }

    return result
}

func values(of readings: [Reading]) -> [Int] {
    var result: [Int] = []

    for reading in readings {
        result.append(reading.value)
    }

    return result
}

let o2Readings = select(logResult.valid) { $0.sensor == "O2" }
let o2Values = values(of: o2Readings)

print("2.1 O2 readings:", o2Readings)
print("2.1 O2 values:", o2Values)

// 2.2
func stats(of values: [Int]) -> (min: Int, max: Int, average: Double)? {
    guard let first = values.first else {
        return nil
    }

    var minValue = first
    var maxValue = first
    var total = 0

    for value in values {
        if value < minValue {
            minValue = value
        }
        if value > maxValue {
            maxValue = value
        }
        total += value
    }

    let average = Double(total) / Double(values.count)
    return (min: minValue, max: maxValue, average: average)
}

func stats(_ values: Int...) -> (min: Int, max: Int, average: Double)? {
    return stats(of: values)
}

print("2.2 stats array:", stats(of: [3, 8, 1]) as Any)
print("2.2 stats variadic:", stats(3, 8, 1) as Any)

let B = Int(stats(of: o2Values)?.average ?? 0)
print("B =", B)

// 2.3 · The Closure Ladder

let sorted1 = logResult.valid.sorted(by: { (a: Reading, b: Reading) -> Bool in
    return a.value > b.value
})

let sorted2 = logResult.valid.sorted(by: { (a, b) in
    return a.value > b.value
})

let sorted3 = logResult.valid.sorted(by: { a, b in
    a.value > b.value
})

let sorted4 = logResult.valid.sorted(by: {
    $0.value > $1.value
})

let sorted5 = logResult.valid.sorted {
    $0.value > $1.value
}

func readingsEqual(_ first: [Reading], _ second: [Reading]) -> Bool {
    if first.count != second.count {
        return false
    }

    for i in 0..<first.count {
        if first[i].sensor != second[i].sensor || first[i].value != second[i].value {
            return false
        }
    }

    return true
}

let allSortsMatch =
    readingsEqual(sorted1, sorted2) &&
    readingsEqual(sorted2, sorted3) &&
    readingsEqual(sorted3, sorted4) &&
    readingsEqual(sorted4, sorted5)

print("2.3 all sorting results match:", allSortsMatch)
print("2.3 sorted readings:", sorted5)


// MARK: Level 3 · Temperature Stabilization

// 3.1
func heatUp(_ t: Int) -> Int {
    return t + 5
}

func coolDown(_ t: Int) -> Int {
    return t - 3
}

func hold(_ t: Int) -> Int {
    return t
}

func chooseProtocol(for temp: Int) -> (Int) -> Int {
    if temp < 18 {
        return heatUp
    } else if temp > 24 {
        return coolDown
    } else {
        return hold
    }
}

// 3.2
func runUntilStable(from start: Int, maxSteps: Int = 10) -> (finalTemp: Int, steps: Int, isStable: Bool) {
    var temperature = start
    var steps = 0

    while (temperature < 18 || temperature > 24) && steps < maxSteps {
        let selectedProtocol = chooseProtocol(for: temperature)
        temperature = selectedProtocol(temperature)
        steps += 1
    }

    return (
        finalTemp: temperature,
        steps: steps,
        isStable: temperature >= 18 && temperature <= 24
    )
}

print("3.1 heatUp:", heatUp(10))
print("3.1 coolDown:", coolDown(30))
print("3.1 hold:", hold(21))
print("3.1 chooseProtocol:", chooseProtocol(for: 10)(10))

print("3.2 from 31:", runUntilStable(from: 31))
print("3.2 from -100:", runUntilStable(from: -100, maxSteps: 5))

let temperatures = select(logResult.valid) { $0.sensor == "TEMP" }
let temperatureValues = values(of: temperatures)
let lowestTemperature = stats(of: temperatureValues)?.min ?? 0
let C = runUntilStable(from: lowestTemperature).steps

print("Lowest valid temperature:", lowestTemperature)
print("C =", C)


// MARK: Level 4 · The Crew

// 4.1
func oxygenLevel(of member: CrewMember) -> Int? {
    member.module?.oxygenTank?.level
}

// 4.2
func status(of member: CrewMember) -> String {
    guard let module = member.module else {
        return "\(member.name): no data (open space)"
    }

    let level = oxygenLevel(of: member) ?? -1

    if level < 0 {
        return "\(member.name): no data (\(module.name))"
    } else if level < 20 {
        return "\(member.name): \(level)% CRITICAL"
    } else {
        return "\(member.name): \(level)% OK"
    }
}

print("4.1 Timur oxygen:", oxygenLevel(of: crew[0]) as Any)
print("4.1 Dana oxygen:", oxygenLevel(of: crew[1]) as Any)

print("4.2 Crew status:")
for member in crew {
    print(status(of: member))
}

// 4.3
@discardableResult
func transferOxygen(from source: inout Int, to target: inout Int, amount: Int) -> Int {
    if amount <= 0 {
        return 0
    }

    let availableSpace = 100 - target
    let transferred = min(amount, min(source, availableSpace))

    if transferred <= 0 {
        return 0
    }

    source -= transferred
    target += transferred

    return transferred
}

if let labTank = lab.oxygenTank, let habTank = hab.oxygenTank {
    let transferred = transferOxygen(
        from: &labTank.level,
        to: &habTank.level,
        amount: 30
    )
    print("4.3 Transferred:", transferred)
    print("4.3 Lab oxygen:", labTank.level)
    print("4.3 Hab oxygen:", habTank.level)
}

let D = hab.oxygenTank?.level ?? 0
print("D =", D)

// 4.4
func evacuationOrder(_ names: String..., roster: [String: CrewMember]) -> [String] {
    var foundMembers: [CrewMember] = []

    for name in names {
        guard let member = roster[name] else {
            print("Unknown crew member: \(name)")
            continue
        }

        foundMembers.append(member)
    }

    // Manual sort by priority, without using higher-order sorting helpers.
    for i in 0..<foundMembers.count {
        var smallestIndex = i

        if i + 1 < foundMembers.count {
            for j in (i + 1)..<foundMembers.count {
                if foundMembers[j].priority < foundMembers[smallestIndex].priority {
                    smallestIndex = j
                }
            }
        }

        if smallestIndex != i {
            let temp = foundMembers[i]
            foundMembers[i] = foundMembers[smallestIndex]
            foundMembers[smallestIndex] = temp
        }
    }

    var result: [String] = []
    for member in foundMembers {
        result.append(member.name)
    }

    return result
}

print("4.4 Evacuation:", evacuationOrder(
    "Dana",
    "Ghost",
    "Aigerim",
    "Timur",
    roster: roster
))


// MARK: Level 5 · The Saboteur's Logbook

/*
Problems in the original reportOxygen:

1. member.module! crashes when member.module is nil.
   Example: Nurlan has no module, so Nurlan would cause a runtime crash.

2. member.module!.oxygenTank! crashes when the module has no oxygen tank.
   Example: Dana is in Dock, and Dock.oxygenTank is nil.

3. The force unwraps violate the station rule forbidding ! outside
   the Saboteur's original code.

Problems in the original firstCritical:

1. oxygenLevel(of: member)! crashes when a crew member has no oxygen data.
   Example: Dana or Nurlan can cause a runtime crash.

2. result! crashes when nobody is critical because result remains nil.
   This is possible if every available oxygen level is >= 20.

3. Logic bug: the loop keeps going after finding a critical member and
   overwrites result. Therefore it returns the LAST critical member,
   not the FIRST critical member.
*/

// Fixed version of reportOxygen:
func reportOxygen(for member: CrewMember) -> String {
    guard let level = oxygenLevel(of: member) else {
        return "\(member.name): no data"
    }

    return "\(member.name): \(level)%"
}

// Fixed version of firstCritical:
func firstCritical(in crew: [CrewMember]) -> String? {
    for member in crew {
        guard let level = oxygenLevel(of: member) else {
            continue
        }

        if level < 20 {
            return member.name
        }
    }

    return nil
}

print("5. reportOxygen Timur:", reportOxygen(for: crew[0]))
print("5. reportOxygen Dana:", reportOxygen(for: crew[1]))
print("5. reportOxygen Nurlan:", reportOxygen(for: crew[3]))

print("5. firstCritical starter crew:", firstCritical(in: crew) as Any)

// Test proving the original logic bug is fixed:
// Both Aigerim and another member are critical, so the correct answer
// must be the FIRST critical member in the array.
let testCriticalCrew = [
    CrewMember(name: "FirstCritical", role: "Engineer", priority: 1, module: Module(name: "Test1", oxygenTank: Tank(level: 10))),
    CrewMember(name: "SecondCritical", role: "Scientist", priority: 2, module: Module(name: "Test2", oxygenTank: Tank(level: 5))),
    CrewMember(name: "Safe", role: "Pilot", priority: 3, module: Module(name: "Test3", oxygenTank: Tank(level: 50)))
]

print("5. firstCritical test:", firstCritical(in: testCriticalCrew) as Any)
print("5. expected first critical: FirstCritical")


// MARK: Finale · Launch Code

let launchCode = "\(A)-\(B)-\(C)-\(D)"
print("LAUNCH CODE: \(launchCode)")


// MARK: Bonus

func makeAlarm(threshold: Int) -> (Int) -> Bool {
    var count = 0

    return { oxygenLevel in
        if oxygenLevel < threshold {
            count += 1
            print("Alarm #\(count)")
            return true
        }

        return false
    }
}

let alarm = makeAlarm(threshold: 20)
print("Bonus alarm 12:", alarm(12))
print("Bonus alarm 40:", alarm(40))
print("Bonus alarm 5:", alarm(5))

/*
The counter lives in the closure's captured environment.
Even after makeAlarm returns, the returned closure keeps the captured
variable alive, so the next call can see and update the same counter.
*/


// MARK: - ================= DEFENSE QUESTIONS =================

/*
1. How does guard let differ from if let beyond syntax?

guard is used when something must be valid for the rest of the
current scope. If the condition fails, guard must exit the scope.

Example:
guard let value = optionalValue else { return }

With if let, the unwrapped value normally exists only inside the
if block, so deeply nested code can become harder to read.

2. Why can't you call stats(someArray) where someArray: [Int]?

Because stats(_ values: Int...) is variadic. It accepts separate Int
arguments such as stats(3, 8, 1), not one [Int] argument.

For an array, use stats(of: someArray).

3. Why doesn't transferOxygen(from: &x, to: &x, amount: 5) compile?
What bug does this prevent?

Swift does not allow the same variable to be passed as two simultaneous
inout arguments. This prevents overlapping mutable access to the same
memory and makes the mutation unambiguous.

4. Why doesn't oxygenLevel(of: dana) ?? "no data" compile?

oxygenLevel(of:) returns Int?, so ?? needs a fallback value of Int.
"no data" is a String, so the types do not match.

For example:
let level = oxygenLevel(of: dana) ?? 0

Or use the optional in a String-producing expression.

5. What is the full type of the function chooseProtocol itself?

(Int) -> (Int) -> Int

It means chooseProtocol takes one Int argument and returns a function.
The returned function itself takes an Int and returns an Int.

Bonus. Where does the alarm counter live after makeAlarm returns?

The counter is captured by the returned closure. The closure keeps the
captured variable alive, so the counter remains available between calls.
*/
