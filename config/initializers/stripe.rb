pub_file = File.open("/home/srlane/Notes/stripe-pub-key")
pub_data = pub_file.read
secret_file = File.open("/home/srlane/Notes/stripe-secret-key")
secret_data = secret_file.read
Rails.configuration.stripe = {
  :publishable_key => pub_data,
  :secret_key => secret_data
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
