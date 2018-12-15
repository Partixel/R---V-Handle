local Kids = script.Parent.Parent.Parent:GetChildren( )

for a = 1, #Kids do
	
	if Kids[ a ] ~= script.Parent.Parent and Kids[ a ].Name == script.Parent.Parent.Name then
		
		wait( )
		
		script.Parent.Parent:Destroy( )
		
		return
		
	end
	
end

local Cur = 0

local RS

script.Parent.Position = UDim2.new( 0.7, -2, 1, 0 )

game["Script Context"].Error:Connect( function ( Message, Stack, Source )
	
	local Ran, FullName = pcall( function ( ) return Source:GetFullName( ) end )
	
	script.Parent.Text.Text = Ran and FullName or ( Source and tostring( Source ) or "Something" ) .. " is creating errors (F9)"
	
	local localCur = Cur + 1
	
	Cur = localCur
	
	if not RS then
		
		script.Parent:TweenPosition( UDim2.new( 0.7, -2, 0.95, -2 ), nil, nil, 0.2, true )
		
		local Start = tick( ) + math.pi / 2
		
		RS = game["Run Service"].RenderStepped:Connect( function ( )
			
			script.Parent.Position = UDim2.new( 0.7, -2, 0.95, -2 - ( 1 + math.sin( ( tick( ) - Start ) * 15 ) ) * 2 )
			
		end )
		
	end
	
	for a = 10, 0, - 1 do
		
		script.Parent.Text.TextColor3 = Color3.fromRGB( 255, 255 - a * 20, 255 - a * 20 )
		
		if Cur ~= localCur then return end
		
		wait( 0.05 )
		
	end
	
	wait( 4 )
	
	if Cur == localCur then
		
		script.Parent:TweenPosition( UDim2.new( 0.7, -2, 1, 0 ), nil, nil, 0.2, true )
		
		RS:Disconnect( )
		
		RS = nil
		
	end
	
end )