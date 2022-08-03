
require('dotenv').config();
const {Name, Symbol, MaxSupply, PublicLimitPerWallet, PlaceholderURI, mintStartTime} = process.env;
async function main() {
    const Contract = await ethers.getContractFactory("NineLives")
    const contractInstance = await Contract.deploy(
        Name,
        Symbol,
        MaxSupply,
        PublicLimitPerWallet ,
        ["0x1561B8A12BA194Cdc55002ffb567f1fC69Afe75f" , "0x9Ad7b13f62ae54Fb78e2aeDFA7433Ac50f8a2694", "0xFb38c8F3c775c46ecE2d1b905f0D4690C29AEEA6"],      
        ["10", "10", "5"],
        PlaceholderURI ,
        mintStartTime
    )
    console.log(`Contract deployed to "${contractInstance.address}"`);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })