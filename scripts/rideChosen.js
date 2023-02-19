const { getAddress, isAddress } = require("ethers/lib/utils")
const { ethers } = require("hardhat")

async function startRide() {
    const rideFree = await ethers.getContract("rideFree")

    const riderAddress = prompt("Rider Address");
    const driverAddress = prompt("Driver Address");
    if(!isAddress(riderAddress) || !isAddress(driverAddress))
        throw "Fill the correct address."

    // await rideFree.transferFareFromRider({value: })
}

startRide()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })