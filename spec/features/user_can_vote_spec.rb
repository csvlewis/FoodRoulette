require 'rails_helper'

describe "As a user" do
  context "After I complete the survey data form and send survey" do
    before :each do
      @user = create(:user)
      @survey1 = create(:survey, user: @user)
      @restaurant1 = create(:restaurant)
      @restaurant2 = create(:restaurant)
      @restaurant3 = create(:restaurant)
      @sr1 = create(:survey_restaurant, survey: @survey1, restaurant: @restaurant1)
      @sr2 = create(:survey_restaurant, survey: @survey1, restaurant: @restaurant2)
      @sr3 = create(:survey_restaurant, survey: @survey1, restaurant: @restaurant3)
      @phone_number1 = create(:phone_number, digits: "+12223334444", survey: @survey1)
      @phone_number2 = create(:phone_number, digits: "+13334445555", survey: @survey1)
      @phone_number3 = create(:phone_number, digits: "+14445556666", survey: @survey1)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      url = "https://api.yelp.com/v3/businesses/search?categories=restaurants&limit=50&location=Denver,%20CO&open_now=true&price=1,2&radius=8000"
      filename = "survey_random_roulette_response.json"
      stub_get_json(url, filename)
    end

    context 'As the user creator' do
      it "I see a voting page with the correct options" do
        visit vote_path(@survey1)

        expect(current_path).to eq(vote_path(@survey1))

        expect(page).to have_content("Vote for your choice!")

        expect(page).to have_content("#{@restaurant1.name}")
        expect(page).to have_content("#{@restaurant2.name}")
        expect(page).to have_content("#{@restaurant3.name}")

        expect(page).to have_css('.survey-restaurant', count: 3)

        within(".survey-restaurant-#{@sr1.id}") do
          expect(page).to have_content("#{@restaurant1.name}")

          expect(page).to have_button('Vote for this')
        end

        expect(page).to have_button('Cancel Survey')
      end

      it "I can vote for my choice" do
        visit vote_path(@survey1)

        expect(Vote.count).to eq(0)

        expect(current_path).to eq(vote_path(@survey1))

        within(".survey-restaurant-#{@sr1.id}") do
          expect(page).to have_content("#{@restaurant1.name}")

          expect(page).to have_button('Vote for this')

          click_button('Vote for this')
        end

        expect(Vote.count).to eq(1)
        expect(Vote.last.survey_restaurant).to eq(@sr1)

        expect(current_path).to eq(survey_path(@survey1))

        expect(page).to have_content("Your vote has been cast")
      end

      it "I can't vote twice" do
        visit vote_path(@survey1)

        expect(Vote.count).to eq(0)

        expect(current_path).to eq(vote_path(@survey1))

        within(".survey-restaurant-#{@sr1.id}") do
          expect(page).to have_content("#{@restaurant1.name}")

          expect(page).to have_button('Vote for this')

          click_button('Vote for this')
        end

        expect(Vote.count).to eq(1)

        expect(current_path).to eq(survey_path(@survey1))

        expect(page).to have_content("Your vote has been cast")

        visit vote_path(@survey1)

        expect(current_path).to eq(survey_path(@survey1))

        expect(page).to have_content("You already voted!")
      end

      it "I can cancel survey" do
        visit vote_path(@survey1)

        expect(current_path).to eq(vote_path(@survey1))

        expect(Vote.count).to eq(0)

        expect(page).to have_button('Cancel Survey')

        click_button 'Cancel Survey'

        expect(current_path).to eq(root_path)

        expect(Vote.count).to eq(0)

        expect(page).to have_content("Group roulette aborted.")
      end
    end

    it "I get a 404 if I am not the survey creator" do
    end

  end
end
