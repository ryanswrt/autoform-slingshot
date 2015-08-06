Package.describe({
  name: "ryanswrt:autoform-slingshot",
  summary: "File upload for AutoForm with Slingshot",
  description: "File upload for AutoForm with Slingshot",
  version: "1.1.1",
  git: "https://github.com/TheAncientGoat/autoform-slingshot"
});

Package.onUse(function(api) {
  configure(api);
});

function configure(api) {
  api.versionsFrom('METEOR@1.1.0.2');

  api.use([
    'coffeescript',
    'underscore',
    'templating',
    'less',
    'jquery',
    'aldeed:autoform@5.3.0',
    'edgee:slingshot@0.6.2',
    "tap:i18n@1.5.1"
  ], ['client', 'server']);

  api.imply([
    'aldeed:autoform',
    'edgee:slingshot',
    'tap:i18n'
  ]);

  api.addFiles('i18n/package-tap.i18n', ["client", "server"]);

  api.addFiles([
    'lib/client/autoform-slingshot.html',
    'lib/client/autoform-slingshot.less',
    'lib/client/autoform-slingshot.coffee'
  ], 'client');

  api.add_files([
    "i18n/en.i18n.json",
    "i18n/sv.i18n.json"
  ], ["client", "server"]);

  api.export('SwapTemp');
});
