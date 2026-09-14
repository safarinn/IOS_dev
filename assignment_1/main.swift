//
//  main.swift
//  ios_dev_labs
//
//  Created by Нурали Муратов on 12.09.2026.
//

import Foundation

var firstName: String = "Nurali"
var lastName: String = "Muratov"
var age: Int = 19
var birthYear: Int = 2007
var isStudent: Bool = true
var height: Double = 167.7
let currentYear: Int = 2026
let calculatedAge: Int = currentYear - birthYear
var speciality : String = "Information systems"
var job : String = "Digital marketing /ads manager"

var hobby : String = "Shooting photos/videos "
var numberofHobbies : Int = 1
var favouriteNumber : Int = 7
var isHobbyCreative : Bool = true
var futureGoals: String = "In the future, I want to become a professional iOS developer and the nearest year I want to take an internship in Bigtech companies like Yandex and etc, to reach this goal I  learn swift UI and and creating an app. Then I plan to enroll to the NU for master's degree in computer science school so that at the graduation course I must do one beneficial app on ios base "
var lifeStory : String = "My name is \(lastName) \(firstName) . I am \(age) years old , born in \(birthYear). I am currently a student and work as a \(job) specialist at a company. I enjoy \(hobby), which is a creative hobby. I have just only obe hobby which related with mobile , and my favourite number is \(favouriteNumber). \(futureGoals)"

print(lifeStory)
