class ShopEmployerNotices::ZeroEmployeesOnRoster < ShopEmployerNotice

   def deliver
    build
    append_data
    generate_pdf_notice
    employer_appeal_rights_attachment
    attach_envelope
    non_discrimination_attachment
    upload_and_send_secure_message
    send_generic_notice_alert
  end

  def append_data
    plan_year = employer_profile.show_plan_year
    notice.plan_year = PdfTemplates::PlanYear.new({
          :open_enrollment_end_on => plan_year.open_enrollment_end_on,
        })
    #binder payment deadline
    notice.plan_year.binder_payment_due_date = PlanYear.calculate_open_enrollment_date(plan_year.start_on)[:binder_payment_due_date]
  end

end