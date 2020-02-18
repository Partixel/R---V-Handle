local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

---------- SPECTATE

local pi    = math.pi
local abs   = math.abs
local clamp = math.clamp
local exp   = math.exp
local rad   = math.rad
local sign  = math.sign
local sqrt  = math.sqrt
local tan   = math.tan

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local Camera = Workspace.CurrentCamera
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	local newCamera = Workspace.CurrentCamera
	if newCamera then
		Camera = newCamera
	end
end)

local TOGGLE_INPUT_PRIORITY = Enum.ContextActionPriority.Low.Value
local INPUT_PRIORITY = Enum.ContextActionPriority.High.Value
local FREECAM_MACRO_KB = {Enum.KeyCode.LeftShift, Enum.KeyCode.P}

local NAV_GAIN = Vector3.new(1, 1, 1)*64
local PAN_GAIN = Vector2.new(0.75, 1)*8
local FOV_GAIN = 300

local PITCH_LIMIT = rad(90)

local VEL_STIFFNESS = 1.5
local PAN_STIFFNESS = 1.0
local FOV_STIFFNESS = 4.0

local Spring = {} do
	Spring.__index = Spring

	function Spring.new(freq, pos)
		local self = setmetatable({}, Spring)
		self.f = freq
		self.p = pos
		self.v = pos*0
		return self
	end

	function Spring:Update(dt, goal)
		local f = self.f*2*pi
		local p0 = self.p
		local v0 = self.v

		local offset = goal - p0
		local decay = exp(-f*dt)

		local p1 = goal + (v0*dt - offset*(f*dt + 1))*decay
		local v1 = (f*dt*(offset*f - v0) + v0)*decay

		self.p = p1
		self.v = v1

		return p1
	end

	function Spring:Reset(pos)
		self.p = pos
		self.v = pos*0
	end
end

------------------------------------------------------------------------

local cameraPos = Vector3.new()
local cameraRot = Vector2.new()
local cameraFov = 0

local velSpring = Spring.new(VEL_STIFFNESS, Vector3.new())
local panSpring = Spring.new(PAN_STIFFNESS, Vector2.new())
local fovSpring = Spring.new(FOV_STIFFNESS, 0)

------------------------------------------------------------------------

