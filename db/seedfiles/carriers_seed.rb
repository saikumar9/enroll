puts "*"*80
puts "::: Generating MA Carriers:::"

hbx_office = OfficeLocation.new(
    is_primary: true,
    address: {kind: "work", address_1: "address_placeholder", address_2: "address_2", city: "City", state: "St", zip: "10001" },
    phone: {kind: "main", area_code: "111", number: "111-1111"}
  )

org = Organization.new(fein: "050513223", legal_name: "Altus", office_locations: [hbx_office])
cp = org.create_carrier_profile(id: "53e67210eb899a4603000021", abbrev: "ALT", hbx_carrier_id: 20001, ivl_health: false, ivl_dental: false, shop_health: true, shop_dental: true)

org = Organization.new(fein: "041045815", legal_name: "Blue Cross Blue Shield MA", office_locations: [hbx_office])
cp = org.create_carrier_profile(id: "53e67210eb899a4603000025", abbrev: "BCBS", hbx_carrier_id: 20002, ivl_health: false, ivl_dental: false, shop_health: true, shop_dental: true)

org = Organization.new(fein: "043373331", legal_name: "Boston Medical Center Health Plan", office_locations: [hbx_office])
cp = org.create_carrier_profile(id: "53e67210eb899a4603000029", abbrev: "BMCHP", hbx_carrier_id: 20003, ivl_health: false, ivl_dental: false, shop_health: true, shop_dental: true)

org = Organization.new(fein: "046143185", legal_name: "Delta", office_locations: [hbx_office])
cp = org.create_carrier_profile(id: "53e67210eb899a4603000033", abbrev: "DDA", hbx_carrier_id: 20004, ivl_health: false, ivl_dental: false, shop_health: true, shop_dental: true)

org = Organization.new(fein: "237442369", legal_name: "FCHP", office_locations: [hbx_office])
cp = org.create_carrier_profile(id: "53e67210eb899a4603000037", abbrev: "FCHP", hbx_carrier_id: 20005, ivl_health: false, ivl_dental: false, shop_health: true, shop_dental: true)

org = Organization.new(fein: "135123390", legal_name: "Guardian", office_locations: [hbx_office])
cp = org.create_carrier_profile(id: "53e67210eb899a4603000041", abbrev: "GUARD", hbx_carrier_id: 20006, ivl_health: false, ivl_dental: false, shop_health: true, shop_dental: true)

org = Organization.new(fein: "042864973", legal_name: "Health New England", office_locations: [hbx_office])
cp = org.create_carrier_profile(id: "53e67210eb899a4603000045", abbrev: "HNE", hbx_carrier_id: 20007, ivl_health: false, ivl_dental: false, shop_health: true, shop_dental: true)

org = Organization.new(fein: "042452600", legal_name: "Harvard Pilgrim Health Care", office_locations: [hbx_office])
cp = org.create_carrier_profile(id: "53e67210eb899a4603000049", abbrev: "HPHC", hbx_carrier_id: 20008, ivl_health: false, ivl_dental: false, shop_health: true, shop_dental: true)

org = Organization.new(fein: "453596033", legal_name: "Minuteman Health", office_locations: [hbx_office])
cp = org.create_carrier_profile(id: "53e67210eb899a4603000053", abbrev: "MHI", hbx_carrier_id: 20009, ivl_health: false, ivl_dental: false, shop_health: true, shop_dental: true)

org = Organization.new(fein: "234547586", legal_name: "Neighborhood Health Plan", office_locations: [hbx_office])
cp = org.create_carrier_profile(id: "53e67210eb899a4603000057", abbrev: "NHP", hbx_carrier_id: 20010, ivl_health: false, ivl_dental: false, shop_health: true, shop_dental: true)

org = Organization.new(fein: "800721489", legal_name: "Tufts Health Plan Direct", office_locations: [hbx_office])
cp = org.create_carrier_profile(id: "53e67210eb899a4603000061", abbrev: "THPD", hbx_carrier_id: 20011, ivl_health: false, ivl_dental: false, shop_health: true, shop_dental: true)

org = Organization.new(fein: "042674079", legal_name: "Tufts Health Plan Premier", office_locations: [hbx_office])
cp = org.create_carrier_profile(id: "53e67210eb899a4603000065", abbrev: "THPP", hbx_carrier_id: 20012, ivl_health: false, ivl_dental: false, shop_health: true, shop_dental: true)

org = Organization.new(fein: "562592010", legal_name: "Commonwealth Health Insurance Connector Authority", office_locations: [hbx_office])
cp = org.create_carrier_profile(id: "53e67210eb899a4603000069", abbrev: "CCA", hbx_carrier_id: 20013, ivl_health: false, ivl_dental: false, shop_health: true, shop_dental: true)

puts "::: Generated MA Carriers :::"
puts "*"*80
