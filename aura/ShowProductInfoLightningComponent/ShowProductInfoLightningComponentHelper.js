({
    getProductDetails : function(component) {
        var action = component.get('c.fetchProductEntries'); 
        action.setParams({
            "caseId" : component.get('v.recordId') 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                
                if(! $A.util.isUndefinedOrNull(response.getReturnValue())){
                    component.set('v.mapPricebookData',response.getReturnValue());
                    for(var obj in response.getReturnValue()){
                        let objCostPerMonth = {
                            strDE : response.getReturnValue()[obj].mapCostPerMonth['EUR'],
                            strFR : response.getReturnValue()[obj].mapCostPerMonth['EUR'],
                            strES : response.getReturnValue()[obj].mapCostPerMonth['EUR'],
                            strIT : response.getReturnValue()[obj].mapCostPerMonth['EUR'],
                            strUK : response.getReturnValue()[obj].mapCostPerMonth['GBP'],
                            strCurrencyCode : 'EUR',
                            strUKCurrencyCode : 'GBP'
                            
                        }
                        let objAtmFee = {
                            strDE : response.getReturnValue()[obj].mapAtmFee['EUR'],
                            strFR : response.getReturnValue()[obj].mapAtmFee['EUR'],
                            strES : response.getReturnValue()[obj].mapAtmFee['EUR'],
                            strIT : response.getReturnValue()[obj].mapAtmFee['EUR'],
                            strUK : response.getReturnValue()[obj].mapAtmFee['GBP'],
                            strCurrencyCode : 'EUR',
                            strUKCurrencyCode : 'GBP'
                        }
                        let objCardReplaceCost = {
                            strDE : response.getReturnValue()[obj].mapCardReplaceCost['EUR'],
                            strFR : response.getReturnValue()[obj].mapCardReplaceCost['EUR'],
                            strES : response.getReturnValue()[obj].mapCardReplaceCost['EUR'],
                            strIT : response.getReturnValue()[obj].mapCardReplaceCost['EUR'],
                            strUK : response.getReturnValue()[obj].mapCardReplaceCost['GBP'],
                            strCurrencyCode : 'EUR',
                            strUKCurrencyCode : 'GBP'
                        }
                        component.set('v.objCostPerMonth',objCostPerMonth);
                        component.set('v.objAtmFee',objAtmFee);
                        component.set('v.objCardReplaceCost',objCardReplaceCost);
                        component.set('v.productName',obj);
                    }                   
                }
            }
        });
        $A.enqueueAction(action);
    },
    
})