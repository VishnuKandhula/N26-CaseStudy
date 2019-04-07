global class CustomerSurveyReminderBatch implements Database.Batchable<sObject>,Database.AllowsCallouts{
    public String strQuery;
    private static string strEndPoint = system.label.LimitsClassApiEndPoint;
    private static string GermanEmailTemplate = system.label.GermanEmailTemplateLabel;
    private static string EnglishEmailTemplate =  system.label.EnglishEmailTemplateLabel;
    private static string EmailSubject = system.label.EmailSubject;
    private static integer BatchScope = 100;
    
    public CustomerSurveyReminderBatch(){
        this.strQuery = 'SELECT Id,survey_date__c,AccountId,language__c,name FROM Contact WHERE survey_date__c < Today limit 15';
    }
    
    //scheduling class for batch
    public void execute(SchedulableContext context) {
        Database.executeBatch(this,BatchScope); //can send up to 100 receipents in a single transaction
    }
    //end 
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(this.strQuery);
    }
    global void execute(Database.BatchableContext BC, List<Contact> objContacts){
        list<Messaging.SingleEmailMessage> lstMessages = new list<Messaging.SingleEmailMessage>();
        list<Contact> lstContactToBeUpdated = new list<Contact>();
        list<Contact> lstUpdateSurveyDate = new list<Contact>();
        EmailLimitsWrapper objEmailLimitsResponse = getAPILimits.getOrgEmailLimits(strEndPoint);
        Integer intEmailsAllowed = objContacts.size();
        system.debug('@@@@intEmailsAllowed'+intEmailsAllowed);
        if(objEmailLimitsResponse.SingleEmail.Remaining < intEmailsAllowed ){
            intEmailsAllowed = objEmailLimitsResponse.SingleEmail.Remaining;
        }
        for(Integer i=0; i < intEmailsAllowed ; i++){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTargetObjectId(objContacts[i].Id);
            message.setSubject(EmailSubject);
            if(objContacts[i].language__c == 'en'){
                message.setPlainTextBody('Hey'+objContacts[i].name+EnglishEmailTemplate+objContacts[i].id);
            } else {
                message.setPlainTextBody('Hey'+objContacts[i].name+GermanEmailTemplate+objContacts[i].id);
            }
            
            message.setWhatId(objContacts[i].AccountId);
            message.setSaveAsActivity(true);
            lstMessages.add(message);
            system.debug('@@@@lstMessages'+lstMessages);
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
            system.debug('@@@@lstUpdateSurveyDate'+lstUpdateSurveyDate);
            update lstUpdateSurveyDate;
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
    }
}
