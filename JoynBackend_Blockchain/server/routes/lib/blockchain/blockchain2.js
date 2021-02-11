const express  = require('express');
const router   = express.Router();
const UserDetailsModel = require("../../../models/userDetailsModel");
const {validateApiSecret,isAuthenticated} = require("../auth/authHelper");
const client = require("../blockchain/clientHelper");
const token = require("../blockchain/tokenServicesHelper");
const { body, validationResult } = require("express-validator");
const TokenClass = require("./token")

const Token = new TokenClass();

router.post("/createAccountAssociateTransfer",[
    body('username').not().isEmpty(),
    ],
    validateApiSecret,
    async (req,res)=>{
        try{
            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(422).json({
                error: errors.array()[0],
                });
            }
            // New Account Creation
            const result = await client.accountCreate() 
            
            if(!result.status){
                return res.status(400).json({
                    msg:"Account Creation Failed",
                    result:false,
                    error:result.error
                })
            }
                const user = await UserDetailsModel.findOneAndUpdate({username:req.body.username},{
                    hederaAccountId:result.newAccountId,
                    privateKey:result.privateKey,
                    token:1000,
                });
                console.log(user)
                return  res.status(200).json({
                    msg:"New Hedera Account Created and Associated with John Token and Token Transferred as Bonus",
                    result:true,
                    data:{
                        tokenTransferTransactionId:result.id,
                        tokenAsociateMessage:result.message,
                        newAccountId:result.newAccountId,
                        tokenAssociatedTransactionId:result.id,
                        tokenAsociateMessage:result.message
                    }
                })
            

    }catch(e){
        return res.status(400).json({
            msg:"Failed Request",
            result:false,
            error:e.message
        })
    }
});

router.post("/getAccountInfo",
    validateApiSecret,
    isAuthenticated,
    async (req,res)=>{
    try{
        const username = req.decoded.username
            let user = await UserDetailsModel.findOne({username:username})
            if (!user){
                return res.status(404).json({
                    msg:"User Not Found",
                    result:false,
                    error:"Not Found"
                })
            }
            if(!user.hederaAccountId || !user.privateKey ){
                return res.status(400).json({
                    msg:"user not registered with hedera",
                    result:false,
                    error:""
                })
            }
        const accountInfo = await client.accountGetInfo(user.hederaAccountId)
        console.log(accountInfo)
        if (!accountInfo.status){
            return res.status(400).json({
                result:true,
                error:accountInfo.error,
                message:"Failed to Get Info"
            })
        }
        return res.status(200).json({
            msg:"Account Information",
            result:true,
            data:{...accountInfo,user }
        })
    }catch(error){
        
            return res.status(500).json({
                msg:"Failed To Get Info",
                result:false,
                error:e.message
            })
    }
});


router.post("/addToken",[
    body('tokenAmount').not().isEmpty().isNumeric(),
    ],
    validateApiSecret,
    isAuthenticated,
    async (req,res)=>{
        try{
            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(422).json({
                error: errors.array()[0],
                });
            }
            const username = req.decoded.username
            const tokenAmount = parseInt(req.body.tokenAmount)
            let user = await UserDetailsModel.findOne({username:username})
            if (!user){
                return res.status(404).json({
                    msg:"User Not Found",
                    result:false,
                    error:"Not Found"
                })
            }
            if(!user.hederaAccountId || !user.privateKey ){
                return res.status(400).json({
                    msg:"user not registered with hedera",
                    result:false,
                    error:""
                })
            }
            console.log(user)

            const result = await client.tokenTransfer({
                            accountId:process.env.MY_ACCOUNT_ID,
                            privateKey:process.env.MY_PRIVATE_KEY
                        },
                        Token.getHbarFromToken(tokenAmount),
                        {
                            accountId: user.hederaAccountId,
                            privateKey:user.privateKey,
                        })
                console.log(result)
        if(!result.status){
            return res.status(400).json({
                    msg:"Token Transfer Failed",
                    result:false,
                    error:result.error
                })
        }else{
                user.token += tokenAmount
                user =await new UserDetailsModel(user).save()
                console.log(user)
                return  res.status(200).json({
                    msg:"Token Transferred",
                    result:true,
                    data:{
                        tokenTransferTransactionId:result.id,
                        tokenAsociateMessage:result.message
                    }
                })
        }
    }catch(e){
        console.log(e)
        return res.status(500).json({
            msg:"Failed To Get Info",
            result:false,
            error:e.message
        })
    }
}); 


