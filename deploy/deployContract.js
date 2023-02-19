const { network, ethers } = require("hardhat")
const {
    networkConfig,
    developmentChains,
    VERIFICATION_BLOCK_CONFIRMATIONS,
} = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId
        
    const waitBlockConfirmations = developmentChains.includes(network.name)
        ? 1
        : VERIFICATION_BLOCK_CONFIRMATIONS

    log("----------------------------------------------------")
    const arguments = [
        networkConfig[chainId]["gasLane"]
    ]
    const rideFree = await deploy("rideFree", {
        from: deployer,
        args: arguments,
        log: true,
        waitConfirmations: waitBlockConfirmations,
    })


    // Verify the deployment
    if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
        log("Verifying...")
        await verify(rideFree.address, arguments)
    }

    log("Start Riding using this command.")
    const networkName = network.name == "hardhat" ? "localhost" : network.name
    log(`yarn hardhat run scripts/rideChosen.js --network ${networkName}`)
    log("----------------------------------------------------")
}

