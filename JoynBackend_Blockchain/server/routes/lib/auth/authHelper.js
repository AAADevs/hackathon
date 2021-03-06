const jwt     = require("jsonwebtoken");
const bcrypt  = require("bcrypt");
require("dotenv").config();

//Validate Joyn API secret key

exports.validateApiSecret = (req,res,next) =>{
  const api_secret_key = req.headers.joyn_api_secret_key;

  // Checking if the API secret key is provided

  if(req.headers.joyn_api_secret_key == "" || req.headers.joyn_api_secret_key == undefined){
    return res.status(401).json({error:"API secret key is not provided"});
  }

  //Checking if the API secret key is valid

  bcrypt.compare(api_secret_key,process.env.api_secret_key, function(err, result) {
    if(err){
      return res.status(401).json({error:err,msg:"Invalid Joyn API secret key"});
    }
    if(!result){
      return res.status(401).json({error:"Invalid Joyn API secret key"});
    }
    else{
     next(); 
    }
  });
} 


//Validate Admin Joyn API secret key

exports.validateAdminApiSecret = (req,res,next) =>{
  const api_secret_key = req.headers.joyn_api_secret_key;

  // Checking if the API secret key is provided

  if(req.headers.joyn_api_secret_key == "" || req.headers.joyn_api_secret_key == undefined){
    return res.status(401).json({error:"Admin API secret key is not provided"});
  }

  //Checking if the API secret key is valid

  bcrypt.compare(api_secret_key,process.env.admin_api_secret_key, function(err, result) {
    if(err){
      return res.status(401).json({error:err,msg:"Invalid Admin Joyn API secret key"});
    }
    if(!result){
      return res.status(401).json({error:"Invalid Admin Joyn API secret key"});
    }
    else{
     next(); 
    }
  });
} 


//Generate token

exports.generateToken = (payload) => {
  return jwt.sign(payload, process.env.TOKEN_SECRET, {
    expiresIn: "90d",
  });
};


//Check for authentication

exports.isAuthenticated=(req,res,next)=>{
  var authHeader =
    req.body.token ||
    req.query.token ||
    req.headers["authorization"];
  if (authHeader) {
    let token = authHeader.split(" ");
    jwt.verify(token[0], process.env.TOKEN_SECRET, function (err, decoded) {
      if (err) {
        return res
          .status(401)
          .send({ success: false, message: "Failed to authenticate token." });
      } else {
        req.decoded = decoded;
        next();
      }
    });
  } else {
    return res.status(401).send({
      success: false,
      message: "No token provided.",
    });
  }
}







