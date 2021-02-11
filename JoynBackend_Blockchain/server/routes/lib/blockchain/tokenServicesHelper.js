const clientHandler = require("./clientHelper");
require("dotenv").config();


const {
  PrivateKey,
  TokenCreateTransaction,
  TokenAssociateTransaction,
  TokenBurnTransaction,
  TokenDeleteTransaction,
  TokenDissociateTransaction,
  TokenFreezeTransaction,
  TokenGrantKycTransaction,
  TokenInfoQuery,
  TokenMintTransaction,
  TokenRevokeKycTransaction,
  TransferTransaction,
  TokenUnfreezeTransaction,
  TokenWipeTransaction,
  Hbar,
  Status
} = require("@hashgraph/sdk");


// 0.0.29631
const tokenGetInfo= async (token)=> {
  const client =await clientHandler.hederaClient();
  const tokenResponse = token;
  try {
    const info = await new TokenInfoQuery()
      .setTokenId(token.tokenId)
      .execute(client);

    tokenResponse.totalSupply = info.totalSupply;
    tokenResponse.expiry = info.expirationTime.toDate();
  } catch (err) {
      console.log(err)
}

  return tokenResponse;
}

const  tokenCreate= async (token)=> {
  let tokenResponse = {};
  const autoRenewPeriod = 7776000; // set to default 3 months
  const ownerAccount = process.env.MY_ACCOUNT_ID
  try {
    let additionalSig = false;
    let sigKey;
    const tx = await new TokenCreateTransaction();
    tx.setTokenName(token.name);
    tx.setTokenSymbol(token.symbol);
    tx.setDecimals(token.decimals);
    tx.setInitialSupply(token.initialSupply);
    tx.setTreasuryAccountId(token.treasury);
    // tx.setAutoRenewAccountId(token.autoRenewAccount);
    tx.setMaxTransactionFee(new Hbar(11));
    tx.setAutoRenewPeriod(autoRenewPeriod);

    if (token.adminKey) {
      sigKey = PrivateKey.fromString(token.adminKey);
      tx.setAdminKey(sigKey.publicKey);
      additionalSig = true;
    }
    if (token.kycKey) {
      sigKey = PrivateKey.fromString(token.adminKey);
      tx.setKycKey(sigKey.publicKey);
      additionalSig = true;
    }
    if (token.freezeKey) {
      sigKey = PrivateKey.fromString(token.adminKey);
      tx.setFreezeKey(sigKey.publicKey);
      additionalSig = true;
      tx.setFreezeDefault(token.defaultFreezeStatus);
    }
    else {
      tx.setFreezeDefault(false);
    }
    if (token.wipeKey) {
      additionalSig = true;
      sigKey = PrivateKey.fromString(token.adminKey);
      tx.setWipeKey(sigKey.publicKey);
    }
    if (token.supplyKey) {
      additionalSig = true;
      sigKey = PrivateKey.fromString(token.adminKey);
      tx.setSupplyKey(sigKey.publicKey);
    }
    const client =await  clientHandler.hederaClient();

    await tx.signWithOperator(client);

    if (additionalSig) {
      // TODO: should sign with every key (check docs)
      // since the admin/kyc/... keys are all the same, a single sig is sufficient
      await tx.sign(sigKey);
    }

    const response = await tx.execute(client);

    const transactionReceipt = await response.getReceipt(client);

    if (transactionReceipt.status !== Status.Success) {
      notifyError(transactionReceipt.status.toString());
    } else {
      token.tokenId = transactionReceipt.tokenId;

      const transaction = {
        id: response.transactionId.toString(),
        type: "tokenCreate",
        inputs:
          "Name=" +
          token.name +
          ", Symbol=" +
          token.symbol +
          ", Decimals=" +
          token.decimals +
          ", Supply=" +
          token.initialSupply +
          ", ...",
        outputs: "tokenId=" + token.tokenId.toString()
      };
    //   EventBus.$emit("addTransaction", transaction);

      const tokenInfo = await tokenGetInfo(token);

      tokenResponse = {
        tokenId: token.tokenId.toString(),
        symbol: token.symbol,
        name: token.name,
        totalSupply: token.initialSupply,
        decimals: token.decimals,
        autoRenewAccount: ownerAccount,
        autoRenewPeriod: autoRenewPeriod,
        defaultFreezeStatus: token.defaultFreezeStatus,
        kycKey: token.kycKey,
        wipeKey: token.wipeKey,
        freezeKey: token.freezeKey,
        adminKey: token.adminKey,
        supplyKey: token.supplyKey,
        expiry: tokenInfo.expiry,
        isDeleted: false,
        treasury: ownerAccount
      };

      // force refresh
    //   await store.dispatch("fetch");
    //   notifySuccess("token created successfully");
    }
    // return tokenResponse;
    console.log(tokenResponse)
  } catch (err) {
      console.log(err)
    // notifyError(err.message);
    return {};
  }
}


