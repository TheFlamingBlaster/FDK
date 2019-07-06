return function()
	local BaseClass = require(script.Parent.Parent.src.BaseClass)
	local TestClass = BaseClass:new("TestClass")
	local TestClass2 = TestClass:extend("TestClass2")

	describe("Class", function()
		it("Should be ok", function()
			expect(TestClass).to.be.ok()
		end)

		it("Init function should be ok", function()
			TestClass.TestClass = function(self)
				return self
			end

			expect(function()
				TestClass()
			end).never.to.throw()
		end)

		it("Variables should be ok", function()
			TestClass.testVar1 = true

			expect(TestClass.testVar1).to.equal(true)
		end)

		it("Functions should be ok", function()
			TestClass.testFunction1 = function(self)
				return true
			end

			expect(TestClass.testFunction1()).to.equal(true)
		end)

		describe("Function", function()
			it("Registered should work", function()
				expect(TestClass:registered()).to.equal(true)
				expect(BaseClass:registered(TestClass)).to.equal(true)
			end)

			it("IsA should work", function()
				expect(TestClass2:isA("TestClass")).to.equal(true)
			end)

			it("Equals should work", function()
				expect(TestClass2 == TestClass).to.equal(true)
			end)

			describe("Metamethod", function()
				TestClass2.__unm = function() return true end
				TestClass2.__add = function() return true end
				TestClass2.__sub = function() return true end
				TestClass2.__mul = function() return true end
				TestClass2.__div = function() return true end
				TestClass2.__mod = function() return true end
				TestClass2.__pow = function() return true end

				it("Unary", function()
					expect(-TestClass2).to.equal(true)
				end)

				it("Add", function()
					expect(TestClass2 + 1).to.equal(true)
				end)

				it("Subtract", function()
					expect(TestClass2 - 1).to.equal(true)
				end)

				it("Multiply", function()
					expect(TestClass2 * 1).to.equal(true)
				end)

				it("Divide", function()
					expect(TestClass2 / 1).to.equal(true)
				end)

				it("Modulus", function()
					expect(TestClass2 % 1).to.equal(true)
				end)

				it("Exponet", function()
					expect(TestClass2^1).to.equal(true)
				end)
			end)
		end)

		describe("Extend", function()
			it("Should be ok", function()
				expect(TestClass2).to.be.ok()
			end)

			it("Should work in init function", function()
				TestClass.TestClass = function(self)
					self.testInitVar1 = true

					return self
				end

				expect(TestClass().testInitVar1).to.equal(true)
			end)

			it("Should carry over variables", function()
				TestClass.testExtendVar1 = true

				expect(TestClass:extend("ExtendTestClass").testExtendVar1).to.equal(true)
			end)

			it("Should carry over functions", function()
				TestClass.testExtendFunction1 = function()
					return true
				end

				expect(TestClass:extend("ExtendTestClass2").testExtendFunction1()).to.equal(true)
			end)
		end)

		describe("Lock", function()
			local TestClass3 = BaseClass:new("TestClass3")

			TestClass3.testVar1 = true
			TestClass3.testTable1 = {
				["test"] = true,
				["testTable2"] = {
					["test"] = true
				}
			}

			TestClass3.TestClass3 = function(self)
				self.callWorks = true

				return self
			end

			local LockedClass3 = TestClass3:lock()
			local LockedMetamethodClass = TestClass2:lock()

			it("Should be ok", function()
				expect(LockedClass3).to.be.ok()
			end)

			it("Should access variables correctly", function()
				expect(LockedClass3.testVar1).to.equal(true)
				expect(LockedClass3.testTable1.test).to.equal(true)
			end)

			it("Should have all tables locked", function()
				expect(getmetatable(LockedClass3)).to.equal("B-Locked.")
				expect(getmetatable(LockedClass3["testTable1"])).to.equal("B-Locked.")
				expect(getmetatable(LockedClass3["testTable1"]["testTable2"])).to.equal("B-Locked.")
			end)

			it("Should throw on newindex", function()
				expect(function()
					LockedClass3.testVar2 = 2
				end).to.throw()

				expect(function()
					LockedClass3.testTable1.test1 = false
				end).to.throw()

				expect(function()
					LockedClass3.testTable1.test = false
				end)

				expect(function()
					LockedClass3.testTable1.testTable2.test = false
				end)
			end)

			it("Should use the init function correctly", function()
				expect(LockedClass3()["callWorks"]).to.equal(true)
			end)

			describe("Metamethods", function()
				it("Unary", function()
					expect(-LockedMetamethodClass).to.equal(true)
				end)

				it("Add", function()
					expect(LockedMetamethodClass + 1).to.equal(true)
				end)

				it("Subtract", function()
					expect(LockedMetamethodClass - 1).to.equal(true)
				end)

				it("Multiply", function()
					expect(LockedMetamethodClass * 1).to.equal(true)
				end)

				it("Divide", function()
					expect(LockedMetamethodClass / 1).to.equal(true)
				end)

				it("Modulus", function()
					expect(LockedMetamethodClass % 1).to.equal(true)
				end)

				it("Exponet", function()
					expect(LockedMetamethodClass^1).to.equal(true)
				end)
			end)
		end)

		describe("Error checking", function()
			it("New class should fail with incorrect arguments", function()
				expect(function()
					BaseClass:New({})
				end).to.throw()
			end)

			it("Extend should fail with wrong arguments", function()
				local testClassFail = BaseClass:new("Test")

				expect(function()
					testClassFail.Extend({})
				end).to.throw()

				expect(function()
					testClassFail:Extend({
						["ClassName"] = "fail"
					})
				end).to.throw()
			end)

			it("Init function should fail with wrong class constructor", function()
				local testClassFail = BaseClass:new("Test")

				testClassFail.Test = function(self)
					return self
				end

				testClassFail["className"] = 'asdasdasdasd'

				expect(function()
					testClassFail()
				end).to.throw()
			end)

			it("Init function should fail with init function given", function()
				local testClassFail = BaseClass:new("Test")

				testClassFail.Test = 'asd'

				expect(function()
					testClassFail()
				end).to.throw()
			end)
		end)
	end)
end