class ShopBrokerNotice < Notice

  Required= Notice::Required + []

  attr_accessor :broker_profile

  def initialize(broker_profile, args = {})
    self.broker_profile = broker_profile
    args[:recipient] = broker_profile
    args[:market_kind]= 'shop'
    args[:notice] = PdfTemplates::BrokerNotice.new
    args[:to] = broker_profile.person.work_email_or_best
    args[:name] = broker_profile.person.full_name.titleize
    args[:recipient_document_store] = broker_profile
    self.header = "notices/shared/header_with_page_numbers.html.erb"
    super(args)
  end

  def deliver
    build
    generate_pdf_notice
    attach_envelope
    upload_and_send_secure_message
    send_generic_notice_alert
  end

  def build
    notice.first_name = broker_profile.first_name.titleize
    notice.last_name = broker_profile.last_name.titleize
    notice.primary_fullname = broker_profile.person.full_name.titleize
    notice.er_legal_name = broker_profile.employer_profile.legal_name.titleize
    notice.er_fullname = broker_profile.employer_profile.person.full_name.titleize
    notice.primary_identifier = broker_profile.hbx_id
    address = (broker_profile.person.mailing_address.present? ? broker_profile.person.mailing_address : broker_profile.address)
    append_primary_address(address)
    append_hbe
  end

  def append_hbe
    notice.hbe = PdfTemplates::Hbe.new({
      url: "www.dhs.dc.gov",
      phone: "(855) 532-5465",
      fax: "(855) 532-5465",
      email: "#{Settings.contact_center.email_address}",
      address: PdfTemplates::NoticeAddress.new({
        street_1: "100 K ST NE",
        street_2: "Suite 100",
        city: "Washington DC",
        state: "DC",
        zip: "20005"
      })
    })
  end

  def attach_envelope
    join_pdfs [notice_path, Rails.root.join('lib/pdf_templates', 'ma_envelope_without_address.pdf')]
  end

  def non_discrimination_attachment
    join_pdfs [notice_path, Rails.root.join('lib/pdf_templates', 'ma_shop_non_discrimination_attachment.pdf')]
  end

  def append_address(primary_address)
    notice.primary_address = PdfTemplates::NoticeAddress.new({
      street_1: primary_address.address_1.titleize,
      street_2: primary_address.address_2.titleize,
      city: primary_address.city.titleize,
      state: primary_address.state,
      zip: primary_address.zip
      })
  end
end
