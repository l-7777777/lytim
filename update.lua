  local os = http.get("https://raw.githubusercontent.com/l-7777777/lytim/master/startup.lua")
  local lo = fs.open("startup", "w")
  if os.readAll() ~= lo.readAll() then
    print("There is an update.")
    print("Would you like to update this computer? [Y/n]")
    local yorn = read()
    if (yorn == Y) or (yorn == y) then
      print("Restart to update")
      term.setBackgroundColor(colors.green)
      print("           ")
      print("  Restart  ")
      print("           ")
      local event, button, x, y = os.pullEvent("mouse_click")
      if (y < 7) and (x < 11) and (y > 4) then
        os.reboot()
