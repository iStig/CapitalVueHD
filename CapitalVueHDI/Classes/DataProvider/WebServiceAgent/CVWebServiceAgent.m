//
//  CVWebServiceAgent.m
//  CapitalVueHD
//
//  Created by jishen on 8/23/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVWebServiceAgent.h"

#define CVServerRequestEncryptedURl @"http://data.capitalvue.com/soap.php?m=service&method=genEncrptyUrl&cmd=Cada_Services."

@interface CVWebServiceAgent()
@property(nonatomic, retain) NSString *m_element;
@property(nonatomic, retain) NSString *m_key;
@property(nonatomic, retain) NSString *m_value;
@property(nonatomic, retain) NSMutableArray *m_array;
@property(nonatomic, retain) NSMutableDictionary *m_rootObject;
@property(nonatomic, retain) NSMutableDictionary *m_object;

- (BOOL)parseXML:(NSString *)serviceUrl;
@end

@implementation CVWebServiceAgent

@synthesize m_element;
@synthesize m_key;
@synthesize m_value;
@synthesize m_array;
@synthesize m_rootObject;
@synthesize m_object;

#pragma mark private methods

- (void) DumpDict:(NSDictionary *)dictData dictName:(NSString *)dictName
{
	static int nLevel = 0;
	
	nLevel++;
	for (NSString * key in dictData)
	{
		id value = [dictData objectForKey:key];
		
		if ([value isKindOfClass:[NSDictionary class]])
		{
		//	NSLog(@"  dict name=%@", key);
			[self DumpDict:value dictName:key];
		}
		else if ([value isKindOfClass:[NSString class]])
		{
			NSMutableString * strSpace = [[NSMutableString alloc] initWithCapacity:1];
			for(int i = 0; i < nLevel; i++)
				[strSpace appendString:@"    "];
			
		//	NSLog(@"  \t%@[%d] %@: %@=%@", strSpace, nLevel, dictName, key, strValue);
			[strSpace release];
		}
		else if ([value isKindOfClass:[NSArray class]])
		{
			NSArray * array = (NSArray *)value;
			for ( int i = 0; i < array.count; i++)
			{
				id obj = [array objectAtIndex:i];
		//		NSLog(@">>dict array[%d] name=%@", i, key);
				[self DumpDict:obj dictName:key];
			}
		}
		else
		{
	//		NSLog(@"  \t%@=unknown", key);
		}
	}
	nLevel --;
}

/*
 * It returns the url that request the encrypted api of webservice
 *
 * @param: name - api name
 * @return: the address of the api
 */
- (NSString *)apiAddress:(NSString *)name {
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	NSString *plistPath;
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
													NSUserDomainMask, YES) objectAtIndex:0];
	NSString *address;
	
	address = nil;
	
	plistPath = [rootPath stringByAppendingPathComponent:@"interfazAdd.plist"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
		plistPath = [[NSBundle mainBundle] pathForResource:@"interfazAdd" ofType:@"plist"];
	}
	
	// get the address information
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSDictionary *addDict = (NSDictionary *)[NSPropertyListSerialization
									  propertyListFromData:plistXML
									  mutabilityOption:NSPropertyListMutableContainersAndLeaves
									  format:&format
									  errorDescription:&errorDesc];
	if (nil != addDict) {
		// look for the address throught the dictionary
		NSString *value1, *value2;
		// get the url
		value1 = [addDict valueForKey:@"serviceUrl"];
		// get the method
		value2 = [addDict valueForKey:name];
		if (nil != value1 && nil != value2) {
			address = [[[NSString alloc] initWithFormat:@"%@",value2] autorelease];
		}
	} else {
		NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
	}
	
	return address;
}

