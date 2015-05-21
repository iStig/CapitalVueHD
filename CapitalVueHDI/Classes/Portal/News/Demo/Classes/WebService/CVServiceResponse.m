
#import "CVServiceResponse.h"


@implementation ServiceResponse

@synthesize m_strKey, m_strValue, m_arrayElementDictStack, m_arrayElementNameStack;
@synthesize m_dictData, m_dictCurrentElement, m_strCurrElementName;
@synthesize m_arrayMany;

- (void) DumpDict:(NSDictionary *)dictData dictName:(NSString *)dictName
{
	static int nLevel = 0;
	
	nLevel++;
	for (NSString * key in dictData)
	{
		id value = [dictData objectForKey:key];
		
		if ([value isKindOfClass:[NSDictionary class]])
		{
			//NSLog(@"  dict name=%@", key);
			[self DumpDict:value dictName:key];
		}
		else if ([value isKindOfClass:[NSString class]])
		{
			NSMutableString * strSpace = [[NSMutableString alloc] initWithCapacity:1];
			//NSString * strValue = value;
			for(int i = 0; i < nLevel; i++)
				[strSpace appendString:@"    "];
			
			//NSLog(@"  \t%@[%d] %@: %@=%@", strSpace, nLevel, dictName, key, strValue);
			[strSpace release];
		}
		else if ([value isKindOfClass:[NSArray class]])
		{
			NSArray * array = (NSArray *)value;
			for ( int i = 0; i < array.count; i++)
			{
				id obj = [array objectAtIndex:i];
				//NSLog(@">>dict array[%d] name=%@", i, key);
				[self DumpDict:obj dictName:key];
			}
		}
		else
		{
			//NSLog(@"  \t%@=unknown", key);
		}
	}
	nLevel --;
}

- (id) init
{
	if ( [super init] ) {
		NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
		self.m_dictData = dic;
		[dic release];
		NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:1];
		self.m_arrayElementDictStack = array;
		[array release];
	}	
	return self;
}

- (void)dealloc {
	[m_strKey release];
	[m_strValue release];
	[m_arrayElementDictStack release];
	if(m_arrayElementDictStack)
		[m_arrayElementNameStack release];
	if(m_dictCurrentElement)
		[m_dictCurrentElement release];
	[m_strCurrElementName release];
	[m_arrayMany release];
    [super dealloc];
}

#pragma mark API

- (void) setDelegate: (id) delegate	{
	m_idDelegate = delegate;
}

-(void)startQueryAndParse:(ServiceRequest *)request//(NSData *)data
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *strServiceUrl = [request getServiceURL];	
	
	NSURL *url = [[NSURL alloc] initWithString:strServiceUrl];
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	[url release];
	
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	//NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
	
	//Set delegate
	[xmlParser setDelegate:self];
	
	//Start parsing the XML file.
	[xmlParser parse];

	
	if (m_idDelegate != nil)
	{
		[self addNewsListTag:request.url];
		[m_idDelegate queryFinished:self.m_dictData];
	}
	
	[xmlParser release];
	[pool release];
}

- (void) addNewsListTag:(NSString *)url{
	[self.m_dictData setObject:url forKey:@"NewsStyle"];
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
	//NSLog(@"foundCDATA:%@", strData);
	[strData release];
}

- (void)parser:(NSXMLParser *)parser foundInternalEntityDeclarationWithName:(NSString *)name value:(NSString *)value
{
	//NSLog(@"foundInternalEntity: name=%@, value=%@", name, value);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	//NSLog(@"Processing Value: %@", string);
	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {		
	
	//NSLog(@"Start Element: %@, namespace=%@, qualifiedName=%@", elementName, namespaceURI, qualifiedName);
	for (id key in attributeDict) {
		//NSLog(@"\t%@ = %@", key, [attributeDict objectForKey:key]);
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	//NSLog(@"End Element: %@, namespace=%@, qualifiedName=%@",elementName, namespaceURI, qName);
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	//NSLog(@"Start document");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	//NSLog(@"End document");
}


@end
