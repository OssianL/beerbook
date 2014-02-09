require 'spec_helper'

describe Beer do

  it "is not saved without name" do
    beer = Beer.create style:"IPS"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without style" do
    beer = Beer.create name:"kalja"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  describe "with a proper name and style" do
    let(:beer) {Beer.create name:"kalja", style:"IPS"}

    it "is saved" do
      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end
  end
end