- (NSString *)serviceUrl:(NSString *)api args:(NSArray *)paramters {
	NSString  *strUrl;
	NSMutableString *strRequestEncrypted;
	strUrl = nil;
	
	if (nil != api) {
		NSString *strTemp;
		
		strRequestEncrypted = [[NSMutableString alloc] initWithCapacity:512];
		strTemp = [self apiAddress:api];
		if (nil != strTemp) {
			[strRequestEncrypted appendString:strTemp];
		}
		[strRequestEncrypted appendString:@"("];
		if (nil != paramters) {
			NSInteger i, count = [paramters count];
			for (i = 0; i < count - 1; i++) {
				[strRequestEncrypted appendFormat:@"%@,", [paramters objectAtIndex:i]];
			}
			if ([paramters count] > 0) {
				[strRequestEncrypted appendString:[paramters objectAtIndex:i]];
			}
		}
		[strRequestEncrypted appendString:@")"];
	}
	
	/* URL Generator */
		
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
	[parameters setObject:@"guest" forKey:@"username"];
	[parameters setObject:[@"123456" MD5]  forKey:@"password"];
	
	
	UIDevice *device = [UIDevice currentDevice];
	[parameters setObject:[[device.identifierForVendor description] MD5] forKey:@"deviceID"];
	[parameters setObject:device.model forKey:@"deviceType"];
	[parameters setObject:device.name forKey:@"deviceName"];
	[parameters setObject:@"192.168.0.1" forKey:@"ipAddress"];
	[parameters setObject:device.systemName forKey:@"osName"];
	[parameters setObject:device.systemVersion forKey:@"osVersion"];
	[parameters setObject:@"1.0" forKey:@"appVer"];
	[parameters setObject:@"CapitalVue+IPAD+Version" forKey:@"appName"];
	[parameters setObject:@"1" forKey:@"appID"];
	[parameters setObject:@"" forKey:@"alg"];
	[parameters setObject:strRequestEncrypted forKey:@"cmd"];
	
	if (strRequestEncrypted) {
		[strRequestEncrypted release];
	}
	
	 int random = arc4random()%100000;//	 Random rand = new Random();
	 NSString *strRandom = [NSString stringWithFormat:@"%d",random];
	[parameters setObject:strRandom forKey:@"random"];
//	 [parameters addObject:[NSString stringWithFormat:@"rand=%@",[[strRandom MD5] URLEncode]]];//	 parameters.add("rand="+URLEncoder.encode(this.MD5((rand.nextInt(99999))+""),"utf-8"));
	
	//NSArray *algs = [NSArray arrayWithObjects:@"md5",@"sha1",@"sha256",@"sha512",nil];//	  $algos_list = $this->algo_methods;
	random = arc4random()%4;
	//NSString *alg = [algs objectAtIndex:random];//	  $algos_method = $algos_list[rand(0,count($algos_list)-1)];

	
	NSString *strQuery =  [NSString HTTPQuery:parameters];
	[parameters release];
//	NSLog(@"Web SA:%@",strQuery);
	
	//NSString *secrectKey = [strQuery newStringInBase64FromData];
	//NSString *strHash = [alg HMAC:alg key:secrectKey];

	strUrl = [NSString stringWithFormat:@"http://data.capitalvue.com/soap.php?m=service&method=call&hash=%@&sk=%@",@"",[strQuery newStringInBase64FromData]];
	
//	NSLog(@"Str Url:%@",strUrl);
	
	return strUrl;
}

-(BOOL)parseXML:(NSString *)serviceUrl {
	BOOL success;
	NSAutoreleasePool *pool;
	
	pool = [[NSAutoreleasePool alloc] init];
	
	// contruct the request
	NSURL *url;
	NSURLRequest *request;
	url = [[NSURL alloc] initWithString:serviceUrl];
	request = [[NSURLRequest alloc] initWithURL:url
									cachePolicy:NSURLRequestUseProtocolCachePolicy
								timeoutInterval:20.0];
	
	
	// retreive the data using timeout
	NSURLResponse* response;
	NSError *error;
	NSData *serviceData;
	
	error = nil;
	response = nil;
	serviceData = [NSURLConnection sendSynchronousRequest:request 
										   returningResponse:&response
													   error:&error];
	
	// 1001 is the error code for a connection timeout
	if (error && [error code] == 1001 ) {
		NSLog( @"Server timeout!" );
	}
	
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:serviceData];
	
	[url release];
	[request release];
	
	//Set delegate
	[xmlParser setDelegate:self];
	
	//Start parsing the XML file.
	success = [xmlParser parse];
	
	[xmlParser release];
	[pool release];
	
	return success;
}

#pragma mark public methods

