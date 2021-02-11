const express   =   require('express');
const router    =   express.Router();
const { body, validationResult } = require("express-validator");
const client = require("../blockchain/clientHelper");
const {isAuthenticated} = require("../auth/authHelper");
require("dotenv").config;

const UserDetailsModel = require('../../../models/userDetailsModel');


// Get user details for all the users on Joyn from user_details collection.

router.get('/getAllUsersDetails',
    isAuthenticated,
    async(req,res)=>{
        try{
            //Fetching required user data from the database
            const data = await UserDetailsModel.find({},
                {username:1,email:1,token:1,profile_picture:1,passbase:1});

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
                msg:"Error geting users details"
            })   
        }
});


//Get Admin account information 

router.get("/getAdminTotalToken",
    isAuthenticated,
    async (req,res)=>{
        try{
            const adminTokenID = process.env.TOKEN_ID
            const accountInfo = await client.accountGetInfo(process.env.MY_ACCOUNT_ID)
            if(accountInfo){
                res.status(200).json({
                    msg:"Account balance fetched",
                    result:true,
                    balance: accountInfo.tokenRelationships[adminTokenID].balance
                })
            }
            else{
                res.status(404).json({
                    msg:"No Account found",
                    result:false,
                    data: accountInfo
                })
            }

        }catch(e){
            console.log(e);
            res.status(500).json({
                msg:"Fetching account balance info Failed",
                result:false,
                error:e.message
            })
        }
});


module.exports = router;