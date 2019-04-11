@isTest 
public class CustomerSurveyReminderBatchTest 
{
    static testMethod void testMethodRunBatch() 
    {
        
        Account objAccount = Test_DataFactory.createAccount('TestAccount');
        list<contact> lstContact = new list<contact>();
        for(Integer i=0 ;i <200;i++)
        {
            Contact objContact = Test_DataFactory.createContact(objAccount.id, 'firstName'+i, 'lastName'+i, 'email@gmail.com', 'en', Date.today() - 1,null,false);
            lstContact.add(objContact);
        }       
        insert lstContact;
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new Test_DataFactory.SingleEmailLimitSuccessMock());
            CustomerSurveyReminderBatch obj = new CustomerSurveyReminderBatch();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
    
    static testMethod void testMethodScheduleBatch() 
    {
        
        Account objAccount = Test_DataFactory.createAccount('TestAccount');
        list<contact> lstContact = new list<contact>();
        for(Integer i=0 ;i <100;i++)
        {
            Contact objContact = Test_DataFactory.createContact(objAccount.id, 'firstName'+i, 'lastName'+i, 'email@gmail.com', 'de', Date.today() - 1,null,false);
            lstContact.add(objContact);
        }       
        insert lstContact;
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new Test_DataFactory.SingleEmailLimitSuccessMock());
            CustomerSurveyReminderBatch obj = new CustomerSurveyReminderBatch();
            system.schedule('jobName', '0 0 13 * * ?',obj);           
        Test.stopTest();
    }
}