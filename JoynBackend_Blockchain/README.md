# Joyn API documentation

## Notes to use the API 

Pass the API secret key in the header with key name **joyn_api_secret_key**.  
Pass the token generated after login into the header with key name **Authorization**.  

**ATK - Authorization token**  
**ASK - API secret key for joyn**  


## Register new joyn user 

### ASK required  

**Endpoint**

http://167.71.239.221:8088/api/userRegister

**JSON body**

{
    "email":"nano@gmail.com",
    "username":"nano",
    "password":"nano123"
}



## Login API 

### ASK required  

**Endpoint**

http://167.71.239.221:8088/api/userLogin

**JSON body**

{
    "email_username":"giga",
    "password":"sagar8"
}



## Upload profile picture

### ASK required  

**Endpoint**

http://167.71.239.221:8088/api/uploadProfilePicture

**Headers Extra**
username (e.g: sagarparker)  

**Form data**

image    (Select an image file here)  
email    (For e.g sagar8parker@gmail.com)  



## Verify user 

### ASK & ATK required  

### Note : This API is only to check if a user's token is valid and if he is a registered user in database and not related to verification technologies Like Passbase,Yoti,etc .

**Endpoint**

http://167.71.239.221:8088/api/verifyUser


**Body**

No body required


## Passbase verified 

### ASK required  

**Endpoint**

http://167.71.239.221:8088/api/passbaseVerified


**JSON body**

{
    "email":"sagar8parker@gmail.com"
}




## Get user details - no populated data

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/getUserDetails


**JSON body**

{
    "email":"sagar8parker@gmail.com"
}  


## Get All user details - no populated data

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/getAllUsersDetails


**No JSON body required**




## Get user details + connections data

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/getUserConnections


**JSON body**

{
    "email":"sagar8parker@gmail.com"
}  


## Search Users API

### ASK & ATK required  

**Note: Since we are using regular expression in this API it would return the best reults for the input strings that have length greater than 2. Search is case insensitive at this moment**

**Endpoint**

http://167.71.239.221:8088/api/searchUsers


**JSON body**

{
    "username":"sagar"
}


## Updating user demographic details

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/editDemographicDetails


**JSON body**

{
    "gender":"Male",
    "nationality":"India",
    "country_residence":"India",
    "age":18
}



## Post a new feed - Pic

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/postNewFeedPic

**Form data**

multi-files     ( Select (image/video/gif) file here. Note: Maximum limit of file is 10 )  
description     ( For e.g : Hello this is my first Pic on Joyn platform )  
category		(Funny,Pets,Arts,Sports,News,Others) pass one of these as a value.



## Post a new feed - Jot

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/postNewFeedJot

**Form data**

multi-files     ( Select (image/video/gif) file here. Note: Maximum limit of file is 4, Minimum file limit is 0 )  
jotText         ( For e.g : Hello this is my first Jot on Joyn platform. Note: Maximum limit of text is 280 characters)  
category		(Funny,Pets,Arts,Sports,News,Others) pass one of these as a value.



## Post a new feed - Vibe

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/postNewFeedVibe

**Form data**

multi-files     ( Select (video) file here. Note: Maximum limit of file is 1. Only video format of (mp4/mkv) supported. Maximum File Size is 15mb )      
vibeText        ( For e.g : Hello this is my first Vibe on Joyn platform. Note: Maximum limit of text is 50 characters)  



## User can upload new asset to the Joyn store for selling with this API

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/uploadAssetToShop

**Form data**

multi-files     ( Select (image/video/gif) file here. Note: Maximum limit of file is 1 )  
type            ( Pass one as a asset type [wallpaper,homebutton,icon] )  
name    		( Name of the asset, this is always unique )  
price           ( Price of the token, For eg : 30 )  




## Get all the latest feeds post on Joyn - Latest posts - Only Pic and Jot

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/getAllFeeds


**Body**

No body required




## Get all the latest feeds post on Joyn from the accounts that user follows - Latest posts from following

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/getLatestPostsFromFollowings


**Body**

No body required




## Get posts in descending order of no of likes from the accounts that user follows - Popular posts from following

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/getPopularPostsFromFollowings


**Body**

No body required





## Get Popular feeds post on Joyn - Popular posts - Only Pic and Jot

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/getPopularPosts


**Body**

No body required


## Get all Vibe on Joyn 

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/getAllVibes


**Body**

No body required




## Get all feeds belonging to a user 

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/getUserFeeds


**JSON Body**

username 



## Get all feeds belonging to a particular category

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/getFeedsFromCategory


**JSON Body**

category		(Funny,Pets,Arts,Sports,News,All,Others) pass one of these as a value.




## Like a post

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/likePost


**Body**

post_id      (Enter the post id that is the _id of the post)


## Unlike a post

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/unLikePost


**Body**

post_id      (Enter the post id that is the _id of the post)





## Get Account Information from hedera account 

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/getAccountInfo



## Create Account with hedera , associate with it and transfer initialAmount for now 0

### ASK   

**Endpoint**

http://167.71.239.221:8088/api/createAccountAssociateTransfer


**JSON body**

{
	"username":"dummy1"
}


## Transfer Token Betwwen the user accounts

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/transferToken


**JSON body**

{
	"sender":"dummy1",
	"receiver":"dummy",
	"tokenAmount":"10"
}


## Add Token to the user account from admin account

### ASK & ATK required   

**Endpoint**

http://167.71.239.221:8088/api/addToken


**JSON body**

{
	"tokenAmount":"20"
}


## Deduct Token to the user account from admin account

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/deductToken


**JSON body**

{
	"tokenAmount":"20"
}


## To Mint Token (Usually Done By Admin)

### ASK   

**Endpoint**

http://167.71.239.221:8088/api/mintToken


**JSON body**

{
	"tokenAmount":"100"
}


## Follow a user

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/followUser


**Body**

user_id      (Enter the user id that is the (object id ) _id of the userdetials)


## Unfollow a user

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/unFollowUser

**Body**

user_id      (Enter the user id that is the (object id ) _id of the userdetails)


## Purchase Item

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/purchase


**JSON body**

{
    "id":"5ffd85c03b4f9941b8652de0",
}


## Get All Purchased and non-purchased Items

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/purchasedAndUnpurchasedItem



## Set Default Items

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/setDefault


**JSON body**

{
    "id":"5ffd85c03b4f9941b8652de0",
}



## Get Admin Account token balance

### ATK required  

**Endpoint**

http://167.71.239.221:8088/api/getAdminTotalToken



## Add a comment to the post on feed 

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/addCommentToPost


**JSON body**

{
    "post_id": "600011417e9fe13bf019581e",   (Post id of the post you want to add comment to)
    "post_comment": "This is a comment"
}


## Fetch comments for the post

### ASK & ATK required  

**Endpoint**

http://167.71.239.221:8088/api/getPostComments


**JSON body**

{
    "post_id": "600011417e9fe13bf019581e"   (Post id of the post you want to add comment to)
}


