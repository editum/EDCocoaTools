//
//  EDHTTPRequest.m
//  EDCocoaTools
//
//  Created by Oliver Michel on 07.03.10.
//  Copyright 2010 :editum.internet solutions. All rights reserved.
//

#import "EDHTTPRequest.h"


@implementation EDHTTPRequest

@dynamic delegate;
@synthesize method = _method;
@synthesize acceptedStatusCodes = _acceptedStatusCodes;
@synthesize requestBody = _requestBody;
@synthesize requestHeaders = _requestHeaders;
@synthesize credentialPassword = _credentialPassword;
@synthesize credentialUser = _credentialUser;
@synthesize identifier = _identifier;
@synthesize tag = _tag;
@synthesize timeOutInterval = _timeOutInterval;
@synthesize requestURL = _requestURL;
@synthesize response = _response;
@synthesize responseTime = _responseTime;

#pragma mark -
#pragma mark Initializers

- (id)initWithURL:(NSURL *)url delegate:(id)theDelegate {
	
	self = [super init];
	_requestURL = [url copy]; 
	_delegate = [theDelegate retain];
	return self;
}

+ (EDHTTPRequest *)request {
	
	return [[[self alloc] init] autorelease];
}

+ (EDHTTPRequest *)requestWithURL:(NSURL *)url delegate:(id)theDelegate {
	
	return [[[self alloc] initWithURL:url delegate:theDelegate] autorelease];
}

#pragma mark -
#pragma mark Setting/Getting the Delegate

- (void)setDelegate:(id)theDelegate {
	
	if([theDelegate conformsToProtocol:@protocol(EDHTTPRequestDelegate)] 
	   && [theDelegate respondsToSelector:@selector(request:finishedSucessfullyWithStatus:data:)]
	   && [theDelegate respondsToSelector:@selector(request:didFailWithError:status:)]) {
		
		_delegate = [theDelegate retain];
		
	} else {
		@throw [NSException exceptionWithName:@"EDHTTPRequest Exception" 
									   reason:@"Delegate doesn't conform to EDHTTPRequestDelegate" userInfo:nil];
	}
}

- (id)delegate {
	
	return _delegate;
} 

#pragma mark -
#pragma mark starting/stopping the request

- (void)start {
	
	if(!_delegate || !_requestURL || _running) {
		
		if(!_delegate) {
			@throw [NSException exceptionWithName:@"EDHTTPRequest Exception" reason:@"No Delegate defined" userInfo:nil];
		} else if(!_requestURL) {
			@throw [NSException exceptionWithName:@"EDHTTPRequest Exception" reason:@"No URL defined" userInfo:nil];
		} else if(_running) {
			if(_delegate) 
				[_delegate request:self didFailWithError:EDHTTPRequestErrorParallelRequests status:0];
		}
		
	} else {
		
		_running = YES;
		_responseTime = 0;
		[_response release];
		
		if(!_timeOutInterval)
			_timeOutInterval = 15;

		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_requestURL 
																	cachePolicy:NSURLRequestUseProtocolCachePolicy 
																timeoutInterval:(float)_timeOutInterval];
		
		switch (_method) {
			case EDHTTPRequestMethodGet: [request setHTTPMethod:@"GET"]; break;
			case EDHTTPRequestMethodPost: [request setHTTPMethod:@"POST"]; break;
			case EDHTTPRequestMethodHead: [request setHTTPMethod:@"HEAD"]; break;
			case EDHTTPRequestMethodPut: [request setHTTPMethod:@"PUT"]; break;
			case EDHTTPRequestMethodDelete: [request setHTTPMethod:@"DELETE"]; break;
			default: [request setHTTPMethod:@"GET"];
		}
		
		if(_requestBody)
			[request setHTTPBody:_requestBody];
		
		if(_requestHeaders) 
			[request setAllHTTPHeaderFields:_requestHeaders];
		
		_urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		
		[request release];
		
		if(_urlConnection) {
			NSLog(@"EDHTTPRequest: %@ %@", [request HTTPMethod], _requestURL);
			_responseData = [[NSMutableData alloc] init];
			_requestTime = [[NSDate alloc] init];
		} else {
			[_delegate request:self didFailWithError:EDHTTPRequestErrorConnectionInitFailed status:0];
		}
	}
}

