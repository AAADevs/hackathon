const express           = require('express');
const router            = express.Router();
const moment            = require('moment-timezone');
const UserFeedsModel    = require("../../../models/userFeedsModel");

const {validateApiSecret,isAuthenticated} = require("../auth/authHelper");

const PicUploadController  = require("../../../controllers/PicUploadController");
const JotUploadController  = require("../../../controllers/JotUploadController");
const VibeUploadController = require("../../../controllers/VibeUploadController");


// Function to check if the provided category for a post is a valid category.

function checkForCategory(category){
    const categories = ['Funny','Pets','Arts','Sports','News','Others']
    for(let i = 0; i<categories.length; i++){
        if(categories[i]==category){
            return true;
        }
    }
}


// Posting a new Pic feed and saving data in database in the collection userfeeds

router.post('/postNewFeedPic',
    validateApiSecret,
    isAuthenticated,
    PicUploadController.multipleUpload,
    async (req,res) => {
        try{

            // Checking if description & category field are empty

            if(req.body.description == "" || req.body.description == undefined){
                return res.status(400).json({
                    error:"Input field ( description ) is not valid."
                })
            }

            if(req.body.category == "" || req.body.category == undefined){
                return res.status(400).json({
                    error:"Input field ( category ) is not valid."
                })
            }


            else{   
                // Check if the provided category for a post is a valid category.
                // If the post category is valid
                if(checkForCategory(req.body.category)){
                    const Files = req.files;
                    var files_url_array = [] 
                    
                    // Storing the image/video URL/URLs in media_url field of the schema with forEach
                    
                    Files.forEach(function(file){
                        files_url_array.push({
                            url:`http://167.71.239.221:8088/media/user_feeds/${file.filename}`,
                            type:file.mimetype,
                            originalname:file.originalname
                        });
                    })
                    
                    var new_feed ={ 
                        'type':'Pic',
                        'user_id':req.decoded.id,
                        'profile_picture':`http://167.71.239.221:8088/media/profile_picture/${req.decoded.username}.jpg`,
                        'email':req.decoded.email,
                        'media_url':files_url_array,
                        'username':req.decoded.username,
                        'description':req.body.description,
                        'category':req.body.category,
                        'timestamp':moment().format('MMMM Do YYYY, h:mm:ss a')
                    }
                    
                    
                    // Inserting into the userfeeds collection in database
                    
                    const data = await UserFeedsModel.collection.insertOne(new_feed);
                    if(data){
                        return res.status(200).json({
                            msg:"New feed posted - Pic",
                            result:true,
                            data:data.ops
                        });
                    }
                    else{
                        return res.status(400).json({
                            msg:"Failed to post a new feed",
                            result:false
                        });
                    }
                    
                }
                else {
                    //If the post category is invalid
                    return res.status(400).json({
                        msg:"Provided category value is not valid",
                        result:false
                    });
                }
            }

        }catch(err){
            return res.status(500).json({
                msg:"Failed to post a new feed",
                result:false,
                error:err
            });
        }

});



// Posting a new Jot on feed and saving data in database in the collection userfeeds

router.post('/postNewFeedJot',
    validateApiSecret,
    isAuthenticated,
    JotUploadController.multipleUpload,
    async (req,res) => {
        try{
            
            // Checking if jotText&category field is empty

            if(req.body.jotText == "" || req.body.jotText == undefined){
                return res.status(400).json({
                    error:"Input field ( jotText ) is not valid"
                })
            }

            if(req.body.category == "" || req.body.category == undefined){
                return res.status(400).json({
                    error:"Input field ( category ) is not valid."
                })
            }

            else{  

                //Checking if the jotText is below 280 characters

                if(req.body.jotText.length > 280){
                    return res.status(400).json({
                        error:"Maximum 280 characters allowed in jotText field"
                    })
                } 

                // Check if the provided category for a post is a valid category.
                // If the post category is valid
                if(checkForCategory(req.body.category)){
                    const Files = req.files;
                    var files_url_array = [];
                    
                    // Storing the image/video URL/URLs in media_url field of the schema with forEach
                    
                    Files.forEach(function(file){
                        files_url_array.push({
                            url:`http://167.71.239.221:8088/media/user_feeds/${file.filename}`,
                            type:file.mimetype,
                            originalname:file.originalname
                        });
                    })
                    
                    var new_feed = { 
                        'type':'Jot',
                        'user_id':req.decoded.id,
                        'profile_picture':`http://167.71.239.221:8088/media/profile_picture/${req.decoded.username}.jpg`,
                        'email':req.decoded.email,
                        'media_url':files_url_array,
                        'username':req.decoded.username,
                        'description':req.body.jotText,
                        'category':req.body.category,
                        'timestamp':moment().format('MMMM Do YYYY, h:mm:ss a')
                    }
                    
                    
                    // Inserting into the userfeeds collection in database
                    
                    const data = await UserFeedsModel.collection.insertOne(new_feed);

                    if(data){
                        return res.status(200).json({
                            msg:"New feed posted - Jot",
                            result:true,
                            no_of_media:data.ops[0].media_url.length,
                            data:data.ops
                        })
                    }
                    else{
                        return res.status(400).json({
                            msg:"Failed to post a new feed",
                            result:false
                        })
                    }
                    
                }
                else {
                    //If the post category is invalid
                    return res.status(400).json({
                        msg:"Provided category value is not valid",
                        result:false
                    })
                }     
            }

        }catch(err){
            return res.status(500).json({
                msg:"Failed to post a new feed",
                result:false,
                error:err
            })
        }
});



// Posting a new Vibe on feed and saving data in database in the collection userfeeds

router.post('/postNewFeedVibe',
    validateApiSecret,
    isAuthenticated,
    VibeUploadController.multipleUpload,
    async (req,res) => {
    try{

        // Checking if vibeText field is empty

        if(req.body.vibeText == "" || req.body.vibeText == undefined){
            return res.status(400).json({
                error:"Input field ( vibeText ) is not valid"
            })
        }

        else{  

            //Checking if the vibeText is below 50 characters

            if(req.body.vibeText.length > 50){
                    return res.status(400).json({
                        error:"Maximum 50 characters allowed in jotText field"
                })
            } 


            // Storing the details for Vibe video url,type and original name in the database

            var file_url_array = [{
                url:`http://167.71.239.221:8088/media/user_feeds/${req.files[0].filename}`,
                type:req.files[0].mimetype,
                originalname:req.files[0].originalname
            }];
            
            var new_feed ={ 
                'type':'Vibe',
                'user_id':req.decoded.id,
                'profile_picture':`http://167.71.239.221:8088/media/profile_picture/${req.decoded.username}.jpg`,
                'email':req.decoded.email,
                'media_url':file_url_array,
                'username':req.decoded.username,
                'description':req.body.vibeText,
                'timestamp':moment().format('MMMM Do YYYY, h:mm:ss a')
            }
            
            
            // Inserting into the userfeeds collection in database

            const data = await UserFeedsModel.collection.insertOne(new_feed);

            if(data){
                return res.status(200).json({
                    msg:"New feed posted - Vibe",
                    result:true,
                    data:data.ops
                })
            }
            else{
                return res.status(400).json({
                    msg:"Failed to post a new Vibe",
                    result:false
                });
            }  
        }
    }catch(err){
        return res.status(500).json({
            msg:"Failed to post a new Vibe",
            result:false,
            error:err
        })
    }
       

});





module.exports = router;



