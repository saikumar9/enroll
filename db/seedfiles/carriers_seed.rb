puts "*"*80
puts "::: Generating MA Carriers:::"

hbx_office = OfficeLocation.new(
    is_primary: true,
    address: {kind: "work", address_1: "address_placeholder", address_2: "609 H St, Room 415", city: "Washington", state: "DC", zip: "20002" },
    phone: {kind: "main", area_code: "202", number: "555-1212"}
  )

org = Organization.new(office_locations: [hbx_office], fein: "011000000", legal_name: "BMC Health Net")
cp = org.create_carrier_profile(id: "53e67210eb899a4603000020", abbrev: "BMCHP", hbx_carrier_id: nil, ivl_health: false, ivl_dental: false, shop_health: true, shop_dental: true)

org = Organization.new(office_locations: [hbx_office], fein: "021000000", legal_name: "Fallon Health")
cp = org.create_carrier_profile(id: "53e67210eb899a4603000023", abbrev: "FCHP", hbx_carrier_id: nil, ivl_health: false, ivl_dental: false, shop_health: true, shop_dental: true)

org = Organization.new(office_locations: [hbx_office], fein: "031000000", legal_name: "Health New England")
cp = org.create_carrier_profile(id: "53e67210eb899a4603000026", abbrev: "HNE", hbx_carrier_id: nil, ivl_health: false, ivl_dental: false, shop_health: true, shop_dental: true)

org = Organization.new(office_locations: [hbx_office], fein: "041000000", legal_name: "MinuteMan")
cp = org.create_carrier_profile(id: "53e67210eb899a4603000029", abbrev: "MNI", hbx_carrier_id: nil, ivl_health: false, ivl_dental: false, shop_health: true, shop_dental: true)


puts "::: Generated MA Carriers :: #{} :::"
puts "*"*80
