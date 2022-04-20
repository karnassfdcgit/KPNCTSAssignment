# KPNCTSAssignment

The following Components are creating during this assignment implementation.

1. Flow: - It will update standard pricebook during order creation.
Assign_Default_Price_Book

2. Custom labels: Create to store Static data.

3. Apex Classes: 
UpdateOrderAndOrderItems - Service Class - It will update Order status to Activated.
It will upsert order items.
OrderProductsHandlerTest - Test Class
OrderProductsHandler - It will show order products.
HandleCustomExceptionTest
HandleCustomException - Handle exception in catch class.
AvailableProductsHandlerTest
AvailableProductsHandler - Show Order products and products which are related to order pricebook.
AssignmentSendOrderToRequestTeacher - It will trigger JSON request to Request Teacher site.

4. LWC Components:
availableProducts
orderedProducts

5. Objects are created and modified:
CustomException__c - Store all custom exceptions.
OrderItem - Created Status fields, this will get updated, when we click activate button in order products lwc.
PriceBookEntry - Created product Name field to show in LWC files.

6. Order Record Page created:
Order_Record_Page
