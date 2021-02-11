const util      =   require("util");
const multer    =   require("multer");
const uniqid    =   require('uniqid');
const path      =   require('path');


const storage = multer.diskStorage({
    destination: function(req,file,cb){
        cb(null,(path.join(__dirname,'../../../JoynMedia/user_feeds')));
    },
    filename:function(req,file,cb){
        const match = ["video/mp4", "video/mkv"];
        if (match.indexOf(file.mimetype) === -1) {
        var message = `${file.originalname} is invalid. Only accept mp4/mkv files.`;
        return cb(message, null);
        }

        const file_extension = file.mimetype.split("/")[1];
        const file_name = uniqid()+"."+file_extension;
        cb(null,file_name)
    }
});


var uploadFiles = multer({ storage: storage,limits: { fileSize: 15728640 } }).array("multi-files", 1);
var uploadFilesMiddleware = util.promisify(uploadFiles);
module.exports = uploadFilesMiddleware;