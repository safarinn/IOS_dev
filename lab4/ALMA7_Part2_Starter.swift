// =============================================================
//  Station ALMA-7, Part II: The Teleporter Incident
//  iOS Mobile Development · Module 4 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Part2_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER DATA section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Default to struct. Use class only where the task says so.
// =============================================================


// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Splits a line into fields.
/// fields("crate:101:120")            -> ["crate", "101", "120"]
/// fields("livestock:lab mice:12:2")  -> ["livestock", "lab mice", "12", "2"]
/// fields("junk")                     -> ["junk"]
func fields(_ line: String, separatedBy separator: Character = ":") -> [String] {
    var result: [String] = []
    var current = ""
    for character in line {
        if character == separator {
            result.append(current)
            current = ""
        } else {
            current.append(character)
        }
    }
    result.append(current)
    return result
}

/// Cargo manifest as recovered from the damaged recorder.
let rawManifest = [
    "crate:101:120",
    "container:KZ-ALM-7:340",
    "livestock:lab mice:12:2",
    "???-corrupted-line",
    "crate:102:75",
    "container:KZ-ALM-9:410",
    "livestock:ficus:3:5",
    "crate:103:260",
    "crate:104:abc",
    ""
]

/// Oxygen readings. One of these deck names is not a real deck.
let deckReadings: [(deck: String, oxygen: Int)] = [
    (deck: "bridge",     oxygen: 78),
    (deck: "lab",        oxygen: 64),
    (deck: "greenhouse", oxygen: 55),
    (deck: "cargo",      oxygen: 12),
    (deck: "medbay",     oxygen: 90),
    (deck: "engine",     oxygen: 41)
]

/// Crew records, straight from the personnel file.
let crewData: [(name: String, deck: String, oxygen: Int)] = [
    (name: "Timur",   deck: "engine", oxygen: 62),
    (name: "Dana",    deck: "lab",    oxygen: 48),
    (name: "Aigerim", deck: "bridge", oxygen: 91),
    (name: "Nurlan",  deck: "cargo",  oxygen: 17)
]

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================
// Uncomment each declaration when you start working on it.


// MARK: Level 1 · The Deck Register

// 1.1
enum Deck: String, CaseIterable {
    case bridge
    case lab
    case cargo
    case medbay
    case engine

    // Smaller number means higher evacuation priority.
    // If your assignment sheet specifies a different priority order, use that order.
    var evacuationPriority: Int {
        switch self {
        case .bridge: return 1
        case .medbay: return 2
        case .engine: return 3
        case .lab: return 4
        case .cargo: return 5
        }
    }
}

enum AlarmLevel: Int {
    case green = 0
    case yellow = 1
    case orange = 2
    case red = 3

    static func level(forTotalMass mass: Int) -> AlarmLevel {
        let nonNegativeMass = max(0, mass)
        let rawLevel = min(nonNegativeMass / 500, 3)
        return AlarmLevel(rawValue: rawLevel) ?? .green
    }
}

// MARK: - Level 2: Parse the manifest

enum ManifestEntry {
    case crate(id: Int, massKg: Int)
    case container(code: String, massKg: Int)
    case livestock(species: String, count: Int, massPerUnitKg: Int)
    case unknown(raw: String)
}

func parseEntry(_ line: String) -> ManifestEntry {
    let parts = fields(line)

    guard let first = parts.first else {
        return .unknown(raw: line)
    }

    switch first {
    case "crate":
        guard parts.count == 3,
              let id = Int(parts[1]),
              let mass = Int(parts[2]),
              mass >= 0 else {
            return .unknown(raw: line)
        }
        return .crate(id: id, massKg: mass)

    case "container":
        guard parts.count == 3,
              !parts[1].isEmpty,
              let mass = Int(parts[2]),
              mass >= 0 else {
            return .unknown(raw: line)
        }
        return .container(code: parts[1], massKg: mass)

    case "livestock":
        guard parts.count == 4,
              !parts[1].isEmpty,
              let count = Int(parts[2]),
              let massPerUnit = Int(parts[3]),
              count >= 0,
              massPerUnit >= 0 else {
            return .unknown(raw: line)
        }
        return .livestock(species: parts[1], count: count, massPerUnitKg: massPerUnit)

    default:
        return .unknown(raw: line)
    }
}

func mass(of entry: ManifestEntry) -> Int {
    switch entry {
    case let .crate(_, massKg):
        return massKg
    case let .container(_, massKg):
        return massKg
    case let .livestock(_, count, massPerUnitKg):
        return count * massPerUnitKg
    case .unknown:
        return 0
    }
}

var totalManifestMass = 0
var unknownManifestCount = 0

for line in rawManifest {
    let entry = parseEntry(line)
    totalManifestMass += mass(of: entry)
    if case .unknown = entry {
        unknownManifestCount += 1
    }
}

print("LEVEL 2 — Manifest")
print("Total valid mass: \(totalManifestMass) kg")
print("Unknown entries: \(unknownManifestCount)")

// MARK: - Level 3: Crew snapshots (value types)

