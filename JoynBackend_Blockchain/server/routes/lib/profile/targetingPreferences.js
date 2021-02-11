const express  = require('express');
const router   = express.Router();
const path      =   require('path');
const UserDetailsModel = require("../../../models/userDetailsModel");
const { body, validationResult } = require("express-validator");
const {validateApiSecret,isAuthenticated} = require("../auth/authHelper");
const { gender,countries } = require("./profileValidation");



// Edit users demographic profile details

router.post("/editDemographicDetails",[
    validateApiSecret,
    isAuthenticated,
    body('gender').not().isEmpty(),
    body('nationality').not().isEmpty(),
    body('country_residence').not().isEmpty(),
    body('age').not().isEmpty()],
    async (req,res)=>{
        try{

            //////// Input field validation /////////
            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(422).json({
                    error: errors.array()[0],
                });
            }

            const userGender            =   req.body.gender;
            const userNationality       =   req.body.nationality;
            const userCountryResidence  =   req.body.country_residence;
            const userAge               =   req.body.age;

            //If the gender provided is not valid 
            if(!gender.hasOwnProperty(userGender)){
                return res.status(404).json({
                    result:false,
                    msg:"Gender not found"
                })
            }

            //If the country provided for Nationality is not valid
            if(!countries.hasOwnProperty(userNationality)){
                return res.status(404).json({
                    result:false,
                    msg:"Country is not valid for userNationality"
                })
            }

            //If the country provided for Residency is not valid
            if(!countries.hasOwnProperty(userCountryResidence)){
                return res.status(404).json({
                    result:false,
                    msg:"Country is not valid for user residence"
                })
            }

            let userDemographicDetails = {
                gender:userGender,
                nationality:userNationality,
                country_residence:userCountryResidence,
                age:userAge
            }

            //Update the users userdetails with the new data
            const userDetails = await UserDetailsModel.findOneAndUpdate(
                {"username":req.decoded.username},userDemographicDetails
            )
            if(userDetails){
                return res.status(200).json({
                    result:true,
                    msg:"User details updated"
                })
            }

            else{
                return res.status(401).json({
                    result:false,
                    msg:"There was a problem updating user details",
                })
            }


        }
        catch(err){
            console.log(err);
            return res.status(500).json({
                result:false,
                msg:"Failed to update user demographic details"
            })   
        }

    }
)

module.exports = router;