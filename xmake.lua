-- xmake.lua

-- Dolga magyarul: 
-- Összegyűjti az összes cpp és cppm filet src alul.

set_project("MYGAME")

set_toolchains("clang")
set_languages("c++23")
set_policy("build.c++.modules", true)
add_rules("plugin.compile_commands.autoupdate", {outputdir = "build"})
add_requires("doctest")

target("bstd")
  set_kind("static")

  -- add_files("src/bstd/**/*.cpp")
  add_files("src/bstd/**.cppm", {public = true})
  remove_files("src/bstd/**/*-test.cpp")

target("bstd-tests")
  set_kind("binary")
  add_files("src/bstd/**/*-test.cpp")
  add_deps("bstd")
  add_packages("doctest")
  set_default(false)

target("mygame")
  
  set_kind("binary")
  -- add_files("src/mygame/**/*.cpp")
  add_files("src/mygame/*.cpp")
  add_deps("bstd")
