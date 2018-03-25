//
//  BFirebaseNetworkAdapterModule.m
//  ChatSDK Demo
//
//  Created by Ben on 2/1/18.
//  Copyright © 2018 deluge. All rights reserved.
//

#import "BFirebaseNetworkAdapterModule.h"
#import "ChatFirebaseAdapter.h"

@implementation BFirebaseNetworkAdapterModule

-(void) activate {
    [BNetworkManager sharedManager].a = [[BFirebaseNetworkAdapter alloc] init];
}

@end
