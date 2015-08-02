Package.describe({
  name: "timbrandin:autoform-slingshot",
  summary: "File upload for AutoForm with Slingshot",
  description: "File upload for AutoForm with Slingshot",
  version: "1.0.0",
  git: "http://github.com/timbrandin/autoform-slingshot.git"
});

Npm.depends({
  "async": "1.4.0"
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@1.1.0.2');

  api.use([
    'coffeescript',
    'underscore',
    'templating',
    'less',
    'jquery',
    'reactive-dict',
    'aldeed:autoform@5.3.0',
    'edgee:slingshot@0.6.2',
    'cosmos:browserify@0.4.0',
    "tap:i18n@1.5.1"
  ], 'client');

  api.imply('tap:i18n');
  api.addFiles('i18n/package-tap.i18n', ["client", "server"]);

  api.addFiles([
    'lib/client/autoform-slingshot.html',
    'lib/client/autoform-slingshot.less',
    'client.browserify.js',
    'lib/client/autoform-slingshot.coffee'
  ], 'client');

  api.add_files([
    "i18n/en.i18n.json",
    "i18n/sv.i18n.json"
  ], ["client", "server"]);
});
