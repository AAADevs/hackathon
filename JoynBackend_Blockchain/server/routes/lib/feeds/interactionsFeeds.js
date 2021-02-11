const express   = require('express');
const router    = express.Router();
const moment    = require('moment-timezone');
const UserFeedsModel = require("../../../models/userFeedsModel");
const postCommentModel = require("../../../models/postComment");
const { body, validationResult } = require("express-validator");
const {validateApiSecret,isAuthenticated} = require("../auth/authHelper");


//Like a post on feed

router.post('/likePost',[body('post_id').not().isEmpty()],
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

            //Find the post by _id

            const postDetails = await UserFeedsModel.findById({_id:req.body.post_id});

            //If the post is found

            if(postDetails){

                //Check if the post is already liked  

                for(let i = 0; i<postDetails.like_details.length;i++){
                    if(postDetails.like_details[i].username == req.decoded.username){
                        return res.status(400).json({
                            msg:"Post already liked",
                            result:false
                        });
                    }
                }
                
                //If the post has never been liked before
                //Increment the likes count and add username,timestamp to like_details field of the database

                let likeData = {
                    $inc    :   {'likes':1},
                    $push   :   {like_details:
                        {   username    :   req.decoded.username,
                            timestamp   :   moment().format('MMMM Do YYYY, h:mm:ss a')
                        }
                    }
                }

                const likePostDetails = await UserFeedsModel.findByIdAndUpdate({_id:req.body.post_id},likeData,{upsert:true});
                
                if(likePostDetails){
                    return res.status(200).json({
                        msg:"Liked added to the post",
                        result:true
                    })
                }
                else{
                    return res.status(400).json({
                        msg:"Failed to like the post",
                        result:false
                    })
                }
            }
            //If the post is not found

            else{
                return res.status(404).json({
                    msg:"Post not found",
                    result:false
                })
            }


        }
        catch(err){
            console.log(err);
            return res.status(500).json({
                msg:"Failed to like the post",
                result:false
            })
        }
});



// Unlike a post on feed

router.post('/unLikePost',[body('post_id').not().isEmpty()],
    validateApiSecret,
    isAuthenticated,
    async(req,res)=>{
        try{

            //Input field validation

            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(422).json({
                error: errors.array()[0],
                });
            }

            //Find the post by _id

            const postDetails = await UserFeedsModel.findById({_id:req.body.post_id});

            // If the post exists

            if(postDetails){
                var isNeverLiked = true

                // Check if the post is liked  
                
                for(let i = 0; i<postDetails.like_details.length;i++){
                    if(postDetails.like_details[i].username == req.decoded.username){
                        isNeverLiked = false;
                        

                        //If the post has been liked before
                        //Decrement the likes count and remove username,timestamp from like_details field of the database

                        let unlikeData = {
                            $inc    :   {'likes':-1},
                            $pull   :   {"like_details": {"username":req.decoded.username}}
                        }

                        const unlikePostDetails = await UserFeedsModel.findByIdAndUpdate({_id:req.body.post_id},unlikeData);
                        if(unlikePostDetails){
                            return res.status(200).json({
                                msg:"Post unliked",
                                result:true
                            })
                        }
                        else{
                            return res.status(400).json({
                                msg:"Failed to unlike the post",
                                result:false
                            })
                        }
                    }
                }

                // If the post was never liked before

                if(isNeverLiked){
                    res.status(400).json({
                        msg:"Post was never liked before",
                        result:false
                    });
                }
            }

            // If the post does not exists

            else{
                return res.status(404).json({
                    msg:"Post not found",
                    result:false
                })
            }
        }
        catch(err){
            console.log(err);
            return res.status(500).json({
                msg:"Failed to unlike the post",
                result:false
            })
        }
});


// Comment on a post

router.post('/addCommentToPost',[
    body('post_id').not().isEmpty(),
    body('post_comment').not().isEmpty()],
    validateApiSecret,
    isAuthenticated,
    async(req,res)=>{
        try{
            
            //Input field validation

            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(422).json({
                error: errors.array()[0],
                });
            }

            const post_id = req.body.post_id;

            //Check if the post you want to add a comment to exists
            const feedPostExists = await UserFeedsModel.findById({_id:post_id});

            //If the post you want to add a comment to exists
            if(feedPostExists){


                // Add comment data to PostComment collection
                let commentData = {
                    username    :   req.decoded.username,
                    timestamp   :   moment().format('MMMM Do YYYY, h:mm:ss a'),
                    postId      :   feedPostExists._id,
                    comment     :   req.body.post_comment
                }

                const commentOnPost = await postCommentModel.create(commentData);

                // If the comment data is saved in the database
                if(commentOnPost){
                    
                    //Save the object id of the comment in the comments array of the feed post
                    const postData = await UserFeedsModel.findByIdAndUpdate(
                        {_id:post_id},
                        {
                            $push :{
                                comments: commentOnPost._id
                            }
                        }
                    )

                    // If the object id of the comment was updated in the comments array of the feed post
                    if(postData){
                        return res.status(200).json({
                            msg:"Comment added to the post",
                            result:true
                        })
                    }

                    // If the object id of the comment was not updated in the comments array of the feed post
                    else{
                        return res.status(400).json({
                            msg:"Failed to add a comment to the post",
                            result:false
                        })
                    }


                }

                // If the comment data is not saved in the database
                else{
                    return res.status(400).json({
                        msg:"Failed to add a comment to the post",
                        result:false
                    })
                }
            }

            //If the post you want to add a comment to does not exists
            else{
                return res.status(404).json({
                    msg:"Post not found",
                    result:false
                })
            }
        }

        catch(err){
            console.log(err);
            return res.status(500).json({
                msg:"Failed to add a comment to the post",
                result:false
            })
        }
});





module.exports = router;