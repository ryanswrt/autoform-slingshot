Package.describe({
  name: "ryanswrt:autoform-slingshot",
  summary: "File upload for AutoForm with Slingshot",
  description: "File upload for AutoForm with Slingshot",
  version: "0.0.2",
  git: "http://github.com/TheAncientGoat/autoform-slingshot.git"
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
    'edgee:slingshot@0.6.2'
    ],
    'client');

  api.imply([
    'aldeed:autoform@5.3.0',
    'edgee:slingshot@0.6.2'
  ]);

  api.addFiles('lib/client/autoform-slingshot.html', 'client');
  api.addFiles('lib/client/autoform-slingshot.less', 'client');
  api.addFiles('lib/client/autoform-slingshot.coffee', 'client');
});
