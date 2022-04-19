/*
 Name: OrderedProducts JS Controller
 Created by: Shiva Karna
 Date: 18-Apr-2022
 Description: This controller is used to show existing order products in order record page.
 This updates order status to Activated
 Changes:
*/
import { LightningElement, track, wire, api } from 'lwc';
import retriveOrderProducts from '@salesforce/apex/OrderProductsHandler.getOrderProducts';//import order products from apex
import updateOrderStatusJS from '@salesforce/apex/OrderProductsHandler.updateOrderStatus';//import order status update method from apex
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; //trigger toast message
import orderStatus_Fld from '@salesforce/schema/Order.Status'//order status field
import { getRecord } from 'lightning/uiRecordApi';//get current record details
import { refreshApex } from '@salesforce/apex';//refresh list
import OrderStatusActivate from '@salesforce/label/c.OrderStatusActivate';//custom label
import prodaddedSuccessfully from '@salesforce/label/c.prodaddedSuccessfully';//custom label
import OrderActivatedSuccessfully from '@salesforce/label/c.OrderActivatedSuccessfully';//custom label
import successMsg from '@salesforce/label/c.successMsg';//custom label
import ErrorVariant from '@salesforce/label/c.ErrorVariant';//custom label
import orderissue from '@salesforce/label/c.orderissue';//custom label
import dismissable from '@salesforce/label/c.dismissable';//custom label
import OrderUpdated from '@salesforce/label/c.OrderUpdated';//custom label


import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
  } from "lightning/messageService";
import SAMPLEMC from "@salesforce/messageChannel/RefreshOrderProducts__c";

//order item columns
const columns = [    
    { label: 'Name', fieldName: 'Product_Code__c',sortable: "true"},
    { label: 'Unit Price', fieldName: 'UnitPrice', type: 'currency',sortable: "true" },
    { label: 'Total Price', fieldName: 'TotalPrice', type: 'currency',sortable: "true"},  
    { label: 'Quantity', fieldName: 'Quantity', type: 'number',sortable: "true"},  
];
//order object columns
const orderfields = [
    'Order.Name',
    'Order.Status',    
];

export default class ApexWireMethodWithParams extends LightningElement {

    @wire(MessageContext)
  messageContext;

  subscription = null;
  receivedMessage;
  isDisabled = false;
  isDisabledUnsb = true;

    @api recordId;
    @api orderitems1;
    columns = columns;   
    @track sortBy;
    @track sortDirection;   
    @track record;
    @track error;
    @track orderstatusflag=true;

    @wire(retriveOrderProducts, { orderRecID: '$recordId'})
    orderitems;    
    @wire(getRecord, { recordId: '$recordId', fields: orderfields })
    order({error, data}){	      
         if(data){            
            this.record = data;//const paramField1 = getFieldValue(data, orderStatus_Fld);              
            if(this.record.fields.Status.value == OrderStatusActivate){
                this.orderstatusflag=false;                
            }
        }else if(error){
            this.error = error;  
        }
    }

    handleMessage(message) {
        refreshApex(this.orderitems);       
    }   
    handleSortAccountData(event) {       
        this.sortBy = event.detail.fieldName;       
        this.sortDirection = event.detail.sortDirection;       
        this.sortOrderProducts(event.detail.fieldName, event.detail.sortDirection);
    }
    sortOrderProducts(fieldname, direction) {
        
        let parseData = JSON.parse(JSON.stringify(this.orderitems.data));       
        let keyValue = (a) => {
            return a[fieldname];
        };
       let isReverse = direction === 'asc' ? 1: -1;
           parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; 
            y = keyValue(y) ? keyValue(y) : '';           
            return isReverse * ((x > y) - (y > x));
        });        
        this.orderitems.data = parseData;
        }

    
//connectedCallback function is similar to init method in Lightning Components.
    connectedCallback(){
        this.searchKey = this.recordId;        
        this.isDisabled = true;
        this.isDisabledUnsb = false;        
        if (this.subscription) {
            return;
        }
        this.subscription = subscribe(
        this.messageContext,
        SAMPLEMC,
        message => {
        this.handleMessage(message);
        },
        { scope: APPLICATION_SCOPE }
        );
    }    

    handleActivateOrderClick(event) {       
        updateOrderStatusJS({ orderRecID: this.recordId})
        .then(result =>{
            if(result==successMsg){
                const evt = new ShowToastEvent({
                    title: OrderUpdated,
                    message: OrderActivatedSuccessfully,
                    variant: successMsg,
                    mode: dismissable
                })
                this.dispatchEvent(evt);
                //eval("$A.get('e.force:refreshView').fire();");

            }else{
                const evt = new ShowToastEvent({
                    title: orderissue,
                    message: result,
                    variant: ErrorVariant,
                    mode: dismissable
                })
                this.dispatchEvent(evt);   
            }                    
        }).catch(error => {
            this.error = error;
           
        });;
     }

}