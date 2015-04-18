#!/usr/bin/env lsc
require! {
  'fs'
  'path'
  'split'
  '../../src/utils': { parseLine }
}

const config = {
  rootPath: path.resolve __dirname, '../../'
}

glyph-count = 0
count = 0
#table = {}

jsonPath = path.resolve config.rootPath, 'json'
if not fs.existsSync jsonPath
  fs.mkdirSync jsonPath

fs.createReadStream path.resolve config.rootPath, 'data', 'dump_newest_only.txt'
  .pipe split!
  .on \data (line) ->
    if line is /.*name.*related.*data/ then return

    if line is /^[-+]+$/
      count := 0
      return

    if line is /\((\d+) 行\)/
      total = +RegExp.$1
      if total isnt count
        throw new Error "glyph number mismatched: #count/#total"
      return console.log \done

    { id }:glyph = parseLine line

    if not id then return

    filePath = path.resolve config.rootPath, 'json', "#id.json"
    fs.exists filePath, (exists) ->
      if not exists
        fs.writeFile do
          filePath
          JSON.stringify glyph,, 2

    ++count
