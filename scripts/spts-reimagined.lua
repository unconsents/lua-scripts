(function()
local _svc=setmetatable({},{__index=function(_,k) return game:GetService(k) end})
local RS,PL,RU,TS,UI=_svc.ReplicatedStorage,_svc.Players,_svc.RunService,_svc.TweenService,_svc.UserInputService
local _re=RS:WaitForChild("RemoteEvents")
local _lp=PL.LocalPlayer
local _pg=_lp:WaitForChild("PlayerGui")

if _G.__sc then _G.__sc:Disconnect() end
if _G.__sg then _G.__sg:Disconnect() end
if _G.__si and _G.__si.Parent then _G.__si:Destroy() end

local _C={
	o=Color3.fromRGB(255,120,0),od=Color3.fromRGB(35,15,0),ol=Color3.fromRGB(50,20,0),
	b=Color3.fromRGB(0,0,0),d1=Color3.fromRGB(10,10,10),d2=Color3.fromRGB(22,22,22),
	t1=Color3.fromRGB(24,24,24),t2=Color3.fromRGB(42,42,42),
	tx=Color3.fromRGB(225,225,225),st=Color3.fromRGB(120,120,120),
	tbi=Color3.fromRGB(26,26,26),tbh=Color3.fromRGB(36,36,36),
}

local _TH={auto=323,trolls=162,misc=162}
local _CH=44

local _D={
	p1={t=Vector3.new(-470.38555908203125,246.18482971191406,939.3289794921875),e=Vector3.new(-565.4944458007812,246.19100952148438,946.260986328125)},
	p2={t=Vector3.new(49.16473388671875,246.24708557128906,-503.34759521484375),e=Vector3.new(51.71800994873047,246.24708557128906,-481.5979919433594)}
}

local _am,_dt,_ca,_so,_scp,_sra="none","p1",false,true,nil,false

local function _tgt()
	if _am=="p1" then return _D.p1
	elseif _am=="p2" then return _D.p2
	elseif _am=="dual" then return _D[_dt] end
	return nil
end

local function _chk()
	if not _so then return true end
	return #PL:GetPlayers()<=1
end

local function _alive()
	local c=_lp.Character
	if not c or not c:IsDescendantOf(workspace) then return false end
	local h=c:FindFirstChildOfClass("Humanoid")
	if not h or h.Health<=0 or h.MaxHealth<=0 then return false end
	if h:GetState()==Enum.HumanoidStateType.Dead then return false end
	local r=c:FindFirstChild("HumanoidRootPart")
	return r~=nil and r:IsDescendantOf(workspace)
end

local _rdb=false

local function _rfr()
	if _rdb then return end
	_rdb=true
	task.spawn(function()
		task.wait(0.5)
		pcall(function() _re:WaitForChild("RefreshCharacter"):FireServer() end)
		task.wait(3)
		_rdb=false
	end)
end

local function _hookHealth(char)
	local hum=char:WaitForChild("Humanoid",5)
	if not hum then return end
	hum:GetPropertyChangedSignal("Health"):Connect(function()
		if hum.Health<50 then _rfr() end
	end)
end

local _initChar=workspace:FindFirstChild(_lp.Name)
if _initChar then task.spawn(function() _hookHealth(_initChar) end) end

_G.__sc=_lp.CharacterAdded:Connect(function(char)
	task.spawn(function() _hookHealth(char) end)
end)

task.spawn(function()
	while true do task.wait(2);if _am=="dual" then _dt=_dt=="p1" and "p2" or "p1" end end
end)

task.spawn(function()
	while true do
		if _alive() and _chk() then
			local t=_tgt()
			if t then pcall(function() _re:WaitForChild("UseSkill"):FireServer("Teleport",t.t) end) end
		end
		task.wait(1)
	end
end)

task.spawn(function()
	while true do
		if _alive() and _chk() then
			local t=_tgt()
			if t then pcall(function() _re:WaitForChild("UseSkill"):FireServer("EnergySphere",t.e) end) end
		end
		task.wait()
	end
end)

task.spawn(function()
	while true do
		task.wait()
		if _sra and _chk() then
			for _,p in ipairs(PL:GetPlayers()) do
				local chr=p.Character
				if chr then pcall(function() _re:WaitForChild("UseSkill"):FireServer("SoulReap",chr) end) end
			end
		end
	end
end)

local _cn={"CommonCrate","RareCrate","EpicCrate","MythicCrate","GodlyCrate","LegendaryCrate","SecretCrate"}
local function _fcd(m) for _,v in ipairs(m:GetDescendants()) do if v:IsA("ClickDetector") then return v end end end
local function _hrp() local c=_lp.Character;return c and c:FindFirstChild("HumanoidRootPart") or nil end
local function _fza(s)
	local h=_hrp();if not h then return end
	if s then
		local o=h:FindFirstChild("__bpfz");if o then o:Destroy() end
		local b=Instance.new("BodyPosition")
		b.Name="__bpfz";b.MaxForce=Vector3.new(0,math.huge,0)
		b.Position=h.Position;b.D=1000;b.P=10000;b.Parent=h
	else local b=h:FindFirstChild("__bpfz");if b then b:Destroy() end end
end
local function _ufz(h) local b=h:FindFirstChild("__bpfz");if b then b.Position=h.Position end end
local function _ace() for _,n in ipairs(_cn) do if workspace:FindFirstChild(n) then return true end end return false end

local function _stcr()
	local h=_hrp();if h then _scp=h.CFrame end
	_ca=true
	task.spawn(function()
		_fza(true)
		while _ca do
			task.wait();if not _ca then break end
			if not _chk() then continue end
			if not _ace() then
				local h2=_hrp()
				if h2 and _scp then h2.CFrame=_scp;_ufz(h2) end
				continue
			end
			for _,cn in ipairs(_cn) do
				if not _ca then break end
				local ok,_=pcall(function()
					local cr=workspace:FindFirstChild(cn);if not cr then return end
					local cd=_fcd(cr);if not cd then return end
					local h2=_hrp();if not h2 then return end
					h2.CFrame=cd.Parent.CFrame*CFrame.new(0,0,-3);_ufz(h2);task.wait(0.1)
					while _ca and workspace:FindFirstChild(cn) do
						task.wait(0.1);if not _chk() then break end
						local cc=workspace:FindFirstChild(cn);if not cc then break end
						local cd2=_fcd(cc);if not cd2 then break end
						local h3=_hrp();if not h3 then break end
						h3.CFrame=cd2.Parent.CFrame*CFrame.new(0,0,-3);_ufz(h3)
						pcall(fireclickdetector,cd2,0)
					end
					task.wait(0.1)
				end)
				if not ok then task.wait(1) end
			end
		end
		_fza(false)
	end)
end
local function _spcr() _ca=false;_fza(false) end

local _vp=workspace.CurrentCamera.ViewportSize
local _scl=math.clamp(_vp.X/1024,0.6,1.1)

local _gui=Instance.new("ScreenGui")
_gui.Name="__"..tostring(math.random(0xAAAA,0xFFFF))
_gui.ResetOnSpawn=false
_gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
_gui.IgnoreGuiInset=true
_gui.Parent=_pg
_G.__si=_gui

local _mf=Instance.new("Frame")
_mf.Size=UDim2.new(0,240,0,0)
_mf.Position=UDim2.new(0,20,0,60)
_mf.BackgroundColor3=_C.b
_mf.BorderSizePixel=0
_mf.ClipsDescendants=true
_mf.Parent=_gui
Instance.new("UICorner",_mf).CornerRadius=UDim.new(0,14)

local _us=Instance.new("UIScale")
_us.Scale=_scl
_us.Parent=_mf

local _sk=Instance.new("UIStroke")
_sk.Thickness=1.5
_sk.Color=Color3.fromRGB(255,255,255)
_sk.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
_sk.Parent=_mf
local _gr=Instance.new("UIGradient")
_gr.Color=ColorSequence.new({
	ColorSequenceKeypoint.new(0,_C.o),
	ColorSequenceKeypoint.new(0.4,Color3.fromRGB(18,7,0)),
	ColorSequenceKeypoint.new(0.6,Color3.fromRGB(18,7,0)),
	ColorSequenceKeypoint.new(1,_C.o)
})
_gr.Parent=_sk
local _ga=0
_G.__sg=RU.Heartbeat:Connect(function() _ga=(_ga+0.7)%360;_gr.Rotation=_ga end)

local _hdr=Instance.new("Frame")
_hdr.Size=UDim2.new(1,0,0,44)
_hdr.BackgroundColor3=_C.d1
_hdr.BorderSizePixel=0
_hdr.ZIndex=3
_hdr.Parent=_mf
Instance.new("UICorner",_hdr).CornerRadius=UDim.new(0,14)

local _hfx=Instance.new("Frame")
_hfx.Size=UDim2.new(1,0,0,14)
_hfx.Position=UDim2.new(0,0,1,-14)
_hfx.BackgroundColor3=_C.d1
_hfx.BorderSizePixel=0
_hfx.ZIndex=3
_hfx.Parent=_hdr

local _dot=Instance.new("Frame")
_dot.Size=UDim2.new(0,7,0,7)
_dot.Position=UDim2.new(0,13,0.5,-3.5)
_dot.BackgroundColor3=_C.o
_dot.BorderSizePixel=0
_dot.ZIndex=4
_dot.Parent=_hdr
Instance.new("UICorner",_dot).CornerRadius=UDim.new(1,0)

local _hrl=Instance.new("TextLabel")
_hrl.Size=UDim2.new(1,-66,0,16)
_hrl.Position=UDim2.new(0,26,0.5,-8)
_hrl.BackgroundTransparency=1
_hrl.RichText=true
_hrl.Text="SPTS: Reimagined  <font color='#3a1400'>|</font>  Players: <font color='#50ff50'>1</font>"
_hrl.TextColor3=_C.o
_hrl.TextSize=12
_hrl.Font=Enum.Font.GothamBold
_hrl.TextXAlignment=Enum.TextXAlignment.Left
_hrl.TextTruncate=Enum.TextTruncate.AtEnd
_hrl.ZIndex=4
_hrl.Parent=_hdr

task.spawn(function()
	while _gui.Parent do
		local n=#PL:GetPlayers()
		_hrl.Text="SPTS: Reimagined  <font color='#3a1400'>|</font>  Players: <font color='#50ff50'>"..n.."</font>"
		task.wait(3)
	end
end)

local _cob=Instance.new("TextButton")
_cob.Size=UDim2.new(0,26,0,26)
_cob.Position=UDim2.new(1,-34,0.5,-13)
_cob.BackgroundColor3=_C.d2
_cob.Text="−"
_cob.TextColor3=_C.o
_cob.TextSize=16
_cob.Font=Enum.Font.GothamBold
_cob.BorderSizePixel=0
_cob.AutoButtonColor=false
_cob.ZIndex=5
_cob.Parent=_hdr
Instance.new("UICorner",_cob).CornerRadius=UDim.new(0,6)

local _tbr=Instance.new("Frame")
_tbr.Size=UDim2.new(1,0,0,36)
_tbr.Position=UDim2.new(0,0,0,44)
_tbr.BackgroundColor3=_C.d1
_tbr.BorderSizePixel=0
_tbr.ZIndex=2
_tbr.Parent=_mf

local _tbl=Instance.new("Frame")
_tbl.Size=UDim2.new(1,-20,0,1)
_tbl.Position=UDim2.new(0,10,0,0)
_tbl.BackgroundColor3=Color3.fromRGB(30,12,0)
_tbl.BorderSizePixel=0
_tbl.ZIndex=3
_tbl.Parent=_tbr

local _tabnames={"Auto","Trolls","Misc"}
local _tabX={8,84,160}
local _tbns={}

for i=1,3 do
	local tb=Instance.new("TextButton")
	tb.Size=UDim2.new(0,72,0,26)
	tb.Position=UDim2.new(0,_tabX[i],0.5,-13)
	tb.BackgroundColor3=i==1 and _C.o or _C.tbi
	tb.Text=_tabnames[i]
	tb.TextColor3=i==1 and Color3.fromRGB(255,255,255) or _C.st
	tb.TextSize=10
	tb.Font=Enum.Font.GothamBold
	tb.BorderSizePixel=0
	tb.AutoButtonColor=false
	tb.ZIndex=3
	tb.Parent=_tbr
	Instance.new("UICorner",tb).CornerRadius=UDim.new(0,6)
	_tbns[i]=tb
end

local _cth=Instance.new("Frame")
_cth.Size=UDim2.new(1,0,0,_TH.auto-80)
_cth.Position=UDim2.new(0,0,0,80)
_cth.BackgroundTransparency=1
_cth.Parent=_mf

local _twF=TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
local _twH=TweenInfo.new(0.12)
local _twC=TweenInfo.new(0.25,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
local _twL=TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out)

local function _mklbl(par,tx,yp)
	local l=Instance.new("TextLabel")
	l.Size=UDim2.new(1,-20,0,16);l.Position=UDim2.new(0,10,0,yp)
	l.BackgroundTransparency=1;l.Text=tx;l.TextColor3=_C.o
	l.TextSize=9;l.Font=Enum.Font.GothamBold
	l.TextXAlignment=Enum.TextXAlignment.Left;l.Parent=par
	local ln=Instance.new("Frame")
	ln.Size=UDim2.new(1,-20,0,1);ln.Position=UDim2.new(0,10,0,yp+15)
	ln.BackgroundColor3=_C.ol;ln.BorderSizePixel=0;ln.Parent=par
end

local function _mksep(par,yp)
	local s=Instance.new("Frame")
	s.Size=UDim2.new(1,-20,0,1);s.Position=UDim2.new(0,10,0,yp)
	s.BackgroundColor3=Color3.fromRGB(22,9,0);s.BorderSizePixel=0;s.Parent=par
end

local function _mktog(par,lbl,yp)
	local btn=Instance.new("TextButton")
	btn.Size=UDim2.new(1,-20,0,40);btn.Position=UDim2.new(0,10,0,yp)
	btn.BackgroundColor3=_C.t1;btn.BorderSizePixel=0
	btn.Text="";btn.AutoButtonColor=false;btn.Parent=par
	Instance.new("UICorner",btn).CornerRadius=UDim.new(0,10)
	local lb=Instance.new("TextLabel")
	lb.Size=UDim2.new(1,-58,1,0);lb.Position=UDim2.new(0,13,0,0)
	lb.BackgroundTransparency=1;lb.Text=lbl;lb.TextColor3=_C.tx
	lb.TextSize=12;lb.Font=Enum.Font.GothamSemibold
	lb.TextXAlignment=Enum.TextXAlignment.Left;lb.Parent=btn
	local tr=Instance.new("Frame")
	tr.Size=UDim2.new(0,36,0,20);tr.Position=UDim2.new(1,-48,0.5,-10)
	tr.BackgroundColor3=_C.t2;tr.BorderSizePixel=0;tr.Parent=btn
	Instance.new("UICorner",tr).CornerRadius=UDim.new(1,0)
	local kn=Instance.new("Frame")
	kn.Size=UDim2.new(0,14,0,14);kn.Position=UDim2.new(0,3,0.5,-7)
	kn.BackgroundColor3=Color3.fromRGB(160,160,160);kn.BorderSizePixel=0;kn.Parent=tr
	Instance.new("UICorner",kn).CornerRadius=UDim.new(1,0)
	local _on=false
	local function set(on)
		_on=on
		TS:Create(tr,_twF,{BackgroundColor3=on and _C.o or _C.t2}):Play()
		TS:Create(kn,_twF,{
			Position=on and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),
			BackgroundColor3=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(160,160,160)
		}):Play()
		TS:Create(btn,_twF,{BackgroundColor3=on and _C.od or _C.t1}):Play()
	end
	btn.MouseEnter:Connect(function()
		TS:Create(btn,_twH,{BackgroundColor3=_on and Color3.fromRGB(50,20,0) or Color3.fromRGB(34,34,34)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TS:Create(btn,_twH,{BackgroundColor3=_on and _C.od or _C.t1}):Play()
	end)
	return btn,set
end

local _atf=Instance.new("Frame")
_atf.Size=UDim2.new(1,0,0,_TH.auto-80)
_atf.BackgroundTransparency=1
_atf.Visible=true;_atf.Parent=_cth

_mklbl(_atf,"AUTO FARMS",10)
local _b1,_s1=_mktog(_atf,"Place 1",30)
local _b2,_s2=_mktog(_atf,"Place 2",74)
local _bd,_sd=_mktog(_atf,"Dual Farm",118)
_mksep(_atf,163)
_mklbl(_atf,"CRATES",171)
local _bc,_sct=_mktog(_atf,"Auto Crates",191)

local _trf=Instance.new("Frame")
_trf.Size=UDim2.new(1,0,0,_TH.trolls-80)
_trf.BackgroundTransparency=1
_trf.Visible=false;_trf.Parent=_cth

_mklbl(_trf,"TROLLS",10)
local _bsr,_ssr=_mktog(_trf,"Soul Reap All",30)

local _msf=Instance.new("Frame")
_msf.Size=UDim2.new(1,0,0,_TH.misc-80)
_msf.BackgroundTransparency=1
_msf.Visible=false;_msf.Parent=_cth

_mklbl(_msf,"MISC",10)
local _bsf,_ssf=_mktog(_msf,"Safety Toggle",30)
_ssf(true)

local _tcm={
	{c=_atf,h=_TH.auto},
	{c=_trf,h=_TH.trolls},
	{c=_msf,h=_TH.misc}
}
local _ati,_col=1,false

local function _swt(idx)
	if idx==_ati then return end
	_tcm[_ati].c.Visible=false
	TS:Create(_tbns[_ati],_twC,{BackgroundColor3=_C.tbi}):Play()
	_tbns[_ati].TextColor3=_C.st
	_ati=idx
	_tcm[idx].c.Visible=true
	TS:Create(_tbns[idx],_twC,{BackgroundColor3=_C.o}):Play()
	_tbns[idx].TextColor3=Color3.fromRGB(255,255,255)
	if not _col then
		TS:Create(_mf,_twC,{Size=UDim2.new(0,240,0,_tcm[idx].h)}):Play()
	end
end

for i=1,3 do
	_tbns[i].MouseButton1Click:Connect(function() _swt(i) end)
	_tbns[i].MouseEnter:Connect(function()
		if i~=_ati then TS:Create(_tbns[i],_twH,{BackgroundColor3=_C.tbh}):Play() end
	end)
	_tbns[i].MouseLeave:Connect(function()
		if i~=_ati then TS:Create(_tbns[i],_twH,{BackgroundColor3=_C.tbi}):Play() end
	end)
end

local function _setm(m)
	if m~="none" and _ca then _spcr();_sct(false) end
	_am=m;_s1(m=="p1");_s2(m=="p2");_sd(m=="dual")
end

_b1.MouseButton1Click:Connect(function() _setm(_am=="p1" and "none" or "p1") end)
_b2.MouseButton1Click:Connect(function() _setm(_am=="p2" and "none" or "p2") end)
_bd.MouseButton1Click:Connect(function() _setm(_am=="dual" and "none" or "dual") end)
_bc.MouseButton1Click:Connect(function()
	if not _ca and _am~="none" then return end
	if _ca then _spcr();_sct(false) else _stcr();_sct(true) end
end)
_bsr.MouseButton1Click:Connect(function() _sra=not _sra;_ssr(_sra) end)
_bsf.MouseButton1Click:Connect(function() _so=not _so;_ssf(_so) end)

_cob.MouseButton1Click:Connect(function()
	_col=not _col
	TS:Create(_mf,_twC,{Size=UDim2.new(0,240,0,_col and _CH or _tcm[_ati].h)}):Play()
	TS:Create(_cob,_twC,{Rotation=_col and 180 or 0}):Play()
	if _col then
		task.delay(0.25,function() if _col then _hfx.Visible=false end end)
	else
		_hfx.Visible=true
	end
end)

local _dg,_ds,_dp=false,nil,nil
_hdr.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		_dg=true;_ds=i.Position;_dp=_mf.Position
		i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then _dg=false end end)
	end
end)
UI.InputChanged:Connect(function(i)
	if _dg and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
		local d=i.Position-_ds
		_mf.Position=UDim2.new(_dp.X.Scale,_dp.X.Offset+d.X,_dp.Y.Scale,_dp.Y.Offset+d.Y)
	end
end)

task.wait(0.05)
TS:Create(_mf,_twL,{Size=UDim2.new(0,240,0,_TH.auto)}):Play()
end)()
