require 'spec_helper'
include OwnTestHelper

describe "User" do
  let!(:user) {FactoryGirl.create :user}

  it "has no favorite beer or brewery or style if no ratings" do
    visit user_path(user)
    expect(page).not_to have_content "favorite"
  end

  it "has favorite everything if at least one rating" do
    beer = FactoryGirl.create :beer
    FactoryGirl.create :rating, score:10, beer:beer, user:user
    visit user_path(user)

    expect(page).to have_content "favorite beer: anonymous"
    expect(page).to have_content "favorite brewery: anonymous"
    expect(page).to have_content "favorite style: Lager"
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'username and password do not match'
    end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with:'Brian')
      fill_in('user_password', with:'Secret55')
      fill_in('user_password_confirmation', with:'Secret55')

      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end
  end
end