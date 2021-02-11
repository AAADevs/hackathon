const { Client,
    PrivateKey,
    AccountCreateTransaction,
    AccountInfoQuery,
    TransferTransaction,
    Hbar,
    Status
 } = require("@hashgraph/sdk");
 require("dotenv").config();

const checkProvided = (environmentVariable)=> {
    if (environmentVariable === null) {
      return false;
    }
    if (typeof environmentVariable === "undefined") {
      return false;
    }
    return true;
}

const hederaClientForUser= (account)=>{
    //   const account = getAccountDetails(user);
      return hederaClientLocal(account.accountId, account.privateKey);
}

    
const hederaClient =async () =>{

      const operatorPrivateKey = process.env.MY_PRIVATE_KEY;
      const operatorAccount = process.env.MY_ACCOUNT_ID;
      if (!checkProvided(operatorPrivateKey) || !checkProvided(operatorAccount)) {
        throw new Error(
          "environment variables APP_OPERATOR_KEY and APP_OPERATOR_ID must be present"
        );
      }
      return hederaClientLocal(operatorAccount, operatorPrivateKey);
    }
    
    const hederaClientLocal = async (operatorAccount, operatorPrivateKey)=> {
      if (!checkProvided(process.env.NETWORK)) {
        throw new Error("APP_NETWORK_NODES must be set in .env");
      }
    
      const network = {};
      network[process.env.NETWORK] = "0.0.3";
      const client = Client.forNetwork(network);
      client.setOperator(operatorAccount, operatorPrivateKey);
      return client;
    }
    
    // ----------------------
      
const accountCreate = async (wallet) => {
        try{
        const client = await hederaClient();
        const privateKey = await PrivateKey.generate();
        const response = await new AccountCreateTransaction()
          .setKey(privateKey.publicKey)
          .setMaxTransactionFee(new Hbar(1))
          .setInitialBalance(new Hbar(parseInt(process.env.ACCOUNT_INITIAL_BALANCE)))
          .execute(client);
        const transactionReceipt = await response.getReceipt(client);
        if (transactionReceipt.status !== Status.Success) {
          return {
            status: false,
            error:"Unable to transfer Tokens"
          };
        } 
        const newAccountId = transactionReceipt.accountId;
      
        const transaction = {
          id: response.transactionId.toString(),
          type: "cryptoCreate",
          inputs: "initialBalance=" + process.env.ACCOUNT_INITIAL_BALANCE,
          outputs: "accountId=" + newAccountId.toString()
        };
        return {
          status: true,
          newAccountId: newAccountId.toString(),
          privateKey: privateKey.toString(),
        };
      }catch(e){
        return {
          status: false,
          error:e
        };
      }

    }
    
    
    // 0.0.29631 -->token
const accountGetInfo=async (accountId)=> {
        const client =await hederaClient();
        try {
          // cycle token relationships
          let tokenRelationships = {};
          const info = await new AccountInfoQuery()
            .setAccountId(accountId)
            .execute(client);
          const hBarBalance = info.balance;
          for (let key of info.tokenRelationships.keys()) {
            const tokenRelationship = {
              tokenId: key.toString(),
              balance: info.tokenRelationships.get(key).balance.toString(),
              freezeStatus: info.tokenRelationships.get(key).isFrozen,
              kycStatus: info.tokenRelationships.get(key).isKycGranted
            };
            tokenRelationships[key] = tokenRelationship;
          }
          console.log( {
            hbarBalance:hBarBalance.toString(),
            token:parseFloat(hBarBalance.toString().split(" ")[0])*100,
            tokenRelationships
          })
          return {
            status:true,
            hbarBalance:hBarBalance.toString(),
            token:parseFloat(hBarBalance.toString().split()[0])*100,
            tokenRelationships
          };
      } catch (err) {

        return{
          status:false,
          error:err
        }
      }
    }
    // accountGetInfo(process.env.MY_ACCOUNT_ID)
    // accountGetInfo("0.0.2825")


    const tokenTransfer = async (
      account, //giver
      hbar,
      destination
    ) => {
    
      const client = await hederaClientForUser(account);
      try {
        // const transactionBeforeInfo = await new AccountInfoQuery()
        //     .setAccountId(account.accountId)
        //     .execute(client);
        //   const beforehBarBalance = parseFloat(transactionBeforeInfo.balance.toString().split(" ")[0]);
          
        const tx = await new TransferTransaction();
          // token recipient pays in hBar and signs transaction
          
          tx.addHbarTransfer(destination.accountId, new Hbar(hbar));
          tx.addHbarTransfer(account.accountId, new Hbar(-hbar));
          tx.setMaxTransactionFee(new Hbar(1))
          tx.freezeWith(client);
          const sigKey = await PrivateKey.fromString(
              destination.privateKey
          );
          await tx.sign(sigKey);
    
        const result = await tx.execute(client);
        const transactionReceipt = await result.getReceipt(client);
          
        if (transactionReceipt.status !== Status.Success) {
          return {
            status: false,
            error:"Unable to transfer Tokens"
          };
        } else {
          const transactionAfterInfo = await new AccountInfoQuery()
            .setAccountId(account.accountId)
            .execute(client);
          const afterhBarBalance = parseFloat(transactionAfterInfo.balance.toString().split(" ")[0]);;
          const transaction = {
            status: true,
            token: afterhBarBalance*100,
            id: result.transactionId.toString(),
            message:
              "from=" +
              account.accountId +
              ", to=" +
              destination.accountId +
              ", amount=" +
              hbar*100
          };
          return transaction
        }
      } catch (err) {
          return {
          status: false,
          error:err.message
        };;
      }
    }
    
    // {
    //   accountId: '0.0.31229',
    //   account: {
    //     privateKey: '302e020100300506032b65700422042047ea69254552a2dd7521cee01b9b0939d8ea1b5807c634cfe5f353785581c595',
    //     tokenRelationships: {}
    //   }
    // }
    // 0.0.8685
    // 302e020100300506032b6570042204203cd5f152004090b7b9e5845aafea88ba38c376e18467a5602708f2318ad44d7b

    // 0.0.8679
    // 302e020100300506032b657004220420d60391d6d982f606e366814a618b0132397137c2b45d29e66d1238d1f82dcc6e
  module.exports =   {
    hederaClient,
    hederaClientForUser,
    accountCreate,
    accountGetInfo,
    tokenTransfer
  }

  
  
  // tokenTransfer(
  //     {
  //         accountId:process.env.MY_ACCOUNT_ID,
  //         privateKey:process.env.MY_PRIVATE_KEY
  //     },
  //     100,
  //     {
  //       accountId: '0.0.8685',
  //       privateKey:"302e0201003  00506032b6570042204203cd5f152004090b7b9e5845aafea88ba38c376e18467a5602708f2318ad44d7b",
  //     }
  // )