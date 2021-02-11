const express  = require('express');
const router   = express.Router();
const UserDetailsModel = require("../../../models/userDetailsModel");
const AssetsModal = require("../../../models/assetModel");
const { body, validationResult, query } = require("express-validator");
const {validateApiSecret,isAuthenticated} = require("../auth/authHelper");
const client = require("../blockchain/clientHelper");
const token = require("../blockchain/tokenServicesHelper");
const TokenClass = require("../blockchain/token")


const Token = new TokenClass();

router.post("/addItems",[
    // body('type').not().isEmpty(),
    // body('name').not().isEmpty(),
    // body("price").not().isEmpty(),
    ],async (req,res)=>{

        try{
            // const {type,name,price,barColor} = req.body;
            // let assets = await new AssetsModal({
            //     type:type,
            //     name:name,
            //     price:price,
            //     barColor:barColor || null
            // }).save();
            let  assets = await  AssetsModal.find()
            assets.forEach((item)=>{
                let asset = item;
                asset.imageURL = `http://167.71.239.221:8088/assets/${asset.type}s/${asset.name.replace(" ","_")}.png`
                // asset.uploader_username = ""
                new AssetsModal(asset).save()
            })
            return res.status(200).json({
                        result:false,
                        msg:"Saved Successfully",
                        assets:assets
                    })
        }catch(e){
            return res.status(400).json({
                result:false,
                msg:"Failed Request",
                error:e.message
            })
        }
})

router.post("/purchase",[
    body("id").not().isEmpty(),
    ],
    validateApiSecret,
    isAuthenticated,
    async (req,res)=>{
        try{
            // Validation
            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(422).json({
                error: errors.array()[0],
                });
            }
            // Getting information of asset,buyer and sender
            let asset = await AssetsModal.findById(req.body.id)
            const type = asset.type

            let ownerdetails =  {
                accountId:process.env.MY_ACCOUNT_ID,
                privateKey:process.env.MY_PRIVATE_KEY
            }
            if (asset.uploader_username !== "JoynOrignalContent"){
                owner = await UserDetailsModel.findOne({username:asset.uploader_username})
                ownerdetails =  {
                    accountId:owner.hederaAccountId,
                    privateKey:owner.privateKey
                }
                // owner Validation
                if (!owner){
                    return res.status(404).json({
                        msg:"Owner Not Found",
                        result:false,
                        error:"Not Found"
                    })
                }
                if(!owner.hederaAccountId || !owner.privateKey ){
                    return res.status(400).json({
                        msg:"Owner not registered with hedera",
                        result:false,
                        error:""
                    })
                }
            }
            // User validation
            const username = req.decoded.username    

            let user =await  UserDetailsModel.findOne({username:username});
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
            if(asset.price + 5 > user.token){
                return res.status(400).json({
                    msg:"Not Enough token to buy this Item",
                    result:false,
                    error:"Transaction Failed"
                })
            }
            let foundItem;
            if (type == "wallpaper"){
                foundItem = user.purchasedWallpapers.find((i)=>i == req.body.id)
                if(!foundItem){
                    user.purchasedWallpapers = [...user.purchasedWallpapers,req.body.id]
                }
            }else if(type == "homebutton"){
                foundItem = user.purchasedHomebuttons.find((i)=>i == req.body.id)
                if(!foundItem){
                    user.purchasedHomebuttons = [...user.purchasedHomebuttons,req.body.id]
                }
            }else if (type === "icon"){
                foundItem = user.purchasedHomebuttons.find((i)=>i == req.body.id)
                if(!foundItem){
                    user.purchasedIcons = [...user.purchasedIcons,req.body.id]
                }
            }else{
                return res.status(400).json({
                    result:false,
                    msg:"Invalid Type",
                })
            }
            if(foundItem){
                return res.status(200).json({
                    result:false,
                    msg:"Already Buyed Item",
                })
            }

            const result = await client.tokenTransfer(
                    {
                        accountId: user.hederaAccountId,
                        privateKey:user.privateKey,
                    },
                    Token.getHbarFromToken(asset.price), //token amount
                    ownerdetails
                    )
                if(!result.status){
                    return res.status(400).json({
                            msg:"Token Transfer Failed",
                            result:false,
                            error:result.error
                        })
                }else{
                        user.token = result.token
                        if(asset.uploader_username !== "JoynOrignalContent"){
                            owner.token += asset.price
                            owner =await new UserDetailsModel(owner).save()
                        }
                        user =await new UserDetailsModel(user).save()
                        return    res.status(200).json({
                            msg:"Token Transferred and Purchased Successfully",
                            result:true,
                            data:{
                                tokenTransferTransactionId:result.id,
                                tokenAsociateMessage:result.message
                            }
                        })
                }
           
        }catch(e){
            return res.status(400).json({
                result:false,
                msg:"Failed Request",
                error:e.message
            })
        }
})


router.post("/setDefault",[
    body("id").not().isEmpty(),
    ],
    validateApiSecret,
    isAuthenticated,
    async (req,res) =>{
        try{
            
            let user =await  UserDetailsModel.findOne({username:req.decoded.username});
            let asset = await AssetsModal.findById(req.body.id)
            const type = asset.type
            if(!asset){
                return res.status(400).json({
                    result:false,
                    msg:"Asset Not Found",
                })
            }
            if (type == "wallpaper"){
                user.currentWallpaper = asset.imageURL
            }else if(type == "homebutton"){
                user.currentHomebutton = asset.imageURL
            }else if (type === "icon"){
                user.currentIcon = asset.imageURL
            }else{
                return res.status(400).json({
                    result:false,
                    msg:"Invalid Type",
                })
            }
            user =await new UserDetailsModel(user).save()
            return    res.status(200).json({
                msg:"Successfully Updated",
                result:true,
            })
        }catch(e){
            return res.status(400).json({
                result:false,
                msg:"Request Failed",
                error:e.message
            })
        }
    }
)


router.get("/purchasedAndUnpurchasedItem",
    validateApiSecret,
    isAuthenticated,
    async (req,res)=>{
        try{
            
            let user =await  UserDetailsModel.findOne({username:req.decoded.username});
            if (!user){
                return res.status(404).json({
                    msg:"User Not Found",
                    result:false,
                    error:"Not Found"
                })
            }
            let data = {
                wallpaper:[],
                homebutton:[],
                icon:[],
            }
            let assets = await AssetsModal.find()
            let foundItem;
            assets.forEach((item)=>{
                if(item.type == "homebutton"){
                   foundItem = user.purchasedHomebuttons.find((i)=>i == item.id)
                    if (foundItem){
                        data.homebutton.push({...item._doc,purchased:true})
                    }else{
                        data.homebutton.push({...item._doc,purchased:false})
                    }
                }else if(item.type == "wallpaper"){
                    foundItem = user.purchasedWallpapers.find((i)=>i == item.id)
                     if (foundItem){
                         data.wallpaper.push({...item._doc,purchased:true})
                     }else{
                         data.wallpaper.push({...item._doc,purchased:false})
                     }
                 }
            })
            res.status(200).json({
                result:true,
                msg:"",
                data:data
            })
        }catch(e){
            return res.status(400).json({
                result:false,
                msg:"Failed Request",
                error:e.message
            })
        }

    });







module.exports = router