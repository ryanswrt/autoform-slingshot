Autoform Slingshot
==================

Work in progress!

Pretty much a clone of [yogiben:autoform-file](https://atmospherejs.com/yogiben/autoform-file) using [edgee:slingshot](https://atmospherejs.com/edgee/slingshot) instead of CFS, very hacky and has a lot of dead code from the porting process, no tests either, so use at your discretion!

Usage
=====

Follow Slingshot's instructions on setting up a directive, then define the following autoform rules in your schema.  If you want to resize before upload the following is an example using `thinksoftware:image-resize-client`.

```
picture_url:
    type: String,
    optional:true,
    autoform: {
      afFieldInput:{
        type: 'slingshotFileUpload',
        slingshotdirective: 'myDefinedDirective'
        onBeforeUpload: function(files, callback){
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
```

The resulting field will contain the URL of the uploaded file
