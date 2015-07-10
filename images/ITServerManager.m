//
//  ITServerManager.m
//  imagesTest
//
//  Created by Линник Александр on 02.07.15.
//  Copyright (c) 2015 Alex Linnik. All rights reserved.
//


#import "ITServerManager.h"
#import "ITImageItem.h"
#import "XMLReader.h"

@interface ITServerManager () <NSXMLParserDelegate>

@property(strong, nonatomic) NSMutableData* tempData;
@property(strong, nonatomic) NSMutableString* tempData2;

@property(assign, nonatomic) NSInteger expectedBytes;
@property(assign, nonatomic) NSInteger loadedBytes;

@end


@implementation ITServerManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        

    }
    return self;
}


+(ITServerManager*) sharedManager{
    
    static ITServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    
        dispatch_once(&onceToken, ^{
    
            manager = [[ITServerManager alloc]init];
            
        });
    
        return manager;
}


-(void)getImagList{

    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<GetImageList xmlns=\"http://tempuri.org/\">\n"
                             "</GetImageList>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             ];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* requestURL = [defaults stringForKey:@"requestURL"];
    
    NSURL *url = nil;
    
    if (requestURL) {
        
        url = [NSURL URLWithString:requestURL];
        
    } else {
        
        url = [NSURL URLWithString:@"http://ioswcf.dataxdev.com/Service1.svc"];
        
    }
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/IIosService/GetImageList" forHTTPHeaderField:@"soapaction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection connectionWithRequest:theRequest delegate:self];

}


-(void)getImageById:(NSInteger)ID{
    
   NSMutableString *log = [NSMutableString string];
    
    NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"ImageID",@"offset",@"totalbytes", nil];
    
    NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%ld",(long)ID],@"0",@"1000000000", nil];
    
    for (int i=0; i<[tags count]; i++) {
        
       NSString* strResult = [NSString stringWithFormat:@"<%@>%@</%@>", [tags objectAtIndex:i],[vars objectAtIndex:i],[tags objectAtIndex:i]];
        
        [log appendString:strResult];
    }

    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<GetImage xmlns=\"http://tempuri.org/\">%@\n"
                             "</GetImage>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", log
                             ];

    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* requestURL = [defaults stringForKey:@"requestURL"];
    
    NSURL *url = nil;
    
    if (requestURL) {
        
        url = [NSURL URLWithString:requestURL];
        
    } else {
        
        url = [NSURL URLWithString:@"http://ioswcf.dataxdev.com/Service1.svc"];
        
    }
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    

    
    [theRequest addValue: @"text/xml; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest addValue: @"http://tempuri.org/IIosService/GetImage" forHTTPHeaderField:@"soapaction"];
    
//    [theRequest addValue: @"mutipart/form-data" forHTTPHeaderField:@"enctype"];

    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection connectionWithRequest:theRequest delegate:self];
    

}

#pragma mark - Privet Methods


-(NSData *)dataFromBase64EncodedString:(NSString *)string{
    
    if (string.length > 0) {
        
        NSString *data64URLString = [NSString stringWithFormat:@"data:;base64,%@", string];
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:data64URLString]];
        
        return data;
    }
    
    return nil;
}

-(void)parseDataFromDictionary:(NSDictionary*)dict{
    
    if ([dict objectForKey:@"Envelope"]) {
        
        NSMutableArray* imageItems = [NSMutableArray array];
        
        NSDictionary* envelopeDict = [dict objectForKey:@"Envelope"];
        
        if ([envelopeDict objectForKey:@"Body"]) {
            
            NSDictionary* bodyDict = [envelopeDict objectForKey:@"Body"];
            
            if ([bodyDict objectForKey:@"GetImageListResponse"]) {
                
                NSDictionary* getImagelistResponse = [bodyDict objectForKey:@"GetImageListResponse"];
                
                if ([getImagelistResponse objectForKey:@"GetImageListResult"]) {
                    
                    NSDictionary*  getImageListResult =[getImagelistResponse objectForKey:@"GetImageListResult"];
                    
                    if ([getImageListResult objectForKey:@"int"]) {
                        
                        NSMutableArray* arrayImagesId = [getImageListResult objectForKey:@"int"];
                        
                        for (NSDictionary* imageID in arrayImagesId) {
                            
                            ITImageItem* imageItem = [[ITImageItem alloc]init];
                            
                            imageItem.imageID = [[imageID objectForKey:@"text"] integerValue];
                            
                            [imageItems addObject:imageItem];
                        }
                        
                        if ([self.delegate respondsToSelector:@selector(getImagListResponds:)]) {
                            
                            [self.delegate getImagListResponds:imageItems];
                            
                            
                        }
                        
                    }
                }
                
            } else{
                
                if ([bodyDict objectForKey:@"GetImageResponse"]) {
                    
                    NSDictionary* getImageResponse = [bodyDict objectForKey:@"GetImageResponse"];
                    
                    if ([getImageResponse objectForKey:@"GetImageResult"]) {
                        
                        NSDictionary*  getImageResult =[getImageResponse objectForKey:@"GetImageResult"];
                        
                        if ([getImageResult objectForKey:@"text"]) {
                            
                            NSData* imageData = [self dataFromBase64EncodedString:[getImageResult objectForKey:@"text"]];
                            
                            if ([self.delegate respondsToSelector:@selector(getImagResponds:)]) {
                                
                                [self.delegate getImagResponds:imageData];
                            }
                            
                            
                        }
                    }
                }
            }
        }
        
    } else {
        
        if ([self.delegate respondsToSelector:@selector(errorResponds:)]) {
            
            [self.delegate errorResponds:@"Error parsing Xml"];
        }
        
    }

}

#pragma mark - NSURLConnectionDelegate


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    NSError *error = nil;
    
    NSDictionary *dict = [XMLReader dictionaryForXMLData:data
                                                 options:XMLReaderOptionsProcessNamespaces
                                                   error:&error];
    
    float dat = [data length];
    
    if (_loadedBytes == 0) {
        
        _loadedBytes = dat;
        
    } else {
        
        _loadedBytes = _loadedBytes + dat;

    }
    
    if  (_expectedBytes > _loadedBytes ) {
        
         [self.tempData appendData:data];
        
        [self.delegate progtessLoadImage:_expectedBytes loadBytes:_loadedBytes];

        
    } else if (_expectedBytes == _loadedBytes) {
        
        [self.tempData appendData:data];
    
    }
    
    if (dict) {
        
        [self parseDataFromDictionary:dict];
        
    }
    
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    if (self.tempData.length>0) {
        
        NSString *thexml=[[NSString alloc] initWithBytes:[self.tempData mutableBytes] length:[self.tempData length] encoding:NSASCIIStringEncoding];
        
        NSData *xmlData = [thexml dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        
        NSDictionary *dict = [XMLReader dictionaryForXMLData:xmlData
                                                     options:XMLReaderOptionsProcessNamespaces
                                                       error:&error];
        [self parseDataFromDictionary:dict];
        
    }
    
    
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    
        NSString *msg = [NSString stringWithFormat:@"ERROR: %@", error.localizedDescription];

                if ([self.delegate respondsToSelector:@selector(errorResponds:)]) {
        
                    [self.delegate errorResponds:msg];
                }
    
}


 -(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
        
        self.tempData = [NSMutableData data];
     
        [self.tempData setLength:0];
     
        _loadedBytes = 0;

        _expectedBytes = [response expectedContentLength];
     
    }



@end
