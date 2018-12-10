require "squib"

# This sample demonstrates the built-in layouts for Squib.
# Each card demonstrates a different built-in layout.
Squib::Deck.new(cards: 16, layout: 'layouts/front.yml', width: 744, height: 1039) do
  background color: 'white'

  set font: 'Times New Roman,Serif 10.5'
  hint text: '#333' # show extents of text boxes to demo the layout

  text str: 'fantasy.yml', layout: :title
  text str: 'ur',          layout: :upper_right
  text str: 'art',         layout: :art
  text str: 'type',        layout: :type
  text str: 'tr',          layout: :type_right
  text str: 'description', layout: :description
  text str: 'lr',          layout: :lower_right
  text str: 'll',          layout: :lower_left
  text str: 'credits',     layout: :copy

  rect layout: :safe
  rect layout: :cut
  save_pdf prefix: 'layouts_builtin_fantasy_', sprue: 'sprues/sprue.yml'
end
