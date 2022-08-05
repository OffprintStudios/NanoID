//
//  NanoID.swift
//
//  Created by Anton Lovchikov on 05/07/2018.
//  Copyright © 2018 Anton Lovchikov. All rights reserved.
//

import Foundation

/// USAGE
///
/// Nano ID with default alphabet (0-9a-zA-Z_~) and length (21 chars)
/// let id = NanoID.new()
///
/// Nano ID with default alphabet and given length
/// let id = NanoID.new(12)
///
/// Nano ID with given alphabet and length
/// let id = NanoID.new(alphabet: .uppercaseLatinLetters, size: 15)
///
/// Nano ID with preset custom parameters
/// let nanoID = NanoID(alphabet: .lowercaseLatinLetters,.numbers, size:10)
/// let idFirst = nanoID.new()
/// let idSecond = nanoID.new()
public class NanoID {
    // Shared Parameters
    private var size: Int
    private var alphabet: String

    // Default Parameters
    private static let defaultSize = 21
    private static let defaultAlphabet = NanoIDAlphabet.urlSafe.toString()

    /// Inits an instance with Shared Parameters
    init(alphabet: NanoIDAlphabet..., size: Int) {
        self.size = size
        self.alphabet = NanoIDHelper.parse(alphabet)
    }

    /// Generates a Nano ID using Shared Parameters
    func new() -> String {
        return NanoIDHelper.generate(from: alphabet, of: size)
    }

    /// Generates a Nano ID using Default Alphabet and given size
    public static func new(_ size: Int = defaultSize) -> String {
        return NanoIDHelper.generate(from: defaultAlphabet, of: size)
    }

    /// Generates a Nano ID using given occasional parameters
    public static func new(alphabet: NanoIDAlphabet..., size: Int) -> String {
        let charactersString = NanoIDHelper.parse(alphabet)
        return NanoIDHelper.generate(from: charactersString, of: size)
    }
}

fileprivate struct NanoIDHelper {
    /// Parses input alphabets into a string
    static func parse(_ alphabets: [NanoIDAlphabet]) -> String {
        var stringChars = ""
        for alphabet in alphabets {
            stringChars.append(alphabet.toString())
        }
        return stringChars
    }

    /// Generates a Nano ID using given parameters
    static func generate(from alphabet: String, of length: Int) -> String {
        var nanoId = ""
        for _ in 0..<length {
            let randomChar = NanoIDHelper.randomCharacter(from: alphabet)
            nanoId.append(randomChar)
        }
        return nanoId
    }

    /// Returns a random character from a given string
    static func randomCharacter(from string: String) -> Character {
        let randomNum = Int.random(in: 0..<string.count)
        let randomIdx = string.index(string.startIndex, offsetBy: randomNum)
        return string[randomIdx]
    }
}

enum NanoIDAlphabet {
    case urlSafe
    case uppercaseLatinLetters
    case lowercaseLatinLetters
    case numbers

    func toString() -> String {
        switch self {
        case .lowercaseLatinLetters, .uppercaseLatinLetters, .numbers:
            return self.chars()
        case .urlSafe:
            return("\(NanoIDAlphabet.uppercaseLatinLetters.chars())\(NanoIDAlphabet.lowercaseLatinLetters.chars())\(NanoIDAlphabet.numbers.chars())-_")
        }
    }

    private func chars() -> String {
        switch self {
        case .uppercaseLatinLetters:
            return "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        case .lowercaseLatinLetters:
            return "abcdefghijklmnopqrstuvwxyz"
        case .numbers:
            return "1234567890"
        default:
            return ""
        }
    }
}
