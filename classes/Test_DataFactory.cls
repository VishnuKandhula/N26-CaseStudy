@isTest
public class Test_DataFactory {
    
    public static Account createAccount(String accName) {
        Account testAccount = new Account(
            Name = accName
        );
        insert testAccount;
        return testAccount;
    }

    public static Contact createContact(Id accId, String firstName, String lastName, String email, String language, Date surveyDate, Id productId,boolean InsertContact) {
        Contact testContact = new Contact(
            AccountId = accId,
            FirstName = firstName,
            LastName = lastName,
            Email = email,
            Language__c = language,
            Survey_Date__c = surveyDate,
            Product__c = productId                
        );
        if(InsertContact)
        {
        insert testContact;
        }
        return testContact;
    }
    
    public static Case createCase(Id accId, String conId, String subject) {
        Case testCase = new Case(
            AccountId = accId,
            ContactId = conId,
            Subject = subject
        );
        insert testCase;
        return testCase;
    }
    
    public static Product2 createProduct(String name, String currencyIsoCode, String productCode) {
        Product2 testProduct = new Product2(
            IsActive = true,
            Name = name,
            CurrencyIsoCode = currencyIsoCode,
            ProductCode = productCode
                   );
        insert testProduct;
        return testProduct;
    }
    
    public static PricebookEntry createPricebookEntry(Product2 product, String currencyIsoCode, Decimal unitPrice) {
        PricebookEntry testPricebookEntry = new PricebookEntry(
            IsActive = true,
            Product2Id = product.Id,
            CurrencyIsoCode = currencyIsoCode,
            Pricebook2Id = Test.getStandardPricebookId(),
            UnitPrice = unitPrice
        );
        insert testPricebookEntry;
        return testPricebookEntry;
    }
    
    public class SingleEmailLimitSuccessMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody(''
                        +'{ '
                        +'    "SingleEmail" : { '
                        +'        "Max" : "5000", '
                        +'        "Remaining" : "14" '
                        +'    } '
                        +'}'
                       );
            res.setStatusCode(200);
            return res;
        }
    }
    }