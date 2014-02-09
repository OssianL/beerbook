require 'spec_helper'
include OwnTestHelper

describe "beer" do

  describe "with valid parameters" do
    before :each do
      FactoryGirl.create(:user)
      FactoryGirl.create(:brewery)
      sign_in(username:"Pekka", password:"Foobar1")
      visit new_beer_path
      fill_in("Name", with: "kaljaaaa")
      click_button "Create Beer"
    end

    it "is saved" do
      expect(Beer.count).to eq(1)
    end
  end

  it "is not saved without name" do
    FactoryGirl.create(:user)
    sign_in(username:"Pekka", password:"Foobar1")
    visit new_beer_path
    click_button "Create Beer"
    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to eq(0)
  end
end