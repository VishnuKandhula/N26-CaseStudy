public class getAPILimits {
    
    public Static EmailLimitsWrapper getOrgEmailLimits(string strEndPoint) {
        EmailLimitsWrapper objEmailLimitsResponse;
        HttpResponse response;
        HttpRequest request;
        Http http;
        
        try {
            //get latest Single Email Limits
            http = new Http();
            request = new HttpRequest();
            request.setEndpoint(strEndPoint);
            request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
            request.setMethod('GET');
            response = http.send(request);
            objEmailLimitsResponse = (EmailLimitsWrapper)JSON.deserialize(response.getBody(), EmailLimitsWrapper.Class);
        } catch(Exception objException) {
            //No handling needed.
        }
        return objEmailLimitsResponse;
    }
    
}