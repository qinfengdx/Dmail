//SPDX-License-Identifier:MIT
pragma solidity >=0.8.4;
import "./SponsorWhitelistControl.sol";
import "./dataPice.sol";
import "./SafeMath.sol";
import "./Address.sol";
contract SMS {
  SponsorWhitelistControl constant private SPONSOR = SponsorWhitelistControl(address(0x0888000000000000000000000000000000000001));
  address private minter;
  uint private daynumber=31;
  uint256 private contractNumber=0;
  mapping (address => string) private publicKey;//公钥
  mapping (address => bool) private havepublicKey;//是否有公钥
  
  mapping (string => address) private EmailName;//emailName\
  mapping (address => string) private addrToEmailName;//emailName
  mapping (string => bool) private haveEmailName;//是否有Emailname
  mapping (string => address) private realEmailName;//是否有Emailname
  mapping (string => bool) private haverealEmailName;//是否有Emailname

  event PUKCreate(address sender, string puk);
  event emailNameCreate(address sender, string name);

  mapping (uint => bool) private haveEMAIL_datapice;
  mapping (uint => address) private EMAIL_datapice;//Email分片存储
  mapping (uint => uint) private EMAIL_datapice_Time;

  mapping(address => uint) private Coins;//地址里的通证余额
  mapping(string => uint) private TransactionPrice;//通证 价格 去中心化交易
  mapping(string => bool) private isOnTransaction;//通证是否挂卖交易 去中心化交易
  event Sent(address  _from,address  _to,uint amount);
  event saleEvent(address  _from,string domain,uint value);//sale事件
  event cancelsaleEvent(address  _from,string domain);//sale取消事件
  event buyEvent(address  _from,address  _to, string domain,uint value);//buy事件
  event GETCOINEVENT(address  _from,uint value1,uint value2);//getCoin事件
  event ExchangeCOINEVENT(address  _from,uint value1,uint value2);//getCoin事件

  constructor() {
    minter = msg.sender;
    Coins[minter]=1000;//创世
    //address[] memory a = new address[](1);
    //a[0] = minter;
   // SPONSOR.addPrivilege(a);
    //测试网
     address[] memory a = new address[](1);
      a[0] = address(0x0000000000000000000000000000000000000000);
      SPONSOR.addPrivilege(a);
    //
     dataPice dp=new dataPice(minter);
        address address_dp=address(dp);
        time=block.timestamp;
        EMAIL_datapice_Time[contractNumber]=block.timestamp;
        haveEMAIL_datapice[contractNumber]=true;
        EMAIL_datapice[contractNumber]=address_dp;
        contractNumber=SafeMath.add(contractNumber,1);
  }
  function getcontractNumber() public view returns(uint){
    return contractNumber;
  }
  function getEMAIL_datapice_Time(uint num) public view returns(uint){
    return EMAIL_datapice_Time[num];
  }
  function AutoDeployDataPice_AUTO() private{//86400  30天一片
    dataPice dp=new dataPice(msg.sender);
    time=block.timestamp;
    EMAIL_datapice_Time[contractNumber]=block.timestamp;
    haveEMAIL_datapice[contractNumber]=true;
    EMAIL_datapice[contractNumber]=address(dp);
    contractNumber=SafeMath.add(contractNumber,1);
  }
//关联真实QQ邮箱
 function InitrealEmailName(string memory  Qname) public  returns(bool){
    require(bytes(Qname).length<32,"too long!");
    require(isContract(msg.sender)==false,"Stupid hacker!");
    require(Address.isContract(msg.sender)==false,"You are not human");
    require(haverealEmailName[Qname]==false," This mailbox has been bound");
    require(Coins[msg.sender]>=1,"Your SMS Coin is not enough. It must be greater than 1 ");
    realEmailName[Qname]=msg.sender;
    haverealEmailName[Qname]=true;
    Coins[msg.sender]=SafeMath.sub(Coins[msg.sender],1);
    Coins[minter]=SafeMath.add(Coins[minter],1);
    return true;
 }
 //删除关联真实QQ邮箱
  function DeletrealEmailName(string memory DQname) public  returns(bool){
    require(isContract(msg.sender)==false,"Stupid hacker!");
    require(Address.isContract(msg.sender)==false,"You are not human");
    require(haverealEmailName[DQname]==true," This mailbox has not been bound");
    haverealEmailName[DQname]=false;
    return true;
 }
 //获取关联真实QQ邮箱
  function CallrealEmailName(string memory  CEname) public view returns(address){
    require(haverealEmailName[CEname]==true,"This mailbox has not been bound");
    return realEmailName[CEname];
 }
// EMAIL 分片 通过时间来索引 新合约地址
function getEMAIL_datapice(uint number) public view returns(address addr){//获取 分片存储 合约地址
    require(haveEMAIL_datapice[number],"Do not Find This Data Pice ");
    return EMAIL_datapice[number];  
}
function getEMAIL_datapice_Now() public view returns(address addr){//获取 分片存储 合约地址
    require(haveEMAIL_datapice[contractNumber-1]);
    return EMAIL_datapice[contractNumber-1]; 
}
  function name() public pure returns(string memory){//合约名字
    return "SMS";  
  }
  function symbol() public pure returns(string memory){//NFT
    return "SMSc";
  } 
  uint public time;
  
    function kill() public {
    require(isContract(msg.sender)==false,"Stupid hacker!");
       if (minter == msg.sender) { // 检查谁在调用
          selfdestruct(payable(msg.sender)); // 销毁合约
       }
    }

  //更tokenID  返回持有者地址
  function ownerOf(string memory OWname) public view returns (address owner) {//通证持有者地址
    require(haveEmailName[OWname],"Do not have this EmailName ");
    return EmailName[OWname];
  }
  // Address获取 name
 function getNameFromAddr(address GNFtokenOwner) public view returns(string memory){//
    return addrToEmailName[GNFtokenOwner];
  }
// publicKey获取
 function getpublicKeyFromAddr(address GPFtokenOwner) public view returns(string memory){
    require(havepublicKey[GPFtokenOwner],"publicKey is not Init");//
    return publicKey[GPFtokenOwner];
  }
  // publicKey获取
 function getpublicKeyFromName(string memory GPFname) public view returns(string memory){
    require(haveEmailName[GPFname],"Do not have this EmailName");//有名称
    require(havepublicKey[EmailName[GPFname]],"Do not have this EmailName's publicKey ");//有公钥
    return publicKey[EmailName[GPFname]];//返回PUK
  }
// 注册时自动调用
  function InitpublicKey(string memory  PUK) public returns(bool) {
    require(isContract(msg.sender)==false,"Stupid hacker!");
    require(Address.isContract(msg.sender)==false,"You are not human");
    require(bytes(PUK).length<512,"Stupid hacker!");
    publicKey[msg.sender] = PUK;
    havepublicKey[msg.sender]=true;
    if(block.timestamp-time>=86400*daynumber){
      AutoDeployDataPice_AUTO();
    }
    emit PUKCreate(msg.sender,PUK);
    return true;
  }
  // name注册
  function InitEmailName(string memory  IEname) public  returns(bool){
    require(isContract(msg.sender)==false,"Stupid hacker!");
    require(Address.isContract(msg.sender)==false,"You are not human");
    require(Coins[msg.sender]>=1,"Your SMS Coin is not enough. It must be greater than 1");
    require(haveEmailName[IEname]==false,"this EmailName is occupied ");//没有名称
    Coins[msg.sender]= SafeMath.sub(Coins[msg.sender],1);
    Coins[minter]= SafeMath.add(Coins[minter],1);
    EmailName[IEname] = msg.sender;
    haveEmailName[IEname]=true;
    haveEmailName[addrToEmailName[msg.sender]]=false;//老的放弃掉
    addrToEmailName[msg.sender]=IEname;
    isOnTransaction[IEname]=false;
    emit emailNameCreate(msg.sender,IEname);
    return true;
  }
  //去中心化交易
   //查币

  function balanceOf(address _owner) public view returns(uint){ //地址里的通证余额
    return Coins[_owner];
  }
  //充币 1:1
  function getCoin() public payable returns(bool){
     require(isContract(msg.sender)==false,"Stupid hacker!");
    require(Address.isContract(msg.sender)==false,"You are not human");
     require(msg.value>=1*10**18&&msg.value < 10000*10**18,"CFX number must be greater than 1   < 10000");
     Coins[msg.sender]=SafeMath.add(Coins[msg.sender],SafeMath.div(msg.value,(10**18)));
     //1cfx=1
      emit GETCOINEVENT(msg.sender,msg.value, Coins[msg.sender]);
     return true;
    }
    //转币
  function sendCoin(address receiver, uint amount) public {
    require(isContract(msg.sender)==false,"Stupid hacker!");
    require(Address.isContract(msg.sender)==false,"You are not human");
    require(amount <= SafeMath.add(Coins[msg.sender],1), "Insufficient balance.");
    require(amount < 10000*10**18&&amount>=1,"data overflow!");
    Coins[msg.sender]=SafeMath.sub(Coins[msg.sender],SafeMath.add(amount,1));
    Coins[receiver] = SafeMath.add(Coins[receiver],amount);
    Coins[minter]=SafeMath.add(Coins[minter],1);
    emit Sent(msg.sender, receiver, amount);
  }
  //提币 value 1个cfx
  function exchangeCoin(uint value) public payable returns(bool){//
    require(isContract(msg.sender)==false,"Stupid hacker!");
    require(Address.isContract(msg.sender)==false,"You are not human");
    require(value>=1&&value<=10000,"The number of withdrawals must be greater than 1 and less than 1000000!");
    require(Coins[msg.sender]>=SafeMath.add(value,1),"Your SMSc is not enough  ");
    Coins[msg.sender]=SafeMath.sub(Coins[msg.sender],1);
    Coins[msg.sender]=SafeMath.sub(Coins[msg.sender],value);
    Coins[minter]=SafeMath.add(Coins[minter],1);
    payable(msg.sender).transfer(value * 10**18);
    emit ExchangeCOINEVENT(msg.sender,value,Coins[msg.sender]);
    return true;
  }
  //去中心化交易
//挂单
  function sale(string memory SAname,uint value) public returns(bool) {
    require(isContract(msg.sender)==false,"Stupid hacker!");
    require(Address.isContract(msg.sender)==false,"You are not human");
    require(value>=1,"Your Price  must be greater than 1");
    require(value < 100000*10*18,"data overflow!");
    require(haveEmailName[SAname],"Do not have this EmailName");
    require(isOnTransaction[SAname]==false,"this EmailName is not On Transaction");//没有挂单
    require(msg.sender == ownerOf(SAname));
    require(Coins[msg.sender]>=1);
    Coins[msg.sender]=SafeMath.sub(Coins[msg.sender],1);//手续费
    Coins[minter]=SafeMath.add(Coins[minter],1);
    TransactionPrice[SAname]=value;
    isOnTransaction[SAname]=true;
    emit saleEvent(msg.sender,SAname,value);
    return true;
  }
  //取消挂单
function cancelsale(string memory CAname) public returns(bool) {
    require(isContract(msg.sender)==false,"Stupid hacker!");
    require(Address.isContract(msg.sender)==false,"You are not human");
    require(haveEmailName[CAname],"Do not have this EmailName");
    require(isOnTransaction[CAname],"this EmailName is not On Transaction");//已经挂单
    address currentOwner = msg.sender;
    require(currentOwner == ownerOf(CAname),"this EmailName is not belongs to you");
    TransactionPrice[CAname]=0;
    isOnTransaction[CAname]=false;
    emit cancelsaleEvent(currentOwner,CAname);
    return true;
  }
//买单
function buy(string memory BUname) public returns(bool) {
    require(isContract(msg.sender)==false,"Stupid hacker!");
    require(Address.isContract(msg.sender)==false,"You are not human");
    require(haveEmailName[BUname],"Do not have this EmailName");//存在
    address currentOwner = msg.sender;
    require(isOnTransaction[BUname],"this EmailName is not On Transaction");//已挂单
    require(Coins[currentOwner]>=TransactionPrice[BUname]+1,"Your SMSc is not enough");//币够
    address oldOwner=EmailName[BUname];
    require(oldOwner!=currentOwner,"you can not buy name that belong to you!");//不能自己买自己
    uint price=TransactionPrice[BUname];
    Coins[currentOwner]=SafeMath.sub(Coins[currentOwner],1);//手续费
    Coins[minter]=SafeMath.add(Coins[minter],1);
    Coins[currentOwner]=SafeMath.sub(Coins[currentOwner],price);//售价
    TransactionPrice[BUname]=0;
    haveEmailName[addrToEmailName[currentOwner]]=false;
    isOnTransaction[BUname]=false;//下架
    Coins[oldOwner]=SafeMath.add(Coins[oldOwner],price);//卖家获得钱
    EmailName[BUname]=currentOwner;//更改所有权
    addrToEmailName[currentOwner]=BUname;

    emit buyEvent(oldOwner,currentOwner,BUname,price);
    return true;
  }
  //详 价
  function getPrice(string memory GPname) public view returns(uint) {
    require(haveEmailName[GPname],"Do not have this EmailName");//存在
    require(isOnTransaction[GPname],"this EmailName is not On Transaction ");//已挂单
    return TransactionPrice[GPname];
  }
  //详 是否售卖
  function getisOnTransaction(string memory GOname) public view returns(bool) {
    return isOnTransaction[GOname];
  }

  //###################智能合约安全###############################################
  // conflux特有合约判定大法
  function isContract(address _addre) private pure returns (bool) {
    return uint160(_addre) > (type(uint160).max/ 2) ? true : false;
  }

}