local Input = {} do
	local thumbstickCurve do
		local K_CURVATURE = 2.0
		local K_DEADZONE = 0.15

		local function fCurve(x)
			return (exp(K_CURVATURE*x) - 1)/(exp(K_CURVATURE) - 1)
		end

		local function fDeadzone(x)
			return fCurve((x - K_DEADZONE)/(1 - K_DEADZONE))
		end

		function thumbstickCurve(x)
			return sign(x)*clamp(fDeadzone(abs(x)), 0, 1)
		end
	end

	local gamepad = {
		ButtonX = 0,
		ButtonY = 0,
		DPadDown = 0,
		DPadUp = 0,
		ButtonL2 = 0,
		ButtonR2 = 0,
		Thumbstick1 = Vector2.new(),
		Thumbstick2 = Vector2.new(),
	}

	local keyboard = {
		W = 0,
		A = 0,
		S = 0,
		D = 0,
		E = 0,
		Q = 0,
		U = 0,
		H = 0,
		J = 0,
		K = 0,
		I = 0,
		Y = 0,
		Up = 0,
		Down = 0,
		LeftShift = 0,
		RightShift = 0,
	}

	local mouse = {
		Delta = Vector2.new(),
		MouseWheel = 0,
	}

	local NAV_GAMEPAD_SPEED  = Vector3.new(1, 1, 1)
	local NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
	local PAN_MOUSE_SPEED    = Vector2.new(1, 1)*(pi/64)
	local PAN_GAMEPAD_SPEED  = Vector2.new(1, 1)*(pi/8)
	local FOV_WHEEL_SPEED    = 1.0
	local FOV_GAMEPAD_SPEED  = 0.25
	local NAV_ADJ_SPEED      = 0.75
	local NAV_SHIFT_MUL      = 0.25

	local navSpeed = 1

	function Input.Vel(dt)
		navSpeed = clamp(navSpeed + dt*(keyboard.Up - keyboard.Down)*NAV_ADJ_SPEED, 0.01, 4)

		local kGamepad = Vector3.new(
			thumbstickCurve(gamepad.Thumbstick1.x),
			thumbstickCurve(gamepad.ButtonR2) - thumbstickCurve(gamepad.ButtonL2),
			thumbstickCurve(-gamepad.Thumbstick1.y)
		)*NAV_GAMEPAD_SPEED

		local kKeyboard = Vector3.new(
			keyboard.D - keyboard.A + keyboard.K - keyboard.H,
			keyboard.E - keyboard.Q + keyboard.I - keyboard.Y,
			keyboard.S - keyboard.W + keyboard.J - keyboard.U
		)*NAV_KEYBOARD_SPEED

		local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)

		return (kGamepad + kKeyboard)*(navSpeed*(shift and NAV_SHIFT_MUL or 1))
	end

	function Input.Pan(dt)
		local kGamepad = Vector2.new(
			thumbstickCurve(gamepad.Thumbstick2.y),
			thumbstickCurve(-gamepad.Thumbstick2.x)
		)*PAN_GAMEPAD_SPEED
		local kMouse = mouse.Delta*PAN_MOUSE_SPEED
		mouse.Delta = Vector2.new()
		return kGamepad + kMouse
	end

	function Input.Fov(dt)
		local kGamepad = (gamepad.ButtonX - gamepad.ButtonY)*FOV_GAMEPAD_SPEED
		local kMouse = mouse.MouseWheel*FOV_WHEEL_SPEED
		mouse.MouseWheel = 0
		return kGamepad + kMouse
	end

	do
		local function Keypress(action, state, input)
			keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
			return Enum.ContextActionResult.Sink
		end

		local function GpButton(action, state, input)
			gamepad[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
			return Enum.ContextActionResult.Sink
		end

		local function MousePan(action, state, input)
			local delta = input.Delta
			mouse.Delta = Vector2.new(-delta.y, -delta.x)
			return Enum.ContextActionResult.Sink
		end

		local function Thumb(action, state, input)
			gamepad[input.KeyCode.Name] = input.Position
			return Enum.ContextActionResult.Sink
		end

		local function Trigger(action, state, input)
			gamepad[input.KeyCode.Name] = input.Position.z
			return Enum.ContextActionResult.Sink
		end

		local function MouseWheel(action, state, input)
			mouse[input.UserInputType.Name] = -input.Position.z
			return Enum.ContextActionResult.Sink
		end

		local function Zero(t)
			for k, v in pairs(t) do
				t[k] = v*0
			end
		end

		function Input.StartCapture()
			ContextActionService:BindActionAtPriority("FreecamKeyboard", Keypress, false, INPUT_PRIORITY,
				Enum.KeyCode.W, Enum.KeyCode.U,
				Enum.KeyCode.A, Enum.KeyCode.H,
				Enum.KeyCode.S, Enum.KeyCode.J,
				Enum.KeyCode.D, Enum.KeyCode.K,
				Enum.KeyCode.E, Enum.KeyCode.I,
				Enum.KeyCode.Q, Enum.KeyCode.Y,
				Enum.KeyCode.Up, Enum.KeyCode.Down
			)
			ContextActionService:BindActionAtPriority("FreecamMousePan",          MousePan,   false, INPUT_PRIORITY, Enum.UserInputType.MouseMovement)
			ContextActionService:BindActionAtPriority("FreecamMouseWheel",        MouseWheel, false, INPUT_PRIORITY, Enum.UserInputType.MouseWheel)
			ContextActionService:BindActionAtPriority("FreecamGamepadButton",     GpButton,   false, INPUT_PRIORITY, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY)
			ContextActionService:BindActionAtPriority("FreecamGamepadTrigger",    Trigger,    false, INPUT_PRIORITY, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2)
			ContextActionService:BindActionAtPriority("FreecamGamepadThumbstick", Thumb,      false, INPUT_PRIORITY, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2)
		end

		function Input.StopCapture()
			navSpeed = 1
			Zero(gamepad)
			Zero(keyboard)
			Zero(mouse)
			ContextActionService:UnbindAction("FreecamKeyboard")
			ContextActionService:UnbindAction("FreecamMousePan")
			ContextActionService:UnbindAction("FreecamMouseWheel")
			ContextActionService:UnbindAction("FreecamGamepadButton")
			ContextActionService:UnbindAction("FreecamGamepadTrigger")
			ContextActionService:UnbindAction("FreecamGamepadThumbstick")
		end
	end
end

local function GetFocusDistance(cameraFrame)
	local znear = 0.1
	local viewport = Camera.ViewportSize
	local projy = 2*tan(cameraFov/2)
	local projx = viewport.x/viewport.y*projy
	local fx = cameraFrame.rightVector
	local fy = cameraFrame.upVector
	local fz = cameraFrame.lookVector

	local minVect = Vector3.new()
	local minDist = 512

	for x = 0, 1, 0.5 do
		for y = 0, 1, 0.5 do
			local cx = (x - 0.5)*projx
			local cy = (y - 0.5)*projy
			local offset = fx*cx - fy*cy + fz
			local origin = cameraFrame.p + offset*znear
			local _, hit = Workspace:FindPartOnRay(Ray.new(origin, offset.unit*minDist))
			local dist = (hit - origin).magnitude
			if minDist > dist then
				minDist = dist
				minVect = offset.unit
			end
		end
	end

	return fz:Dot(minVect)*minDist
end

local function StepFreecam(dt)
	local vel = velSpring:Update(dt, Input.Vel(dt))
	local pan = panSpring:Update(dt, Input.Pan(dt))
	local fov = fovSpring:Update(dt, Input.Fov(dt))

	local zoomFactor = sqrt(tan(rad(70/2))/tan(rad(cameraFov/2)))

	cameraFov = clamp(cameraFov + fov*FOV_GAIN*(dt/zoomFactor), 1, 120)
	cameraRot = cameraRot + pan*PAN_GAIN*(dt/zoomFactor)
	cameraRot = Vector2.new(clamp(cameraRot.x, -PITCH_LIMIT, PITCH_LIMIT), cameraRot.y%(2*pi))

	local cameraCFrame = CFrame.new(cameraPos)*CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0)*CFrame.new(vel*NAV_GAIN*dt)
	cameraPos = cameraCFrame.p

	Camera.CFrame = cameraCFrame
	Camera.Focus = cameraCFrame*CFrame.new(0, 0, -GetFocusDistance(cameraCFrame))
	Camera.FieldOfView = cameraFov