// tokenCreate({
//     name:"John",
//     symbol:"J",
//     decimals:3,
//     initialSupply:100,
//     adminKey:process.env.MY_PRIVATE_KEY,
//     treasury:process.env.MY_ACCOUNT_ID,
//     supplyKey:true,
//     // kycKey:true,
//     wipeKey:true,
//     freezeKey:true
// })


const tokenTransactionWithAmount = async(
  client,
  transaction,
  instruction,
  key
)=> {
  try {
    transaction.setTokenId(instruction.tokenId);
    if (typeof instruction.accountId !== "undefined") {
      transaction.setAccountId(instruction.accountId);
    }
    transaction.setAmount(instruction.amount);
    transaction.setMaxTransactionFee(new Hbar(1));

    await transaction.signWithOperator(client);
    await transaction.sign(key);

    const response = await transaction.execute(client);

    const transactionReceipt = await response.getReceipt(client);
    if (transactionReceipt.status !== Status.Success) {
      return {
        status: false
      };
    }
  
    console.log({
      status: true,
      transactionId: response.transactionId.toString()
    })
    return {
      status: true,
      transactionId: response.transactionId.toString()
    };
  } catch (err) {
    return {
      error:err.message,
      status: false
    };
  }
}



// export async function tokenBurn(instruction) {
//   instruction.successMessage =
//     "Burnt " + instruction.amount + " from token " + instruction.tokenId;
//   const token = state.getters.getTokens[instruction.tokenId];
//   const supplyKey = PrivateKey.fromString(token.supplyKey);
//   const tx = await new TokenBurnTransaction();
//   const client = ownerClient();
//   const result = await tokenTransactionWithAmount(
//     client,
//     tx,
//     instruction,
//     supplyKey
//   );
//   if (result.status) {
//     const transaction = {
//       id: result.transactionId,
//       type: "tokenBurn",
//       inputs:
//         "tokenId=" + instruction.tokenId + ", Amount=" + instruction.amount
//     };
//     EventBus.$emit("addTransaction", transaction);
//   }
//   return result.status;
// }

const tokenMint = async (instruction)=> {
  instruction.successMessage =
    "Minted " + instruction.amount + " for token " + instruction.tokenId;
  const supplyKey = PrivateKey.fromString(instruction.supplyKey);
  const tx = await new TokenMintTransaction();
  const client = await clientHandler.hederaClient();
  let result = await tokenTransactionWithAmount(
    client,
    tx,
    instruction,
    supplyKey
  );
  if (result.status) {
     result = {
      status:true,
      transactionId: result.transactionId,
      message: "tokenId=" + instruction.tokenId + ", Amount=" + instruction.amount
    };
  }
  return result;
}

// tokenMint({
//   amount:100,
//   tokenId:process.env.TOKEN_ID,
//   supplyKey:process.env.MY_PRIVATE_KEY,
//   // accountId:process.env.MY_ACCOUNT_ID
// })

