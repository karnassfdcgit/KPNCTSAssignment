@isTest
public class OrderProductsHandlerTest {
 @isTest
    public static void OrderProductHandlerTestMethod() {
    
    Id pricebookId = Test.getStandardPricebookId();
        system.debug('price book '+pricebookId);
    // Insert Account
    Account a = new Account();
    a.Name = 'KPN Test Account';
    insert a;
	List<String> prodLst = new List<string>();
        prodLst.add('ZXEDFVCCV');
        prodLst.add('ZHSH1HSHS');
        List<product2> prdList= new List<product2>();
       for(string prdstr:prodLst){           
    		Product2 prdone = new Product2();
    		prdone.Name = prdstr;
    		prdone.Description='Productdesc'+prdstr;
    		prdone.productCode = prdstr;
    		prdone.isActive = true;
            prdList.add(prdone);
        }    
    // Insert Product
    insert prdList;
    List<PricebookEntry> priceBookList = new List<PricebookEntry>();
    for(Product2 prdRec:prdList){
    
    PricebookEntry standardPrice = new PricebookEntry();
    standardPrice.Pricebook2Id = pricebookId;
    standardPrice.Product2Id = prdRec.Id;
    standardPrice.UnitPrice = 1;
    standardPrice.IsActive = true;
    standardPrice.UseStandardPrice = false;
    priceBookList.add(standardPrice);
    }
    // Insert PricebookEntry
    insert priceBookList ;
    
    // Insert Order    
    Order orderRec = new Order();
    orderRec.Name = 'Test Order ';
    orderRec.Status = 'Draft';
    orderRec.EffectiveDate = system.today();
    orderRec.EndDate = system.today() + 4;
    orderRec.AccountId = a.id;
    orderRec.Pricebook2Id =  pricebookId ;
    
    insert orderRec;
        
    // Insert Order Item
    OrderItem OrdItemRec = new OrderItem();
    OrdItemRec.OrderId = orderRec.id;
    OrdItemRec.Quantity = 24;
    OrdItemRec.UnitPrice = 240;
    OrdItemRec.Product2id = prdList[0].id;
    OrdItemRec.PricebookEntryId=priceBookList[0].id;
    insert OrdItemRec;       
    list<OrderItem> orderItemList = OrderProductsHandler.getOrderProducts(orderRec.id);
    System.AssertNotEquals(orderItemList.size(),0);
    list<PricebookEntry> priceBooklisttest = AvailableProductsHandler.getProducts(orderRec.id);
    System.AssertNotEquals(priceBooklisttest.size(),0);
    string orderitemStatus = AvailableProductsHandler.upsertOrderItems(orderRec.id,priceBookList);
    System.assertEquals(orderitemStatus,'success');
    string orderStatus =  OrderProductsHandler.updateOrderStatus(orderRec.id);
    System.assertEquals(orderStatus,'success');
    string orderNotStatus = OrderProductsHandler.updateOrderStatus(null);
    System.assertNotEquals(orderNotStatus,'success');
    
    }
}