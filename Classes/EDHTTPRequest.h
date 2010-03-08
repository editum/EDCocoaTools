//
//  EDHTTPRequest.h
//  EDCocoaTools
//
//  Created by Oliver Michel on 07.03.10.
//  Copyright 2010 :editum.internet solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	EDHTTPRequestErrorGeneric = 1,
	EDHTTPRequestErrorConnectionInitFailed,
	EDHTTPRequestErrorWrongStatus,
	EDHTTPRequestErrorStatus400,
	EDHTTPRequestErrorStatus401,
	EDHTTPRequestErrorStatus402,
	EDHTTPRequestErrorStatus403,
	EDHTTPRequestErrorStatus404,
	EDHTTPRequestErrorStatus500,
	EDHTTPRequestErrorTimeOut,
	EDHTTPRequestErrorFailedSavingResponseData,
	EDHTTPRequestErrorNoNetworkConnection,
	EDHTTPRequestErrorNetworkConnectionLost,
	EDHTTPRequestErrorCannotConnectToHost
} EDHTTPRequestError;

typedef enum {
	EDHTTPRequestMethodGet = 1,
	EDHTTPRequestMethodPost,
	EDHTTPRequestMethodPut, 
	EDHTTPRequestMethodDelete, 
	EDHTTPRequestMethodHead
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
	NSURL *_requestURL;
	
	NSDate *_requestTime;
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
@property(nonatomic, copy) NSURL *requestURL;

@property(nonatomic, readonly) NSHTTPURLResponse *response;

+ (EDHTTPRequest *)request;
+ (EDHTTPRequest *)requestWithURL:(NSURL *)url delegate:(id)theDelegate;
- (id)initWithURL:(NSURL *)url delegate:(id)theDelegate;

- (void)start;
- (void)cancel;

@end
