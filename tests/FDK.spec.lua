return function()
	local FDK = require(script.Parent.Parent.src.FDK)
	FDK:wrapEnvironment(getfenv())

	local testClass = import("FDKTestClass")

	describe("FDK", function()
		it("The enviroment should be wrapped properly", function()
			expect(import).to.be.a("function")
			expect(new).to.be.a("function")

			expect(BaseClass).to.be.a("table")
		end)

		it("Import should import correctly", function()
			expect(testClass).to.be.a("table")

			expect(testClass.testVar1).to.equal(1)
			expect(testClass.testFunction1()).to.equal(1)
		end)

		it("Initalizing the class should create a extended class properly", function()
			local extendedTestClass = testClass()

			expect(extendedTestClass.testVar1).to.equal(1)
			expect(extendedTestClass.testVar2).to.equal(2)

			expect(extendedTestClass.testFunction1()).to.equal(1)
			expect(extendedTestClass.testFunction2()).to.equal(2)
		end)

		it("importing FDK should just give FDK", function()
			expect(import("FDK").wrapEnvironment).to.be.ok()
		end)

		it("importing BaseClass should give BaseClass", function()
			expect(import("BaseClass").lock).to.be.ok()
		end)
	end)

	describe("Function errors", function()
		it("should fail with incorrect arguments in import", function()
			expect(function()
				import({ })
			end).to.throw()
		end)

		it("should fail with nonexisent package", function()
			expect(function()
				import("bad.megabad")
			end).to.throw()
		end)

		it("should fail bad modulescript", function()
			expect(function()
				import("FDKBadClass")
			end).to.throw()
		end)

		it("should fail on incorrect Instance", function()
			expect(function()
				local newInstance = Instance.new("BoolValue")
				newInstance.Parent = script.Parent

				import("Value")
			end).to.throw()
		end)

		it("should fail on incorrect arguments in WrapEnv", function()
			expect(function()
				FDK.WrapEnv(1)
			end).to.throw()
		end)
	end)
end