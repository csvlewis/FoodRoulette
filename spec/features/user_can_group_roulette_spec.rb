# frozen_string_literal: true

require 'rails_helper'

describe 'As a user' do
  describe 'when I visit the root page and click \'Survey them!\'' do
    it 'I see a list of 3 restaurants that I can send to my friends', :vcr do
      user = create(:user)
      allow_any_instance_of(ApplicationController)
        .to receive(:current_user).and_return(user)

      visit '/'

      set_location('Denver, CO')

      click_button 'Survey them!'

      expect(current_path).to eq(group_roulette_path)
      expect(page).to have_content('Address:', count: 3)

      click_button 'Roulette Again'

      expect(current_path).to eq(group_roulette_path)

      expect(page).to have_button('Send to Friends')
    end
  end
end
