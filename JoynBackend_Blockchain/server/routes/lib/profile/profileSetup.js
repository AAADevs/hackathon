const express  = require('express');
const router   = express.Router();
const multer   = require('multer');
const path      =   require('path');
const UserDetailsModel = require("../../../models/userDetailsModel");
const { body, validationResult } = require("express-validator");
const {validateApiSecret,isAuthenticated}=require("../auth/authHelper");



// Get user details from user_details collection

router.post('/getUserDetails',
    validateApiSecret,
    isAuthenticated,
    body('email').not().isEmpty(),
    async(req,res)=>{
        try{
            //Input field validation
            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(422).json({
                    error: errors.array()[0],
                });
            }

            //Fetching user data from the database
            const data = await UserDetailsModel.find({email:req.body.email})
            
            if(data.length > 0){
                return res.status(200).json({
                    result:true,
                    data})
            }
            else{
                return res.status(401).json({
                    result:false,
                    msg:"No user found"
                })   
            }
        }catch(err){
            console.log(err);
            return res.status(500).json({
                result:false,
                msg:"Error geting user details"
            })   
        }
});

// The reason we are creating two API is to ensure that the user is only quering the data that he needs 
// for his specific function and not waste valuable user network data. 

// Get user details + connections data from user_details collection

router.post('/getUserConnections',
    validateApiSecret,
    isAuthenticated,
    body('email').not().isEmpty(),
    async(req,res)=>{
        try{
            //Input field validation
            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(422).json({
                    error: errors.array()[0],
                });
            }

            //Fetching user data with followers and following data from the database
            const data = await UserDetailsModel
                .find({email:req.body.email})
                .populate('following')
                .populate('follower');
            if(data.length > 0){
                return res.status(200).json({
                    result:true,
                    data})
            }
            else{
                return res.status(401).json({
                    result:false,
                    msg:"No user found"
                })   
            }
        }catch(err){
            console.log(err);
            return res.status(500).json({
                result:false,
                msg:"Error geting user details"
            })   
        }
});





// Multer setup for profile picture update

const storage = multer.diskStorage({
    destination: function(req,file,cb){
        cb(null,(path.join(__dirname,'../../../../../JoynMedia/profile_picture')));
    },
    filename:function(req,file,cb){
        const file_name = req.headers.username +".jpg";
        cb(null,file_name)
    }
});

const upload = multer({storage:storage});


// Upload profile image to DigitalOcean and save the file url to Database

router.post('/uploadProfilePicture',
    validateApiSecret,
    upload.single('image'),
    async(req,res) => {
        try{
            // Checking if image,email or username field is empty

            if(req.file == undefined || req.file.size == 0){
                return res.status(401).json({
                    error:"No valid image is provided"
                })
            }
            if(req.body.email == "" || req.body.email == undefined){
                return res.status(401).json({
                    error:"Input field email is not valid"
                })
            }
            if(req.headers.username == "" || req.headers.username == undefined){
                return res.status(401).json({
                    error:"Input field username is not valid"
                })
            }
            else{   
                const image_url = `http://167.71.239.221:8088/media/profile_picture/${req.file.filename}`;

                //  Update the profile picture URL to the profile_picture in userdetails collection

                const userDetails = await UserDetailsModel.findOneAndUpdate(
                    {'email':req.body.email},
                    {'profile_picture':image_url}
                );

                if(userDetails){
                    return res.status(200).json({
                        msg:"Profile picture saved",
                        image_url:image_url,
                        result:true
                    })
                }
                else if(userDetails == null){
                    return res.status(401).json({
                        msg:"No user found with given email",
                        result:false
                    });
                }

            }
        }
        catch(err){
            console.log(err);
            return res.status(500).json({
                result:false,
                msg:"Error updating user profile picture"
            })   
        }
})



// Save to database that the user is Passbase verified

router.post('/passbaseVerified',
    validateApiSecret,
    body('email').not().isEmpty(),
    async (req,res) => {
        try{
            //Input field validation
            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(422).json({
                    error: errors.array()[0],
                });
            }

            //Update users passbase status
            const userDetails = await UserDetailsModel.findOneAndUpdate(
                {'email':req.body.email},
                {'passbase':true}
            );

            if(userDetails){
                   return res.status(200).json({
                    result:true,
                    msg:"Saved to database"
                })
            }
            else if(userDetails == null){
                return res.status(401).json({
                    result:false,
                    msg:"No user found for given Email_id"
                })
            }
        }
        catch(err){
            res.status(500).json({
                result:false,
                msg:"Failed to update the passbase status"
            })
        }

});


// Follow a user on Joyn platform 

//How the API works
//First:
//Check if the user you want to follow exists
//Second:
//Inserting the object id of the account you want to follow in your (following) array in database.
//Third:
//Inserting your account object id in the (follower) array of the account you want to follow in database.

