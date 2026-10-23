// =============================================================
//  Station ALMA-7, Part III: The Repair Fleet
//  iOS Mobile Development · Module 5 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Part3_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER DATA section. LegacyBeacon in
//     particular must be reached with an extension, not edited.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • The Health Rule must exist in exactly ONE place in this file.
// =============================================================


// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Drone records recovered from the fleet registry.
/// One `kind` does not correspond to any drone type you will build.
let fleetData: [(kind: String, id: String, charge: Int)] = [
    (kind: "welder",  id: "W-1", charge: 80),
    (kind: "scanner", id: "S-1", charge: 45),
    (kind: "cargo",   id: "C-1", charge: 100),
    (kind: "welder",  id: "W-2", charge: 15),
    (kind: "scanner", id: "S-2", charge: 60),
    (kind: "tug",     id: "T-1", charge: 50)
]

/// Hull sensors. These are NOT drones — they never move and never work a shift.
let sensorData: [(id: String, charge: Int)] = [
    (id: "hull-cam", charge: 12),
    (id: "thermal",  charge: 77)
]

/// Hardware from the original station. You may not add anything to this
/// declaration — no methods, no protocols, no properties.
struct LegacyBeacon {
    let name: String
    let signalStrength: Int
}

let beacon = LegacyBeacon(name: "ALMA-BEACON", signalStrength: 8)

print("Fleet registry online: \(fleetData.count) drone records, \(sensorData.count) sensors, beacon \(beacon.name).")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================
// Uncomment each declaration when you start working on it.


// MARK: Level 1 · The Power Cell

// Why a class and not a struct here?  ->
final class PowerCell {
  private var charge: Int

  init(charge:Int){
    self.charge = max(0, min(100,charge))
  }

  func level() -> Int {
    return charge
  }

  func spend(amount: Int) -> Bool {
    if amount<=0 || amount > charge{
      return false
    }

    charge-=amount
    return true
  }

  func recharge(by amount: Int){
    if amount<=0 {
      return
    }
    charge = min(100, charge+amount)
    
  }
}
let cell = PowerCell(charge:80)

print(cell.level())          // 80

print(cell.spend(amount: 30)) // true
print(cell.level())          // 50

print(cell.spend(amount: 0))  // false
print(cell.spend(amount: 60)) // false
print(cell.level())           // 50

cell.recharge(by: 40)
print(cell.level())           // 90

cell.recharge(by: 100)
print(cell.level())
// Encapsulation proof (leave this commented, with the compiler error):
// cell.charge = 100
// error:


// MARK: Level 2 · The Fleet

// 2.1  What does `final` on runOnce() buy you?  ->
class Drone {

let id: String
let cell: PowerCell
init(id: String, cell: PowerCell){
  self.id = id
  self.cell = cell
}
var powerCost: Int { 
  return 10 
  }
var statusLine: String {
  return "\(id) @ \(cell.level())%"
}
func performTask() -> Int { 
  return 0 
  } 
final func runOnce() -> Int {
  if (!cell.spend(amount: powerCost)) {
    return 0
  }
  return performTask()
}
 }

// 2.2
 class WelderDrone: Drone { 

  override var powerCost: Int {
    return 25 
  }

  override func performTask() -> Int {
    return 40;
  }

  func weldSeam() -> String {
    return "\(id) welded a seam."
  }

 }
 class ScannerDrone: Drone { 
   override var powerCost: Int {
    return 10
  }

  override func performTask() -> Int {
    return 15
  }
   override var statusLine: String {
        return super.statusLine + " [scanner]"
    }


 }
 final class CargoDrone: Drone { 
  override var powerCost: Int {
    return 20
  }

  override func performTask() -> Int {
    return 25
  }
 }

// 2.3
 func makeDrone(kind: String, id: String, charge: Int) -> Drone? { 
  let cell = PowerCell(charge: charge)

  switch kind.lowercased(){
    case "welder":
      return WelderDrone(id:id, cell:cell)
    case "scanner":
      return ScannerDrone(id:id, cell:cell)
    case "cargo":
      return CargoDrone(id:id, cell:cell)
    default:
      return nil
  }
 }
 var fleet: [Drone] = []
