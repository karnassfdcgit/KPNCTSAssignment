/**
<<<<<<< HEAD
 * Name: OrderProductsHandler
 * Date: 17-Apr-22
 * Author: Shiva Karna
 * Description: this class developed to show order products and available products 
 * in OrderedProducts lwc component in order record page 
 * Changes: 
 * 
 * 
 */
=======
 * Apex Class Name: OrderProductsHandler
 * created Date: 17-Apr-22
 * @Author: Shiva Karna
 * @Description: this class developed to show order products and available products 
 * in OrderedProducts lwc component in order record page 
 * Modification log
 * Ver   Date          Author                               Modification
 * 1.0   17-Apr-2022   Shiva Karna                      Initial Version
 * 
 * 
 */

>>>>>>> 49c5e33fea438895d6fc3658662391f0c9c60600
public without sharing class OrderProductsHandler {
    
    //retrive all exsisting order products based on currently open order
    @AuraEnabled(cacheable=true)
    public static list<OrderItem> getOrderProducts(string orderRecID){
<<<<<<< HEAD
        List<OrderItem> orderitemlst = [SELECT Id, OrderItemNumber,Product_Code__c,UnitPrice, TotalPrice, Quantity FROM OrderItem WHERE OrderId = :orderRecID WITH SECURITY_ENFORCED];
=======
        List<OrderItem> orderitemlst = [SELECT Id, OrderItemNumber,Product_Code__c,UnitPrice, TotalPrice, Quantity FROM OrderItem WHERE OrderId = :orderRecID];
>>>>>>> 49c5e33fea438895d6fc3658662391f0c9c60600
        return orderitemlst;
    } 
    //onclick activate buttom in lwc, update order status to Activated
    @AuraEnabled
    public static string updateOrderStatus(string orderRecID){
        
         try{
            UpdateOrderAndOrderItems.updateOrderAndOrderItemsStatus(orderRecID);
             AssignmentSendOrderToRequestTeacher.sendOrderDetails(orderRecID);
            return system.label.successMsg;
         }catch(exception e){
             //capture any exceptions in custom exception object
             HandleCustomException.LogException(e);             
            return  e.getMessage();       
         }        
    }        
}