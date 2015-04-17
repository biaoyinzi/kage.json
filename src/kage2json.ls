#!/usr/bin/env lsc
require! {
}

running-as-script = not module.parent

const stroke-type = do
  '99': 'link'
  '1': 'line'
  '2': 'curve'
  '3': 'bend-line'
  '4': 'OTSU'
  '6': 'complex-curve'
  '7': 'vert-slash'
const head-type = do
  '0': 'free'
  '2': 'horiz-connect'
  '32': 'vert-connect'
  '12': 'left-top-corner'
  '22': 'right-top-corner'
  '7': 'narrow-for-dot'
const tail-type = do
  '1': do # line
    '0': 'free'
    '2': 'horiz-connect'
    '32': 'vert-connect'
    '13': 'left-bottom-corner'
    '23': 'right-bottom-corner'
    '4': 'hook-left'
    '313': 'left-bottom-GT' # XXX: what is a G/T?
  '2': do # curve
    '7': 'slash-left'
    '0': 'slash-right'
    '8': 'stop-for-dot'
    '4': 'hook-left'
    '5': 'hook-right'
  '3': do # bend-line
    '0': 'free'
    '5': 'hook-up'
  '4': do # OTSU
    '0': 'free'
    '5': 'hook-up'
  '6': do # complex curve
    '7': 'slash-left'
    '0': 'slash-right'
    '8': 'stop-for-dot'
    '4': 'hook-left'
    '5': 'hook-right'
  '7': do # vert slash
    '7': 'slash-left'

parser = ->
  parts = it.split /\$|\s/
  body = []
  for part in parts
    [type, head, tail, x0, y0, x1, y1, x2, y2, x3, y3] = part.split ':'
    console.log typeof type
    switch +type
    | 99
      body.push do
        type: stroke-type[type] or "unknown: #type"
        src: x2
        leftTop:
          x: +x0, y: +y0
        rightBottom:
          x: +x1, y: +y1
    | 1 # strait-line
      body.push do
        type: stroke-type[type]     or "unknown: #type"
        head: head-type[head]       or "unknown: #head"
        tail: tail-type[type][tail] or "unknown: #tail"
        control-points:
          * x: +x0, y: +y0
          * x: +x1, y: +y1
    | 2, 3, 4 # curve, bend-line, OTSU
      body.push do
        type: stroke-type[type]     or "unknown: #type"
        head: head-type[head]       or "unknown: #head"
        tail: tail-type[type][tail] or "unknown: #tail"
        control-points:
          * x: +x0, y: +y0
          * x: +x1, y: +y1
          * x: +x2, y: +y2
    | 6, 7 # complex-curve, vert-slash
      body.push do
        type: stroke-type[type]     or "unknown: #type"
        head: head-type[head]       or "unknown: #head"
        tail: tail-type[type][tail] or "unknown: #tail"
        control-points:
          * x: +x0, y: +y0
          * x: +x1, y: +y1
          * x: +x2, y: +y2
          * x: +x3, y: +y3
    | otherwise
      # ignore anything else
  return body

if running-as-script
  chars = ''
  process.stdin
    ..setEncoding \utf8
    ..on \data -> chars += it
    ..on \end  -> console.log JSON.stringify(parser(chars), null, 2)
else
  module.exports = { parser }
