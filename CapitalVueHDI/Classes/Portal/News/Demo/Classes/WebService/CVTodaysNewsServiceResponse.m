
#import "CVTodaysNewsServiceResponse.h"


@implementation CVTodaysNewsServiceResponse

@synthesize m_topicsArray;
@synthesize m_currentValueString;
@synthesize m_isPaser;
- (id)init {
	if ([super init]) {
		NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:1];
		self.m_topicsArray = array;
		[array release];
		
		NSMutableDictionary *dicMutable = [[NSMutableDictionary alloc] initWithCapacity:1];
		self.m_dictCurrentElement = dicMutable;
		[dicMutable release];
		
		self.m_isPaser = TRUE;
	}
	
	return self;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(self.m_currentValueString!=nil)
	{
		[self.m_currentValueString appendString:string];
		
		//NSLog(@"Processing Value: %@", string);
	}
	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"row"] && TRUE == m_isPaser) {
		NSMutableDictionary *dicMutable = [[NSMutableDictionary alloc] init];
		self.m_dictCurrentElement = dicMutable;
		[dicMutable release];
		
		for (id key in attributeDict) {
			//NSLog(@"\t%@ = %@", key, [attributeDict objectForKey:key]);
			[m_dictCurrentElement setObject:[attributeDict objectForKey:key] forKey:key];
		}
	}
	if ([elementName isEqualToString:@"post_id"] ||
		[elementName isEqualToString:@"title"] ||
		[elementName isEqualToString:@"body"] ||
		[elementName isEqualToString:@"ownerid"] ||
		[elementName isEqualToString:@"ownername"] ||
		[elementName isEqualToString:@"comment_count"] ||
		[elementName isEqualToString:@"t_stamp"] ||
		[elementName isEqualToString:@"poststat_total_hitcount"] ||
		[elementName isEqualToString:@"poststat_setid"] ||
		[elementName isEqualToString:@"poststat_groupid"] ||
		[elementName isEqualToString:@"poststat_groupdn"] ||
		[elementName isEqualToString:@"text"] ||
		[elementName isEqualToString:@"image"] ||
		[elementName isEqualToString:@"typeid"] ||
		[elementName isEqualToString:@"custom1"] ||
		[elementName isEqualToString:@"custom2"] ||
		[elementName isEqualToString:@"attachment"] ||
		[elementName isEqualToString:@"url"] ||
		[elementName isEqualToString:@"url_ring_join"] ||
		[elementName isEqualToString:@"url_edit"] ||
		[elementName isEqualToString:@"url_send"] ||
		[elementName isEqualToString:@"url_delete"] ||
		[elementName isEqualToString:@"user_favorite_code"] ||
		[elementName isEqualToString:@"fav_edit_class"] ||
		[elementName isEqualToString:@"text_body"] ||
		[elementName isEqualToString:@"thumbUrl"] ||
		[elementName isEqualToString:@"smallUrl"] ||
		[elementName isEqualToString:@"thumbWidth"] ||
		[elementName isEqualToString:@"thumbHeight"] ||
		[elementName isEqualToString:@"tag_list_text"] ||
		[elementName isEqualToString:@"canEditSelf"] ||
		[elementName isEqualToString:@"canRingSelf"] ||
		[elementName isEqualToString:@"canCommentSelf"] ||
		[elementName isEqualToString:@"isOwner"]){
		self.m_currentValueString = [[NSMutableString alloc] init];
	}
	else if ([elementName isEqualToString:@"read_perm_list"]){
		self.m_currentValueString = [[NSMutableString alloc] init];
		self.m_isPaser = FALSE;
	}
	else if ([elementName isEqualToString:@"canDeleteSelf"]){
		self.m_currentValueString = [[NSMutableString alloc] init];
		self.m_isPaser = TRUE;
	}

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if ([elementName isEqualToString:@"row"] && TRUE == m_isPaser) {
		[self.m_topicsArray addObject:m_dictCurrentElement];
	} else if ([elementName isEqualToString:@"root"]){
		[m_dictData setObject:m_topicsArray forKey:@"TodaysNewsDataSet"];
	} else if ([elementName isEqualToString:@"post_id"] ||
			   [elementName isEqualToString:@"title"] ||
			   [elementName isEqualToString:@"body"] ||
			   [elementName isEqualToString:@"ownerid"] ||
			   [elementName isEqualToString:@"ownername"] ||
			   [elementName isEqualToString:@"comment_count"] ||
			   [elementName isEqualToString:@"t_stamp"] ||
			   [elementName isEqualToString:@"poststat_total_hitcount"] ||
			   [elementName isEqualToString:@"poststat_setid"] ||
			   [elementName isEqualToString:@"poststat_groupid"] ||
			   [elementName isEqualToString:@"poststat_groupdn"] ||
			   [elementName isEqualToString:@"text"] ||
			   [elementName isEqualToString:@"image"] ||
			   [elementName isEqualToString:@"typeid"] ||
			   [elementName isEqualToString:@"custom1"] ||
			   [elementName isEqualToString:@"custom2"] ||
			   [elementName isEqualToString:@"attachment"] ||
			   [elementName isEqualToString:@"url"] ||
			   [elementName isEqualToString:@"url_ring_join"] ||
			   [elementName isEqualToString:@"url_edit"] ||
			   [elementName isEqualToString:@"url_send"] ||
			   [elementName isEqualToString:@"url_delete"] ||
			   [elementName isEqualToString:@"user_favorite_code"] ||
			   [elementName isEqualToString:@"fav_edit_class"] ||
			   [elementName isEqualToString:@"text_body"] ||
			   [elementName isEqualToString:@"thumbUrl"] ||
			   [elementName isEqualToString:@"smallUrl"] ||
			   [elementName isEqualToString:@"thumbWidth"] ||
			   [elementName isEqualToString:@"thumbHeight"] ||
			   [elementName isEqualToString:@"tag_list_text"] ||
			   [elementName isEqualToString:@"canEditSelf"] ||
			   [elementName isEqualToString:@"canRingSelf"] ||
			   [elementName isEqualToString:@"canCommentSelf"] ||
			   [elementName isEqualToString:@"isOwner"] ||
			   [elementName isEqualToString:@"read_perm_list"] ||
			   [elementName isEqualToString:@"canDeleteSelf"]){
		[m_dictCurrentElement setObject:self.m_currentValueString forKey:elementName];
		[self.m_currentValueString release];
		self.m_currentValueString = nil;
	}
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	[m_topicsArray removeAllObjects];
	//NSLog(@"Start document");
	//self.m_dictCurrentElement = m_dictData;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	//self.m_dictData = self.m_dictCurrentElement;
	//NSLog(@"End document");
}


- (void)dealloc {
	[m_topicsArray release];
	[super dealloc];
}
@end
