global class CustomerSurveyReminderBatch implements Database.Batchable<sObject>,Schedulable,Database.AllowsCallouts{
    public String strQuery;
    private static string strEndPoint = system.label.LimitsClassApiEndPoint;
    private static string GermanEmailTemplate = system.label.GermanEmailTemplateLabel;
    private static string EnglishEmailTemplate =  system.label.EnglishEmailTemplateLabel;
    private static string EmailSubject = system.label.EmailSubject;
    //records processed per transaction limit
    private static integer BatchScope = 100;
    
    public CustomerSurveyReminderBatch(){
        //Query the Details to run the Batch.
        this.strQuery = 'SELECT Id,survey_date__c,AccountId,language__c,name FROM Contact WHERE survey_date__c < Today';
    }
    
    //scheduling class for batch
    public void execute(SchedulableContext context) {
        Database.executeBatch(this,BatchScope); //We can only send up to 100 receipents in a single transaction
    }
    //end of scheduling batch
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(this.strQuery);
    }
    global void execute(Database.BatchableContext BC, List<Contact> objContacts){
        list<Messaging.SingleEmailMessage> lstMessages = new list<Messaging.SingleEmailMessage>();
        list<Contact> lstContactToBeUpdated = new list<Contact>();
        list<Contact> lstUpdateSurveyDate = new list<Contact>();
        //API call out to get the Org limits for Single Email messaging API
        EmailLimitsWrapper objEmailLimitsResponse = getAPILimits.getOrgEmailLimits(strEndPoint);
        Integer intEmailsAllowed = objContacts.size();
        //check the remaining email limit with the Batch Scope/Limit for each transaction.
        if(objEmailLimitsResponse.SingleEmail.Remaining < intEmailsAllowed ){
            intEmailsAllowed = objEmailLimitsResponse.SingleEmail.Remaining;
        }
        for(Integer i=0; i < intEmailsAllowed ; i++){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTargetObjectId(objContacts[i].Id);
            //Setting up Email Subject
            message.setSubject(EmailSubject);
            //setting up Email Template Dyanmically by storing Body in Custom Labels.
            if(objContacts[i].language__c == 'en'){
                message.setPlainTextBody('Hey'+objContacts[i].name+EnglishEmailTemplate+objContacts[i].id);
            } else {
                message.setPlainTextBody('Hey'+objContacts[i].name+GermanEmailTemplate+objContacts[i].id);
            }
            
            message.setWhatId(objContacts[i].AccountId);
            message.setSaveAsActivity(true);
            lstMessages.add(message);
            lstContactToBeUpdated.add(objContacts[i]);
        }
        
        if(! lstMessages.isEmpty()){
            Messaging.sendEmail(lstMessages);
        }
        if(! lstContactToBeUpdated.isEmpty()){
            for(Contact con:lstContactToBeUpdated){
                con.survey_date__c = null;
                lstUpdateSurveyDate.add(con);
            }
            //Updating Contacts with Survey_date__c to Null/Blank
            update lstUpdateSurveyDate;
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
    }
}