//
//  CVDatabase.m
//  CapitalVueHD
//
//  Created by jishen on 9/28/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "CVDatabase.h"
#import <sqlite3.h>

#define DBFile @"CapitalVue.sqlite"

@implementation CVDatabase

static sqlite3 *_database = 0;
static CVDatabase *sharedInstance = nil;

+ (CVDatabase *)openDatabase {
    @synchronized(self) {
        if (sharedInstance == nil) {
			if (0 == _database) {
				NSString * bundlePath = [[NSBundle mainBundle] bundlePath];
				NSString * dbFile =	[bundlePath stringByAppendingPathComponent:DBFile];
				
				if (sqlite3_open([dbFile UTF8String], &_database) != SQLITE_OK)
				{
					sqlite3_close(_database);
					return nil;
				}
			}
            [[self alloc] init]; // assignment not done here
        }
    }
	
    return sharedInstance;
}


+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release {
}

- (id)autorelease {
    return self;
}

+ (void)closeDatabase {
	sqlite3_close(_database);
}

- (void)insertRow:(NSDictionary *)data columns:(NSArray *)columns {
	int ret = 0;
	char * pErrMsg = 0;
	char *gpdm;
	char *gpjc;
	char *gpjcpy;
	char *zhxgrq;
	size_t command_size;
	
	NSString *strTmp;
	
	//insert book info
	char insertbookprefix[] = "INSERT INTO \"EquiteCodes\" (\"GPDM\",\"GPJC\",\"GPJCPY\",\"ZHXGRQ\") VALUES('";
	char data0[] = "',";
	char data1[] = "'";
	char data2[] = "','";
	char data3[] = "');";
	
	// convert NSString to char
	strTmp = [data objectForKey:@"GPDM"];
	gpdm = [strTmp UTF8String];
	strTmp = [data objectForKey:@"GPJC"];
	gpjc = [strTmp UTF8String];
	strTmp = [data objectForKey:@"GPJCPY"];
	gpjcpy = [strTmp UTF8String];
	strTmp = [data objectForKey:@"ZHXGRQ"];
	zhxgrq = [strTmp UTF8String];
	
	command_size = strlen(insertbookprefix) 
	+ strlen(gpdm) 
	+ strlen(data0)
	+ strlen(data1)
	+ strlen(gpjc)
	+ strlen(data2)
	+ strlen(gpjcpy) 
	+ strlen(data2)
	+ strlen(zhxgrq)
	+ strlen(data3);
	char * inserbook = (char *)malloc(command_size + 1);
	strcpy(inserbook, insertbookprefix);
	strcat(inserbook, gpdm);
	strcat(inserbook, data0);
	strcat(inserbook, data1);
	strcat(inserbook, gpjc);
	strcat(inserbook, data2);
	strcat(inserbook, gpjcpy);
	strcat(inserbook, data2);
	strcat(inserbook, zhxgrq);
	strcat(inserbook, data2);
	strcat(inserbook, data3);
	const char * sSQL3 = inserbook;
	ret = sqlite3_exec( _database, sSQL3, 0, 0, &pErrMsg );
	if ( ret != SQLITE_OK )
	{
		fprintf(stderr, "SQL error: %sn", pErrMsg);
		sqlite3_free(pErrMsg);
	}     
	free(inserbook);
	inserbook = NULL;
}

#pragma mark -
#pragma mark public method
- (void)insertEquityCodes:(NSArray *)equityCodes columns:(NSArray *)columns {
	NSDictionary *dict;
	if (0 != _database) {
		if (0 != [equityCodes count]) {
			// clear existing elment in the sql
			NSString *query = @"DELETE FROM EqutiyCodes";
			int ret;
			char * pErrMsg = 0;
			ret = sqlite3_exec(_database, [query UTF8String], 0, 0, &pErrMsg);
			if ( ret != SQLITE_OK )
			{
				fprintf(stderr, "SQL error: %sn", pErrMsg);
				sqlite3_free(pErrMsg);
			}
		}
		
		for (dict in equityCodes) {
			[self insertRow:dict columns:columns];
		}
	}
}

- (NSDictionary *)getEnquityCodes {
	return nil;
}

- (NSDictionary *)getData:(NSString *)api args:(NSArray *)parameters {
	return nil;
}

- (void)insertData:(NSDictionary *) ofApi:(NSString *)api andArgs:(NSArray *)paramters {
}

@end
