/**
 * Name: UpdateOrderAndOrderItems
 * Date: 17-Apr-22
 * Author: Shiva Karna
 * Description: this class developed to update order and order products from
 * OrderProductsHandler and AvailableProductsHandler class 
 * Changes: 
 * 
 * 
 */
public with sharing class UpdateOrderAndOrderItems {
    
  //upsert order products  
  public static void addOrderProducts(List<Orderitem> orderitemlistforUpsert){           
        if(!orderitemlistforUpsert.isempty()){
            upsert orderitemlistforUpsert;
        }    
    }
    //update order and order product status to Activated
    public static void updateOrderAndOrderItemsStatus(string orderRecID){ 
        List<OrderItem> orderItemlistData =new List<OrderItem>();

        Order orderRec =[SELECT Id,Status FROM Order WHERE Id = :orderRecID ];
        List<OrderItem> orderItemlist=[ select id,Status__c from OrderItem where OrderId=:orderRecID];        
        orderRec.Status = system.label.OrderStatusActivate;//assign activated status from custom label
        for(orderitem orditem : orderItemlist){
            orditem.Status__c=system.label.OrderStatusActivate;
            orderItemlistData.add(orditem);
        }        
            if(orderRec!=null){
                update orderRec;
            }
            if(!orderItemlistData.isempty()){
                update orderItemlistData;
            }             
    }
}
