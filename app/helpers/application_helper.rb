module ApplicationHelper
  def header(text)
    content_for(:header) { text.to_s }
  end

  def get_logo(subdomain)
    if subdomain == 'exams' || subdomain == 'videos'
      return { logo: 'rcc-logo', width: 50 }
    elsif subdomain == 'konale-exams' || subdomain == 'konale-videos'
      return { logo: 'konale-logo', width: 120 }
    end
    { logo: 'rcc-logo', width: 50 }
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
