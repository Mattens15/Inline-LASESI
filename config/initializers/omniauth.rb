Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "381156869034730", "af04d1e74eaca77242ad9b47edcf099d"
  provider :google_oauth2, "805289945209-9nh3usnf1vgpno053lq2a1526rghhb3c.apps.googleusercontent.com","ZRyPjkRV2PC9TZxG9OqIDmR6"
end
