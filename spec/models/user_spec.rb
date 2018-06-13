require 'rails_helper'

RSpec.describe User, type: :model do
    
    context "Creating an invalid user" do
        it "should not be valid" do
            user=User.create()
    end
    
    
end
