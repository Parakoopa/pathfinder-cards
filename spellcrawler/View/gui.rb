require 'flammarion'

f = Flammarion::Engraving.new
f.orientation = :horizontal

f.dropdown(%w(Alchemist Antipaladin Barde Druide Hexe Hexenmeister Inquisitor Kampfmagus Magier Kleriker Mystiker Paktmagier Paladin Waldläufer Blutwüter Schamane Jäger)) do |msg|
  f.subpane('possible_schools_pane').clear; f.subpane('possible_schools_pane').input('Mögliche Schulen', {value: msg['text']})
end

f.puts "Welche Zaubergrade willst du?"
recipient = f.subpane("grad").input("Zaubergrad ( 1-9 / 1,2,5-9 / 3)")
f.puts "Welche Informationen willst du auf der Karte?"
name = f.checkbox('Name')
grad = f.checkbox('grad')
schule = f.checkbox('schule')
unterschule = f.checkbox('unterschule')
kategorie = f.checkbox('kategorie')
beschreibung = f.checkbox('beschreibung')
zeitaufwand = f.checkbox('zeitaufwand')
komponenten = f.checkbox('komponenten')
reichweite = f.checkbox('reichweite')
effekt = f.checkbox('effekt')
wirkungsdauer = f.checkbox('wirkungsdauer')
rettungswurf = f.checkbox('rettungswurf')
zauberresistenz = f.checkbox('zauberresistenz')
f.puts "Mögliche Schulen"
possible_schools = f.subpane('possible_schools_pane').input('Mögliche Schulen')

f.wait_until_closed
