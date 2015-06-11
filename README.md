Autoform Slingshot
==================

Work in progress!

Pretty much a clone of [yogiben:autoform-file](https://atmospherejs.com/yogiben/autoform-file) using [edgee:slingshot](https://atmospherejs.com/edgee/slingshot) instead of CFS, very hacky and has a lot of dead code from the porting process, no tests either, so use at your discretion!

Usage
=====

Follow Slingshot's instructions on setting up a directive, then define the following autoform rules in your schema

```
picture_url:
    type: String,
    optional:true,
    autoform: {
      afFieldInput:{
        type: 'slingshotFileUpload',
        slingshotdirective: 'myDefinedDirective'
        onBeforeUpload: function(files){return files} // Synchronous transform for files from the upload field before upload.
        }
    }
```

The resulting field will contain the URL of the uploaded file
