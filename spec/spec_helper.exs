ESpec.configure fn(config) ->
  config.before fn(_tags) ->
    Place.start_link(nil)
    Portal.start_link(nil)
    :ok
  end

  config.finally fn(_shared) ->
    :ok
  end
end
