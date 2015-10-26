SRC = lib/*.js

REQUIRED = --require should --require should-http

TESTS-NEXT := $(wildcard test/**/*.next.js)
TESTS := $(filter-out $(TESTS-NEXT), $(wildcard test/**/*.js))

lint:
	@./node_modules/.bin/eslint lib test

test:
	@NODE_ENV=test node \
		./node_modules/.bin/_mocha \
		$(REQUIRED) \
		$(TESTS) \
		--bail

test-next:
	@NODE_ENV=test node \
		./node_modules/.bin/_mocha \
		--compilers js:babel/register \
		$(REQUIRED) \
		$(TESTS-NEXT) \
		--bail

test-cov:
	@NODE_ENV=test node \
		./node_modules/.bin/istanbul cover \
		./node_modules/.bin/_mocha \
		-- \
		$(REQUIRED) \
		$(TESTS) \
		--bail


test-next-cov:
	@NODE_ENV=test node \
		./node_modules/.bin/istanbul cover \
		./node_modules/.bin/_mocha \
		-- --compilers js:babel/register \
		-u exports \
		$(REQUIRED) \
		$(TESTS-NEXT) \
		--bail

test-travis: lint
	@NODE_ENV=test node \
		./node_modules/.bin/istanbul cover \
		./node_modules/.bin/_mocha \
		--report lcovonly \
		-- \
		$(REQUIRED) \
		$(TESTS) \
		--bail

bench:
	@$(MAKE) -C benchmarks

.PHONY: lint test bench
