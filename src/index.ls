require! {
  'fs'
  'split'
  'prelude-ls': { map }
  './kage2json': { parser }
}

glyph-count = 0
count = 0
table = {}

fs.createReadStream '../data/dump_newest_only.txt'
  .pipe split!
  .on \data (line) ->
    return if line is /.*name.*related.*data/
    return if line is /^[-+]+$/

    if line is /\((\d+) 行\)/
      total = +RegExp.$1
      if total isnt count
        throw new Error "glyph number mismatched: #count/#total"
      return

    [name, related, data] = line.split '|' |> map (.trim!)
    table[name] = { related } <<< data: parser data

    console.log name, JSON.stringify table[name],, 2

    ++count
