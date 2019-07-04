return function()
	local testClass = Class:New("Test")

	testClass.testVar1 = 1

	testClass.testFunction1 = function(self)
		return 1
	end

	testClass.Test = function(self)
		self.testVar2 = 2
		self.testFunction2 = function(self)
			return 2
		end

		return self
	end

	return testClass
end