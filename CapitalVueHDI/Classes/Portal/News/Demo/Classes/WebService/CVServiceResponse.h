

#import <Foundation/Foundation.h>
#import "CVServiceRequest.h"

@protocol ServiceResponseDeleage

- (void)queryFinished:(NSDictionary *)data;

@end

@interface ServiceResponse : NSObject {
	id<ServiceResponseDeleage> m_idDelegate;
	NSMutableDictionary *m_dictData;
	NSMutableDictionary *m_dictCurrentElement;
	NSString *m_strCurrElementName;
	NSString *m_strKey;
	NSString *m_strValue;
	NSMutableArray *m_arrayElementDictStack;
	NSMutableArray *m_arrayElementNameStack;
	NSArray *m_arrayMany;
}

@property (nonatomic, retain) NSMutableDictionary *m_dictData;
@property (nonatomic, retain) NSMutableDictionary *m_dictCurrentElement;
@property (nonatomic, retain) NSString *m_strCurrElementName;
@property (nonatomic, retain) NSString *m_strKey;
@property (nonatomic, retain) NSString *m_strValue;
@property (nonatomic, retain) NSMutableArray *m_arrayElementDictStack;
@property (nonatomic, retain) NSMutableArray *m_arrayElementNameStack;
@property (nonatomic, retain) NSArray *m_arrayMany;

- (void) setDelegate:(id)delegate;
- (void) startQueryAndParse:(ServiceRequest *)request;//(NSData *)data;
- (void) addNewsListTag:(NSString *)url;
- (void) DumpDict:(NSDictionary *)dictData dictName:(NSString *)dictName;

@end