for record in fleetData {
    if let drone = makeDrone(
        kind: record.kind,
        id: record.id,
        charge: record.charge
    ) {
        fleet.append(drone)
    } else {
        print("Warning: skipped unknown drone \(record.kind) with id \(record.id)")
    }
}




// MARK: Level 3 · The Shift
 func runShift( fleet: [Drone], rounds: Int) -> Int {
    var totalWork = 0
    for _ in 0..<rounds {
      for drone in fleet {
        totalWork += drone.runOnce()
      }
    } 
    return totalWork
 }

 let A = runShift(fleet: fleet, rounds: 3)
 print("MISSION A: \(A)")

for drone in fleet {
    print(drone.statusLine)
}

var B = 0

for drone in fleet {
  B += drone.cell.level()
}

print("MISSION B: \(B)")

var C = 0

for drone in fleet {
  if drone.cell.level() >= drone.powerCost {
        C += 1
    }
}
print("MISSION C: \(C)")


// MARK: Level 4 · Diagnostics

// 4.1
protocol Diagnosable {
    var componentID: String { get }
    var statusCode: Int { get }

    func diagnose() -> String
}

protocol Rechargeable {
    mutating func recharge(by amount: Int)
}


// MARK: - DiagnosticDrone

class DiagnosticDrone: Diagnosable, Rechargeable {
    let componentID: String
    let statusCode: Int
    var chargeLevel: Int

    init(componentID: String, statusCode: Int, chargeLevel: Int) {
        self.componentID = componentID
        self.statusCode = statusCode
        self.chargeLevel = chargeLevel
    }

    func diagnose() -> String {
        return "Drone \(componentID): status \(statusCode), charge \(chargeLevel)%"
    }

    // Classes are reference types, so mutating is not required.
    func recharge(by amount: Int) {
        chargeLevel += amount
    }
}


// MARK: - SensorModule

struct SensorModule: Diagnosable, Rechargeable {
    let componentID: String
    let statusCode: Int
    var chargeLevel: Int

    init(sensorData: String, chargeLevel: Int) {
        let parts = sensorData.split(separator: ",")

        self.componentID = String(parts[0])
        self.statusCode = Int(parts[1]) ?? 0
        self.chargeLevel = chargeLevel
    }

    func diagnose() -> String {
        return "Sensor \(componentID): status \(statusCode), charge \(chargeLevel)%"
    }

    mutating func recharge(by amount: Int) {
        chargeLevel += amount
    }
}


// MARK: - Diagnostics Report

func diagnosticsReport(components: [Diagnosable]) -> String {
    var report = ""

    for component in components {
        report += component.diagnose() + "\n"
    }

    return report
}


// MARK: - Test

let drone1 = DiagnosticDrone(
    componentID: "DRONE-01",
    statusCode: 200,
    chargeLevel: 80
)

let drone2 = DiagnosticDrone(
    componentID: "DRONE-02",
    statusCode: 201,
    chargeLevel: 65
)

var sensor1 = SensorModule(
    sensorData: "SENSOR-01,200",
    chargeLevel: 50
)

sensor1.recharge(by: 20)

// [DiagnosticDrone] could never hold SensorModule values because SensorModule is not a subclass of DiagnosticDrone; the protocol type [Diagnosable] can hold both.
let components: [Diagnosable] = [
    drone1,
    drone2,
    sensor1
]

print(diagnosticsReport(components: components))

// MARK: Level 5 · Shared Behaviour

// 5.1 · default diagnose() + the single home of the Health Rule
extension Diagnosable {
  func statusCodeFromCharge(for charge: Int) -> Int {
        if charge < 20 {
            return 2
        } else if charge < 50 {
            return 1
        } 
         else {
            return 0
        }
    }
    func diagnose() -> String {
    return "\(componentID): code  \(statusCode) "
  }
  
 }
 struct Sensor: Diagnosable {
  let componentID: String 
  let charge: Int
  var statusCode: Int {
    return statusCodeFromCharge(for: charge)
  }
 }

 struct ChargeDrone : Diagnosable {
  let componentID: String 
  let charge: Int
  var statusCode: Int {
    return statusCodeFromCharge(for: charge)
  }
 }
 let sensor = Sensor(componentID: "SENSOR-01", charge: 10)
  print(sensor.diagnose()) // SENSOR-01: code 2

  let drone = ChargeDrone(componentID: "DRONE-01", charge: 30)
  print(drone.diagnose()) // DRONE-01: code 1

