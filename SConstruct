#!python
import os

opts = Variables([], ARGUMENTS)

# Gets the standard flags CC, CCX, etc.
env = DefaultEnvironment()

# Define our options
opts.Add(
    EnumVariable(
        "target", "Compilation target", "debug", ["d", "debug", "r", "release"]
    )
)
opts.Add(
    EnumVariable(
        "platform", "Compilation platform", "", ["", "windows", "x11", "linux", "osx"]
    )
)
opts.Add(
    EnumVariable(
        "p",
        "Compilation target, alias for 'platform'",
        "",
        ["", "windows", "x11", "linux", "osx"],
    )
)
opts.Add(BoolVariable("use_llvm", "Use the LLVM / Clang compiler", "no"))
opts.Add(PathVariable("target_path", "The path where the lib is installed.", "bin/"))
opts.Add(
    PathVariable("target_name", "The library name.", "libgdai", PathVariable.PathAccept)
)

# Local dependency paths, adapt them to your setup
godot_headers_path = "godot-cpp/godot-headers/"
cpp_bindings_path = "godot-cpp/"
cpp_library = "libgodot-cpp"

# only support 64 at this time..
bits = 64

# Updates the environment with the option variables.
opts.Update(env)

# Process some arguments
if env["use_llvm"]:
    env["CC"] = "clang"
    env["CXX"] = "clang++"

if env["p"] != "":
    env["platform"] = env["p"]

if env["platform"] == "":
    print("No valid target platform selected.")
    quit()

# For the reference:
# - CCFLAGS are compilation flags shared between C and C++
# - CFLAGS are for C-specific compilation flags
# - CXXFLAGS are for C++-specific compilation flags
# - CPPFLAGS are for pre-processor flags
# - CPPDEFINES are for pre-processor defines
# - LINKFLAGS are for linking flags

env["target_path"] += ""
cpp_library += ".linux"
env.Append(CCFLAGS=["-fPIC"])
env.Append(
    CXXFLAGS=[
        "-std=c++17",
    ]
)
env.Append(LINKFLAGS=["-ltensorflow_cc", "-ltensorflow_framework"])
if env["target"] in ("debug", "d"):
    env.Append(CCFLAGS=["-g3", "-Og"])
else:
    env.Append(CCFLAGS=["-g", "-O3"])

if env["target"] in ("debug", "d"):
    cpp_library += ".debug"
else:
    cpp_library += ".release"

cpp_library += "." + str(bits)

# make sure our binding library is properly includes
env.Append(
    CPPPATH=[
        ".",
        godot_headers_path,
        cpp_bindings_path + "include/",
        cpp_bindings_path + "include/core/",
        cpp_bindings_path + "include/gen/",
        "/usr/include/tensorflow",
    ]
)
env.Append(LIBPATH=[cpp_bindings_path + "bin/"])
env.Append(LIBS=[cpp_library])

# tweak this if you want to use different folders, or more folders, to
# store your source code in.
env.Append(CPPPATH=["src/"])
sources = Glob("src/ai/*.cpp")

library = env.SharedLibrary(
    target=env["target_path"] + env["target_name"], source=sources
)

Default(library)

# Generates help for the -h scons option.
Help(opts.GenerateHelpText(env))
