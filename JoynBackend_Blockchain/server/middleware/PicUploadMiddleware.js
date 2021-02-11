const util      =   require("util");
const multer    =   require("multer");
const uniqid    =   require('uniqid');
const path      =   require('path');


const storage = multer.diskStorage({
    destination: function(req,file,cb){
        cb(null,(path.join(__dirname,'../../../JoynMedia/user_feeds')));
    },
    filename:function(req,file,cb){
        const file_type = file.mimetype.split("/")[1];
        const file_name = uniqid()+"."+file_type;
        cb(null,file_name)
    }
});

var uploadFiles = multer({ storage: storage }).array("multi-files", 10);
var uploadFilesMiddleware = util.promisify(uploadFiles);
module.exports = uploadFilesMiddleware;