var mongoose = require('mongoose');

var commentSchema = new mongoose.Schema({
    username        :   {
                            type:String,
                            default:'NA',
                            required:true
                        },
    timestamp       :   {
                            type:String,
                            default:'NA',
                            required:true
                        },
    postId          :   {
                            type:String,
                            default:'NA',
                            required:true
                        },
    comment         :   {
                            type:String,
                            default:'NA',
                            required:true
                        }
});

module.exports = mongoose.model("PostComment",commentSchema)