router.post("/deductToken",[
    body('tokenAmount').not().isEmpty().isNumeric(),
    ],
    validateApiSecret,
    isAuthenticated,
    async (req,res)=>{
        try{

            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(422).json({
                error: errors.array()[0],
                });
            }
            const username = req.decoded.username
            const tokenAmount = parseInt(req.body.tokenAmount)
            let user = await UserDetailsModel.findOne({username:username})
            if (!user){
                return res.status(404).json({
                    msg:"User Not Found",
                    result:false,
                    error:"Not Found"
                })
            }
            if(!user.hederaAccountId || !user.privateKey ){
                return res.status(400).json({
                    msg:"user not registered with hedera",
                    result:false,
                    error:""
                })
            }
            if(tokenAmount > user.token){
                return res.status(400).json({
                    msg:"Not Enough token ",
                    result:false,
                    error:"Transaction Failed"
                })
            }
            console.log(user)

            const result = await token.tokenTransfer(
                        {
                            accountId: user.hederaAccountId,
                            privateKey:user.privateKey,
                        },
                        Token.getHbarFromToken(tokenAmount),
                        {
                            accountId:process.env.MY_ACCOUNT_ID,
                            privateKey:process.env.MY_PRIVATE_KEY
                        },)
                console.log(result)
        if(!result.status){
            return res.status(400).json({
                    msg:"Token Transfer Failed",
                    result:false,
                    error:result.error
                })
        }else{
                user.token = result.token
                user =await new UserDetailsModel(user).save()
                console.log(user)
                return  res.status(200).json({
                    msg:"Token Transferred",
                    result:true,
                    data:{
                        tokenTransferTransactionId:result.id,
                        tokenAsociateMessage:result.message
                    }
                })
        }
    }catch(e){
        return res.status(500).json({
            msg:"Failed To Get Info",
            result:false,
            error:e.message
        })
    }
});




router.post("/transferToken",[
    body('sender').not().isEmpty(),
    body('receiver').not().isEmpty(),
    body('tokenAmount').not().isEmpty().isNumeric(),
    ],
    validateApiSecret,
    isAuthenticated,
    async (req,res)=>{
        try{
            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(422).json({
                error: errors.array()[0],
                });
            }

            const sender = req.body.sender
            const receiver = req.body.receiver
            const tokenAmount = parseInt(req.body.tokenAmount)
            // sender
            let user1 = await UserDetailsModel.findOne({username:sender})
            //receiver
            let user2 = await UserDetailsModel.findOne({username:receiver})
            if (!user1 || !user2){
                return res.status(404).json({
                    msg:"User Not Found",
                    result:false,
                    error:"Not Found"
                })
            }
            if(!user1.hederaAccountId || !user2.hederaAccountId ){
                return res.status(400).json({
                    msg:"user not registered with hedera",
                    result:false,
                    error:""
                })
            }

            const result = await client.tokenTransfer(
                    {
                        accountId: user1.hederaAccountId,
                        privateKey:user1.privateKey,
                    },
                        Token.getHbarFromToken(tokenAmount),
                        {
                            accountId: user2.hederaAccountId,
                            privateKey:user2.privateKey,
                        },)
                console.log(result)
            if(!result.status){
                return res.status(400).json({
                        msg:"Token Transfer Failed",
                        result:false,
                        error:result.error
                    })
            }else{
                    user1.token = result.token
                    user1 =await new UserDetailsModel(user1).save()
                    console.log(user1)
                    user2.token += tokenAmount
                    user2 =await new UserDetailsModel(user2).save()
                    console.log(user2)
                    return   res.status(200).json({
                        msg:"Token Transferred",
                        result:true,
                        data:{
                            tokenTransferTransactionId:result.id,
                            tokenAsociateMessage:result.message
                        }
                    })
            }
        }catch(e){
            return res.status(500).json({
                msg:"Failed To Get Info",
                result:false,
                error:e.message
            })
        }
});


module.exports = router;