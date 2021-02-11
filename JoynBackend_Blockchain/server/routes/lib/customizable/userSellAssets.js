const express       =   require('express');
const router        =   express.Router();
const AssetsModel   =   require("../../../models/assetModel");

const AssetUploadController                     =   require("../../../controllers/AssetUploadController"); 
const { validateApiSecret,  isAuthenticated}    =   require("../auth/authHelper");


// Post a new asset on the Joyn Store that the user can sell to other users

router.post('/uploadAssetToShop',
    validateApiSecret,
    isAuthenticated,
    AssetUploadController.multipleUpload,
    async (req,res)=>{
        try{

            // Checking if description & category field are empty

            if(req.body.type == "" || req.body.type == undefined){
                return res.status(400).json({
                    error:"Input field ( type ) is not valid."
                })
            }

            if(req.body.name == "" || req.body.name == undefined){
                return res.status(400).json({
                    error:"Input field ( name ) is not valid."
                })
            }

            if(req.body.price == "" || req.body.price == undefined){
                return res.status(400).json({
                    error:"Input field ( price ) is not valid."
                })
            }
            

            // Check if the provided asset type is valid

            const asset_type = {"wallpaper":1,"homebutton":2,"icon":3};

            if(!asset_type.hasOwnProperty(req.body.type)){
                return res.status(400).json({
                    error:"Asset type is not valid"
                })
            }

            

            // Storing the asset data in the database

            const new_asset = {
                    "type":req.body.type,
                    "name":req.body.name,
                    "price":parseInt(req.body.price),
                    "uploader_username":req.decoded.username,
                    "imageURL":`http://167.71.239.221:8088/media/userShopAssets/${req.files[0].filename}`
            }

            const assest_data = await AssetsModel.collection.insertOne(new_asset);

            if(assest_data){
                return res.status(200).json({
                    msg:"New asset added to the store",
                    result:true,
                    data: assest_data.ops
                })
            }
            else{
                return res.status(400).json({
                    msg:"Failed to add a new asset to the store",
                    result:false
                });
            }
        }

        catch(err){
            return res.status(500).json({
                msg:"Failed to add a new asset to the shop to sell.",
                result:false,
                error:err
            });
        }
});


module.exports = router;
