package com.flickr.api
{
    import com.adobe.utils.StringUtil;
    
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    
    public class FlickrRESTAPI
    {
        public static const BASE_URL:String = 'http://api.flickr.com/services/rest/';
        public static const METHOD_BASE:String = 'flickr.';
        
        public var apiKey:String;
        
        public function FlickrRESTAPI(apiKey:String=null)
        {
            this.apiKey = apiKey;
        }
        
        public function getRequest(method:String, args:Object=null):URLRequest
        {
            var vars:URLVariables = new URLVariables();
            if (apiKey) vars['api_key'] = apiKey;
            if (args)
            {
                for (var arg:String in args)
                {
                    vars[arg] = args[arg];
                }
            }
            vars['method'] = StringUtil.beginsWith(method, METHOD_BASE)
                             ? method
                             : METHOD_BASE + method;
            var request:URLRequest = new URLRequest(BASE_URL);
            request.data = vars;
            return request;
        }
    }
}