require 'rails_helper'
require 'spec_helper'

RSpec.describe MapboxController, type: :controller do
  describe "map#show" do
    context "At least 1 room given"do
      it "should render marker on rooms location" do
      
        if page.respond_to? :should
          expect(page).to have_content(marker)
        else
          assert page.has_content?(marker)  
        end
      end
    end
  end
end
