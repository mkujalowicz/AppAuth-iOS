/*! @file OIDURLQueryComponent.m
    @brief AppAuth iOS SDK
    @copyright
        Copyright 2015 Google Inc. All Rights Reserved.
    @copydetails
        Licensed under the Apache License, Version 2.0 (the "License");
        you may not use this file except in compliance with the License.
        You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

        Unless required by applicable law or agreed to in writing, software
        distributed under the License is distributed on an "AS IS" BASIS,
        WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
        See the License for the specific language governing permissions and
        limitations under the License.
 */

#import "OIDURLQueryComponent.h"

/*! @var kQueryStringParamAllowedCharacters
 @brief String representing the set of characters that are unreserved in URL query
 parameters and values.
 */
static NSString *const kQueryStringParamAllowedCharacters =
  @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.-*_";


@implementation OIDURLQueryComponent {
  /*! @var _parameters
      @brief A dictionary of parameter names and values representing the contents of the query.
   */
  NSMutableDictionary<NSString *, NSMutableArray<NSString *> *> *_parameters;
}

- (nullable instancetype)init {
  self = [super init];
  if (self) {
    _parameters = [NSMutableDictionary dictionary];
  }
  return self;
}

- (nullable instancetype)initWithURL:(NSURL *)URL {
  self = [self init];
  if (self) {
    NSString *query = URL.query;
    NSArray<NSString *> *queryParts = [query componentsSeparatedByString:@"&"];
    for (NSString *queryPart in queryParts) {
      NSRange equalsRange = [queryPart rangeOfString:@"="];
      if (equalsRange.location == NSNotFound) {
        continue;
      }
    NSString *name = [queryPart substringToIndex:equalsRange.location];
    name = name.stringByRemovingPercentEncoding;
    NSString *value = [queryPart substringFromIndex:equalsRange.location + equalsRange.length];
    value = value.stringByRemovingPercentEncoding;
    [self addParameter:name value:value];
    }
  }
  return self;
}

- (NSArray<NSString *> *)parameters {
  return _parameters.allKeys;
}

- (NSDictionary<NSString *, NSObject<NSCopying> *> *)dictionaryValue {
  // This method will flatten arrays in our @c _parameters' values if only one value exists.
  NSMutableDictionary<NSString *, NSObject<NSCopying> *> *values = [NSMutableDictionary dictionary];
  for (NSString *parameter in _parameters.allKeys) {
    NSArray<NSString *> *value = _parameters[parameter];
    if (value.count == 1) {
      values[parameter] = [value.firstObject copy];
    } else {
      values[parameter] = [value copy];
    }
  }
  return values;
}

- (NSArray<NSString *> *)valuesForParameter:(NSString *)parameter {
  return _parameters[parameter];
}

- (void)addParameter:(NSString *)parameter value:(NSString *)value {
  NSMutableArray<NSString *> *parameterValues = _parameters[parameter];
  if (!parameterValues) {
    parameterValues = [NSMutableArray array];
    _parameters[parameter] = parameterValues;
  }
  [parameterValues addObject:value];
}

- (void)addParameters:(NSDictionary<NSString *, NSString *> *)parameters {
  for (NSString *parameterName in parameters.allKeys) {
    [self addParameter:parameterName value:parameters[parameterName]];
  }
}

/*! @fn queryItems
    @brief Builds a query items array that can be set to @c NSURLComponents.queryItems
    @discussion The parameter names and values are NOT URL encoded.
    @return An array of unencoded @c NSURLQueryItem objects.
 */
- (NSMutableArray<NSURLQueryItem *> *)queryItems {
  NSMutableArray<NSURLQueryItem *> *queryParameters = [NSMutableArray array];
  for (NSString *parameterName in _parameters.allKeys) {
    NSArray<NSString *> *values = _parameters[parameterName];
    for (NSString *value in values) {
      NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:parameterName value:value];
      [queryParameters addObject:item];
    }
  }
  return queryParameters;
}

/*! @fn queryString
    @brief Builds a query string that can be set to @c NSURLComponents.percentEncodedQuery
    @discussion This string is percentage encoded, and shouldn't be used with
        @c NSURLComponents.query.
    @return An percentage encoded query string.
 */
- (NSString *)queryString {
  NSMutableArray<NSString *> *parameterizedValues = [NSMutableArray array];

  NSCharacterSet *allowedParamCharacters =
    [NSCharacterSet
     characterSetWithCharactersInString: kQueryStringParamAllowedCharacters];

  for (NSString *parameterName in _parameters.allKeys) {
    NSString *encodedParameterName =
        [parameterName stringByAddingPercentEncodingWithAllowedCharacters:allowedParamCharacters];

    NSArray<NSString *> *values = _parameters[parameterName];
    for (NSString *value in values) {
      NSString *encodedValue =
          [value stringByAddingPercentEncodingWithAllowedCharacters:allowedParamCharacters];
      NSString *parameterizedValue =
          [NSString stringWithFormat:@"%@=%@", encodedParameterName, encodedValue];
      [parameterizedValues addObject:parameterizedValue];
    }
  }

  NSString *queryString = [parameterizedValues componentsJoinedByString:@"&"];
  return queryString;
}

- (NSString *)URLEncodedParameters {
  return [self queryString];
}

- (NSURL *)URLByReplacingQueryInURL:(NSURL *)URL {
  NSURLComponents *components =
      [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];

  NSString *queryString = [self queryString];
  components.percentEncodedQuery = queryString;

  NSURL *URLWithParameters = components.URL;
  return URLWithParameters;
}

@end
