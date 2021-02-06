include("../shared.lua")
local Component = ents.tf2.Player

function Component:SetViewModelComponent(componentName)
	self:ResetViewModel()
	self.m_viewModelComponent = componentName
	local vm = ents.get_view_model()
	if(vm ~= nil) then vm:AddComponent(self.m_viewModelComponent) end
end

function Component:ResetViewModel()
	if(self.m_viewModelComponent ~= nil) then
		local vm = ents.get_view_model()
		if(vm ~= nil) then vm:RemoveComponent(self.m_viewModelComponent) end
		self.m_viewModelComponent = nil
	end
end

function Component:ReceiveNetEvent(eventId,packet)
	if(eventId == Component.NET_EVENT_CHANGE_CLASS) then
		local class = packet:ReadUInt32()
		self:ChangeClass(class)
	else return util.EVENT_REPLY_UNHANDLED end
	return util.EVENT_REPLY_HANDLED
end
