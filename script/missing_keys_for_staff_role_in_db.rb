
# These are the hbx ids of people who has some keys missing in database under "Employer Staff Role"

hbxs = ["153774", "1859673", "167667", "170960", "232476", "233794", "237198", "18769185", "18828320", "18837686", "c66fa4921af74e09bd677eacdf2ff748", "d0a1e03c56c84f27be3b2b2a458a0178", "18940885", "18941222", "18941512", "18941513", "18941655", "18941679", "18941833", "18942460", "18942650", "18942716", "19743317", "19743409", "19743489", "19743594", "19743658", "19743708", "19743970", "19744019", "19744105", "19744278", "19744484", "19744776", "19745031", "19745118", "19746039", "19746211", "19747012", "19747719", "19747741", "19747932", "19752399", "19752943", "19753288", "19753532", "19754292", "19754607", "19755338", "19755697", "19755714", "19756546", "19756662", "19756747", "19756851", "19757265", "19757448", "19757494", "19758705", "19758797", "19758829", "19759103", "19759122", "19759390", "19759503", "19759512", "19759744", "19759975", "19760439", "19760460", "19760601", "19760668", "19760748", "19760770", "19761037", "19761356", "19761784", "19762342", "19762518", "19762826", "19763690", "19763904", "19764127", "19764242", "19764833", "19764878", "19765235", "19766753", "19773740", "19767515", "19767868", "19768123", "19768274", "19768594", "19768755", "19768824", "19768844", "19769094", "19769612", "19770063", "19770212", "19770775", "19771012", "19771119", "19771536", "19771636", "19771694", "19771763", "19771779", "19772652", "19772790", "19773861", "19773936", "19774001", "19774250", "19774603", "19774837", "19774850", "19775247", "19775997", "19777061", "19777189", "19777388", "19777409", "19777433", "19777907", "19778357", "19778905", "19779064", "19779662", "19780184", "19780609", "19780741", "19781333", "19781588", "19781931", "19781958", "19782165", "19782338", "19783047", "19783145", "19783153", "19783582", "19783944", "19784187", "19784754", "19784935", "19785089", "19785318", "19785419", "19785499", "19785756", "19785789", "19786009", "19786660", "19787341", "19787690", "19787937", "19787938", "19787941", "19787944", "19787945", "19788145", "19790186", "19790188", "19790190", "19790197", "19790204", "19790207", "19790208", "19794439", "19799218", "19799381", "19799383", "19799393", "19808304", "19808325", "19814421", "19818861", "19818888", "19820959", "19829187", "19829314", "19829326", "19829367", "19834603", "19842446", "19842449", "19842479", "19842484", "19842528", "19842589", "19842605", "19842635", "19842659", "19842693", "19842757", "19842783", "19842800", "19842835", "19842882", "19842900", "19842997", "19843061", "19843159", "19843210", "19843241", "19843260", "19843338", "19843346", "19843430", "19843450", "19843566", "19844050", "19850558", "19872649", "19873507", "19877065", "19877531", "19877587", "19877588", "19877612", "19877630", "19891644", "19895754", "19895773", "19895799", "19895828", "19895847", "19905026", "19905035", "19905047", "19905081", "19915440", "19915569", "19922579", "19922622", "19922650", "19922683", "19922737", "19922779", "19922793", "19922798", "19932924"]

puts "**********    Processing #{hbxs.size} records **********************"

hbxs.each do |hbx_id|
  people = Person.where(hbx_id: hbx_id)

  if people.size != 1
    puts "No or More than 1 person found for #{hbx_id}"
    next
  end

  # This will re-push the keys to db
  people.first.save
end

puts "******** Finished ***********"