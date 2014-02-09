require 'spec_helper'
include OwnTestHelper

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }
  let!(:user2) { FactoryGirl.create :user, username:"Pekka2"}

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "page has all the ratings" do
    FactoryGirl.create(:rating, beer:beer1, user:user)
    FactoryGirl.create(:rating, beer:beer2, user:user)

    visit ratings_path
    expect(page).to have_content "Number of ratings 2"
    expect(page).to have_content "iso 3 10 Pekka"
    expect(page).to have_content "Karhu 10 Pekka"
  end

  it "appear in users page" do
    FactoryGirl.create(:rating, beer:beer1, user:user)
    FactoryGirl.create(:rating, beer:beer2, user:user)
    FactoryGirl.create(:rating, beer:beer1, user:user)
    FactoryGirl.create(:rating, beer:beer2, user:user)
    FactoryGirl.create(:rating, beer:beer1, user:user2)
    FactoryGirl.create(:rating, beer:beer2, user:user2)

    visit user_path(user)
    expect(page).to have_content "has made 4 ratings"
    expect(page).to have_content "iso 3 10"
    expect(page).to have_content "Karhu 10"
  end

  it "can be deleted" do
    FactoryGirl.create(:rating, beer:beer1, user:user)

    visit user_path(user)
    click_link "delete"
    expect(page).not_to have_content "iso 3 10"
    expect(Rating.count).to eq(0)
  end
end