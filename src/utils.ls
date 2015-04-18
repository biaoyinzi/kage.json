require! {
  'prelude-ls': { map }
  './kage2json': { parse }
}

parseLine = (line) ->
  [ id, related, data ] = line.split '|' |> map (.trim!)
  { id, related, data: parse data }

module.exports = { parseLine }
