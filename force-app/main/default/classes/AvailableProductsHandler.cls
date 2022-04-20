<<<<<<< HEAD
/**
 * Name: AvailableProductsHandler
 * Date: 17-Apr-22
 * Author: Shiva Karna
 * Description: this class developed to show order products and available products 
 * in AvailableProducts lwc component in order record page 
 * Changes: 
 * 
 * 
 */
=======
 /**
 * Apex Class Name: AvailableProductsHandler
 * created Date: 17-Apr-22
 * @Author: Shiva Karna
 * Description: this class developed to show order products and available products 
 * in AvailableProducts lwc component in order record page.
 * Modification log
 * Ver   Date          Author                           Modification
 * 1.0   17-Apr-2022   Shiva Karna                      Initial Version
 * 
 * 
 */
 
>>>>>>> 49c5e33fea438895d6fc3658662391f0c9c60600
public with sharing class AvailableProductsHandler {

    // this method will add new products under order products object
    //incase if product already exists, it will increase 1 to existing quanity
    @AuraEnabled
    public static string upsertOrderItems(string orderRecID,List<PricebookEntry> productids){      
        
        map<id,orderitem> orderItemsIdMap = new map<id,orderitem>();
        List<Orderitem> orderitemlistforUpsert = new List<Orderitem>();        
        //retrive order pricebook from current order
        Order orderRec =[select id,Pricebook2Id from order where id=:orderRecID];
        //retrive order products based on current order
        List<Orderitem> orderItemRecs =[SELECT Id, OrderItemNumber,
<<<<<<< HEAD
         UnitPrice, TotalPrice, Quantity,Product2Id FROM OrderItem WHERE OrderId = :orderRecID WITH SECURITY_ENFORCED];
=======
         UnitPrice, TotalPrice, Quantity,Product2Id FROM OrderItem WHERE OrderId = :orderRecID];
>>>>>>> 49c5e33fea438895d6fc3658662391f0c9c60600
       //add order products to map 
        for(OrderItem orditem:orderItemRecs){
        	orderItemsIdMap.put(orditem.Product2Id,orditem);
        }
        for(PricebookEntry priceentry:productids){
            
         orderitem orderitem = new orderitem();
         //update existing order product record
            if(orderItemsIdMap.containsKey(priceentry.Product2Id)){
            	orderitem.id=orderItemsIdMap.get(priceentry.Product2Id).id;
                orderitem.Quantity = integer.valueof(orderItemsIdMap.get(priceentry.Product2Id).Quantity)+1;
            }else{
                // initilize new order product
                orderitem.Quantity =1; 
                orderitem.OrderId =orderRecID; 
                orderitem.Product2Id =priceentry.Product2Id; 
                orderitem.UnitPrice =priceentry.UnitPrice;
                orderitem.PricebookEntryId=priceentry.id;
            }
            //add order products to list
         orderitemlistforUpsert.add(orderitem);
        }
            //upsert order items
            try{
            UpdateOrderAndOrderItems.addOrderProducts(orderitemlistforUpsert);   
<<<<<<< HEAD
            return system.label.successMsg;
            }catch(Exception e){
                HandleCustomException.LogException(e);
                return  e.getMessage();
=======
            return system.label.successMsg;//return success message
            }catch(Exception e){
                //add exception in custom exception object
                HandleCustomException.LogException(e);
                return  e.getMessage();//return error message
>>>>>>> 49c5e33fea438895d6fc3658662391f0c9c60600
            }                        
    }
    
    //Retrive all order products and product which are related to order pricebook
    //and display in Lwc component.
    @AuraEnabled(cacheable=true)
    public static list<PricebookEntry> getProducts(string orderRecID){        
        
        set<id> selectprodIdSet = new set<id>();
        map<id,orderitem> orderItemsIdMap = new map<id,orderitem>();
        //retrive exsisting product ids from orderitem based orderid
<<<<<<< HEAD
        for(orderitem orditem:[select Product2Id from orderitem where OrderId=:orderRecID WITH SECURITY_ENFORCED]){
=======
        for(orderitem orditem:[select Product2Id from orderitem where OrderId=:orderRecID]){
>>>>>>> 49c5e33fea438895d6fc3658662391f0c9c60600
            orderItemsIdMap.put(orditem.Product2Id,orditem);
        }
		//add productid as key in list        
        selectprodIdSet.addAll(orderItemsIdMap.KeySet());        
		//retrive selected pricebookid from order
        Order orderRec =[select id,Pricebook2Id from order where id=:orderRecID];
        //retrive product, list price from pricebook entry based on selected products
        List<PricebookEntry> selectedproductslst = [SELECT Id, ProductCode,Product2Id,UnitPrice
<<<<<<< HEAD
            FROM PricebookEntry where Pricebook2Id =:orderRec.Pricebook2Id 
                And Product2Id=:selectprodIdSet WITH SECURITY_ENFORCED];         
        //retrive products from pricebookentry based orderpricebook and related products
        List<PricebookEntry> productsnotselectlst = [SELECT Id, ProductCode,Product2Id,UnitPrice
            FROM PricebookEntry where Pricebook2Id =:orderRec.Pricebook2Id 
                And Product2Id!=:selectprodIdSet WITH SECURITY_ENFORCED];         
=======
                                                     FROM PricebookEntry where Pricebook2Id =:orderRec.Pricebook2Id 
                                                     And Product2Id=:selectprodIdSet];         
        //retrive products from pricebookentry based orderpricebook and related products
        List<PricebookEntry> productsnotselectlst = [SELECT Id, ProductCode,Product2Id,UnitPrice
                                                       FROM PricebookEntry where Pricebook2Id =:orderRec.Pricebook2Id 
                                                       And Product2Id!=:selectprodIdSet];         
>>>>>>> 49c5e33fea438895d6fc3658662391f0c9c60600
         selectedproductslst.addAll(productsnotselectlst);
        
         return selectedproductslst;
    } 
    
}
