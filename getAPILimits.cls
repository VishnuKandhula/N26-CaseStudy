public class getAPILimits {
    
    public Static EmailLimitsWrapper getOrgEmailLimits(string strEndPoint) {
        EmailLimitsWrapper objEmailLimitsResponse;
        HttpResponse response;
        HttpRequest request;
        Http http;
        
        try {
            http = new Http();
            request = new HttpRequest();
            request.setEndpoint(strEndPoint);
            request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
            request.setMethod('GET');
            response = http.send(request);
            system.debug('@@@@@Response'+response.getBody());
            
            objEmailLimitsResponse = (EmailLimitsWrapper)JSON.deserialize(response.getBody(), EmailLimitsWrapper.Class);
            system.debug('@@@@LimitsResponse'+objEmailLimitsResponse);
        } catch(Exception objException) {
            //No handling needed.
        }
        return objEmailLimitsResponse;
    }
    
}
