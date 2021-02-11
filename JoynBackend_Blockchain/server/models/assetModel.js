var mongoose    =  require("mongoose");

var assetsSchema = new  mongoose.Schema({
    name:               {
                            type:String,
                            required:true,
                            unique:true
                        },
    barColor:           {
                            type:String,
                            required:false
                        },
    price:              {
                            type:Number,
                            required:true
                        },
    type:               {
                            type:String,
                            enum:["wallpaper","homebutton","icon"]
                        },
    uploader_username:  {
                            type:String,
                            required:true,
                            default:'JoynOrignalContent'
                        },
    imageURL:           {
                            type:String,
                            required:true
                        }
});

module.exports = mongoose.model("Assets",assetsSchema);