struct CrewSnapshot {
    let name: String
    var deck: Deck
    var oxygen: Int

    mutating func breathe(amount: Int) {
        let safeAmount = max(0, amount)
        oxygen = max(0, oxygen - safeAmount)
    }

    mutating func move(to newDeck: Deck) {
        deck = newDeck
    }

    mutating func reviveInMedbay() {
        self = CrewSnapshot(name: name, deck: .medbay, oxygen: 100)
    }

    static func rookie(named name: String) -> CrewSnapshot {
        return CrewSnapshot(name: name, deck: .bridge, oxygen: 100)
    }
}

var roster: [CrewSnapshot] = []
for item in crewData {
    if let deck = Deck(rawValue: item.deck) {
        let member = CrewSnapshot(name: item.name, deck: deck, oxygen: item.oxygen)
        roster.append(member)
    } else {
        print("Skipping crew member with invalid deck: \(item.name) (\(item.deck))")
    }
}

print("\nLEVEL 3 — Crew roster")
for member in roster {
    print("\(member.name): deck=\(member.deck.rawValue), oxygen=\(member.oxygen)")
}

if !roster.isEmpty {
    var copiedMember = roster[0]
    copiedMember.breathe(amount: 10)
    print("Value copy check: original oxygen=\(roster[0].oxygen), copy oxygen=\(copiedMember.oxygen)")
}

// MARK: - Level 4: Teleport pods (reference types)

final class TeleportPod {
    let id: String
    var chargeLevel: Int
    var occupant: CrewSnapshot?

    init(id: String, chargeLevel: Int, occupant: CrewSnapshot? = nil) {
        self.id = id
        self.chargeLevel = max(0, min(chargeLevel, 100))
        self.occupant = occupant
    }

    @discardableResult
    func load(crew: CrewSnapshot) -> Bool {
        guard occupant == nil else {
            print("Pod \(id) is already occupied.")
            return false
        }
        occupant = crew
        return true
    }

    func fire() -> CrewSnapshot? {
        guard let crew = occupant else {
            print("Pod \(id) is empty; teleportation failed.")
            return nil
        }
        guard chargeLevel >= 20 else {
            print("Pod \(id) has insufficient charge.")
            return nil
        }

        chargeLevel -= 20
        occupant = nil
        return crew
    }

    deinit {
        print("TeleportPod \(id) deallocated")
    }
}

print("\nLEVEL 4 — Teleport ledger")
let ledgerPod = TeleportPod(id: "ALMA-7", chargeLevel: 100)
let namesToTeleport = ["Timur", "Dana", "Nurlan"]

for name in namesToTeleport {
    var foundCrew: CrewSnapshot? = nil
    for member in roster {
        if member.name == name {
            foundCrew = member
            break
        }
    }

    if let crew = foundCrew {
        if ledgerPod.load(crew: crew) {
            if let teleported = ledgerPod.fire() {
                print("Teleported \(teleported.name). Charge left: \(ledgerPod.chargeLevel)%")
            }
        }
    }
}

let emptyFireResult = ledgerPod.fire()
print("Firing empty pod returned nil: \(emptyFireResult == nil)")
print("Final pod charge: \(ledgerPod.chargeLevel)%")

// MARK: - Level 5: Station, property observers and lazy diagnostics

final class Station {
    let callSign: String

    var hullIntegrity: Int {
        willSet {
            print("Hull integrity requested change: \(hullIntegrity) -> \(newValue)")
        }
        didSet {
            if hullIntegrity < 0 {
                hullIntegrity = 0
            } else if hullIntegrity > 100 {
                hullIntegrity = 100
            }
            print("Hull integrity is now \(hullIntegrity)%")
        }
    }

    lazy var fullDiagnostics: String = {
        print("Running full scan...")
        return "Station \(callSign): hull=\(hullIntegrity)%, oxygen decks=\(oxygenByDeck.count), total oxygen=\(totalOxygen)"
    }()

    private var oxygenByDeck: [Deck: Int] = [:]

    var totalOxygen: Int {
        var total = 0
        for amount in oxygenByDeck.values {
            total += amount
        }
        return total
    }

    var averageOxygen: Int {
        get {
            guard !oxygenByDeck.isEmpty else { return 0 }
            return totalOxygen / oxygenByDeck.count
        }
        set {
            for deck in Deck.allCases {
                if oxygenByDeck[deck] != nil {
                    oxygenByDeck[deck] = max(0, newValue)
                }
            }
        }
    }

    init(callSign: String, hullIntegrity: Int, readings: [(deck: String, oxygen: Int)]) {
        self.callSign = callSign
        self.hullIntegrity = max(0, min(hullIntegrity, 100))
        for reading in readings {
            if let deck = Deck(rawValue: reading.deck) {
                oxygenByDeck[deck] = max(0, reading.oxygen)
            } else {
                print("Ignoring oxygen reading for unknown deck: \(reading.deck)")
            }
        }
    }
}

