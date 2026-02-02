Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'  # In production, change to your frontend domain

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ['Authorization']  # Important for JWT token
  end
end
