require! {
  fs
  jsdom
  hilbert: {Hilbert2d}
  xmlserializer
}

error, window <- jsdom.env '' <[node_modules/snapsvg/dist/snap.svg.js]>
throw error if error

{Snap, document} = window

hilbert = new Hilbert2d 256

paper = Snap 128 * 30, 128 * 30

path-string = ''

for code-point from 0 til 128 * 128
  {x, y} = hilbert.xy code-point
  text = paper.text x * 30 + 15, y * 30 + 25, String.from-code-point code-point
  text.attr do
    text-anchor: \middle
    font-size: \26px

  if path-string.length is 0
    path-string += "M #{x * 30 + 15} #{y * 30 + 15} "
  else
    path-string += "L #{x * 30 + 15} #{y * 30 + 15} "

path = paper.path path-string
path.attr do
  fill: 'none'
  stroke: 'red'
  stroke-opacity: 0.3
  stroke-width: 3
path.prepend-to paper

fs.write-file 'test.svg' xmlserializer.serialize-to-string paper.node

window.close!
