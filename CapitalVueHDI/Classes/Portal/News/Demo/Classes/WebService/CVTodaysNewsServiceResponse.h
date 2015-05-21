
#import <Foundation/Foundation.h>
#import "CVServiceResponse.h"


@interface CVTodaysNewsServiceResponse : ServiceResponse {
	NSMutableArray *m_topicsArray;
	NSMutableString *m_currentValueString;
	BOOL m_isPaser;
}

@property (nonatomic, retain) NSMutableArray *m_topicsArray;
@property (nonatomic, retain) NSMutableString *m_currentValueString;
@property (nonatomic) BOOL m_isPaser;

@end
