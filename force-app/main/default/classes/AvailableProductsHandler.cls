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
         UnitPrice, TotalPrice, Quantity,Product2Id FROM OrderItem WHERE OrderId = :orderRecID];
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
            return system.label.successMsg;
            }catch(Exception e){
                HandleCustomException.LogException(e);
                return  e.getMessage();
            }                        
    }
    
    //Retrive all order products and product which are related to order pricebook
    //and display in Lwc component.
    @AuraEnabled(cacheable=true)
    public static list<PricebookEntry> getProducts(string orderRecID){        
        
        set<id> selectprodIdSet = new set<id>();
        map<id,orderitem> orderItemsIdMap = new map<id,orderitem>();
        //retrive exsisting product ids from orderitem based orderid
        for(orderitem orditem:[select Product2Id from orderitem where OrderId=:orderRecID]){
            orderItemsIdMap.put(orditem.Product2Id,orditem);
        }
		//add productid as key in list        
        selectprodIdSet.addAll(orderItemsIdMap.KeySet());        
		//retrive selected pricebookid from order
        Order orderRec =[select id,Pricebook2Id from order where id=:orderRecID];
        //retrive product, list price from pricebook entry based on selected products
        List<PricebookEntry> selectedproductslst = [SELECT Id, ProductCode,Product2Id,UnitPrice
            FROM PricebookEntry where Pricebook2Id =:orderRec.Pricebook2Id 
                And Product2Id=:selectprodIdSet];         
        //retrive products from pricebookentry based orderpricebook and related products
        List<PricebookEntry> productsnotselectlst = [SELECT Id, ProductCode,Product2Id,UnitPrice
            FROM PricebookEntry where Pricebook2Id =:orderRec.Pricebook2Id 
                And Product2Id!=:selectprodIdSet];         
         selectedproductslst.addAll(productsnotselectlst);
        
         return selectedproductslst;
    } 
    
}
