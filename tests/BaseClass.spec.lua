return function()
	local BaseClass = require(script.Parent.Parent.src.BaseClass)

	describe("BaseClass", function()
		it("Able to create a class", function()
			local testClass = Class:New("Test")

			expect(testClass).to.be.ok()
			expect(testClass:Registered()).to.equal(true)
		end)

		it("Able to have an init function", function()
			local testClass = Class:New("Test")

			testClass.Test = function(self)
				return self
			end

			expect(testClass.Test).to.be.a("function")
			expect(testClass().equals(testClass)).to.equal(true)
		end)

		it("Able to have a variable", function()
			local testClass = Class:New("Test")

			testClass.Test = function(self)
				self.testVar = true

				return self
			end

			expect(testClass().testVar).to.equal(true)
		end)

		it("Able to have a function", function()
			local testClass = Class:New("Test")

			testClass.testFunction = function(self)
				return true
			end

			expect(testClass:testFunction()).to.equal(true)
		end)

		it("Able to be extended", function()
			local testClass1 = Class:New("Test1")

			testClass.Test1 = function(self)
				self.testVar1 = true

				return self
			end

			testClass.testFunction = function(self)
				return true
			end

			testClass1()

			local testClass2 = testClass1:Extend("Test2")

			testClass.testFunction2 = function(self)
				return true
			end

			expect(testClass2.testVar1).to.equal(true)
			expect(testClass2.testFunction).to.equal(true)
			expect(testClass2.testFunction2).to.equal(true)
			expect(testClass2:isA("Test1")).to.equal(true)
		end)

		it("Able to be locked", function()
			local testClass = Class:New("Test")

			testClass.Test = function(self)
				self.testVar = 1

				return self
			end

			local lockedTestClass = testClass:Lock()

			expect(lockedTestClass.testVar).to.equal(1)
			expect(getmetatable(lockedTestClass).__metatable).to.equal("Locked.")
			expect(function()
				lockedTestClass.testVar2 = 2
			end).to.throw()
			expect(lockedTestClass.testVar2).never.to.be.ok()
		end)
	end)
end