// 5.2 · the beacon you cannot edit
 extension LegacyBeacon: Diagnosable {
  var componentID: String {
        return "LEGACY-BEACON"
    }

    var statusCode: Int {
      return statusCodeFromCharge(for: signalStrength)
    }

    func diagnose() -> String {
        return "LEGACY HARDWARE \(componentID): code \(statusCode)"
    }
  }
  let diagnostics: [any Diagnosable] = [
    sensor,
    drone,
    beacon
]

for component in diagnostics {
    print(component.diagnose())
}

 let D = diagnostics.reduce(0){
  total,component in
  total + component.statusCode
 }

 print("MISSION D: \(D)")

// 5.3
extension Int {
  var powerBar: String {
      let clamped = Swift.max(0, Swift.min(self, 100))
        let filled = clamped / 10

        return String(repeating: "#", count: filled)
             + String(repeating: ".", count: 10 - filled)
    }
 }

print(42.powerBar)   // ####......
print(100.powerBar)  // ##########
print(5.powerBar)    // ..........
print((-5).powerBar)   // ..........
print(250.powerBar)  // ##########


// MARK: Level 6 · Incident Reports
// Two of these do not compile. Two compile and lie.
// For each: expectation, actual behaviour, the language rule, the fix.


// Report 1
class PatchDrone: Drone {
  override func performTask() -> Int { //added override to fix compile error
        return 30
    }
}

//Report 2
//final means the class cannot be subclassed, so HeavyWelder cannot inherit from WelderDrone. The fix is to remove the final keyword from WelderDrone.
 class HeavyWelder: WelderDrone {
  override func performTask() -> Int {
        return 999
    }
}

// Report 3
let reportFleet: [Drone] = [
  WelderDrone(id: "W-9",
              cell: PowerCell(charge: 100))]
let first = reportFleet[0]
if let welder = first as? WelderDrone {
  print(welder.weldSeam())
}
// Why does as? return an Optional?
// Because the cast might fail. first as? WelderDrone can produce welderDrone or nil

// Report 4
protocol Labelled {
    var componentID: String { get }
    func label() -> String //add to protocol to make it compile
}

extension Labelled {
    func label() -> String { 
      return "generic component" }
}

struct Thruster: Labelled {
    let componentID: String
    func label() -> String { "thruster \(componentID)" }
}

let parts: [Labelled] = [Thruster(componentID: "T-1")]
print(parts[0].label())



// MARK: Finale · Mission Code

let missionCode = "\(A)-\(B)-\(C)"
print("MISSION CODE: \(missionCode)")


// MARK: Bonus

// Two ways to forbid using Drone directly; a protocol-based redesign;
// two or three sentences comparing them.


// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. Why does a class satisfy a `mutating` protocol requirement without the
    keyword, while a struct must write it?
    A struct is a value type, so changing its properties means changing the whole value. It needs mutating to allow this.
    A class is a reference type, so it can change its properties without mutating.
            Inheritance: a class can reuse code and properties from a parent class.
    * Protocols: different types can follow the same rules/requirements, even if they are unrelated.

 2. One thing inheritance does that protocols cannot, and one thing
    protocols do that inheritance cannot:
            Inheritance: a class can reuse code and properties from a parent class.
    * Protocols: different types can follow the same rules/requirements, even if they are unrelated.


 3. What does `final` prevent, and what did it protect in runOnce()?
     final prevents a class or method from being overridden or inherited.
    In runOnce(), it protected the method from being overridden by a subclass

 4. In Report 4, why did the protocol extension's method win?
     Because the method was not a protocol requirement. It was only a method provided by the protocol extension. Swift chooses that extension method based on the protocol type, not the actual object’s type

*/
