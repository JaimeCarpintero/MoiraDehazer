//
//  SoftMattingWrapper.m
//  MDehazer
//
//  Created by Jaime Carpintero on 2/23/21.
//

#import <Foundation/Foundation.h>
#import "SoftMattingWrapper.h"
#import "SoftMatting.h"

@implementation SoftMattingWrapper

- (NSString *) sayHello{
    SoftMatting softMatting;
    char hola[5] = "hola";
    return [NSString
            stringWithCString:hola
            encoding:NSUTF8StringEncoding];
}

-(void)softMatting:(float * _Nonnull)input
                    tMap:(float * _Nonnull)transmissionMap
                    channels:(NSInteger)channels
                    width:(NSInteger)width
                    height:(NSInteger)height
                    softMattingWindowSize:(NSInteger)softMattingWindowSize{
    
    SoftMatting softMatter;
    softMatter.softMattingTransmission(input,
                                       transmissionMap,
                                       (int)channels,
                                       (int)width,
                                       (int)height,
                                       (int)softMattingWindowSize);
}



@end
