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
    elsif %w[demo].include? subdomain
      return { logo: 'edu-circle-logo', height: 40}
    elsif %w[dep].include? subdomain
      return { logo: 'dep-logo', height: 40}
    elsif %w[bep].include? subdomain
      return { logo: 'bep-logo', height: 40}
    elsif %w[chate].include? subdomain
      return { logo: 'chate', height: 50}
    elsif %w[jmc].include? subdomain
      return { logo: 'joshi-logo', height: 50}
    elsif %w[vaa].include? subdomain
      return { logo: 'vaa-logo', height: 50}
    elsif %w[bansalclasses].include? subdomain
      return { logo: 'bansal-logo', height: 50}
    elsif %w[annapurnaacademy].include? subdomain
      return { logo: 'anna-logo', height: 50}
    elsif %w[sstl].include? subdomain
      return { logo: 'sstl-logo', height: 50}
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

    if %w[adhyayan-exams adhyayan-videos annapurnaacademy].include?(subdomain)
      return ''
    end

    return 'DSCL' if %w[dayanand].include?(subdomain)
    return '' if %w[bhosale].include?(subdomain)

    return 'PIS, Jalna' if ['pis'].include? subdomain

    return 'Infinity, Akola' if ['infinity'].include? subdomain

    return 'Bhargav Career Academy' if ['bhargav'].include? subdomain

    return 'Chate digiEdu' if ['chate'].include? subdomain

    return 'Vidya Aradhana Academy, Latur.' if ['vaa'].include? subdomain

    return 'Shahu Screening Test' if ['sstl'].include? subdomain
    return '' if ['jmc'].include? subdomain
    return '' if ['bansalclasses'].include? subdomain

    request.subdomain.humanize || "Exams"
  end

	def distance_of_time_in_hours_and_minutes(secs)
    [[60, :seconds], [60, :minutes], [24, :hours], [Float::INFINITY, :days]].map{ |count, name|
      if secs > 0
        secs, n = secs.divmod(count)

        "#{n.to_i} #{name}" unless n.to_i==0
      end
    }.compact.reverse.join(' ')
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
