Package.describe({
	name: "velocity:test-proxy",
	summary: "Dynamically created package to expose test files to mirrors",
	version: "0.0.4",
	debugOnly: true
});

Package.on_use(function (api) {
	api.use("coffeescript", ["client", "server"]);
	api.add_files("tests/mocha/client/increment_decrement_spec.coffee",["client"]);
	api.add_files("tests/mocha/client/sampleClientTest.coffee",["client"]);
	api.add_files("tests/mocha/server/charger_server_doc_spec.coffee",["server"]);
	api.add_files("tests/mocha/server/charger_server_spec.coffee",["server"]);
	api.add_files("tests/mocha/server/sampleServerTest.coffee",["server"]);
});