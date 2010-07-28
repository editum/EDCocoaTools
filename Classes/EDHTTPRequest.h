//
//  EDHTTPRequest.h
//  EDCocoaTools
//
//  Created by Oliver Michel on 07.03.10.
//  Copyright 2010 :editum.internet solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	EDHTTPRequestErrorGeneric							= 1,
	EDHTTPRequestErrorConnectionInitFailed			= 2,
	EDHTTPRequestErrorWrongStatus						= 4,
	EDHTTPRequestErrorStatus400						= 8,
	EDHTTPRequestErrorStatus401						= 16,
	EDHTTPRequestErrorStatus402						= 32,
	EDHTTPRequestErrorStatus403						= 64,
	EDHTTPRequestErrorStatus404						= 128,
	EDHTTPRequestErrorStatus500						= 256,
	EDHTTPRequestErrorTimeOut							= 512,
	EDHTTPRequestErrorFailedSavingResponseData	= 1024,
	EDHTTPRequestErrorNoNetworkConnection			= 2048,
	EDHTTPRequestErrorNetworkConnectionLost		= 4096,
	EDHTTPRequestErrorCannotConnectToHost			= 8192,
	EDHTTPRequestErrorParallelRequests				= 16384,
	EDHTTPRequestErrorWrongCredential				= 32768
} EDHTTPRequestError;

typedef enum {
	EDHTTPRequestMethodGet		= 1,
	EDHTTPRequestMethodPost		= 2,
	EDHTTPRequestMethodPut		= 3, 
	EDHTTPRequestMethodDelete	= 4, 
	EDHTTPRequestMethodHead		= 5
} EDHTTPRequestMethod;

@class EDHTTPRequest;

@protocol EDHTTPRequestDelegate

@required
- (void)request:(EDHTTPRequest *)request didFailWithError:(EDHTTPRequestError)error status:(NSUInteger)statusCode;
- (void)request:(EDHTTPRequest *)request finishedSucessfullyWithStatus:(NSUInteger)statusCode data:(NSData *)returnData;
@end

@interface EDHTTPRequest : NSObject {

	@private
	id <EDHTTPRequestDelegate> _delegate;
	
	EDHTTPRequestMethod _method;
	NSArray *_acceptedStatusCodes;
	NSData *_requestBody;
	NSMutableDictionary *_requestHeaders;
	NSString *_credentialPassword;
	NSString *_credentialUser;
	NSString *_identifier;
	NSUInteger _tag;
	NSUInteger _timeOutInterval;
	NSString *_requestURL;
	
	NSDate *_requestTime;
	NSTimeInterval _responseTime;
	NSMutableData *_responseData;
	BOOL _running;
	NSURLConnection *_urlConnection;
	NSHTTPURLResponse *_response;
}

@property(nonatomic, retain) id <EDHTTPRequestDelegate> delegate;
@property EDHTTPRequestMethod method;
@property(nonatomic, retain) NSArray *acceptedStatusCodes;
@property(nonatomic, retain) NSData *requestBody;
@property(nonatomic, retain) NSMutableDictionary *requestHeaders;
@property(nonatomic, copy) NSString *credentialPassword;
@property(nonatomic, copy) NSString *credentialUser;
@property(nonatomic, copy) NSString *identifier;
@property NSUInteger tag;
@property NSUInteger timeOutInterval;
@property(nonatomic, copy) NSString *requestURL;

@property(nonatomic, readonly) NSHTTPURLResponse *response;
@property(readonly) NSTimeInterval responseTime;

+ (EDHTTPRequest *)request;
+ (EDHTTPRequest *)requestWithURL:(NSString *)url delegate:(id)theDelegate;
- (id)initWithURL:(NSString *)url delegate:(id)theDelegate;

- (void)setValue:(NSString *)value forHeaderField:(NSString *)field;
- (void)start;
- (void)cancel;

@end
