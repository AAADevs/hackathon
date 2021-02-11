const express   = require('express');
const router    = express.Router();
const bcrypt    = require("bcrypt");
const moment    = require('moment-timezone');
const UserAuthModel = require("../../../models/userAuthModel");
const UserDetailsModel = require("../../../models/userDetailsModel");
const { body, validationResult } = require("express-validator");
const {generateToken,validateApiSecret,isAuthenticated}=require("./authHelper");



// REGISTER new user into joyn

router.post('/userRegister',[
  body('email').isEmail(),
  body('email').not().isEmpty(),
  body('username').not().isEmpty(),
  body('password').not().isEmpty(),
],validateApiSecret,
  (req,res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(422).json({
      error: errors.array()[0],
    });
  }
  
  //Check if the username is within the length bracket
  if(req.body.username.length>50 || req.body.username.length<5){
    return res.status(401).json({
      error:'Username cannot be more than 50 characters and smaller than 5 characters'
    });
  }

  //Check if the password is smaller than 5
  if(req.body.password.length<5){
    return res.status(401).json({
      error:'Password cannot be smaller than 5 characters'
    });
  }

      // Hashing password and storing user data in the database
      bcrypt.genSalt(10, (err, salt) => {
        bcrypt.hash(req.body.password, salt, (err, hash) => {
          const userDetails = {
            email:req.body.email,
            username:req.body.username,
            password:hash,
            timestamp:moment().format('MMMM Do YYYY, h:mm:ss a')
          }

          UserAuthModel.create(userDetails,(err,data) =>{
            
            if(err){
              if(err.name === 'MongoError' && err.code === 11000){
                console.log(err);
                res.status(401).json({
                  msg:"Duplicate field",
                  field:err.keyValue
                });
              }
              else{
                res.status(401).json(err);
              }
            }
            else{
              
              const userPersonalDetails = {email:req.body.email,username:req.body.username}

              UserDetailsModel.create(userPersonalDetails,(err,data)=>{
                if(err){
                  if(err.name === 'MongoError' && err.code === 11000){
                    console.log(err);
                    res.status(401).json({
                      msg:"Duplicate field",
                      field:err.keyValue
                    });
                  }
                  else{
                    res.status(401).json(err);
                  }
                }
                else{
                  res.status(200).json({ msg: "User registered successfully", details: data });
                }
              })
            }
          })
        });
      });
})


//Login user into their joyn account

router.post('/userLogin',[
  body('email_username').not().isEmpty(),
  body('password').not().isEmpty()
],validateApiSecret,
(req,res)=>{
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(422).json({
      error: errors.array()[0],
    });
  }
  const {email_username,password}=req.body;
  UserAuthModel.find(
    { $or:[ {email:email_username},{username:email_username} ]},(err,data)=>{
    if(err){
      console.log(err);
      res.status(401).json(
        {error:"User doesn't exist",
        details:err});
    }
    if(data.length == 0){
      console.log(err);
      res.status(401).json(
        {error:"User doesn't exist"});
    }
    else{
      bcrypt.compare(req.body.password,data[0].password,(error,result)=>{
        if(error){
          res.status(401).json(error);
        }
        if(result == true){
            UserDetailsModel.find({$or:[ {email:email_username},{username:email_username} ]},(err,data)=>{
              if(data){
                let payload = {
                  email: data[0].email,
                  username:data[0].username,
                  id:data[0]._id
                };
                const token = generateToken(payload);
                return res.status(200).json({
                  email: data[0].email,
                  username:data[0].username,
                  id:data[0]._id,
                  token:token
                });
              }
              else{
                res.status(404).json({
                  error:"UserDetails not found"
                })
              }
            })
        }
        else if(result == false){
          res.status(401).json({error:"Wrong password"})
        }
      })
    }
  })
});



//Verify user to check if he is a registered Joyn user with a valid token.

router.post('/verifyUser',
  validateApiSecret,
  isAuthenticated,
  async (req,res)=>{
    try{
      const userData = await UserAuthModel.find({ $or:[ {email:req.decoded.email},{username:req.decoded.username}]});
      if(userData.length>0){
        res.status(200).json({
          msg:"User is a valid registered Joyn user",
          result:true
        })
      }
      else{
        res.status(404).json({
          error:"User doesn't exist",
          result:false
        })
      }
    }catch(err){
      return res.status(500).json({
        msg:"Failed to verify user.",
        result:false,
        err
      });
    }
});

module.exports = router;