router.post('/followUser',
    validateApiSecret,
    isAuthenticated,
    body('user_id').not().isEmpty(),
    async (req,res) => {
        try{
            //Input field validation
            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(422).json({
                    error: errors.array()[0],
                });
            }

            //Check if the user you want to follow exists
            const userYouWantToFollow = await UserDetailsModel.findById(req.body.user_id);
            
            //If the user exists
            if(userYouWantToFollow){
                
                // Inserting the object id of the user's account you want to follow in the (following) field array.
                const userDetails = await UserDetailsModel.findOneAndUpdate(
                    {email    :   req.decoded.email},
                    {$addToSet  :   {
                        following:req.body.user_id
                    }
                    },
                );
                console.log(userDetails);

                // If your account is found
                if(userDetails){

                    // Inserting your account object id in the (follower) field array of the users account you want to follow.
                    const followAccountDetails = await UserDetailsModel.findOneAndUpdate(
                        {_id    :   req.body.user_id},
                        {$addToSet  :   {
                            follower: userDetails._id
                        }
                        },
                    );

                    // If the account you want to follow is found 
                    if(followAccountDetails){
                        return res.status(200).json({
                            msg:`You are now following ${req.body.user_id}.`,
                            result:true
                        })
                    }

                    // If the account you want to follow is not found 
                    else{
                        return res.status(401).json({
                            msg:`There was a problem following the user.`,
                            result:false
                        })
                    }
                }
                //If your account is not found
                else{
                    return res.status(404).json({
                        msg:`User ${req.decoded.email} is not found.`,
                        result:false
                    })
                }
            }

            //If the user you want to follow does not exist.
            else{
                return res.status(404).json({
                    msg:`User ${req.body.user_id} is not found.`,
                    result:false
                })
            }
        }
        catch(err){
            console.log(err);
            return res.status(500).json({
                msg:'There was a problem following the user',
                result:false
            })
        }
});




// Unfollow a user on Joyn platform 

//How the API works
//First:
//Check if the user you want to unfollow exists
//Second:
//Removing the object id of the user's account you want to unfollow from the (following) field array.
//Third:
//Removing your account object id from the (follower) field array of the users account you want to unfollow.

router.post('/unFollowUser',
    validateApiSecret,
    isAuthenticated,
    body('user_id').not().isEmpty(),
    async (req,res) => {
        try{
            //Input field validation
            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(422).json({
                    error: errors.array()[0],
                });
            }

            //Check if the user you want to unfollow exists
            const userYouWantToUnFollow = await UserDetailsModel.findById(req.body.user_id);

            //If the user exists
            if(userYouWantToUnFollow){
                
                // Removing the object id of the user's account you want to unfollow from the (following) field array.
                const userDetails = await UserDetailsModel.findOneAndUpdate(
                    {email    :   req.decoded.email},
                    {$pull  :   {
                        following:req.body.user_id
                    }
                    },
                );

                // If your account is found
                if(userDetails){

                    // Removing your account object id from the (follower) field array of the users account you want to unfollow.
                    const followAccountDetails = await UserDetailsModel.findOneAndUpdate(
                        {_id    :   req.body.user_id},
                        {$pull  :   {
                            follower: userDetails._id
                        }
                        },
                    );

                    // If the account you want to unfollow is found 
                    if(followAccountDetails){
                        return res.status(200).json({
                            msg:`You unfollowed ${req.body.user_id}.`,
                            result:true
                        })
                    }

                    // If the account you want to unfollow is not found 
                    else{
                        return res.status(401).json({
                            msg:`There was a problem unfollowing the user.`,
                            result:false
                        })
                    }
                }
                //If your account is not found
                else{
                    return res.status(404).json({
                        msg:`User ${req.decoded.email} is not found.`,
                        result:false
                    })
                }
            }

            //If the user you want to unfollow does not exist.
            else{
                return res.status(404).json({
                    msg:`User ${req.body.user_id} is not found.`,
                    result:false
                })
            }
        }
        catch(err){
            console.log(err);
            return res.status(500).json({
                msg:'There was a problem unfollowing the user',
                result:false
            })
        }
    }
);


// Search for a user in the database

/* Since we are using regular expression in this API,we will get 
the best result for input strings that have length greater than 2 */

//Search is case insensitive at this moment

router.post('/searchUsers',
    [body('username').not().isEmpty()],
    validateApiSecret,
    isAuthenticated,
    async (req,res)=>{
        try{
            //Input field validation
            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(422).json({
                    error: errors.array()[0],
                });
            }

            //Using regular expression for fetching matching usernames from the database.
            const usersDetails = await UserDetailsModel.find({
                "username":{"$regex":req.body.username,"$options":"i"}
            });

            //If user/users for the username is/were found
            if(usersDetails.length>0){
                return res.status(200).json({
                    msg:'User details Fetched.',
                    result:false,
                    data:usersDetails
                })
            }

            //If there is not matching username
            else{
                return res.status(404).json({
                    msg:'No user was found for the given username.',
                    result:false
                })
            }
        }
        catch(err){
            console.log(err);
            return res.status(500).json({
                msg:'There was a problem fetching the users.',
                result:false
            })
        }
});





module.exports = router;