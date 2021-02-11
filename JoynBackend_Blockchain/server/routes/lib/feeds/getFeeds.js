const express                               =   require('express');
const router                                =   express.Router();
const moment                                =   require('moment-timezone');
const UserFeedsModel                        =   require("../../../models/userFeedsModel");
const UserDetailsModel                      =   require("../../../models/userDetailsModel"); 
const { body, validationResult }            =   require("express-validator");
const { validateApiSecret,isAuthenticated } =   require("../auth/authHelper");


// Function to check if the provided category for a post is a valid category.

function checkForCategory(category){
    const categories = ['Funny','Pets','Arts','Sports','News','All','Others']
    for(catg in categories){
        if(categories[catg] == category){
            return true;
        }
    }
}


// Get all the feeds posted by all the users on Joyn - latest posts

router.post("/getAllFeeds",
    validateApiSecret,
    isAuthenticated,
    async (req,res)=>{
        try{
            const allFeeds = await UserFeedsModel.find({type:{$ne:'Vibe'}});
            if(allFeeds.length>0){
                res.status(200).json({
                    msg:"All feeds retrieved",
                    result:true,
                    data:allFeeds
                })
            }
            else{
                res.status(404).json({
                    msg:"No feeds found",
                    result:false
                }) 
            }
        }
        catch(err){
            res.status(500).json({
                msg:"Failed to retrieve all the feeds",
                result:false,
                error:err
            })
        }
});

// Get all the feeds posted by all the users on Joyn in descending likes count - Popular posts

router.post("/getPopularPosts",
    validateApiSecret,
    isAuthenticated,
    async (req,res)=>{
        try{
            const allFeeds = await UserFeedsModel.find({type:{$ne:'Vibe'}}).sort({'likes':-1});
            if(allFeeds.length>0){
                res.status(200).json({
                    msg:"All feeds retrieved",
                    result:true,
                    data:allFeeds
                })
            }
            else{
                res.status(404).json({
                    msg:"No feeds found",
                    result:false
                }) 
            }
        }
        catch(err){
            res.status(500).json({
                msg:"Failed to retrieve all the feeds",
                result:false,
                error:err
            })
        }
});


// Get all the Vibe posted by all the users on Joyn

router.post("/getAllVibes",
    validateApiSecret,
    isAuthenticated,
    async (req,res)=>{
        try{
            const allFeeds = await UserFeedsModel.find({type:'Vibe'});
            if(allFeeds.length>0){
                res.status(200).json({
                    msg:"All Vibes retrieved",
                    result:true,
                    data:allFeeds
                })
            }
            else{
                res.status(404).json({
                    msg:"No vibes found",
                    result:false
                }) 
            }
        }
        catch(err){
            res.status(500).json({
                msg:"Failed to retrieve all the vibes",
                result:false,
                error:err
            })
        }
});




// Get all the feeds posted by a particular user

router.post("/getUserFeeds",
    [body('username').not().isEmpty()],
    validateApiSecret,
    isAuthenticated,
    async (req,res)=>{
        try{

            // Input field validation

            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(422).json({
                error: errors.array()[0],
                });
            }

            // Get users feeds

            const allFeeds = await UserFeedsModel.find({username:req.body.username});

            if(allFeeds.length > 0){
                res.status(200).json({
                    msg:"All feeds retrieved for the user",
                    result:false,
                    data:allFeeds
                })
            }
            else{
                res.status(404).json({
                    msg:"No feeds found for the user",
                    result:false
                }) 
            }
        }
        catch(err){
            console.log(err);
            res.status(500).json({
                msg:"Failed to retrieve all the feeds for the user",
                result:false,
                error:err
            })
        }
});


// Get all the feeds for a particular category

router.post("/getFeedsFromCategory",
    [body('category').not().isEmpty()],
    validateApiSecret,
    isAuthenticated,
    async (req,res)=>{
        try{

            // Input field validation

            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(422).json({
                error: errors.array()[0],
                });
            }


            //Check if the user provided post category is valid or not

            const categoryValid = checkForCategory(req.body.category);


            //If the user provided post category is valid

            if(categoryValid){
                //If the user wants to return all the feeds
                if(req.body.category === 'All'){
                    var allCategoryFeedPosts = await UserFeedsModel.find({});
                }
                //If the user want to return feeds from a particular category
                else{
                    var allCategoryFeedPosts = await UserFeedsModel.find({category:req.body.category});
                }
                if(allCategoryFeedPosts.length>0){
                    res.status(200).json({
                        msg:`All feed posts retrieved for ${req.body.category} category.`,
                        result:false,
                        data:allCategoryFeedPosts
                    })
                }
                else{
                    res.status(404).json({
                        msg:`No post found for ${req.body.category} category.`,
                        result:false
                    }) 
                }
            }


            //If the post category is invalid

            else{
                return res.status(400).json({
                    msg:"Provided category value is not valid",
                    result:false
                })
            }

        }
        catch(err){
            console.log(err);
            return res.status(500).json({
                msg:"Failed to retrieve posts for the particular category",
                result:false
            })
        }
});


