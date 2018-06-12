def self.from_omniauth(auth)
  # Check out the Auth Hash function at https://github.com/mkdynamic/omniauth-facebook#auth-hash
  # and figure out how to get email for this user.
  # Note that Facebook sometimes does not return email,
  # in that case you can use facebook-id@facebook.com as a workaround
  email = auth[:info][:email] || "#{auth[:uid]}@facebook.com"
  user = where(email: email).first_or_initialize
  #
  # Set other properties on user here. Just generate a random password. User does not have to use it.
  # You may want to call user.save! to figure out why user can't save
  #
  # Finally, return user
  user.save && user
end