- (id) init
{
	if ( [super init] ) {
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
		self.m_rootObject = dict;
		[dict release];

		NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:1];
		self.m_array = array;
		[array release];
	}	
	return self;
}

- (void) dealloc {
	[m_element release];
	[m_key release];
	[m_value release];
	[m_array release];
	[m_rootObject release];
	[m_object release];
	[super dealloc];
}

/*
 * It retrieves xml-formatted data from the remote server.
 *
 * @param: none
 * @return: NSDictionary
 */

- (NSDictionary *)GetData:(NSString *)api args:(NSArray *)parameters {
	NSString *strUrl;
	
	strUrl = [self serviceUrl:api args:parameters];
	
	if (nil != strUrl)
		[self parseXML:strUrl];
	
	return [[[NSDictionary alloc] initWithDictionary:m_rootObject] autorelease];
}

#pragma mark XMLParser delegate

- (void)parser:(NSXMLParser *)parser foundAttributeDeclarationWithName:(NSString *)attributeName 
	forElement:(NSString *)elementName type:(NSString *)type defaultValue:(NSString *)defaultValue
{
	//NSLog(@"Found attibute:name=%@, elementName=%@, type=%@, defaultValue=%@",
	//	  attributeName, elementName, type, defaultValue);
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
	NSString * strData = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
//	NSLog(@"foundCDATA:%@", strData);
	[strData release];
}

- (void)parser:(NSXMLParser *)parser foundInternalEntityDeclarationWithName:(NSString *)name value:(NSString *)value
{
	//NSLog(@"foundInternalEntity: name=%@, value=%@", name, value);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	NSUInteger count;
	NSMutableDictionary *dict;
	NSMutableString *strValue;
	
	count = [self.m_object count];
	if (0 == count) {
		// an empty object, so create it
		dict = [[NSMutableDictionary alloc] init];
		[dict setObject:string forKey:@"value"];
		self.m_object = dict;
		[dict release];
	} else {
		// it is not empty
		// get the existing value and append string to it
		strValue = [[NSMutableString alloc] init];
		if (nil == [m_object objectForKey:@"value"]) {
			[strValue setString:string];
		} else {
			[strValue setString:[m_object objectForKey:@"value"]];
			[strValue appendString:string];
		}
		[m_object setObject:strValue forKey:@"value"];
		[strValue release];
	}
	
//	NSLog(@"Processing Value: %@", string);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {		
	
//	NSLog(@"Start Element: %@, namespace=%@, qualifiedName=%@", elementName, namespaceURI, qualifiedName);
	for (id key in attributeDict) {
	//	NSLog(@"\t%@ = %@", key, [attributeDict objectForKey:key]);
	}
	
	[m_array addObject:m_object];
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:attributeDict];
	// take the attributeDict as a pair of key and value of an object
	self.m_object = dict;
	self.m_element = elementName;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
//	NSLog(@"End Element: %@, namespace=%@, qualifiedName=%@",elementName, namespaceURI, qName);
	
	NSMutableDictionary *dict;
	
	// get the last object of the array
	dict = [m_array lastObject];
	
	if ([dict objectForKey:elementName] != nil)
	{
		// if there is an object with the same key in the upper level dictionary
		id upperObj = [dict objectForKey:elementName];
		
		if ( [upperObj isKindOfClass:[NSMutableArray class]] )
		{
			// the upper object is an array
			[(NSMutableArray *)upperObj addObject:m_object];
		}
		else
		{
			// the upper object is not an array, but the current object and 
			// and uppper object shares the common attribute, so construct an
			// array to hold them.
			NSMutableArray * newArray = [[NSMutableArray alloc] initWithCapacity:2];
			[newArray addObject:upperObj];
			[newArray addObject:m_object];
			
			[dict removeObjectForKey:elementName];
			[dict setObject:newArray forKey:elementName];
			[newArray release];
		}
	}
	else
	{
		[dict setObject:m_object forKey:elementName];
	}
	
	// pop current dictionary
	self.m_object = [m_array lastObject];
	[m_array removeLastObject];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
//	NSLog(@"Start document");
	self.m_object = m_rootObject;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
//	NSLog(@"End document");
}

@end