end

local PlayerState = {} do
	local mouseBehavior
	local mouseIconEnabled
	local cameraType
	local cameraFocus
	local cameraCFrame
	local cameraFieldOfView

	-- Save state and set up for freecam
	function PlayerState.Push()

		cameraFieldOfView = Camera.FieldOfView
		Camera.FieldOfView = 70

		cameraType = Camera.CameraType
		Camera.CameraType = Enum.CameraType.Custom

		cameraCFrame = Camera.CFrame
		cameraFocus = Camera.Focus

		mouseIconEnabled = UserInputService.MouseIconEnabled
		UserInputService.MouseIconEnabled = false

		mouseBehavior = UserInputService.MouseBehavior
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end

	-- Restore state
	function PlayerState.Pop()

		Camera.FieldOfView = cameraFieldOfView
		cameraFieldOfView = nil

		Camera.CameraType = cameraType
		cameraType = nil

		Camera.CFrame = cameraCFrame
		cameraCFrame = nil

		Camera.Focus = cameraFocus
		cameraFocus = nil

		UserInputService.MouseIconEnabled = mouseIconEnabled
		mouseIconEnabled = nil

		UserInputService.MouseBehavior = mouseBehavior
		mouseBehavior = nil
	end
end

local FreecamEnabled

local function StartFreecam()
	FreecamEnabled = true
	local cameraCFrame = Camera.CFrame
	cameraRot = Vector2.new(cameraCFrame:toEulerAnglesYXZ())
	cameraPos = cameraCFrame.p
	cameraFov = Camera.FieldOfView

	velSpring:Reset(Vector3.new())
	panSpring:Reset(Vector2.new())
	fovSpring:Reset(0)

	PlayerState.Push()
	RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
	Input.StartCapture()
end

local function StopFreecam()
	FreecamEnabled = nil
	Input.StopCapture()
	RunService:UnbindFromRenderStep("Freecam")
	PlayerState.Pop()
end


--------------

function key( t, p )
	
	for a = 1, #t do
		
		if t[ a ] == p then return a end
		
	end
	
end

