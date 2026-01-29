// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Fuzzilli

let duktapeProfile = Profile(
    processArgs: { randomize in
        ["--reprl"]
    },

    processArgsReference: nil,

    processEnv: ["UBSAN_OPTIONS": "handle_segv=0"],

    maxExecsBeforeRespawn: 1000,

    timeout: Timeout.value(250),

    codePrefix: """
                """,

    codeSuffix: """
                """,

    ecmaVersion: ECMAScriptVersion.es5,

    startupTests: [
        // Check that the fuzzilli integration is available.
        ("fuzzilli('FUZZILLI_PRINT', 'test')", .shouldSucceed),

        // Check that common crash types are detected.
        ("fuzzilli('FUZZILLI_CRASH', 0)", .shouldCrash),
        ("fuzzilli('FUZZILLI_CRASH', 1)", .shouldCrash),
    ],

    additionalCodeGenerators: [],

    additionalProgramTemplates: WeightedList<ProgramTemplate>([]),

    // Disable ES6+ generators for Duktape 2.3 (ES5).
    disabledCodeGenerators: [
        // Classes / private fields / super / new.target
        "ClassDefinitionGenerator",
        "ClassConstructorGenerator",
        "ClassInstancePropertyGenerator",
        "ClassInstanceElementGenerator",
        "ClassInstanceComputedPropertyGenerator",
        "ClassInstanceMethodGenerator",
        "ClassInstanceComputedMethodGenerator",
        "ClassInstanceGetterGenerator",
        "ClassInstanceSetterGenerator",
        "ClassStaticPropertyGenerator",
        "ClassStaticElementGenerator",
        "ClassStaticComputedPropertyGenerator",
        "ClassStaticInitializerGenerator",
        "ClassStaticMethodGenerator",
        "ClassStaticComputedMethodGenerator",
        "ClassStaticGetterGenerator",
        "ClassStaticSetterGenerator",
        "ClassPrivateInstancePropertyGenerator",
        "ClassPrivateInstanceMethodGenerator",
        "ClassPrivateStaticPropertyGenerator",
        "ClassPrivateStaticMethodGenerator",
        "PrivatePropertyRetrievalGenerator",
        "PrivatePropertyAssignmentGenerator",
        "PrivatePropertyUpdateGenerator",
        "PrivateMethodCallGenerator",
        "SuperMethodCallGenerator",
        "SuperPropertyRetrievalGenerator",
        "SuperPropertyAssignmentGenerator",
        "ComputedSuperPropertyRetrievalGenerator",
        "ComputedSuperPropertyAssignmentGenerator",
        "SuperPropertyUpdateGenerator",
        "LoadNewTargetGenerator",
        "ConstructWithDifferentNewTargetGenerator",

        // Async / generators / arrow functions
        "ArrowFunctionGenerator",
        "AsyncArrowFunctionGenerator",
        "AsyncFunctionGenerator",
        "GeneratorFunctionGenerator",
        "AsyncGeneratorFunctionGenerator",
        "AwaitGenerator",
        "YieldGenerator",
        "YieldEachGenerator",

        // Template literals / object literal methods / computed properties
        "TemplateStringGenerator",
        "ObjectLiteralMethodGenerator",
        "ObjectLiteralComputedMethodGenerator",
        "ObjectLiteralComputedPropertyGenerator",
        "ObjectLiteralCopyPropertiesGenerator",

        // Spread / destructuring / iterators / for-of
        "ArrayWithSpreadGenerator",
        "MethodCallWithSpreadGenerator",
        "ComputedMethodCallWithSpreadGenerator",
        "FunctionCallWithSpreadGenerator",
        "ConstructorCallWithSpreadGenerator",
        "DestructArrayGenerator",
        "DestructArrayAndReassignGenerator",
        "DestructObjectGenerator",
        "DestructObjectAndReassignGenerator",
        "ForOfLoopGenerator",
        "ForOfWithDestructLoopGenerator",
        "IteratorGenerator",

        // Symbols / proxies / reflect / well-known properties
        "SymbolGenerator",
        "ProxyGenerator",
        "ReflectGenerator",
        "WellKnownPropertyLoadGenerator",
        "WellKnownPropertyStoreGenerator",

        // BigInt
        "BigIntGenerator",
        "BigIntMathGenerator",

        // Typed arrays / buffers / SAB / Atomics / Intl / Temporal
        "TypedArrayGenerator",
        "TypedArrayFromBufferGenerator",
        "TypedArrayLastIndexGenerator",
        "DataViewFromBufferGenerator",
        "ResizableArrayBufferGenerator",
        "ResizableBufferResizeGenerator",
        "GrowableSharedArrayBufferGenerator",
        "GrowableSharedBufferGrowGenerator",
        "AtomicsGenerator",
        "BuiltinIntlGenerator",
        "BuiltinTemporalGenerator",

        // Disposable objects / using
        "DisposableObjVariableGenerator",
        "AsyncDisposableObjVariableGenerator",
        "DisposableClassVariableGenerator",
        "AsyncDisposableClassVariableGenerator",

        // Other generators that are invalid or too new in Duktape 2.3
        "ImitationGenerator",
        "HexGenerator",
        "Base64Generator",
        "RegExpGenerator",
        "StringNormalizeGenerator",
        "PromiseGenerator",
        "EvalGenerator",
        "ThrowGenerator",

        // API-heavy generators that often target newer builtins
        "ApiMethodCallGenerator",
        "ApiFunctionCallGenerator",
    ],

    disabledMutators: [],

    //commented out builtins do not exist. do not uncomment
    additionalBuiltins: [
        // "CBOR.encode"               :  .function([.jsAnything] => .object()),
        // "CBOR.decode"               :  .function([.object()] => .object()),
        "Duktape.fin"               :  .function([.object(), .opt(.function())] => .undefined),
        "Duktape.act"               :  .function([.number] => .object()),
        "Duktape.gc"                :  .function([] => .undefined),
        "Duktape.compact"           :  .function([.object()] => .undefined),
        //"placeholder"               :  .function([] => .undefined),

    ],

    additionalObjectGroups: [],

    additionalEnumerations: [],

    optionalPostProcessor: nil
)
