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

@end
