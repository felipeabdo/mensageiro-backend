Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://mensageiro-frontend.vercel.app' # Remova a barra final
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end