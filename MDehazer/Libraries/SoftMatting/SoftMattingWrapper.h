/*
 * SoftMattingWrapper.h
 * (c) 2021 Jaime Carpintero Carrillo
 * jaime.carpintero.carrillo@gmail.com
 * jaime.carpintero@uabc.edu.mx
 * This code is licensed under MIT license (see LICENSE.txt for details)
*/

#import <Foundation/Foundation.h>

@interface SoftMattingWrapper : NSObject

- (NSString *) sayHello;

-(void)softMatting:(float * _Nonnull)input
                    tMap:(float * _Nonnull)transmissionMap
                    channels:(NSInteger)channels
                    width:(NSInteger)width
                    height:(NSInteger)height
                    softMattingWindowSize:(NSInteger)softMattingWindowSize;


@end
