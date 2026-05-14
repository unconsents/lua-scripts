(function()
local _svc = setmetatable({},{__index=function(_,k) return game:GetService(k) end})
local RS,PL,RU,TS,UI = _svc.ReplicatedStorage,_svc.Players,_svc.RunService,_svc.TweenService,_svc.UserInputService
local _re = RS:WaitForChild("RemoteEvents")
local _lp = PL.LocalPlayer
local _pg = _lp:WaitForChild("PlayerGui")

if _G.__sr then _G.__sr:Disconnect() end
if _G.__sc then _G.__sc:Disconnect() end
if _G.__sg then _G.__sg:Disconnect() end
if _G.__si and _G.__si.Parent then _G.__si:Destroy() end

local _C = {
	o  = Color3.fromRGB(255,120,0),
	od = Color3.fromRGB(35,15,0),
	ol = Color3.fromRGB(50,20,0),
	b  = Color3.fromRGB(0,0,0),
	d1 = Color3.fromRGB(10,10,10),
	d2 = Color3.fromRGB(22,22,22),
	t1 = Color3.fromRGB(24,24,24),
	t2 = Color3.fromRGB(42,42,42),
	tx = Color3.fromRGB(225,225,225),
	st = Color3.fromRGB(120,120,120),
}

local _EH,_CH = 366,44

local _D = {
	p1={t=Vector3.new(-470.38555908203125,246.18482971191406,939.3289794921875),e=Vector3.new(-565.4944458007812,246.19100952148438,946.260986328125)},
	p2={t=Vector3.new(49.16473388671875,246.24708557128906,-503.34759521484375),e=Vector3.new(51.71800994873047,246.24708557128906,-481.5979919433594)}
}

local _am,_dt,_ca,_so,_scp = "none","p1",false,false,nil

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

local _rdb,_lch = false,_lp.Character

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

_G.__sr=RU.Heartbeat:Connect(function()
	local c=_lp.Character
	if c and c~=_lch then _lch=c;_rfr() end
end)
_G.__sc=_lp.CharacterAdded:Connect(function(c)
	if c~=_lch then _lch=c;_rfr() end
end)

task.spawn(function()
	while true do
		task.wait(2)
		if _am=="dual" then _dt=_dt=="p1" and "p2" or "p1" end
	end
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

local _cn={"CommonCrate","RareCrate","EpicCrate","MythicCrate","GodlyCrate"}
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
_mf.Size=UDim2.new(0,240,0,_EH)
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

local _ttl=Instance.new("TextLabel")
_ttl.Size=UDim2.new(1,-80,0,18)
_ttl.Position=UDim2.new(0,26,0,5)
_ttl.BackgroundTransparency=1
_ttl.Text="SPTS: Reimagined"
_ttl.TextColor3=_C.o
_ttl.TextSize=12
_ttl.Font=Enum.Font.GothamBold
_ttl.TextXAlignment=Enum.TextXAlignment.Left
_ttl.ZIndex=4
_ttl.Parent=_hdr

local _pcl=Instance.new("TextLabel")
_pcl.Size=UDim2.new(1,-80,0,12)
_pcl.Position=UDim2.new(0,26,0,26)
_pcl.BackgroundTransparency=1
_pcl.Text="1 player in server"
_pcl.TextColor3=_C.st
_pcl.TextSize=9
_pcl.Font=Enum.Font.Gotham
_pcl.TextXAlignment=Enum.TextXAlignment.Left
_pcl.ZIndex=4
_pcl.Parent=_hdr

task.spawn(function()
	while _gui.Parent do
		local n=#PL:GetPlayers()
		_pcl.Text=n==1 and "1 player in server" or n.." players in server"
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

local _ctf=Instance.new("Frame")
_ctf.Size=UDim2.new(1,0,0,_EH-44)
_ctf.Position=UDim2.new(0,0,0,44)
_ctf.BackgroundTransparency=1
_ctf.Parent=_mf

local _TW=TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)

local function _mklbl(tx,yp)
	local l=Instance.new("TextLabel")
	l.Size=UDim2.new(1,-20,0,16);l.Position=UDim2.new(0,10,0,yp)
	l.BackgroundTransparency=1;l.Text=tx;l.TextColor3=_C.o
	l.TextSize=9;l.Font=Enum.Font.GothamBold
	l.TextXAlignment=Enum.TextXAlignment.Left;l.Parent=_ctf
	local ln=Instance.new("Frame")
	ln.Size=UDim2.new(1,-20,0,1);ln.Position=UDim2.new(0,10,0,yp+15)
	ln.BackgroundColor3=_C.ol;ln.BorderSizePixel=0;ln.Parent=_ctf
end

local function _mktog(lbl,yp)
	local btn=Instance.new("TextButton")
	btn.Size=UDim2.new(1,-20,0,40);btn.Position=UDim2.new(0,10,0,yp)
	btn.BackgroundColor3=_C.t1;btn.BorderSizePixel=0
	btn.Text="";btn.AutoButtonColor=false;btn.Parent=_ctf
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
	local function set(on)
		TS:Create(tr,_TW,{BackgroundColor3=on and _C.o or _C.t2}):Play()
		TS:Create(kn,_TW,{
			Position=on and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),
			BackgroundColor3=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(160,160,160)
		}):Play()
		TS:Create(btn,_TW,{BackgroundColor3=on and _C.od or _C.t1}):Play()
	end
	return btn,set
end

_mklbl("AUTO FARMS",16)
local _b1,_s1=_mktog("Place 1",36)
local _b2,_s2=_mktog("Place 2",80)
local _bd,_sd=_mktog("Dual Farm",124)

local function _mksep(yp)
	local s=Instance.new("Frame")
	s.Size=UDim2.new(1,-20,0,1);s.Position=UDim2.new(0,10,0,yp)
	s.BackgroundColor3=Color3.fromRGB(22,9,0);s.BorderSizePixel=0;s.Parent=_ctf
end

_mksep(169)
_mklbl("CRATES",177)
local _bc,_sc=_mktog("Auto Crates",197)
_mksep(242)
_mklbl("SETTINGS",250)
local _bsf,_ssf=_mktog("Safety Toggle",270)

local function _setm(m)
	if m~="none" and _ca then _spcr();_sc(false) end
	_am=m;_s1(m=="p1");_s2(m=="p2");_sd(m=="dual")
end

_b1.MouseButton1Click:Connect(function() _setm(_am=="p1" and "none" or "p1") end)
_b2.MouseButton1Click:Connect(function() _setm(_am=="p2" and "none" or "p2") end)
_bd.MouseButton1Click:Connect(function() _setm(_am=="dual" and "none" or "dual") end)
_bc.MouseButton1Click:Connect(function()
	if not _ca and _am~="none" then return end
	if _ca then _spcr();_sc(false) else _stcr();_sc(true) end
end)
_bsf.MouseButton1Click:Connect(function() _so=not _so;_ssf(_so) end)

local _col=false
local _cltw=TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)

_cob.MouseButton1Click:Connect(function()
	_col=not _col
	TS:Create(_mf,_cltw,{Size=UDim2.new(0,240,0,_col and _CH or _EH)}):Play()
	TS:Create(_cob,_cltw,{Rotation=_col and 180 or 0}):Play()
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
end)()