# Dmail
基于汇流区块链的分散加密邮件系统。您可以使用此系统发送加密邮件。并且本系统可以在本地http服务器上使用
# Dmail
Decentralized encrypted mail system base on Conflux Block Chain. you can use this system send encrypted mail. and this system can use in local http server！ 
# 为什么信息是加密的？
因为区块链信息是公开透明的，如果不加密，大家都能看到。加密的主要目的是实现点对点通信。尽管信息是加密的，但区块链地址是可追踪的。
# Why is information encrypted?
Because the blockchain information is open and transparent, if it is not encrypted, everyone can see it. The main purpose of encryption is to realize point-to-point communication. Although the information is encrypted, the blockchain address is traceable.
# 私钥和公钥的安全性
本系统的公钥和私钥可以在初始化时随机生成，与CFX钱包密钥无关。随时更换。发送方通过区块链上的公钥加密数据。收到消息后，您可以通过本地私钥对其进行解密。本地密钥存储采用对称加密技术。请保护您的本地私钥以存储密码。这是一个典型的非对称加密过程。由于采用了比特币加密算法secp256k1，系统的安全性非常高。
# Security of private key and public key
The public key and private key of this system can be generated randomly at the time of initialization, which has nothing to do with the CFX Wallet Key. Replace at any time. The sender encrypts the data through your public key on the blockchain. After receiving the message, you decrypt it through the local private key. The local secret key storage adopts symmetric encryption technology. Please protect your local private key to store the password. This is a typical asymmetric encryption process. Because of the use of bitcoin encryption algorithm secp256k1, the security of the system is very high.
# 什么是代币或硬币？
代币从CFX 1:1转换为内部NFT铸造和交易。这个项目基于开源的概念，每个NFT只需要一个令牌。注意，事务注册函数将消耗1个令牌，购买NFT也将消耗1个令牌。令牌可以转移到其他地址。也可以转换为CFX提取。
# What is token or Coin?
The token was converted from CFX 1:1 for internal NFT casting and trading. This project is based on the concept of open source, each NFT only needs one token. Note that the transaction registration function will consume 1 token, and the purchase of NFT will also consume 1 token. Tokens can be transferred to other addresses. It can also be converted to CFX extraction.
# 为什么使用令牌模式？
因为为了方便合同的处理，提高处理速度和安全性，令牌和CFX可以进行等价交换。因此，它不是一个类似于Erc20的令牌，而是一个中间的数据交换。
# Why use token mode?
Because in order to facilitate the contract processing, improve the processing speed and security, the token and CFX and can be exchanged at the same value. Therefore, it is not a token similar to erc20, but a data exchange in the middle.
# 关于邮箱NFT
一个地址对应一个邮箱NFT，每个人都可以随时铸造邮箱NFT，只要这个名字没有被人注册。已经拥有邮箱NFT的情况下再铸造新的邮箱NFT会使得原本的NFT变成野生的NFT,被人随时可以抢先注册。已有邮箱NFT的情况下，购买新的NFT也会是原来的NFT变成野生的NFT
# About email NFT
An address corresponds to an email NFT. Everyone can cast an email NFT at any time, as long as the name is not registered. If you already have a mailbox NFT, casting a new mailbox NFT will turn the original NFT into a wild NFT, and people can register first at any time. In the case of an existing mailbox NFT, the purchase of a new NFT will turn the original NFT into a wild NFT
