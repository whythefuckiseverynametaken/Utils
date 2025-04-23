local Timer = {}

-- This module is for custom timers — like countdowns that run while your game loop continues.

function Timer.new(duration)
	local self = setmetatable({}, Timer)
	self.Duration = duration
	self.Elapsed = 0
	self.Running = false
	return self
end

function Timer:start()
	self.Elapsed = 0
	self.Running = true
end

function Timer:update(dt)
	if self.Running then
		self.Elapsed = self.Elapsed + dt
		if self.Elapsed >= self.Duration then
			self.Running = false
			if self.OnComplete then
				self:OnComplete()
			end
		end
	end
end

function Timer:isFinished()
	return not self.Running
end

function Timer:onComplete(callback)
	self.OnComplete = callback
end

return Timer