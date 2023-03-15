pragma solidity ^0.5.0;

contract Marketplace{
    string public name;
    uint public productCount = 0;
    mapping(uint => Product) public products;
    struct Product{
        uint id;
        string name;
        uint price;
        address payable owner;
        bool purchased;
    }
    event ProductCreated(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    event ProductPurchased(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    constructor() public{
        name = "Speedwall coding!!";
    }


    function createProduct(string memory _name,uint _price) public{
        // require a valid name
        require(bytes(_name).length > 0,"provide a valid name for the product");
        // require a valid price
        require(_price > 0, "provide a valid price");
        productCount++;
        // create a product
        products[productCount] = Product(productCount,_name,_price,msg.sender,false);
        // trigger an events
        emit ProductCreated(productCount, _name, _price, msg.sender, false);
    }



    function purchaseProduct(uint _id) public payable {
        // fetch product using id
        Product memory _product = products[_id];
        // fetch seller using product
        address payable _seller = _product.owner;
        // requirement fulfil
        // check for valid id
        require(_product.id > 0 && _product.id <= productCount);
        //require that there is enough ether in the transaction
        require(_product.price <= msg.value);
        // check if the product is already purschased
        require(! _product.purchased);
        // buyer is not seller
        require(_seller != msg.sender);
        // transfer ownership to buyer
        _product.owner = msg.sender;
        // mark product as purchased
        _product.purchased = true;
        //update product
        products[_id] = _product;
        // pay the seller by sending ether
        address(_seller).transfer(msg.value);
        // Triggger the event
        emit ProductPurchased(_id, _product.name, _product.price, msg.sender, true);
    }
}
