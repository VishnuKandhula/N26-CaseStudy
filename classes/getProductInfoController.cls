public without sharing class getProductInfoController {

	/*Fetch the product data.*/    
    @AuraEnabled
    public static map<string,ProductInfoWrapper.productDetailWrapper> fetchProductEntries(Id caseId) {
        map<string,ProductInfoWrapper.productDetailWrapper> mapDetailWrapper = new map<string,ProductInfoWrapper.productDetailWrapper>();
        set<string> identifyNameSet = new set<string>();
        ProductInfoWrapper ProductDetails = new  ProductInfoWrapper();
        Case CaseRecord = [SELECT Id,ContactId,Contact.Product__c,Contact.language__c,Contact.Home_Country__c FROM Case WHERE id = :caseId];
        if (CaseRecord.Contact == null || String.isBlank(CaseRecord.Contact.Product__c)) {
            return null;
        } else {
            List<PricebookEntry> PriceDetails = [SELECT Id,Pricebook2.CurrencyIsoCode,ATM_Fee__c,Card_Replacement_Cost__c,Name,UnitPrice, CurrencyIsoCode,Product2Id,Product2.Name
                                                 FROM PricebookEntry 
                                                 WHERE Product2Id = :CaseRecord.Contact.Product__c ORDER BY CurrencyIsoCode ASC]; 
                       
            
            if(PriceDetails.size() > 0){   
                //Build wrapper to display on UI.
                for(PricebookEntry pb : PriceDetails){
                    ProductInfoWrapper.productDetailWrapper prodDetailWrapper = new ProductInfoWrapper.productDetailWrapper();
                    prodDetailWrapper.productName = pb.Product2.Name;
                    prodDetailWrapper.currencyCode = pb.CurrencyIsoCode;
                    prodDetailWrapper.mapCostPerMonth = new map<string,Integer>();
                    prodDetailWrapper.mapAtmFee = new map<string,Decimal>();
                    prodDetailWrapper.mapCardReplaceCost = new map<string,Decimal>();
                    prodDetailWrapper.mapCostPerMonth.put(pb.CurrencyIsoCode,Integer.valueOf(pb.UnitPrice));
                    prodDetailWrapper.mapAtmFee.put(pb.CurrencyIsoCode,pb.ATM_Fee__c);
                    prodDetailWrapper.mapCardReplaceCost.put(pb.CurrencyIsoCode,pb.Card_Replacement_Cost__c);                   
                    if(mapDetailWrapper.containsKey(prodDetailWrapper.productName)){
                        mapDetailWrapper.get(prodDetailWrapper.productName).mapCostPerMonth.put(pb.CurrencyIsoCode,Integer.valueOf(pb.UnitPrice));
                        mapDetailWrapper.get(prodDetailWrapper.productName).mapAtmFee.put(pb.CurrencyIsoCode,pb.ATM_Fee__c);
                        mapDetailWrapper.get(prodDetailWrapper.productName).mapCardReplaceCost.put(pb.CurrencyIsoCode,pb.Card_Replacement_Cost__c);
                    }else{
                        mapDetailWrapper.put(prodDetailWrapper.productName,prodDetailWrapper);
                    }
                }
            }         
        }
       return mapDetailWrapper; 
    }
}
