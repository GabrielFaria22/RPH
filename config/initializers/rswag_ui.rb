if defined?(Rswag::Ui)
  Rswag::Ui.configure do |config|
    config.openapi_endpoint '/api-docs/v1/openapi.yaml', 'RPH API V1'
  end
end