// export async function tokenWipe(instruction) {
//   instruction.successMessage =
//     "Wiped " + instruction.amount + " from account " + instruction.accountId;
//   const token = state.getters.getTokens[instruction.tokenId];
//   const supplyKey = PrivateKey.fromString(token.wipeKey);
//   const tx = await new TokenWipeTransaction();
//   const client = ownerClient();
//   const result = await tokenTransactionWithAmount(
//     client,
//     tx,
//     instruction,
//     supplyKey
//   );
//   if (result.status) {
//     const transaction = {
//       id: result.transactionId,
//       type: "tokenWipe",
//       inputs:
//         "tokenId=" +
//         instruction.tokenId +
//         ", AccountId=" +
//         instruction.accountId +
//         ", Amount=" +
//         instruction.amount
//     };
//     EventBus.$emit("addTransaction", transaction);
//   }
//   return result.status;
// }
const  tokenTransactionWithIdAndAccount =async (
  client,
  transaction,
  instruction,
  key
)=> {
  try {
    transaction.setTokenId(instruction.tokenId);
    transaction.setAccountId(instruction.accountId);
    transaction.setMaxTransactionFee(new Hbar(1));

    await transaction.signWithOperator(client);
    await transaction.sign(key);

    const response = await transaction.execute(client);

    const transactionReceipt = await response.getReceipt(client);
    if (transactionReceipt.status !== Status.Success) {
      return {
        status: false,
        error:"Transaction Failed "
      };
    }
    return {
      status: true,
      transactionId: response.transactionId.toString()
    };
  } catch (err) {
    return {
      status: false,
      error:err
    };
  }
}

const  tokenFreeze = async (instruction) => {
  const freezeKey = PrivateKey.fromString(instruction.freezeKey);
  const tx = await new TokenFreezeTransaction();
  const client =await  clientHandler.hederaClient();
  const result = await tokenTransactionWithIdAndAccount(
    client,
    tx,
    instruction,
    freezeKey
  );
  if (result.status) {
    const transaction = {
      taransactionId: result.transactionId,
      status:true,
      message:
        "tokenId=" +
        instruction.tokenId +
        ", AccountId=" +
        instruction.accountId
    };
    return transaction;
  }
  return result;
}

//tokenId ,aaccountId, freezekey 
const tokenUnFreeze = async (instruction)=> {
  const freezeKey = PrivateKey.fromString(transaction.freezeKey);
  const tx = await new TokenUnfreezeTransaction();
  const client = await clientHandler.hederaClient();
  const result = await tokenTransactionWithIdAndAccount(
    client,
    tx,
    instruction,
    freezeKey
  );
  if (result.status) {
    const transaction = {
      transactionId: result.transactionId,
      status:true,
      message:
        "tokenId=" +
        instruction.tokenId +
        ", AccountId=" +
        instruction.accountId
    };
    return transaction;

  }
  return result;
}

// export async function tokenGrantKYC(instruction) {
//   const token = state.getters.getTokens[instruction.tokenId];
//   const kycKey = PrivateKey.fromString(token.kycKey);
//   const tx = await new TokenGrantKycTransaction();
//   instruction.successMessage =
//     "Account " + instruction.accountId + " KYC Granted";
//   const client = ownerClient();
//   const result = await tokenTransactionWithIdAndAccount(
//     client,
//     tx,
//     instruction,
//     kycKey
//   );
//   if (result.status) {
//     const transaction = {
//       id: result.transactionId,
//       type: "tokenGrantKYC",
//       inputs:
//         "tokenId=" +
//         instruction.tokenId +
//         ", AccountId=" +
//         instruction.accountId
//     };
//     EventBus.$emit("addTransaction", transaction);
//   }
//   return result.status;
// }

