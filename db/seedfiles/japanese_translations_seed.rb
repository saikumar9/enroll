puts "*"*80
puts "::: Generating Japanese Translations :::"

Translation.where(key: "ja.layouts.application_brand.call_customer_service").first_or_create.update_attributes!(value: '"お客様サービスへ電話する"')
Translation.where(key: "ja.layouts.application_brand.help").first_or_create.update_attributes!(value: '"ヘルプ"')
Translation.where(key: "ja.layouts.application_brand.logout").first_or_create.update_attributes!(value: '"ログアウト"')
Translation.where(key: "ja.layouts.application_brand.my_id").first_or_create.update_attributes!(value: '"私のID"')
Translation.where(key: "ja.shared.my_portal_links.my_insured_portal").first_or_create.update_attributes!(value: '"保険契約者用ポータル"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.alerts_link").first_or_create.update_attributes!(value: '"Jump to the alerts section of this page"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.badges_link").first_or_create.update_attributes!(value: '"Jump to the badges section of this page"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.buttons_link").first_or_create.update_attributes!(value: '"Jump to the buttons section of this page"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.carousels_link").first_or_create.update_attributes!(value: '"Jump to the carousels section of this page"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.inputs_link").first_or_create.update_attributes!(value: '"Jump to the inputs section of this page"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.navigation_link").first_or_create.update_attributes!(value: '"Jump to the navigation section of this page"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.pagination_link").first_or_create.update_attributes!(value: '"Jump to the pagination section of this page"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.panels_link").first_or_create.update_attributes!(value: '"Jump to the panels section of this page"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.progressbars_link").first_or_create.update_attributes!(value: '"Jump to the progress bars section of this page"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.tables_link").first_or_create.update_attributes!(value: '"Jump to the tables section of this page"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.tooltips_link").first_or_create.update_attributes!(value: '"Jump to the tooltips section of this page"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.typography").first_or_create.update_attributes!(value: '"タイポグラフィ"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.typography_link").first_or_create.update_attributes!(value: '"Jump to the typography section of this page"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.wells_link").first_or_create.update_attributes!(value: '"Jump to the wells section of this page"')
Translation.where(key: "ja.welcome.index.assisted_consumer_family_portal").first_or_create.update_attributes!(value: '"要支援顧客/家族用ポータル"')
Translation.where(key: "ja.welcome.index.broker_agency_portal").first_or_create.update_attributes!(value: '"ブローカーエージェンシー用ポータル"')
Translation.where(key: "ja.welcome.index.broker_registration").first_or_create.update_attributes!(value: '"ブローカー登録"')
Translation.where(key: "ja.welcome.index.byline").first_or_create.update_attributes!(value: '"あなたにとってベストなプランが見つかる場所"')
Translation.where(key: "ja.welcome.index.consumer_family_portal").first_or_create.update_attributes!(value: '"顧客/家族用ポータル"')
Translation.where(key: "ja.welcome.index.employee_portal").first_or_create.update_attributes!(value: '"社員用ポータル"')
Translation.where(key: "ja.welcome.index.employer_portal").first_or_create.update_attributes!(value: '"雇用者用ポータル"')
Translation.where(key: "ja.welcome.index.general_agency_portal").first_or_create.update_attributes!(value: '"一般エージェンシー用ポータル"')
Translation.where(key: "ja.welcome.index.general_agency_registration").first_or_create.update_attributes!(value: '"一般エージェンシー登録"')
Translation.where(key: "ja.welcome.index.hbx_portal").first_or_create.update_attributes!(value: '"HBXポータル"')
Translation.where(key: "ja.welcome.index.logout").first_or_create.update_attributes!(value: '"ログアウト"')
Translation.where(key: "ja.welcome.index.returning_user").first_or_create.update_attributes!(value: '"復帰ユーザ"')
Translation.where(key: "ja.welcome.index.sign_out").first_or_create.update_attributes!(value: '"サインアウト"')
Translation.where(key: "ja.welcome.index.signed_in_as").first_or_create.update_attributes!(value: '"%{current_user} のアカウントでサインインしています"')
Translation.where(key: "ja.welcome.index.welcome_email").first_or_create.update_attributes!(value: '"%{current_user} へようこそ"')
Translation.where(key: "ja.welcome.index.welcome_to_site_name").first_or_create.update_attributes!(value: '"%{short_name} へようこそ"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.headings").first_or_create.update_attributes!(value: '"Headings"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.heading_1").first_or_create.update_attributes!(value: '"Heading 1"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.heading_2").first_or_create.update_attributes!(value: '"Heading 2"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.heading_3").first_or_create.update_attributes!(value: '"Heading 3"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.heading_4").first_or_create.update_attributes!(value: '"Heading 4"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.heading_5").first_or_create.update_attributes!(value: '"Heading 5"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.heading_6").first_or_create.update_attributes!(value: '"Heading 6"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.body_copy").first_or_create.update_attributes!(value: '"Body コピー"')
Translation.where(key: "ja.uis.bootstrap3_examples.index.body_copy_text").first_or_create.update_attributes!(value: '"大きくは単節条虫亜綱と多節条虫亜綱に分けられる。一般にサナダムシとしてイメージするのは後者である。単節条虫亜綱のものは節に分かれない扁平な体で、先端に吸盤などを持つ。多節条虫亜綱のものは、頭部とそれに続く片節からなる。頭部の先端はやや膨らみ、ここに吸盤や鉤など、宿主に固着するための構造が発達する。それに続く片節は、それぞれに生殖器が含まれており、当節から分裂によって形成され、成熟すると切り離される。これは一見では体節に見えるが、実際にはそれぞれの片節が個体であると見るのが正しく、分裂した個体がつながったまま成長し、成熟するにつれて離れてゆくのである。そのため、これをストロビラともいう。長く切り離されずに10mにも達するものもあれば、常に数節のみからなる数mm程度の種もある。切り離された片節は消化管に寄生するものであれば糞と共に排出され、体外で卵が孵化するものが多い。"')

puts "::: Japanese Translations Complete :::"
puts "*"*80