return function ( Main, ModFolder, VH_Events )
	
	ModFolder:WaitForChild( "Ping" ).OnClientInvoke = function ( ) end
	
	local Spectate = ModFolder:WaitForChild( "Spectate" )
	
	local SpectateEvent = nil
	
	local CurSpec = ( _G.VH_Saved or { } ).CurSpec or 1
	
	local Events = { }
	
	local Nametags
	
	function Nametag( Plr, Char )
		
		local Gui = script.PlrName:Clone( )
		
		Gui.TextLabel.Text = Char.Name
		
		Gui.Adornee = Char:WaitForChild( "Head" )
		
		Gui.TextLabel.Visible = Plr.Team == Players.LocalPlayer.Team
		
		Events[ #Events + 1 ] = Plr:GetPropertyChangedSignal( "Team" ):Connect( function ( )
			
			Gui.TextLabel.Visible = Plr.Team == Players.LocalPlayer.Team
			
		end )
		
		Gui.Parent = Char
		
		Nametags[ #Nametags + 1 ] = Gui
		
	end
	
	function StartNameTags( )
		
		Nametags = { }
		
		local Plrs = Players:GetPlayers( )
		
		for a = 1, #Plrs do
			
			if Plrs[ a ] ~= Players.LocalPlayer then
				
				if Plrs[ a ].Character then
					
					Nametag( Plrs[ a ], Plrs[ a ].Character )
					
				end
				
				Events[ #Events + 1 ] = Plrs[ a ].CharacterAdded:Connect( function ( Char ) Nametag( Plrs[ a ], Char ) end )
				
			end
			
		end
		
		Events[ #Events + 1 ] = Players.PlayerAdded:Connect( function ( Plr )
			
			Nametag( Plr, Plr.Character or Plr.CharacterAdded:Wait( ) )
			
			Events[ #Events + 1 ] = Plr.CharacterAdded:Connect( function ( Char ) Nametag( Plr, Char ) end )
			
		end )
		
	end
	
	function FreeCam( Pos )
		
		if SpectateEvent and SpectateEvent ~= true then
			
			SpectateEvent:Disconnect( )
			
		end
		
		if not Nametags then
			
			StartNameTags( )
			
		end
		
		if Pos then
			
			workspace.CurrentCamera.Focus = Pos
			
			workspace.CurrentCamera.CFrame = Pos
			
		end
		
		if not FreecamEnabled then
			
			StartFreecam( )
			
		end
		
		SpectateEvent = true
		
	end
	
	function EndSpec( NoRespawn )
		
		if SpectateEvent and SpectateEvent ~= true then
			
			SpectateEvent:Disconnect( )
			
		end
		
		if Nametags then
			
			for a = 1, #Events do
				
				Events[ a ]:Disconnect( )
				
				Events[ a ] = nil
				
			end
			
			for a = 1, #Nametags do
				
				Nametags[ a ]:Destroy( )
				
			end
			
			Nametags = nil
			
		end
		
		if FreecamEnabled then
			
			StopFreecam( )
			
		end
		
		SpectateEvent = nil
		
		if not NoRespawn then
			
			Spectate:FireServer( )
			
		end
		
	end
	
	function Spec( Plr )
		
		if SpectateEvent and SpectateEvent ~= true then
			
			SpectateEvent:Disconnect( )
			
		end
		
		if not Nametags then
			
			StartNameTags( )
			
		end
		
		if FreecamEnabled then
			
			StopFreecam( )
			
		end
		
		if not Plr.Character then return end
		
		local Char = Plr.Character
		
		local Hum = Char:FindFirstChildOfClass( "Humanoid" )
		
		if not Hum then return end
		
		workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
		
		workspace.CurrentCamera.CameraSubject = Hum
		
		SpectateEvent = Plr:GetPropertyChangedSignal( "Character" ):Connect( function ( )
			
			while Plr.Character ~= Char do Plr.Changed:Wait( ) end 
			
			Char = Plr.Character
			
			if not Plr.Character then return end
			
			local Hum = Plr.Character:FindFirstChildOfClass( "Humanoid" )
			
			if not Hum then return end
			
			workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
			
			workspace.CurrentCamera.CameraSubject = Hum
			
		end )
		
	end
	
	function ChangeSpec( Am )
		
		CurSpec = CurSpec + ( Am or 0 )
			
		local Plrs = Players:GetPlayers( )
		
		if CurSpec > #Plrs then
			
			CurSpec = 1
			
		elseif CurSpec <= 0 then
			
			CurSpec = #Plrs
			
		end
		
		if Plrs[ CurSpec ] == Players.LocalPlayer then
			
			if #Plrs == 1 then return end
			
			CurSpec = CurSpec + ( Am or 1 )
			
			if CurSpec > #Plrs then
				
				CurSpec = 1
				
			elseif CurSpec <= 0 then
				
				CurSpec = #Plrs
				
			end
			
		end
		
	end
	
	VH_Events:WaitForChild( "Destroyed" ).Event:Connect( function ( Update )
		
		if not Update then
			
			if SpectateEvent then
				
				EndSpec( )
				
			end
			
			return
			
		end
		
		_G.VH_Saved.CurSpec = CurSpec
		
	end )
	
	Main.Events[ #Main.Events + 1 ] = Players.LocalPlayer.CharacterAdded:Connect( EndSpec )
	
	Main.Events[ #Main.Events + 1 ] = game:GetService( "UserInputService" ).InputBegan:Connect( function ( Input, Processed )
		
		if Processed or SpectateEvent == nil then return end
		
		if Input.KeyCode == Enum.KeyCode.Space then
			
			if SpectateEvent then
				
				if SpectateEvent ~= true then
					
					FreeCam( )
					
				else
					
					ChangeSpec( 0 )
					
					local Plr = Players:GetPlayers( )[ CurSpec ]
					
					if Plr and Plr ~= Players.LocalPlayer then
						
						Spec( Plr )
						
					end
					
				end
				
			end
			
		elseif Input.KeyCode == Enum.KeyCode.Minus then
			
			ChangeSpec( -1 )
			
			local Plr = Players:GetPlayers( )[ CurSpec ]
			
			if Plr then
				
				if SpectateEvent == true or Plr == Players.LocalPlayer then
					
					FreeCam( ( Plr.Character and Plr.Character:FindFirstChild( "Head" ) or { } ).CFrame )
					
				else
					
					Spec( Plr )
					
				end
				
			end
			
		elseif Input.KeyCode == Enum.KeyCode.Equals then
			
			ChangeSpec( 1 )
			
			local Plr = Players:GetPlayers( )[ CurSpec ]
			
			if Plr then
				
				if SpectateEvent == true or Plr == Players.LocalPlayer then
					
					FreeCam( ( Plr.Character and Plr.Character:FindFirstChild( "Head" ) or { } ).CFrame )
					
				else
					
					Spec( Plr )
					
				end
				
			end
			
		end
		
	end )
	
	Spectate.OnClientEvent:Connect( function ( Plr )
		
		if Plr == nil then
			
			FreeCam( ( workspace:FindFirstChild( "SpectatePos", true ) or { } ).CFrame )
			
			CurSpec = 1
			
		elseif Plr == false then
			
			EndSpec( )
			
		elseif Plr.Character and Plr.Character:FindFirstChildOfClass( "Humanoid" ) then
			
			Spec( Plr )
			
			CurSpec = key( Players:GetPlayers( ), Plr )
			
		end
		
	end )
	
	Main.PersistentFilteredFuncs[ "Message" ] = function ( Time, Text, PlrName )
		
		local Object = Instance.new( "Message" )
		
		Object.Text = PlrName .. ": " .. Text
		
		Object.Parent = Players.LocalPlayer.PlayerGui
		
		Main.Objs[ #Main.Objs + 1 ] = Object
		
		game:GetService( "Debris" ):AddItem( Object, Time )
		
	end
	
	Main.PersistentFilteredFuncs[ "Hint" ] = function ( Time, Text, PlrName )
		
		local Object = Instance.new( "Hint" )
		
		Object.Text = PlrName .. ": " .. Text
		
		Object.Parent = Players.LocalPlayer.PlayerGui
		
		Main.Objs[ #Main.Objs + 1 ] = Object
		
		game:GetService( "Debris" ):AddItem( Object, Time )
		
	end
	
	local LockMessages = {"This server has been soft locked, if you leave you can rejoin", "The team numbers have been locked", "This server has been locked"}
	local LockHint
	Main.PersistentFilteredFuncs["LockServer"] = function(_, _, Type)
		if Type then
			LockHint = Instance.new("Hint")
			LockHint.Text = LockMessages[tonumber(Type)]
			LockHint.Parent = Players.LocalPlayer.PlayerGui
		elseif LockHint then
			LockHint:Destroy()
		end
	end
end