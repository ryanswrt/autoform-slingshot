Autoform Slingshot
==================

Work in progress!

Pretty much a clone of [yogiben:autoform-file](https://atmospherejs.com/yogiben/autoform-file) using [edgee:slingshot](https://atmospherejs.com/edgee/slingshot) instead of CFS,

> NOTICE! There is no tests, so use at your discretion!
> We are happy for any PR containing tests, and helping this package get to 1.0.

Usage
=====

Follow Slingshot's instructions on setting up a directive, then define the following autoform rules in your schema.  If you want to resize before upload the following is an example using `thinksoftware:image-resize-client`.

### Upload a file

> The resulting field will contain the URL of the uploaded file.

```js
file: {
  type: String,
  optional:true,
  autoform: {
    type: 'slingshotFileUpload',
    afFieldInput:{
      slingshotdirective: 'myDefinedDirective'
    }
  }
}
```

### Upload a resized picture

> The resulting field will contain the URL of the uploaded picture.

We're using the Resize package from

```js
picture_url: {
  type: String,
  optional:true,
  autoform: {
    type: 'slingshotFileUpload',
    afFieldInput:{
      slingshotdirective: {
        directive: 'myDefinedDirective',
        onBeforeUpload: function(files, callback) {
          _.each( files, function(file){
            Resizer.resize(file, {width: 1020, height: 1020, cropSquare: true}, function(err, file) {
              if( err ){
                console.error( err );
                callback( file );
              }else{
                callback( file );
              }
            });
          });
        }
      }
    }
  }
}
```

### Upload a picture (with multiple resized versions)

If you want multiple sizes for a uploaded picture and **you want the client to do all the work resizing images for you**, you can now define multiple directives:

```js
picture: {
  // This package can also take type: [String],
  // but it will only save the src in the order you specified in the directives.
  type: [Object],
  label: 'Select Picture', // (optional, defaults to "Select")
  optional: true, // (optional)
  autoform: {
    type: 'slingshotFileUpload', // (required)
    removeLabel: 'Remove', // (optional, defaults to "Remove")
    afFormGroup: { // (optional)
      label: false
    },
    afFieldInput: {
      // Specify which directive to present as thumbnail using the key.
      thumbnail: 'mobile',
      slingshotdirective: {
        mobile: { // This is the key for the "mobile" version.
          directive: "myMobileDirective",
          onBeforeUpload: function(file, callback) {
            // Create a mobile 640x640 size version.
            Resizer.resize(file, {width: 640, height: 640, cropSquare: true}, function(err, file) {
              if( err ){
                console.error( err );
              }
              callback( file );
            });
          }
        },
        large: { // This is the key for the "large" version.
          directive: "myLargeDirective",
          onBeforeUpload: function(file, callback) {
            // Create a large 1500x1500 size version.
            Resizer.resize(file, {width: 1500, height: 1500, cropSquare: false}, function(err, file) {
              if( err ){
                console.error( err );
              }
              callback( file );
            });
          }
        },
        original: "myOriginalDirective"
      }
    }
  }
},
// NOTICE! This is optional.
// But without you don't store any values if using type [Object].
'picture.$.key': { type: String },
// Optional, but without you don't save the filename.
'picture.$.filename': { type: String },
// Optional, but without you don't save the src path.
'picture.$.src': { type: String },
// Optional, but without you don't save the directive.
'picture.$.directive': { type: String }
```

### Framework support

- [x] Bootstrap 3
- [x] Ionic (Meteoric)
