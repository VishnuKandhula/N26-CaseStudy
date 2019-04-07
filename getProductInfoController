public without sharing class getProductInfoController {
    
    @AuraEnabled
    public static ProductInfoWrapper getProductInfo(Id caseId) {
        ProductInfoWrapper ProductDetails = new  ProductInfoWrapper();
        Case CaseRecord = [SELECT Id,ContactId,Contact.Product__c,Contact.language__c,Contact.Home_Country__c FROM Case WHERE id = :caseId];
        if (CaseRecord.Contact == null || String.isBlank(CaseRecord.Contact.Product__c)) {
            return null;
        } else {
            system.debug('aaaa'+CaseRecord.Contact.Product__c);
            List<PricebookEntry> PriceDetails = [SELECT Id,Name,UnitPrice, CurrencyIsoCode,Product2Id,Product2.Name,Product2.Percent__c,Product2.ATMFee__c,Product2.Card_Replacement_Fee__c
                                                 FROM PricebookEntry 
                                                 WHERE Product2Id = :CaseRecord.Contact.Product__c ORDER BY CurrencyIsoCode ASC]; 
                       
            ProductDetails.ContactHomeCountry =  CaseRecord.Contact.Home_Country__c;
            if(PriceDetails.size() > 0){           
                ProductDetails.lstPriceBook = PriceDetails;
            }         
        }
       return ProductDetails; 
    }
}
