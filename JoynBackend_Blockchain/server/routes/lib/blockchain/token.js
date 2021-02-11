class Token{
    constructor(){
        this.name = "John"
        this.symbol = "J"
        this.hbar = 0.01
        this.usd = 0.001
    }
    getTokenInfo = () =>{
        return (
            "TokenName = "+this.name +"\n"+
            "TokenSymbo = "+this.symbol+"\n"+
            "Mapping : \n"+
            "1 Token  =" + this.hbar +" Hbar\n"+
            "1 Token  =" + this.usd +" USD\n" 
            )
    }
    getHbarFromToken = (tokenAmount) => {
        return tokenAmount*this.hbar
    }
    getUSDfromToken = (tokenAmount)=>{
        return tokenAmount*this.usd
    }
}

module.exports = Token