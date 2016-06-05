//
//  Message+CoreDataProperties.h
//  Techkid_Chess
//
//  Created by Quang Dai on 5/29/16.
//  Copyright © 2016 TechKid. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface Message (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *text;

@end

NS_ASSUME_NONNULL_END
