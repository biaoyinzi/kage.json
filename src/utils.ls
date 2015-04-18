require! {
  'prelude-ls': { map }
  './kage2json': { parse }
}

parseLine = (line) ->
  [ id, related, data ] = line.split '|' |> map (.trim!)
  { id, related, raw: data, data: parse data }

module.exports = { parseLine }
