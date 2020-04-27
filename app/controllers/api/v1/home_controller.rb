# frozen_string_literal: true

class Api::V1::HomeController < Api::V1::ApiController

  def dashboard_data
    json_data = {
      'top_banners_data' => top_banners_data,
      'bottom_list_data' => []
    }
    render json: json_data, status: :ok
  end

  def top_banners_data
    [
      {
        img_url: 'https://rccpattern.com/assests/images/home-slider/RCC-Pattern_Motegaonkar_Sir_3.jpg',
        on_click: 'https://rccpattern.com' },
      {
        img_url: 'https://rccpattern.com/assests/images/home-slider/RCC-Pattern_Motegaonkar_Sir_6.jpg',
        on_click: nil },
      {
        img_url: 'https://static01.nyt.com/images/2020/04/12/magazine/12Ethicist/12Ethicist-superJumbo.jpg',
        on_click: 'https://www.youtube.com/watch?v=Hp0yIgdRf4Q' }
    ]
  end

  def gallery
    json_data = [
      {
        img_url: 'https://rccpattern.com/assests/images/home-slider/RCC-Pattern_Motegaonkar_Sir_3.jpg',
      },
      {
        img_url: 'https://rccpattern.com/assests/images/home-slider/RCC-Pattern_Motegaonkar_Sir_6.jpg',
      },
      {
        img_url: 'https://static01.nyt.com/images/2020/04/12/magazine/12Ethicist/12Ethicist-superJumbo.jpg',
      }
    ]
    render json: json_data, status: :ok
  end

  def app_version
    render json: { version: 10, force_update: true }, status: :ok
  end
end