- (void)cancel {
	
	_running = NO;
	[_urlConnection cancel];
	[_responseData release], [_requestTime release];
	_responseData = nil, _requestTime = nil;	
}

#pragma mark -
#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	switch ([error code]) {
			
		case NSURLErrorTimedOut: 
			[_delegate request:self didFailWithError:EDHTTPRequestErrorTimeOut status:0]; break;
			
		case NSURLErrorNotConnectedToInternet: 
			[_delegate request:self didFailWithError:EDHTTPRequestErrorNoNetworkConnection status:0]; break;
			
		case NSURLErrorNetworkConnectionLost: 
			[_delegate request:self didFailWithError:EDHTTPRequestErrorNetworkConnectionLost status:0]; break;
			
		case NSURLErrorCannotConnectToHost:
			[_delegate request:self didFailWithError:EDHTTPRequestErrorCannotConnectToHost status:0]; break;
			 
		default: [_delegate request:self didFailWithError:EDHTTPRequestErrorGeneric status:0];
	}
	_running = NO;
	[_responseData release], [_requestTime release];
	_responseData = nil, _requestTime = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

	_response = [response retain];
	
	NSUInteger status = (NSUInteger)[(NSHTTPURLResponse *)_response statusCode];
	
	if(_acceptedStatusCodes) {
		
		if (![_acceptedStatusCodes containsObject:[NSNumber numberWithInt:status]]) {
			[_delegate request:self didFailWithError:EDHTTPRequestErrorWrongStatus status:status];
			[_urlConnection cancel], [_responseData release], [_requestTime release];
			_responseData = nil, _requestTime = nil;
		}
		
	} else {
		
		if(status == 400 || status == 401 || status == 403 || status == 404 || status == 500) {
			switch (status) {
				case 400: [_delegate request:self didFailWithError:EDHTTPRequestErrorStatus400 status:status]; break;
				case 401: [_delegate request:self didFailWithError:EDHTTPRequestErrorStatus401 status:status]; break;
				case 403: [_delegate request:self didFailWithError:EDHTTPRequestErrorStatus403 status:status]; break;
				case 404: [_delegate request:self didFailWithError:EDHTTPRequestErrorStatus404 status:status]; break;
				case 500: [_delegate request:self didFailWithError:EDHTTPRequestErrorStatus500 status:status]; break;
			}
			[_urlConnection cancel], [_responseData release], [_requestTime release];
			_responseData = nil, _requestTime = nil;
		}
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	if(_responseData) {
		[_responseData appendData:data];
	} else {
		[_delegate request:self didFailWithError:EDHTTPRequestErrorFailedSavingResponseData status:0];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	_responseTime = [[NSDate date] timeIntervalSinceDate:_requestTime];
	
	[_delegate request:self finishedSucessfullyWithStatus:[_response statusCode] data:[_responseData autorelease]];
	_running = NO;
	[_requestTime release], _responseData = nil, _requestTime = nil;
}

#pragma mark -

- (NSString *)description {
	
	if(_running) {
		return [NSString stringWithFormat:@"EDHTTPRequest: running %@ - request time: %@", 
				[_requestURL absoluteString], _requestTime];
	} else {
		return [NSString stringWithFormat:@"EDHTTPRequest: ready %@ - request time: %@", 
				[_requestURL absoluteString], _requestTime];		
	}
	
	return @"EDHTTPRequest:";
}

- (void)dealloc {

	_delegate = nil;
	[_acceptedStatusCodes release];
	[_requestBody release];
	[_requestHeaders release];
	[_credentialPassword release];
	[_credentialUser release];
	[_identifier release];
	[_requestURL release];
	[_requestTime release];
	[_responseData release];
	[_urlConnection release];
	
	[super dealloc];
}

@end
