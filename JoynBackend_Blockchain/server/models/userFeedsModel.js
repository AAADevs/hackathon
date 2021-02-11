var mongoose    =  require("mongoose");

var userFeedsSchema = new mongoose.Schema({
type                    :   {
                                type:String,
                                required:true
                            },
profile_picture         :   {
                                type:String,
                                required:true
                            },
email                   :   {
                                type:String,
                                required:true
                            },
username                :   {
                                type:String,
                                required:true
                            },
media_url               :   {
                                type:Array,
                                default:'NA'
                            },
description             :   {
                                type:String,
                                default:'NA'
                            },
likes                   :   {
                                type:Number,
                                min:0,
                                default:0,
                            },
like_details            :   {
                                type:Array,
                                default:[]

                            },
category                :   {
                                type:String,    
                                default:'NA' 
                            },
timestamp               :   {
                                type:String,
                                required:true
                            },
comments                 :  [{
                                type:mongoose.Schema.Types.ObjectId,
                                ref:'PostComment'
                            }]
});

module.exports = mongoose.model("UserFeeds",userFeedsSchema);
