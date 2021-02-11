const express       =   require('express');
const bodyparser    =   require('body-parser');
const app           =   express();
const cors          =   require("cors");
const path          =   require('path');
const moment        =   require('moment-timezone');
const userAuth      =   require('./lib/auth/userAuth');
const profileSetup  =   require('./lib/profile/profileSetup');
const postFeeds     =   require('./lib/feeds/postFeeds');
const getFeeds      =   require('./lib/feeds/getFeeds');
const blockchain    =   require('./lib/blockchain/blockchain2')
const customizable  =   require('./lib/customizable/customizable');
const adminAuth     =   require('./lib/admin/adminAuth');
const adminAPI      =   require('./lib/admin/adminAPI');
const interactionsFeeds     =   require('./lib/feeds/interactionsFeeds');
const targetingPreferences  =   require('./lib/profile/targetingPreferences');
const userSellAssets        =   require('./lib/customizable/userSellAssets');


//BODY PARSER PRESET

app.use(bodyparser.json());

app.use(bodyparser.urlencoded({
    extended: true
}));

app.use(bodyparser.text({ limit: '200mb' }));


// EXPRESS STATIC FILE SERVER

// Media uploaded by the users
app.use('/media',express.static(path.join(__dirname,'/../../../JoynMedia')))

//Assets for sale via in-app store
app.use("/assets",express.static('assets'));




// CORS PRESETS

app.use(cors());

app.use(express.static("docs"));
app.use((req, res, next) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Headers', 'Origin,X-Requested-With,Content-Type,Accept,Authorization');
    res.setHeader('Access-Control-Allow-Methods', 'GET,POST,PATCH,DELETE,PUT,OPTIONS');
    if (req.method === 'OPTIONS') {
        res.sendStatus(200);
    } else {
        next();
    }
});


// Timezone setup

moment.tz.setDefault("Europe/London");



// User Login/Signup

app.use('/api',userAuth);




// User Profile setup

app.use('/api',profileSetup);




//Post User feeds API

app.use('/api',postFeeds);




//Retrieve User feeds API

app.use('/api',getFeeds);




//Blockchain API 

app.use('/api',blockchain);




//All the interactions for feeds

app.use('/api',interactionsFeeds);




// All the customizable 

app.use("/api",customizable);



// Admin auth 

app.use("/api",adminAuth);



// Admin APIs

app.use("/api",adminAPI);



// User targeting preferences

app.use("/api",targetingPreferences);



// User sell assets on Joyn Store

app.use("/api",userSellAssets);



module.exports = app;