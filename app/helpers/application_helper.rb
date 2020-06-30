module ApplicationHelper
  def header(text)
    content_for(:header) { text.to_s }
  end

  def full_domain_path
    'https://' + request.host_with_port
  end

  def get_logo(subdomain)
    if %w[exams videos].include? subdomain
      return { logo: 'rcc-logo', width: 50 }
    elsif %w[konale-exams konale-videos].include? subdomain
      return { logo: 'konale-logo', width: 120 }
    elsif %w[dhote-exams dhote-videos].include? subdomain
      return { logo: 'dhote-logo', width: 120 }
    elsif %w[saraswati-exams saraswati-videos].include? subdomain
      return { logo: 'saraswati-logo', width: 120 }
    elsif %w[adhyayan-exams adhyayan-videos].include?(subdomain)
      return { logo: 'adhyayan-logo', width: 150}
    elsif %w[dayanand].include?(subdomain)
      return { logo: 'dayanand-logo', width: 30}
    elsif %w[pis].include? subdomain
      return { logo: 'ankush-logo', width: 45, height: 40 }
    elsif %w[bhosale].include? subdomain
      return { logo: 'bhosale-logo', width: 90, height: 40}
    elsif %w[jnc-science-clg].include? subdomain
      return { logo: 'jnc-logo', width: 90, height: 40}
    end

    { logo: 'exams-logo', width: 30 }
  end

  def get_header_name(subdomain)
    return if ['saraswati-exams', 'saraswati-videos'].include? subdomain

    if subdomain == 'dhote-exams' || subdomain == 'dhote-videos'
      return request.subdomain.split('-').last.humanize
    end

    if subdomain == 'saraswati-exams' || subdomain == 'saraswati-videos'
      return request.subdomain.split('-').last.humanize
    end

    if %w[adhyayan-exams adhyayan-videos].include?(subdomain)
      return ''
    end

    return 'DSCL' if %w[dayanand].include?(subdomain)
    return '' if %w[bhosale].include?(subdomain)

    return 'PIS, Jalna' if ['pis'].include? subdomain

    request.subdomain.humanize || "Exams"
  end

	def distance_of_time_in_hours_and_minutes(from_time, to_time)
	  from_time = from_time.to_time if from_time.respond_to?(:to_time)
	  to_time = to_time.to_time if to_time.respond_to?(:to_time)
	  distance_in_hours   = (((to_time - from_time).abs) / 3600).round
	  distance_in_minutes = ((((to_time - from_time).abs) % 3600) / 60).round

	  difference_in_words = ''

	  difference_in_words << "#{distance_in_hours} #{distance_in_hours > 1 ? 'hours' : 'hour' } and " if distance_in_hours > 0
	  difference_in_words << "#{distance_in_minutes} #{distance_in_minutes == 1 ? 'minute' : 'minutes' }"
  end

  def get_vl_row_class(subject)
    return "table-warning" if subject == 'chem'
    return "table-success" if subject == 'phy'
    return "table-danger" if subject == 'bio'
    return "table-primary" if subject == 'maths'
  end

  def delete_button_to(title, url, options = {})
    html_options = {
      class: "delete_button_to",
      method: "delete"
    }.merge(options.delete(:html_options) || {})

    form_for :delete, url: url, html: html_options do |f|
      f.submit title, options
    end
  end
end
