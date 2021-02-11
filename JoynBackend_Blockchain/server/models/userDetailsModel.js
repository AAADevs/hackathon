const { NullTemplateVisitor } = require("@angular/compiler");
var mongoose    =  require("mongoose");

var userDetailsSchema = new mongoose.Schema({
email                   :   {
                                type:String,
                                unique:true
                            },
username                :   {
                                type:String,
                                unique:true 
                            },
gender                  :   {
                                type:String,
                                default:"Not available"
                            },
nationality             :   {
                                type:String,
                                default:"Not available"
                            },
country_residence       :   {
                                type:String,
                                default:"Not available"
                            },
age                     :   {
                                type:Number,
                                default:0
                            },         
profile_picture         :   {
                                type:String,
                                default:'NA'
                            },
passbase                :   {
                                type:Boolean,
                                default:false
                            },
hederaAccountId         :   {
                                type:String,
                                default:""
                            },
privateKey              :   {
                                type:String,
                                default:""
                            },
token                   :   {
                                type:Number,
                                default:0
                            },
following               :   [{
                                type:mongoose.Schema.Types.ObjectId,
                                ref:'UserDetails'
                            }],
follower                :   [{
                                type:mongoose.Schema.Types.ObjectId,
                                ref:'UserDetails'
                            }],
currentWallpaper        :   {
                                type:String,
                                default:""
                            },
currentHomebutton       :   {
                                type:String,
                                default:""     
                            },
currentIcon             :   {
                                type:String,
                                default:""     
                            },
purchasedWallpapers     :   [{
                                type:mongoose.Schema.Types.ObjectId,
                                ref:'Assets'
                            }],
purchasedHomebuttons   :   [{
                                type:mongoose.Schema.Types.ObjectId,
                                ref:'Assets'
                            }]

});

module.exports = mongoose.model("UserDetails",userDetailsSchema);
