Package.describe({
  name: "ryanswrt:autoform-slingshot",
  summary: "File upload for AutoForm with Slingshot",
  description: "File upload for AutoForm with Slingshot",
  version: "0.0.2",
  git: "http://github.com/TheAncientGoat/autoform-slingshot.git"
});

Npm.depends({
  "async": "1.4.0"
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@1.1.0.2');

  api.use(
    [
    'coffeescript',
    'underscore',
    'templating',
    'less',
    'jquery',
    'reactive-dict',
    'aldeed:autoform@5.3.0',
    'edgee:slingshot@0.6.2',
    'cosmos:browserify@0.4.0'
    ],
    'client');

  api.addFiles([
    'lib/client/autoform-slingshot.html',
    'lib/client/autoform-slingshot.less',
    'client.browserify.js',
    'lib/client/autoform-slingshot.coffee'
  ], 'client');
});
