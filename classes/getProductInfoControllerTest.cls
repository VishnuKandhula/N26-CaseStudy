@isTest
private class getProductInfoControllerTest {
    
    //functionality testing.
    @isTest static void testGetProductDetails() {
        
        Product2 testProduct = Test_DataFactory.createProduct('Standard', 'EUR', 'EURDE');
        PricebookEntry testPricebookEntry = Test_DataFactory.createPricebookEntry(testProduct, 'EUR', 0);
        PricebookEntry testPricebookEntry1 = Test_DataFactory.createPricebookEntry(testProduct, 'GBP', 0);
        
        Account acc = Test_DataFactory.createAccount('test');
        Contact con = Test_DataFactory.createContact(acc.Id, 'firstName', 'lastName', 'email1@email.test', 'en', Date.today() - 1, testProduct.Id,true);
        Case CaseRecord = Test_DataFactory.createCase(acc.Id, con.Id, 'test');
        map<string,ProductInfoWrapper.productDetailWrapper> mapDetailWrapper = new map<string,ProductInfoWrapper.productDetailWrapper>();
        mapDetailWrapper = getProductInfoController.fetchProductEntries(CaseRecord.Id);     
        System.assertNotEquals(mapDetailWrapper,null,'No records Returned');   
    }
    
    //Unit testing.
    @isTest static void testNullProductDetails() {
        Case CaseRecord = Test_DataFactory.createCase(null, null, 'test');
        map<string,ProductInfoWrapper.productDetailWrapper> mapDetailWrapper = new map<string,ProductInfoWrapper.productDetailWrapper>();
        mapDetailWrapper = getProductInfoController.fetchProductEntries(CaseRecord.id);     
        System.assertEquals(mapDetailWrapper,null,'No records Returned');   
    }
    
}