// Get all the comments for a post

router.post("/getPostComments",
    [body('post_id').not().isEmpty()],
    validateApiSecret,
    isAuthenticated,
    async (req,res)=>{
        try{

            // Input field validation

            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(422).json({
                error: errors.array()[0],
                });
            }

            //Populate comments data for the post

            const postData = await UserFeedsModel.find({_id:req.body.post_id},{comments:1}).populate('comments');
        
            if(postData[0].comments.length>0){
                res.status(200).json({
                    msg:"All comments retrieved for the post",
                    result:true,
                    data:postData[0].comments
                })
            }
            else{
                res.status(404).json({
                    msg:"No comments found for the post",
                    result:false
                }) 
            }
        }
        catch(err){
            console.log(err);
            res.status(500).json({
                msg:"Failed to retrieve comments for the post.",
                result:false
            })
        }
});


// Get feeds from all the accounts that the users follows - Latest

// console.log(moment("January 25th 2021, 7:36:49 am","MMMM Do YYYY, h:mm:ss a").fromNow());

router.post('/getLatestPostsFromFollowings',
    validateApiSecret,
    isAuthenticated,
    async(req,res)=>{    
        try{
            const username = req.decoded.username;

            //Fetch a list of all the accounts that the user follows
            const userDetails = await UserDetailsModel.find({username:username});
            if(userDetails.length>0){

                //Converting all the object_id of the accounts the user follows into String
                const usersFollowing = [];

                userDetails[0].following.forEach((followingAccount)=>{
                    usersFollowing.push(followingAccount.toString());
                })

                //Find all the feeds from the accounts that the users follow
                //Sorting the feeds to return the post in descending order respect to time they are posted
                const allFollowingFeeds = await UserFeedsModel.find({user_id:{$in:usersFollowing}}).sort({'timestamp':-1});
                
                if(allFollowingFeeds.length>0){
                    res.status(200).json({
                        msg:"Feeds for all the accounts that users follow fetched successfully",
                        result:true,
                        data:allFollowingFeeds
                    })
                }

                //If no feeds posted by the users following accounts
                else{
                    res.status(404).json({
                        msg:"No feeds posted by the accounts that the user follows",
                        result:false
                    })
                }
            }

            //If user account not found
            else{
                res.status(404).json({
                    msg:"User account not found",
                    result:false
                })
            }
        }
        catch(err){
            console.log(err);
            res.status(500).json({
                msg:"Failed to get feeds",
                result:false
            })
        }

})


// Get feeds from all the accounts that the users follows - Popular

router.post('/getPopularPostsFromFollowings',
    validateApiSecret,
    isAuthenticated,
    async(req,res)=>{    
        try{
            const username = req.decoded.username;

            //Fetch a list of all the accounts that the user follows
            const userDetails = await UserDetailsModel.find({username:username});
            if(userDetails.length>0){

                //Converting all the object_id of the accounts the user follows into String
                const usersFollowing = [];

                userDetails[0].following.forEach((followingAccount)=>{
                    usersFollowing.push(followingAccount.toString());
                })

                //Find all the feeds from the accounts that the users follow
                //Sorting the feeds to return the post in descending order respect to no of likes
                const allFollowingFeeds = await UserFeedsModel.find({user_id:{$in:usersFollowing}}).sort({'likes':-1});
                
                if(allFollowingFeeds.length>0){
                    res.status(200).json({
                        msg:"Feeds for all the accounts that users follow fetched successfully",
                        result:true,
                        data:allFollowingFeeds
                    })
                }

                //If no feeds posted by the users following accounts
                else{
                    res.status(404).json({
                        msg:"No feeds posted by the accounts that the user follows",
                        result:false
                    })
                }
            }

            //If user account not found
            else{
                res.status(404).json({
                    msg:"User account not found",
                    result:false
                })
            }
        }
        catch(err){
            console.log(err);
            res.status(500).json({
                msg:"Failed to get feeds",
                result:false
            })
        }

})

module.exports = router;