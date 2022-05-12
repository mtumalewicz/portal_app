ESpec.configure fn(config) ->
  config.before fn(_tags) ->
    Portal.shoot(:blue)
    Portal.shoot(:orange)
    :ok
  end

  config.finally fn(_shared) ->
    :ok
  end
end
