/**
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

public without sharing class OrderProductsHandler {
    
    //retrive all exsisting order products based on currently open order
    @AuraEnabled(cacheable=true)
    public static list<OrderItem> getOrderProducts(string orderRecID){
        List<OrderItem> orderitemlst = [SELECT Id, OrderItemNumber,Product_Code__c,UnitPrice, TotalPrice, Quantity FROM OrderItem WHERE OrderId = :orderRecID];
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