require 'rails_helper'

RSpec.describe User, type: :model do
    
    context "Creating an invalid user" do
        it "should not be valid" do
            user=User.create()
        end
    end

    describe "when i put a blank username" do
        it "should not save the user" do
            user=User.create(:username =>  '',:email => 'mario.rossi@gmail.com',:password => 'provaciao',:password_confirmation => 'provaciao')
            expect(user).not_to be_valid
        end
    end
    
    describe "when i put a blank email" do
        it "should not save the user" do
            user=User.create(:username =>  'mario',:email => '',:password => 'provaciao',:password_confirmation => 'provaciao')
            expect(user).not_to be_valid
        end
    end

    describe "when i put a blank password" do
        it "should not save the user" do
            user=User.create(:username =>  'mario',:email => 'mario.rossi@gmail.com',:password => '',:password_confirmation => 'provaciao')
            expect(user).not_to be_valid
        end
    end

    describe "when i put a blank password_confirmation" do
        it "should not save the user" do
            user=User.create(:username =>  'mario',:email => 'mario.rossi@gmail.com',:password => 'provaciao',:password_confirmation => '')
            expect(user).not_to be_valid
        end
    end

    describe "when i put a password_confirmation different from password" do
        it "should not save the user" do
            user=User.create(:username =>  '',:email => 'mario.rossi@gmail.com',:password => 'ciaoprova',:password_confirmation => 'provaciao')
            expect(user).not_to be_valid
        end
    end

    describe "when i put a blank field" do
        it "should not save the user" do
            user=User.create(:username =>  '',:email => '',:password => '',:password_confirmation => '')
            expect(user).not_to be_valid
        end
    end

    describe "when i put a too long username (max:20 characters)" do
        it "should not save the user" do
            user=User.create(:username =>  'abcdefghilmnopqrstuvz',:email => 'mario.rossi@gmail.com',:password => 'provaciao',:password_confirmation => 'provaciao')
            expect(user).not_to be_valid
        end
    end

    describe "when i put a too short password (min 8 characters)" do
        it "should not save the user" do
            user=User.create(:username =>  'mario',:email => 'mario.rossi@gmail.com',:password => 'prova',:password_confirmation => 'prova')
            expect(user).not_to be_valid
        end
    end

    describe "when i put a too long password (max 15 characters)" do
        it "should not save the user" do
            user=User.create(:username =>  'mario',:email => 'mario.rossi@gmail.com',:password => 'provaciaociaoprovaciao',:password_confirmation => 'provaciaociaoprovaciao')
            expect(user).not_to be_valid
        end
    end

end
