#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface CalloutMapAnnotation : NSObject <MAAnnotation> {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property(retain,nonatomic) NSDictionary *locationInfo;//callout吹出框要显示的各信息
- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;

@end