// export async function tokenRevokeKYC(instruction) {
//   const token = state.getters.getTokens[instruction.tokenId];
//   const kycKey = PrivateKey.fromString(token.kycKey);
//   const tx = await new TokenRevokeKycTransaction();
//   instruction.successMessage =
//     "Account " + instruction.accountId + " KYC Revoked";
//   const client = ownerClient();
//   const result = await tokenTransactionWithIdAndAccount(
//     client,
//     tx,
//     instruction,
//     kycKey
//   );
//   if (result.status) {
//     const transaction = {
//       id: result.transactionId,
//       type: "tokenRevokeKYC",
//       inputs:
//         "tokenId=" +
//         instruction.tokenId +
//         ", AccountId=" +
//         instruction.accountId
//     };
//     EventBus.$emit("addTransaction", transaction);
//   }
//   return result.status;
// }

const tokenAssociationTransaction=async (
  transaction,
  tokenId,
  account,
) => {
  const client = await clientHandler.hederaClientForUser(account);
  const userKey = PrivateKey.fromString(account.privateKey);

  try {
    console.log(tokenId)
    transaction.setTokenIds([tokenId]);
    transaction.setAccountId(account.accountId);
    transaction.setMaxTransactionFee(new Hbar(1));

    await transaction.signWithOperator(client);
    await transaction.sign(userKey);

    const response = await transaction.execute(client);

    const transactionReceipt = await response.getReceipt(client);
    if (transactionReceipt.status !== Status.Success) {
      return {
        status: false,
        error:`Failed To Associate With Account ${account.accountId} with tokenId ${tokenId}`
      };
    }

    return {
      status: true,
      transactionId: response.transactionId.toString()
    };
  } catch (err) {
    return {
      status: false,
      error:err
    };
  }
}

const tokenAssociate = async(tokenId,account)=> {
//   const account = getAccountDetails(user);
  console.log(tokenId,account)
  const tx = await new TokenAssociateTransaction();
  const result = await tokenAssociationTransaction(
    tx,
    tokenId,
    account,
  );
  console.log(result)
  if (result.status) {
    const transaction = {
      status:true,
      id: result.transactionId,
      message: "tokenId=" + tokenId + ", AccountId=" + account.accountId
    };
    return transaction
  }
  
  return result.status;
}
const account = {
    accountId: '0.0.31229',
    privateKey: '302e020100300506032b65700422042047ea69254552a2dd7521cee01b9b0939d8ea1b5807c634cfe5f353785581c595',

  }

  // tokenAssociate( "0.0.31230",account)
// export async function tokenDissociate(tokenId, user) {
//   const account = getAccountDetails(user);
//   const tx = await new TokenDissociateTransaction();
//   const result = await tokenAssociationTransaction(
//     tx,
//     tokenId,
//     account,
//     user,
//     "token successfully dissociated"
//   );
//   if (result.status) {
//     const transaction = {
//       id: result.transactionId,
//       type: "tokenDissociate",
//       inputs: "tokenId=" + tokenId + ", AccountId=" + account.accountId
//     };
//     EventBus.$emit("addTransaction", transaction);
//   }
//   return result.status;
// }

// export async function tokenSwap(
//   from,
//   to,
//   token1,
//   tokenQuantity1,
//   token2,
//   tokenQuantity2,
//   hBars
// ) {
//   const account = getAccountDetails(from);
//   const client = hederaClientForUser(from);

//   try {
//     const tx = await new TransferTransaction();
//     if (token1 !== "" && tokenQuantity1 !== 0) {
//       tx.addTokenTransfer(token1, account.accountId, -tokenQuantity1);
//       tx.addTokenTransfer(token1, to, tokenQuantity1);
//     }
//     if (token2 !== "" && tokenQuantity2 !== 0) {
//       tx.addTokenTransfer(token2, account.accountId, -tokenQuantity2);
//       tx.addTokenTransfer(token2, to, tokenQuantity2);
//     }
//     if (hBars !== 0) {
//       tx.addHbarTransfer(account.accountId, new Hbar(hBars));
//       tx.addHbarTransfer(to, new Hbar(-hBars));
//     }

//     tx.setMaxTransactionFee(new Hbar(1));
//     tx.freezeWith(client);

