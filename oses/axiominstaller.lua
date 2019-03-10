local TermWidth, TermHeight = term.getSize()
local tArgs = {...}
local bgcolor = colors.white
local progBarC = colors.gray
local progBarFillC = colors.cyan
if not color then
  progBarFillC = colors.lightGray
end
local version = os.version()
if version == "CraftOS 1.5" then
  error("Axiom is not compatible with "..version.."!")
end
local textC = colors.black
local width = 25
local pocket_width = 10
local productName = "Axiom"
local minimal = false
local indev = false
local repair = false
 
 
for k,v in ipairs(tArgs) do
  if v == "minimal" then
    minimal = true
  end
  if v == "nightly" then
    indev = true
  end
  if v == "-rep" then
    repair = true
  end
end
local urls = {
  "https://www.dropbox.com/s/a7fp2jo6tgm7xsy/startup?dl=1",
  "https://www.dropbox.com/s/7mzhcfe53dm2rq5/sys.axs?dl=1",
  "https://www.dropbox.com/s/t40vz4gvmyrcjv4/background.axg?dl=1",
  "https://www.dropbox.com/s/wi4n0j98d82256f/AX.nfp?dl=1",
  "https://www.dropbox.com/s/cjahddofwhja8og/axiom.axg?dl=1",
  "https://www.dropbox.com/s/osz72e1rnvt5opl/nature.axg?dl=1",
  "https://www.dropbox.com/s/9byakcx77k03yji/setting?dl=1",
  "https://www.dropbox.com/s/a5kxzjl6122uti2/edge?dl=1",
  "https://www.dropbox.com/s/p3kgkzhe27vr9lj/encryption?dl=1",
  "https://www.dropbox.com/s/ynyrs22t1hh2mry/settings?dl=1",
  "https://www.dropbox.com/s/nd608k6k4boeqtx/button?dl=1",
  "https://www.pastebin.com/raw/vyAZc6tj",
  "https://www.dropbox.com/s/pe72iyt94jfs9tv/settings?dl=1",
  "https://www.dropbox.com/s/hqdf140odxdcr2g/sysinfo?dl=1",
  "https://www.dropbox.com/s/3vn6wqy765v3wv1/explorer?dl=1",
 
}
local files = {
  "altstartup",
  "Axiom/sys.axs",
  "Axiom/images/default.axg",
  "Axiom/images/AX.nfp",
  "Axiom/images/axiom.axg",
  "Axiom/images/nature.axg",
  "Axiom/libraries/setting",
  "Axiom/libraries/edge",
  "Axiom/libraries/encryption",
  "Axiom/settings.0",
  "Axiom/libraries/button",
  "home/prg/luaide.app",
  "Axiom/programs/settings.app",
  "Axiom/programs/store.app",
  "Axiom/programs/explorer.app",
}
if #files ~= #urls then
  error("Invalid package, url:file ratio is "..#urls..":"..#files..", or "..(#urls/#files))
end
if fs.getFreeSpace("/") <= 300000 then
  error("Not enough free space! At least 300kb (300 000 bytes) is required! And you have "..fs.getFreeSpace("/").." bytes available.")
end
local start = ((52 / 2) - (width / 2))-1
local pocket_start = ((26/2 ) - (pocket_width / 2))
local pocket_end = ((26/2 ) + (pocket_width / 2))
local End = ((52 / 2) + (width / 2))-1
function download(url, file)
  fdl = http.get(url)
  if fdl == nil then
    print("Could not connect")
    return false
  else
    f = fs.open(file,"w")
    f.write(fdl.readAll())
    f.close()
  end
  return true
end
function makedir(dir)
  print("makedir: "..dir)
  sleep(0.1)
  fs.makeDir(dir)
end
function pocket_gui()
  edge.render(1,1,TermWidth,TermHeight,bgcolor,bgcolor,"",textC,false)
  term.setTextColor(textC)
  term.setBackgroundColor(colors.white)
  edge.cprint("Installing Axiom Nano",(TermHeight/2)-3)
  edge.xprint("0%",pocket_start,(TermHeight/2),textC)
  edge.render(pocket_start,(TermHeight/2)+1,pocket_end,(TermHeight/2)+1,progBarC,bgcolor,"",textC,false)
  sleep(1)
end
function gui()
  edge.render(1,1,TermWidth,TermHeight,bgcolor,bgcolor,"",textC,false)
  sleep(1)
  local t = ""
  if indev then
    t = "nightly,"..t
  end
  if minimal then
    t = "indev,"..t
  end
  term.setBackgroundColor(colors.white)
  edge.render(10,5,39,15,colors.white,colors.white,"",colors.black,false)
  edge.xprint("0%",start,(TermHeight/2),textC)
  edge.render(start,(TermHeight/2)+1,End,(TermHeight/2)+1,progBarC,bgcolor,"",textC,false)
  term.setTextColor(textC)
  term.setBackgroundColor(colors.white)
  if not repair then
    if indev then
      edge.cprint("Installing Axiom Nightly",(TermHeight/2)-3)
    else
      edge.cprint("Installing Axiom",(TermHeight/2)-3)
    end
 
  else
    edge.cprint("Repairing Axiom",(TermHeight/2)-3)
  end
  sleep(1)
end
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
print("Downloading dependencies")
if download(urls[8],files[8]) then
  print("Dependencies OK")
  sleep(0.1)
end
if pocket and tArgs[1] == "nightly" then
  if download("https://www.dropbox.com/s/68i2l7m9ol51wd7/sys-pocket.axs?dl=1","Axiom/sys-pocket.axs") then
    print("Ready to install Axiom for Pocket Computer")
    sleep(0.1)
  end
end
print("Preparing for install")
os.loadAPI("Axiom/libraries/edge")
makedir("Axiom/libraries")
makedir("Axiom/images")
makedir("Axiom/programs")
makedir("home/prg/")
makedir("home/Documents")
makedir("home/User-Programs")
makedir("users")
makedir("users/apis")
makedir("users/program-files")
makedir("home/Desktop")
local url_len = #urls
local file_len = #files
local count = 0
local xPos = start
local pocket_pos = pocket_start
local xIncrement = width/file_len
local pocket_increment = pocket_width / file_len
term.setBackgroundColor(bgcolor)
edge.render(1,1,52,19, bgcolor, bgcolor, "", colors.black)
term.setTextColor(colors.gray)
if not minimal or not indev then
  edge.cprint("Pick a version to install!", 6)
  edge.render(11,8,41, 8, colors.lightBlue, bgcolor, " Latest", colors.black)
  edge.render(11,11,41, 11, colors.lightBlue, bgcolor, " Nightly", colors.black)
  while(true) do
    local e,b,x,y = os.pullEvent()
    if e == "mouse_click" then
      if x >= 11 and x <= 41 and y == 8 then
        edge.render(11,8,41, 8, colors.blue, bgcolor, " Latest", colors.black)
      end
      if x >= 11 and x <= 41 and y == 11 then
        indev = true
        edge.render(11, 11,41, 11, colors.blue, bgcolor, " Nightly", colors.black)
 
      end
    end
    if e == "mouse_up" then
      if x >= 11 and x <= 41 and y == 8 then
        edge.render(11,8,41, 8, colors.lightBlue, bgcolor, " Latest", colors.black)
        break
      end
      if x >= 11 and x <= 41 and y == 11 then
        indev = true
        edge.render(11, 11,41, 11, colors.lightBlue, bgcolor, " Nightly", colors.black)
        break
 
      end
    end
  end
end
 
if not pocket then
  gui()
else
  pocket_gui()
end
for k,v in ipairs(urls) do
  local f = (k / file_len) * 100
  xPos = (xPos + xIncrement)
  pocket_pos = (pocket_pos + pocket_increment)
  if not pocket then
    term.setBackgroundColor(colors.white)
    term.setTextColor(textC)
    edge.xprint("            ",start,(TermHeight/2),textC)
    edge.xprint(round(f,1).."%",start,(TermHeight/2),textC)
    edge.render(start,(TermHeight/2)+1,xPos,(TermHeight/2)+1,progBarFillC,bgcolor,"",textC,false)
    edge.xprint("                                  ",start,(TermHeight/2+2),colors.lightGray)
    edge.xprint(files[k],start,(TermHeight/2+2),colors.lightGray)
  end
  if pocket then
    term.setBackgroundColor(colors.white)
    term.setTextColor(textC)
    edge.xprint("            ",pocket_start,(TermHeight/2),textC)
    edge.xprint(round(f,1).."%",pocket_start,(TermHeight/2),textC)
    edge.render(pocket_start,(TermHeight/2)+1,pocket_pos,(TermHeight/2)+1,progBarFillC,bgcolor,"",textC,false)
 
  end
  if k == 8 then
 
  else
    if not fs.exists(files[k]) then
      if minimal and k >= 4 and k <= 6 or minimal and k >= 13 and k <= 14 then
        edge.xprint(files[k].." ignored",start,(TermHeight/2+2),colors.lightGray)
        sleep(0.1)
      else
        download(urls[k],files[k])
      end
    else
      sleep(0.1)
    end
  end
end
term.setTextColor(textC)
sleep(2)
if tArgs[1] == "-serv2016" then
  download("https://www.dropbox.com/s/67dycd81yukawnc/sys-server.axs?dl=1","Axiom/sys.axs")
  print("Server installed.")
end
if indev then
  if pocket then
 
  else
    fs.delete("Axiom/sys.axs")
    print("Installing experimental core")
    download("https://www.dropbox.com/s/5v2amjjmw08n9yz/sys-latest.axs?dl=1","Axiom/sys.axs")
    term.clear()
    shell.run("clear")
    fs.makeDir("firstBoot")
  end
else
  shell.run("Axiom/sys.axs")
end
