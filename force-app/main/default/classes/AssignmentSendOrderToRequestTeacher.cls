 /**
  * Apex Class Name: AssignmentSendOrderToRequestTeacher
  * created Date: 17-Apr-22
  * @Author: Shiva Karna
  * Description: this class was developed to send order and order products to requestcatcher site.
  * This class will get involved whenever, we click activate button in order record page.
  * Modification log
  * Ver   Date          Author                               Modification
  * 1.0   17-Apr-2022   Shiva Karna                      Initial Version
  *
  *
  *
  */

  public with sharing class AssignmentSendOrderToRequestTeacher {
    //Pass order id and retrive order products, generate json request and 
    //send it to requestcatcher site.
    @AuraEnabled
    public static void sendOrderDetails(String orderRecordId) {
        list < orderDetailscls > orderDetailList = new list < orderDetailscls > ();
        List < Order > orders = [SELECT Id, Status, OrderNumber, Account_number__c, Type, (SELECT Id, Product_Code__c, Description, UnitPrice, Quantity, OrderId FROM OrderItems) FROM Order WHERE Id = : orderRecordId];
        for (order orderRec: orders) {
            orderDetailscls orderObj = new orderDetailscls(orderRec.Account_number__c, orderRec.OrderNumber, orderRec.Type, orderRec.status);
            //orderObj.accountNumber = orderRec.AccountNumber; - 
            for (Orderitem orditem: orderRec.OrderItems) {
                orderObj.orderProducts.add(new orderProductscls(orditem.Description, orditem.Product_Code__c, orditem.UnitPrice, integer.valueOf(orditem.Quantity)));
            }
            //add order and order products to list
            orderDetailList.add(orderObj);
        }
        //convert order,order product into JSON format, so that other system can read it.
        String str = JSON.serialize(orderDetailList);
        //pass JSON request and execute API callout to other system
        AssignmentSendOrderToRequestTeacher.sendAPIRequest(str);
    }
    public static void sendAPIRequest(String jsonBody) {
        //Set HTTPRequest Method
        try {
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            //req.setHeader('Accept-Encoding', 'gzip,deflate');
            //req.setHeader('content-type', 'text/xml; charset=utf-8');
            req.setHeader('Content-Length', String.valueOf(jsonBody.length()));
            req.setEndpoint('callout:requestcatcher_endpoint'); //Endpoint stored in named credentials                
            req.setBody(jsonBody);
            //Execute web service call here     
            Http http = new Http();
            HTTPResponse res = http.send(req);
            string responseDetails = res.getBody();
            system.debug('Callout response' + responseDetails);
        } catch (exception e) {
            //create exception in custom exception object
            HandleCustomException.LogException(e);
        }
    }
    //capture order and order products details in wrapper class
    public class orderDetailscls {
        String accountNumber; //AccountNumber
        String orderNumber; //OrderNumber
        String type; //order type
        String status; //order status
        public orderProductscls[] orderProducts; //Order items
        orderDetailscls(String accountNumber, String orderNumber, String type, String status) {
            this.accountNumber = accountNumber;
            this.orderNumber = orderNumber;
            this.type = type;
            this.status = status;
            orderProducts = new orderProductscls[0];

        }
    }
    //this class called in orderDetailscls to 
    //capture order products in this wrapper class
    class orderProductscls {
        public String name; //product name
        public String code; //product code
        public decimal unitPrice; //10
        public Integer quantity; //1
        orderProductscls(String name, String code, decimal unitPrice, Integer quantity) {
            this.name = name;
            this.code = code;
            this.unitPrice = unitPrice;
            this.quantity = quantity;
        }
    }
}