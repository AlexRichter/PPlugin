visitorLog = (dcs, options) ->
  dcs.addTransform ((dcsObject, o) ->
    dcsuri = dcsObject.DCS.dcsuri    
    dname = "DCS.dcsuri_"

    if dcsuri? and localStorage? and JSON?
      storedLog = if localStorage.wt_visitorLog? then JSON.parse(localStorage.wt_visitorLog) else {}
      
      dcsObject.DCS.dcsuri_d = null
      dcsObject.DCS.dcsuri_w = null
      dcsObject.DCS.dcsuri_m = null
      dcsObject.DCS.dcsuri_y = null

      if storedLog[dcsuri]?
        # If we know when we last saw it
        savedDate = new Date(storedLog[dcsuri])
        curDate = new Date()
        
        tracking = 0 

        if savedDate.getFullYear() != curDate.getFullYear()
          # Need to do all of them
          tracking = 4 
        else if savedDate.getMonth() != curDate.getMonth()
          # Do month down
          tracking = 3
        else if savedDate.getWeek() != curDate.getWeek()
          # Do week down
          tracking = 2
        else if savedDate.getDate() != curDate.getDate()        
          # Just do day 
          tracking = 1        
      else
        tracking = 4

      record = (t) ->
        o.argsa.push("#{dname}#{t}", 1)

      if tracking > 0
        record("d")
      if tracking > 1
        record("w")
      if tracking > 2
        record("m")
      if tracking > 3
        record("y")
      storedLog[dcsuri] = new Date()
      localStorage.wt_visitorLog = JSON.stringify(storedLog)
    return true
  ), "all"

Date::getWeek = ->
  # Expands default 'Date' object with a 'getWeek' method to return week-of-year
  onejan = new Date(@getFullYear(), 0, 1)
  Math.ceil (((this - onejan) / 86400000) + onejan.getDay() + 1) / 7

Webtrends.registerPlugin "visitorlog", (dcs, options) ->
  visitorLog(dcs, options)