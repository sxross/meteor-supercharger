@bounded_value = (value, limits={}) ->
  l = if limits.upper? then Math.min(value, limits.upper) else value
  u = if limits.lower? then Math.max(l, limits.lower) else l
  u
