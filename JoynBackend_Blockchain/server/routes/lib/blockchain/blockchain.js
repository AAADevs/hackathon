const express  = require('express');
const router   = express.Router();
const UserDetailsModel = require("../../../models/userDetailsModel");
const {validateApiSecret,isAuthenticated} = require("../auth/authHelper");
const client = require("../blockchain/clientHelper");
const token = require("../blockchain/tokenServicesHelper");
const { body, validationResult } = require("express-validator");
const { isNumeric } = require('tslint');
const { result } = require('lodash');


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
            const {newAccountId,privateKey} = await client.accountCreate() 
            
            // Token Associate
            let result = await token.tokenAssociate(
                process.env.TOKEN_ID,{
                accountId:newAccountId,
                privateKey:privateKey
            })

            if(!result.status){
                return res.status(400).json({
                    msg:"Failed To Associate Token With Account",
                    result:false,
                    error:err 
                })
            }
            //Token Transfer
            result = await token.tokenTransfer(process.env.TOKEN_ID,{
                                            accountId:process.env.MY_ACCOUNT_ID,
                                            privateKey:process.env.MY_PRIVATE_KEY
                                        },
                                        1000, //token amount
                                        0,
                                        {
                                            accountId: newAccountId,
                                            privateKey: privateKey,
                                        })
            if(!result.status){
                return res.status(400).json({
                    msg:"Token Transfer Failed",
                    result:false,
                    error:result.error
                })
            }else{
                const user = await UserDetailsModel.findOneAndUpdate({username:req.body.username},{
                    hederaAccountId:newAccountId,
                    privateKey:privateKey,
                    token:100,
                });
                console.log(user)
                return  res.status(200).json({
                    msg:"New Hedera Account Created and Associated with John Token and Token Transferred as Bonus",
                    result:true,
                    data:{
                        tokenTransferTransactionId:result.id,
                        tokenAsociateMessage:result.message,
                        newAccountId:newAccountId,
                        tokenAssociatedTransactionId:result.id,
                        tokenAsociateMessage:result.message
                    }
                })
            }

        return res.status(200).json({
            msg:"New Hedera Account Created and Associated with John Token and Token Transferred as Bonus",
            result:true,
            data:{
                newAccountId:newAccountId,
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

router.post("/getAccountInfo",[
    body('username').not().isEmpty(),
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
        const username = req.body.username
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
        return res.status(200).json({
            msg:"Account Information",
            result:true,
            data:{...accountInfo,user }
        })
    }catch(error){
        e = JSON.parse(error.message)
        if(error.status == 400){
            return res.status(400).json({
                msg:"Failed To Get Info",
                result:false,
                error:e.message
            })
        }else{
            return res.status(500).json({
                msg:"Failed To Get Info",
                result:false,
                error:e.message
            })
        }
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

            const result = await token.tokenTransfer(process.env.TOKEN_ID,{
                            accountId:process.env.MY_ACCOUNT_ID,
                            privateKey:process.env.MY_PRIVATE_KEY
                        },
                        tokenAmount, //token amount
                        0,
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

            const result = await token.tokenTransfer(process.env.TOKEN_ID,
                    {
                        accountId: user.hederaAccountId,
                        privateKey:user.privateKey,
                    },
                        tokenAmount, //token amount
                        0,
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
                user.token -= tokenAmount
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
            let user1 = await UserDetailsModel.findOne({username:sender})
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

            const result = await token.tokenTransfer(process.env.TOKEN_ID,
                    {
                        accountId: user1.hederaAccountId,
                        privateKey:user1.privateKey,
                    },
                        tokenAmount, //token amount
                        0,
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
                user1.token -= tokenAmount
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

router.post("/mintToken",[
    body('tokenAmount').not().isEmpty(),
    ],
    // validateApiSecret,
async (req,res)=>{
    try{
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(422).json({
            error: errors.array()[0],
            });
        }
        const amountToMint = parseInt(req.body.tokenAmount);
        const result =  await token.tokenMint({
              amount:amountToMint,
              tokenId:process.env.TOKEN_ID,
              supplyKey:process.env.MY_PRIVATE_KEY,
            });
        if(!result.status){
            return res.status(400).json({
                msg:"Token Minting Failed",
                result:false,
                error:result.error
            })
        }
        return res.status(200).json({
            msg:result.message,
            data:result.transactionId,
            result:true
        })

    }catch(e){
        return res.status(400).json({
            msg:"Token Minting Failed",
            result:false,
            error:e.message
        })
    }
})

router.post("/freezeToken",[
    body('accountId').not().isEmpty(),
],validateApiSecret,async (req,res)=>{
    try{
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(422).json({
            error: errors.array()[0],
            });
        }
        const result =  await token.tokenFreeze({
            tokenId:process.env.TOKEN_ID,
            accountId:req.body.accountId,
            freezeKey:process.env.MY_PRIVATE_KEY
          });
        if(!result.status){
            res.status(400).json({
                msg:"Token Minting Failed",
                result:false,
                error:result.error
            })
        }
        res.status(200).json({
            msg:result.message,
            data:result.transactionId,
            result:true
        })

    }catch(e){
        res.status(400).json({
            msg:"Token Minting Failed",
            result:false,
            error:e.message
        })
    }
})

router.post("/unfreezeToken",[
    body('accountId').not().isEmpty(),
],validateApiSecret,async (req,res)=>{
    try{
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(422).json({
            error: errors.array()[0],
            });
        }
        const result =  await token.tokenUnFreeze({
              tokenId:process.env.TOKEN_ID,
              accountId:req.body.accountId,
              freezeKey:process.env.MY_PRIVATE_KEY
            });
        if(!result.status){
            res.status(400).json({
                msg:"Token Minting Failed",
                result:false,
                error:result.error
            })
        }
        res.status(200).json({
            msg:result.message,
            data:result.transactionId,
            result:true
        })

    }catch(e){
        res.status(400).json({
            msg:"Token Minting Failed",
            result:false,
            error:e.message
        })
    }
})


module.exports = router;