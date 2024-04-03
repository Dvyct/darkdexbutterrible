-- Create a ScreenGui to hold the GUI elements
local gui = Instance.new("ScreenGui")
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create a function to toggle the visibility of children
local function toggleChildrenVisibility(listItem)
	local children = listItem:GetChildren()
	for _, child in ipairs(children) do
		if child:IsA("Frame") and child.Name == "ChildrenContainer" then
			child.Visible = not child.Visible
		end
	end
end

-- Create a function to update the button text
local function updateButtonText(button, isVisible)
	button.Text = isVisible and "<" or ">"
end

-- Recursive function to create GUI list for the hierarchy of objects in the workspace
local function createListHierarchy(object, parent, indent)
	indent = indent or 0

	-- Create a BoxFrame to hold the list item
	local listItem = Instance.new("Frame")
	listItem.Name = "ListItem"
	listItem.Size = UDim2.new(1, 0, 0, 20)
	listItem.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	listItem.Parent = parent

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "NameLabel"
	nameLabel.Size = UDim2.new(1, -20, 1, 0)
	nameLabel.Position = UDim2.new(0, 20 * indent, 0, 0)
	nameLabel.Text = string.rep("  ", indent) .. object.Name
	nameLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Parent = listItem

	-- Check if the object has children
	local children = object:GetChildren()
	if #children > 0 then
		-- If it has children, create a button to toggle their visibility
		local toggleButton = Instance.new("TextButton")
		toggleButton.Name = "ToggleButton"
		toggleButton.Size = UDim2.new(0, 20, 0, 20)
		toggleButton.Position = UDim2.new(0, 20 * (indent + 1), 0, 0)
		toggleButton.Text = ">"
		toggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		toggleButton.BackgroundTransparency = 1
		toggleButton.Parent = listItem
		toggleButton.MouseButton1Click:Connect(function()
			toggleChildrenVisibility(listItem)
			updateButtonText(toggleButton, listItem.ChildrenContainer.Visible)
		end)

		-- Create a container for children
		local childrenContainer = Instance.new("Frame")
		childrenContainer.Name = "ChildrenContainer"
		childrenContainer.Size = UDim2.new(1, 0, 0, 0)
		childrenContainer.Position = UDim2.new(0, 20, 0, 20)
		childrenContainer.BackgroundTransparency = 1
		childrenContainer.Visible = false
		childrenContainer.Parent = listItem

		-- Add UIListLayout to the container
		local listLayout = Instance.new("UIListLayout")
		listLayout.Parent = childrenContainer
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder

		-- Recursively create GUI list for children
		for _, child in ipairs(children) do
			createListHierarchy(child, childrenContainer, indent + 1)
		end
	end
end

-- Create a frame to contain the list
local listContainer = Instance.new("Frame")
listContainer.Name = "ListContainer"
listContainer.Size = UDim2.new(0.5, 0, 0.5, 0)
listContainer.Position = UDim2.new(0.25, 0, 0.25, 0)
listContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
listContainer.BorderSizePixel = 2
listContainer.Parent = gui

-- Create a scrolling frame to contain the list
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, -20, 1, -40)
scrollFrame.Position = UDim2.new(0, 10, 0, 10)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 16
scrollFrame.Parent = listContainer

-- Add UIListLayout to the scrolling frame
local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollFrame
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Start creating GUI list hierarchy from the workspace
createListHierarchy(game.Workspace, scrollFrame)

-- Connect a function to update the CanvasSize of the scrolling frame
scrollFrame:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollFrame.UIListLayout.AbsoluteContentSize.Y)
end)

-- Create an X button to delete the GUI
local xButton = Instance.new("TextButton")
xButton.Name = "CloseButton"
xButton.Size = UDim2.new(0, 50, 0, 20)
xButton.Position = UDim2.new(0.5, -25, 1, 5)
xButton.Text = "X"
xButton.TextColor3 = Color3.fromRGB(255, 0, 0)
xButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
xButton.BorderSizePixel = 2
xButton.Parent = listContainer
xButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
