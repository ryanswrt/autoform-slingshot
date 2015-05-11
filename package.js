Package.describe({
  name: "ryanswrt:autoform-slingshot",
  summary: "File upload for AutoForm with Slingshot",
  description: "File upload for AutoForm with Slingshot",
  version: "0.0.1",
  git: "http://github.com/TheAncientGoat/autoform-slingshot.git"
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@1.0');

  api.use(
    [
    'coffeescript',
    'underscore',
    'templating',
    'less',
    'aldeed:autoform@4.2.2 || 5.1.2',
    'edgee:slingshot@0.6.2'
    ],
    'client');

  api.addFiles('lib/client/autoform-slingshot.html', 'client');
  api.addFiles('lib/client/autoform-slingshot.less', 'client');
  api.addFiles('lib/client/autoform-slingshot.coffee', 'client');
}); 