let station = Station(callSign: "ALMA-7", hullIntegrity: 85, readings: deckReadings)
let finaleAverageOxygen = station.averageOxygen
print("\nLEVEL 5 — Station")
print("Total oxygen: \(station.totalOxygen)")
print("Average oxygen: \(station.averageOxygen)")
print(station.fullDiagnostics)
print(station.fullDiagnostics) // The lazy property runs its closure only on first access.
station.hullIntegrity = 130
station.hullIntegrity = -40
station.hullIntegrity = 55

// MARK: - Level 6: Value and reference semantics reports

print("\nLEVEL 6 — Reports")
print("Report 1: Mutating a loop variable copy does not update the array. Update roster[index] instead.")
print("Report 2: Assigning one class instance to another variable copies the reference; both names refer to the same pod.")
print("Report 3: A struct method that changes stored properties must be marked mutating.")
print("Report 4: Changing a let struct value does not compile; changing a class instance's var property through let reference does compile.")

// MARK: - Level 7: Sealed flight recorder and access control

final class FlightRecorder {
    private var entries: [String] = []
    private(set) var isSealed = false

    var entryCount: Int {
        return entries.count
    }

    var transcript: String {
        return entries.joined(separator: "\n")
    }

    func add(_ entry: String) {
        guard !isSealed else {
            print("Cannot add entry: recorder is sealed.")
            return
        }
        entries.append(entry)
    }

    func seal() {
        isSealed = true
    }

    fileprivate func auditTranscript() -> String {
        return transcript
    }
}

func auditTranscript(of recorder: FlightRecorder) -> String {
    return recorder.auditTranscript()
}

let recorder = FlightRecorder()
recorder.add("Manifest mass calculated: \(totalManifestMass) kg")
recorder.add("Unknown manifest rows: \(unknownManifestCount)")
recorder.add("Crew teleported: Timur, Dana, Nurlan")
recorder.seal()
recorder.add("This entry should be rejected")
print("\nLEVEL 7 — Flight recorder")
print("Sealed: \(recorder.isSealed), entries: \(recorder.entryCount)")
print(auditTranscript(of: recorder))

// MARK: - Finale: Integrity code

let A = totalManifestMass
let B = finaleAverageOxygen
let C = ledgerPod.chargeLevel
let D = AlarmLevel.level(forTotalMass: A).rawValue
let integrityCode = "\(A)-\(B)-\(C)-\(D)"

print("\nFINALE")
print("INTEGRITY CODE: \(integrityCode)")

// MARK: - Bonus: deinitialization and identity

// The deinit example is separate so it is easy to observe when the last
// strong reference to a TeleportPod is released.
func demonstrateReferenceIdentity() {
    let first = TeleportPod(id: "BONUS-1", chargeLevel: 50)
    let second = first
    print("Same object: \(first === second)")
    second.chargeLevel = 70
    print("Charge through first reference: \(first.chargeLevel)")
}

demonstrateReferenceIdentity()

// MARK: - Defense Questions (short answers)

 /*
 1. Why did CrewSnapshot get an initializer for free while TeleportPod did not?
    Structs can receive a synthesized memberwise initializer. This class
    defines its own required init(id:chargeLevel:) to initialize occupant to nil
    and to control initialization.

 2. What does mutating actually do to self, and why do classes never need it?
    For a struct, mutating permits the method to change the value of self or
    its stored properties. A class method can mutate the referenced object
    without mutating the reference value itself, so classes do not use mutating.

 3. In Report 4, both values are declared with let. What does let freeze?
    For a struct, let makes the whole value immutable, so snapshot.oxygen cannot
    be assigned. For a class, let freezes which object the reference points to;
    var properties of that object can still change.

 4. Why must a lazy property be var?
    Its value is stored the first time it is accessed, so initialization must
    be able to write that stored result. A lazy diagnostics property also delays
    the scan and its print side effect until first access.

 5. private vs fileprivate?
    private keeps the backing entries array accessible only inside FlightRecorder
    and its extensions in the same file. fileprivate lets the free function
    recordSystemNotice call appendUnchecked from elsewhere in this file.
 */

// MARK: - Bonus: reference counting / identity

func samePod(_ first: TeleportPod, _ second: TeleportPod) -> Bool {
    first === second
}

print("\n=== BONUS: IDENTITY ===")
let identityPod1 = TeleportPod(id: "IDENTITY", chargeLevel: 40)
let identityPod2 = identityPod1
let identityPod3 = TeleportPod(id: "IDENTITY", chargeLevel: 40)
print("Same reference (1 and 2): \(samePod(identityPod1, identityPod2))")
print("Same reference (1 and 3): \(samePod(identityPod1, identityPod3))")
// === works only with class references, not CrewSnapshot structs.
// A deinitializer runs when the last strong reference to a class instance is released.
do {
    let localPod = TeleportPod(id: "DO-BLOCK", chargeLevel: 40)
    let secondReference = localPod
    print("Inside do block; pod id = \(secondReference.id)")
}
print("After do block. DO-BLOCK is not deinitialized there if another strong reference still exists.")
