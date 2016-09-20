/*! @file OIDURLQueryComponent.h
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

#import <Foundation/Foundation.h>

@class OIDAuthorizationRequest;

NS_ASSUME_NONNULL_BEGIN

/*! @class OIDURLQueryComponent
    @brief A utility class for creating and parsing URL query components.
 */
@interface OIDURLQueryComponent : NSObject

/*! @property parameters
    @brief The parameter names in the query.
 */
@property(nonatomic, readonly) NSArray<NSString *> *parameters;

/*! @property dictionaryValue
    @brief The parameters represented as a dictionary.
    @remarks All values are @c NSString except for parameters which contain multiple values, in
        which case the value is an @c NSArray<NSString *> *.
 */
@property(nonatomic, readonly) NSDictionary<NSString *, NSObject<NSCopying> *> *dictionaryValue;

/*! @fn initWithURL:
    @brief Creates an @c OIDURLQueryComponent by parsing the query string in a URL.
    @param URL The URL from which to extract a query component.
 */
- (nullable instancetype)initWithURL:(NSURL *)URL;

/*! @fn valuesForParameter:
    @brief The value (or values) for a named parameter in the query.
    @param parameter The parameter name. Case sensitive.
    @return The value (or values) for a named parameter in the query.
 */
- (NSArray<NSString *> *)valuesForParameter:(NSString *)parameter;

/*! @fn addParameter:value:
    @brief Adds a parameter value to the query.
    @param parameter The name of the parameter. Case sensitive.
    @param value The value to add.
 */
- (void)addParameter:(NSString *)parameter value:(NSString *)value;

/*! @fn addParameters:
    @brief Adds multiple parameters with associated values to the query.
    @param parameters The parameter name value pairs to add to the query.
 */
- (void)addParameters:(NSDictionary<NSString *, NSString *> *)parameters;

/*! @fn URLByReplacingQueryInURL:
    @param URL The URL to add the query component to.
    @return The original URL with the query component replaced by the parameters from this query.
 */
- (NSURL *)URLByReplacingQueryInURL:(NSURL *)URL;

/*! @fn URLEncodedParameters
    @brief Builds an x-www-form-urlencoded string representing the parameters.
    @return The x-www-form-urlencoded string representing the parameters.
 */
- (NSString *)URLEncodedParameters;

@end

NS_ASSUME_NONNULL_END
