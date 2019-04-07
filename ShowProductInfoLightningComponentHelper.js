({
	getProductDetails : function(component) {
		var action = component.get('c.getProductInfo'); 
        action.setParams({
            "caseId" : component.get('v.recordId') 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                if(! $A.util.isUndefinedOrNull(response.getReturnValue())){
                var PriceBookInfo = response.getReturnValue().lstPriceBook;
                console.log(response.getReturnValue()); 
                var ContactInfo = response.getReturnValue().ContactHomeCountry;                   
                console.log('abc');	
                //set the Home Country of contact to get matching Product Info    
                component.set('v.contactHomeCountry',ContactInfo); 
                //set the PriceBook Info    
                component.set('v.productInfo',PriceBookInfo[0]);
                }
            }
        });
        $A.enqueueAction(action);
	},
    
})
