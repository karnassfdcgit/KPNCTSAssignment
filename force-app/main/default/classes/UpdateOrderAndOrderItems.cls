/**
<<<<<<< HEAD
 * Name: UpdateOrderAndOrderItems
 * Date: 17-Apr-22
 * Author: Shiva Karna
 * Description: this class developed to update order and order products from
 * OrderProductsHandler and AvailableProductsHandler class 
 * Changes: 
 * 
 * 
 */
=======
 * Apex Class Name: UpdateOrderAndOrderItems
 * created Date: 17-Apr-22
 * @Author: Shiva Karna
 * Description: this class developed to update order and order products from
 * OrderProductsHandler and AvailableProductsHandler class.
 * Modification log
 * Ver   Date          Author                               Modification
 * 1.0   17-Apr-2022   Shiva Karna                      Initial Version
 * 
 * 
 */
 
>>>>>>> 49c5e33fea438895d6fc3658662391f0c9c60600
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
