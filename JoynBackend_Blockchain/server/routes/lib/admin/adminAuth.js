const bcrypt    =   require('bcrypt');
const express   =   require('express');
const router    =   express.Router();
const { body, validationResult } = require("express-validator");
const {generateToken,validateAdminApiSecret} = require("../auth/authHelper");
require("dotenv").config;

//Admin login 

router.post('/adminLogin',
    [body('username').not().isEmpty(),
    body('password').not().isEmpty()],
    validateAdminApiSecret,
    async (req,res) =>{
        try{

            // Input field validation

            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(422).json({
                error: errors.array()[0],
                });
            }

            const adminPassword = req.body.password;
            const adminUsername = req.body.username;
            
            //Checking if the username is valid
            if(adminUsername == process.env.admin_username){

                //Checking if the password is valid
                bcrypt.compare(adminPassword,process.env.admin_password,function(err,result){
                    if(err){
                        return res.status(500).json({
                            msg:"Problem verifying the password for admin.",
                            result:false
                        });
                    }

                    //If the password is valid
                    if(result == true){

                        //Creating a payload for JWT token 
                        let payload = {
                            username:adminUsername
                        };

                        //Create a JWT token
                        const token = generateToken(payload);

                        //Send the JWT token in response along with username
                        return res.status(200).json({
                            msg:"Admin login successful",
                            result:true,
                            username:adminUsername,
                            token:token
                        });
                    }
                    //If the password is invalid
                    else{
                        return res.status(401).json({
                            msg:"Password is invalid.",
                            result:false
                        })
                    }
                });
            }
            //If the username is invalid then
            else{
                return res.status(401).json({
                    msg:"Invalid username.",
                    result:false
                })
            }
           
        }
        catch(err){
            console.log(err);
            return res.status(500).json({
                msg:"Login request failed.",
                result:false
            })
        }


});

module.exports = router;