//
//  tripbHistMode.m
//  tripb
//
//  Created by 云开互联 on 16/06/01
//  Copyright (c) tripb. All rights reserved.
//

#import "tripbHistMode.h"
#import "Trips.h"

@implementation tripbHistMode

+ (NSDictionary *)objectClassInArray{
    return @{@"trips" : [Trips class]};
}

@end
