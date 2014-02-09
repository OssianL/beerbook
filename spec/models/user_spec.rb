require 'spec_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    user.username.should == "Pekka"
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with invalid password" do
    ["aa1", "asd", "Asdf", "ASDF", "1234", "123a", "A1", "a1"].each do |pass|
      user = User.create username:"Pekka", password:pass, password_confirmation:pass

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining the favorite_beer" do
      user.should respond_to :favorite_beer
    end

    it "without rating does not have a favorite rating" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beer_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user) {FactoryGirl.create(:user)}

    it "has method for determining the favorite style" do
      user.should respond_to :favorite_style
    end

    it "without ratings does not have a favorite style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the one with the highest rating if several rated" do
      brewery = FactoryGirl.create :brewery, name:"Koff"
      beer1 = FactoryGirl.create :beer, name:"koira", style:"kusta", brewery:brewery
      FactoryGirl.create :rating, score:20, user:user, beer:beer1
      create_beer_with_rating(1, user)
      create_beer_with_rating(5, user)
      create_beer_with_rating(10, user)

      expect(user.favorite_style).to eq(beer1.style)
    end
  end

  describe "favorite brewery" do
    let(:user) {FactoryGirl.create(:user)}

    it "has method for determining the favorite brewery" do
      user.should respond_to :favorite_brewery
    end

    it "without ratings does not have a favorite brewery" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one rating" do
      brewery = create_brewery_with_rating(10, user)

      expect(user.favorite_brewery).to eq(brewery)
    end

    it "is the one with the highest rating if several rated" do
      create_brewery_with_ratings(1, 13, 4, 20, user)
      best = create_brewery_with_rating(30, user)

      expect(user.favorite_brewery).to eq(best)
    end
  end

  describe "with a proper password" do
    let(:user){ User.create username:"Pekka", password:"Secret1", password_confirmation:"Secret1" }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end
end

def create_beer_with_rating(score, user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beer_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating(score, user)
  end
end

def create_brewery_with_rating(score, user)
  brewery = FactoryGirl.create(:brewery)
  beer = FactoryGirl.create(:beer, brewery:brewery)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  brewery
end

def create_brewery_with_ratings(*scores, user)
  scores.each do |score|
      create_brewery_with_rating(score, user)
  end
end