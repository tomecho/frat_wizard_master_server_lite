json.array!(@orgs) do |org|
  json.extract! org, :id, :name, :location_id
  json.url org_url(org, format: :json)
end
