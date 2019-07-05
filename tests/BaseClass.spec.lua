return function()
	local Class = require(script.Parent.Parent.src.BaseClass)

	describe("Class checking", function()
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

			expect(function()
				testClass()
			end).never.to.throw()
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

			testClass1.testVar1 = true

			testClass1.Test1 = function(self)
				return self
			end

			testClass1.testFunction = function(self)
				return true
			end

			testClass1()

			local testClass2 = testClass1:Extend("Test2")

			testClass2.testVar2 = true

			testClass2.testFunction2 = function(self)
				return true
			end

			expect(testClass2.testVar1).to.equal(true)
			expect(testClass2.testVar2).to.equal(true)

			expect(testClass2:testFunction()).to.equal(true)
			expect(testClass2:testFunction2()).to.equal(true)

			expect(testClass2:isA("Test1")).to.equal(true)
		end)

		it("Able to be locked", function()
			local testClass = Class:New("Test")

			testClass.testVar1 = 1
			testClass.testTable1 = {
				["test"] = true,
				["testTable2"] = {
					["test"] = true
				}
			}

			local lockedTestClass = testClass:Lock()

			expect(lockedTestClass.testVar1).to.equal(1)
			expect(lockedTestClass["testTable1"]["test"]).to.equal(true)

			print(getmetatable(lockedTestClass.testVar1))

			expect(getmetatable(lockedTestClass["testTable1"])).to.equal("Locked.")
			expect(getmetatable(lockedTestClass["testTable1"]["testTable2"])).to.equal("Locked.")
			expect(getmetatable(lockedTestClass)).to.equal("Locked.")

			expect(tostring(lockedTestClass)).to.be.a("string")

			expect(function()
				lockedTestClass.testVar2 = 2
			end).to.throw()

			expect(function()
				lockedTestClass["testTable1"]["test1"] = false
			end).to.throw()

			expect(function()
				lockedTestClass["testTable1"]["test"] = false
			end).to.throw()

			expect(function()
				lockedTestClass["testTable1"]["tesTable2"]["test"] = false
			end).to.throw()

			expect(lockedTestClass.testVar2).never.to.be.ok()
			expect(lockedTestClass["testTable1"]["test1"]).never.to.equal(false)
			expect(lockedTestClass["testTable1"]["test"]).never.to.equal(false)
			expect(lockedTestClass["testTable1"]["testTable2"]["test"]).never.to.equal(false)
		end)
	end)

	describe("Function checking", function()
		it("Able to be checked against", function()
			local testClass = Class:New("Test")

			testClass.Test = function(self)
				return self
			end

			expect(testClass() == testClass).to.equal(true)
		end)

		it("Non equal classes should return false", function()
			local testClass = Class:New("Test")

			expect(testClass == {}).to.equal(false)
		end)

		it("IsA should return false if not inherited class", function()
			local testClass = Class:New("Test")

			expect(testClass:isA("TestParent")).to.equal(false)
		end)

		it("Non registered classes should not be registered", function()
			expect(Class.Registered({})).to.equal(false) -- Saves creating another class
		end)
	end)

	describe("Error checking", function()
		it("New class should fail with incorrect arguments", function()
			expect(function()
				Class:New({})
			end).to.throw()
		end)

		it("Extend should fail with wrong arguments", function()
			local testClass = Class:New("Test")

			expect(function()
				testClass.Extend({})
			end).to.throw()

			expect(function()
				testClass:Extend({
					["ClassName"] = "fail"
				})
			end).to.throw()
		end)
	end)
end