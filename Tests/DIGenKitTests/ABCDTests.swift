//
//  Tests.swift
//  dikitgenTests
//
//  Created by Yosuke Ishikawa on 2017/09/16.
//

import XCTest
import DIGenKit
import DIKit

struct A: Injectable {
    struct Dependency {}
    init(dependency: Dependency) {}
}

struct B: Injectable {
    struct Dependency {
        let ba: A
    }

    init(dependency: Dependency) {}
}

struct C: Injectable {
    struct Dependency {
        let ca: A
        let cd: D
    }

    init(dependency: Dependency) {}
}

struct D {}

protocol ABCDResolver: DIKit.Resolver {
    func provideD() -> D
}

final class ABCDTests: XCTestCase {
    func test() {
        let generator = CodeGenerator(path: #file)
        let contents = try! generator.generate().trimmingCharacters(in: .whitespacesAndNewlines)
        XCTAssertEqual(contents, """
            //
            //  Resolver.swift
            //  Generated by dikitgen.
            //

            extension ABCDResolver {

                func resolveA() -> A {
                    return A(dependency: .init())
                }

                func resolveB() -> B {
                    let a = resolveA()
                    return B(dependency: .init(ba: a))
                }

                func resolveD() -> D {
                    return provideD()
                }

                func resolveC() -> C {
                    let a = resolveA()
                    let d = resolveD()
                    return C(dependency: .init(ca: a, cd: d))
                }

            }
            """)
    }
}