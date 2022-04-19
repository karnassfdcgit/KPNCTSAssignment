/*
 Name: AvailableProducts JS Controller
 Created by: Shiva Karna
 Date: 18-Apr-2022
 Description: This controller is used to show existing order products
 and products which associated with order pricebook in order record page.
 This JS will call apex method(upsertOrderItems) to add new products in order products object.
 Changes:
*/
import { LightningElement, track, wire, api } from 'lwc';
import retriveProducts from '@salesforce/apex/AvailableProductsHandler.getProducts';//retrive order products
import addAndUpdateOrderItems from '@salesforce/apex/AvailableProductsHandler.upsertOrderItems';//Activate order
import { refreshApex } from '@salesforce/apex';//refresh product list
import { ShowToastEvent } from 'lightning/platformShowToastEvent';//show toast message in lwc
import { getRecord } from 'lightning/uiRecordApi';
import OrderStatusActivate from '@salesforce/label/c.OrderStatusActivate';//custom label
import prodaddedSuccessfully from '@salesforce/label/c.prodaddedSuccessfully';//custom label
import lwcCompMessage from '@salesforce/label/c.lwcCompMessage';//custom label
import lwcplace from '@salesforce/label/c.lwcplace';//custom label
import LWCNameMessage from '@salesforce/label/c.LWCNameMessage';//custom label
import ErrorVariant from '@salesforce/label/c.ErrorVariant';//custom label
import orderissue from '@salesforce/label/c.orderissue';//custom label
import dismissable from '@salesforce/label/c.dismissable';//custom label
import successMsg from '@salesforce/label/c.successMsg';//custom label

// Import message service features required for publishing and the message channel
import { publish, MessageContext } from 'lightning/messageService';
import orderrefreshpublisher from '@salesforce/messageChannel/RefreshOrderProducts__c';
//product object fields
const columns = [
    { label: 'ProductCode', fieldName: 'ProductCode',sortable: "true"},
    { label: 'List Price', fieldName: 'UnitPrice', type: 'currency',sortable: "true" },    
];
//order object columns
const orderfields = [
    'Order.Name',
    'Order.Status',    
];

export default class ApexWireMethodWithParams extends LightningElement {
    @wire(MessageContext)
    messageContext;
    @api recordId;
    columns = columns;   
    @track sortBy;
    @track sortDirection;
    @track record;
    @track error;
    @track orderstatusflag=true;
    @track page = 1; 
    @track startingRecord = 1;
    @track endingRecord = 0; 
    @track pageSize = 8; 
    @track totalRecountCount = 0;
    @track totalPage = 0;    
    @track items = []; 
    @track data = []; 
    isPageChanged = false;    
    @wire(retriveProducts, { orderRecID: '$recordId'})
    products({error, data}){	      
        if(data){            
           this.processRecords(data);                    
       }else if(error){
           this.error = error;  
       }
   }          
    @wire(getRecord, { recordId: '$recordId', fields: orderfields })
    order({error, data}){	      
         if(data){            
            this.record = data;            
            if(this.record.fields.Status.value == OrderStatusActivate){
                this.orderstatusflag=false;                
            }
        }else if(error){
            this.error = error;  
        }
    }
    //process retrived products
processRecords(data){
    this.items = data;
        this.totalRecountCount = data.length; 
        this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
        
        this.data = this.items.slice(0,this.pageSize); 
        this.endingRecord = this.pageSize;
        this.columns = columns;
}

    getSelectedRec(event) {
            var selectedRecords =  this.template.querySelector("lightning-datatable").getSelectedRows();
            if(selectedRecords.length > 0){
                       
                let ids = '';
                selectedRecords.forEach(currentItem => {
                    ids = ids + ',' + currentItem.Product2Id;
                });
                this.selectedIds = ids.replace(/^,/, '');
                this.lstSelectedRecords = selectedRecords;               
                
                addAndUpdateOrderItems({orderRecID :this.orderRecID ,productids : selectedRecords})
                .then(result => {
                this.message = result; 

                if(result==successMsg){
                    const evt = new ShowToastEvent({title: prodaddedSuccessfully,
                        message: prodaddedSuccessfully,
                        variant: successMsg,
                        mode: dismissable
                    })
                    this.dispatchEvent(evt);     
                    
                   const message = {
                    recordId: this.searchKey,
                    message : lwcCompMessage,
                    source: lwcplace,
                    recordData: {name: LWCNameMessage}
                };
                publish(this.messageContext, orderrefreshpublisher, message);              
                }else{
                    //Show toast message with error details
                    const evt = new ShowToastEvent({
                        title: orderissue,
                        message: result,
                        variant: ErrorVariant,
                        mode: dismissable
                    })
                    this.dispatchEvent(evt);   
                }
               //after clicking - Add Selected Products buttoon, clear the selected checkboxes                
               this.template.querySelector('lightning-datatable').selectedRows=[];
                // Refresh the view of the data                    
                return refreshApex(this.products);
                })
                .catch(error => {
                this.error = error.message;
        });              
    } 
}   
//clicking on previous button this method will be called
previousHandler() {
    this.isPageChanged = true;
    if (this.page > 1) {
        this.page = this.page - 1; //decrease page by 1
        this.displayRecordPerPage(this.page);
    }
      var selectedIds = [];
      for(var i=0; i<this.allSelectedRows.length;i++){
        selectedIds.push(this.allSelectedRows[i].Id);
      }
    this.template.querySelector(
        '[data-id="table"]'
      ).selectedRows = selectedIds;
}

//clicking on next button this method will be called
nextHandler() {
    this.isPageChanged = true;
    if((this.page<this.totalPage) && this.page !== this.totalPage){
        this.page = this.page + 1; //increase page by 1
        this.displayRecordPerPage(this.page);            
    }
      var selectedIds = [];
      for(var i=0; i<this.allSelectedRows.length;i++){
        selectedIds.push(this.allSelectedRows[i].Id);
      }
    this.template.querySelector(
        '[data-id="table"]'
      ).selectedRows = selectedIds;
}
 //this method displays records page by page
 displayRecordPerPage(page){

    this.startingRecord = ((page -1) * this.pageSize) ;
    this.endingRecord = (this.pageSize * page);

    this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                        ? this.totalRecountCount : this.endingRecord; 

    this.data = this.items.slice(this.startingRecord, this.endingRecord);
    this.startingRecord = this.startingRecord + 1;
} 
//connectedCallback function is similar to init method in Lightning Components.
    connectedCallback(){
        this.orderRecID = this.recordId;        
    }   

}