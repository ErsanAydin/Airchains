const ethers = require('ethers');
require('dotenv').config();
const {
    ADDRESS_RECEIVER,
    GAS_LIMIT,
    PRIVATE_KEY,
    ETH_RPC_URL
} = process.env;

const provider = new ethers.providers.JsonRpcProvider(ETH_RPC_URL);

const increaseGasBy = 15000000000;

async function getCurrentGasPrice() {
    try {
        const currentGasPrice = await provider.getGasPrice();
        return (Number(currentGasPrice) + increaseGasBy).toString();
    }
    catch (err) {
        console.error(err);
    }
}

const delay = ms => new Promise(resolve => setTimeout(resolve, ms));

function getRandomDelay(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min) * 1000;
}

const bot = async () => {
    while (true) {
        provider.once("block", async () => {
            console.log("  Yeni Tx Oluşturuluyor...");
            const _target = new ethers.Wallet(PRIVATE_KEY);
            const target = _target.connect(provider);
            const balance = await provider.getBalance(target.address);
            const currentGasPrice = await getCurrentGasPrice();
            const balanceinEther = ethers.utils.formatEther(balance);

            if (Number(balanceinEther) > 0 && Number(currentGasPrice) > 0) {
                try {
                    await target.sendTransaction({
                        to: ADDRESS_RECEIVER,
                        value: ethers.utils.parseEther("0.0001"),  // Küçük bir miktar gönderiliyor
                        gasPrice: currentGasPrice,
                        gasLimit: GAS_LIMIT.toString()
                    });
                    console.log(`  Transfer Başarılı --> Cüzdan bakiyesi: ${ethers.utils.formatEther(balance)}`);
                } catch (error) {
                    console.log(`  HATA, TEKRAR DENENİYOR...`);
                }
            }
        });

        // 5 ile 15 saniye arasında rastgele bir süre bekle
        const randomDelay = getRandomDelay(5, 15);
        await delay(randomDelay);
    }
}

bot();