//     // signature only required if transferring from the 'to' address, but
//     // let's sign anyway for now
//     //TODO: Only sign if necessary
//     const sigKey = await PrivateKey.fromString(getPrivateKeyForAccount(to));
//     await tx.sign(sigKey);

//     const result = await tx.execute(client);
//     const transactionReceipt = await result.getReceipt(client);

//     if (transactionReceipt.status !== Status.Success) {
//       notifyError(transactionReceipt.status.toString());
//       return false;
//     } else {
//       // force refresh
//       await store.dispatch("fetch");
//       notifySuccess("tokens transferred successfully");
//       const transaction = {
//         id: result.transactionId.toString(),
//         type: "tokenTransfer",
//         inputs: ""
//       };
//       EventBus.$emit("addTransaction", transaction);
//       return true;
//     }
//   } catch (err) {
//     notifyError(err.message);
//     return false;
//   }
// }

const tokenTransfer = async (
  tokenId,
  account, //giver
  quantity,
  hbar,
  destination
) => {

  const client = await clientHandler.hederaClientForUser(account);
  try {
    const tx = await new TransferTransaction();
    tx.addTokenTransfer(tokenId, account.accountId, -quantity);
    tx.addTokenTransfer(tokenId, destination.accountId, quantity);
    tx.setMaxTransactionFee(new Hbar(1));
    if (hbar !== 0) {
      // token recipient pays in hBar and signs transaction
      tx.addHbarTransfer(destination, new Hbar(-hbar));
      tx.addHbarTransfer(account.accountId, new Hbar(hbar));
      tx.freezeWith(client);
      const sigKey = await PrivateKey.fromString(
          destination.privateKey
        // getPrivateKeyForAccount(destination)
      );
      await tx.sign(sigKey);
    }

    const result = await tx.execute(client);
    const transactionReceipt = await result.getReceipt(client);

    if (transactionReceipt.status !== Status.Success) {
    return {
      status: false,
      error:"Unable to transfer Tokens"
    };
    } else {
     
      const transaction = {
        status: true,
        id: result.transactionId.toString(),
        message:
          "tokenId=" +
          tokenId +
          ", from=" +
          account.accountId +
          ", to=" +
          destination +
          ", amount=" +
          quantity
      };
      return transaction
    }
  } catch (err) {

    // console.log(err)
    return {
      status: false,
      error:err.message
    };;
  }
}

// tokenTransfer(
//     "0.0.31230",
//     {
//         accountId:process.env.MY_ACCOUNT_ID,
//         privateKey:process.env.MY_PRIVATE_KEY
//     },
//     1,
//     0,
//     {
//       accountId: '0.0.35599',
//       privateKey:"302e020100300506032b657004220420c48310e490c53e21009a833c992f26b2bcc5783f5e11480d26a7710a10728e73",
//     }
// )

// export async function tokenDelete(token) {
//   const client = ownerClient();
//   try {
//     let tx = await new TokenDeleteTransaction();
//     tx.setTokenId(token.tokenId);
//     tx.setMaxTransactionFee(new Hbar(1));

//     await tx.signWithOperator(client);
//     if (typeof token.adminKey !== "undefined") {
//       await tx.sign(PrivateKey.fromString(token.adminKey));
//     }

//     const response = await tx.execute(client);

//     const transactionReceipt = await response.getReceipt(client);

//     if (transactionReceipt.status !== Status.SUCCESS) {
//       notifyError(transactionReceipt.status.toString());
//       return false;
//     } else {
//       // force refresh
//       await store.dispatch("fetch");
//       notifySuccess("Token deleted successfully");
//       const transaction = {
//         id: response.transactionId.toString(),
//         type: "tokenDelete",
//         inputs: "tokenId=" + token.tokenId
//       };
//       EventBus.$emit("addTransaction", transaction);
//       return true;
//     }
//   } catch (err) {
//     notifyError(err.message);
//     return false;
//   }
// }

module.exports ={
  tokenMint,
  tokenFreeze,
  tokenUnFreeze,
  tokenTransfer,
  tokenAssociate,
  tokenCreate
}