class KeyGenerator
  getUniqueKey: ->
    @lastTimestamp ||= 0

    if window.performance && window.performance.now
      timestamp = parseInt(window.performance.now() * 1000000)
      if timestamp <= @lastTimestamp
        timestamp = @lastTimestamp + 1
      @lastTimestamp = timestamp
      timestamp
    else
      timestamp = Date.now()
      if timestamp <= @lastTimestamp
        timestamp = @lastTimestamp + 1
      @lastTimestamp = timestamp
      timestamp

window.KeyGenerator = KeyGenerator
