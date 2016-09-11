//
//  EKSWebViewWrapper.m
//  EKSperience
//
//  Created on 19/03/16.

//

#import "WKWebViewWrapper.h"

@interface WKWebViewWrapper ()

@property (strong, nonatomic, readwrite) WKWebView *webView;

@end

@implementation WKWebViewWrapper

#pragma mark - Inits

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        [self commonSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self commonSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self commonSetup];
    }
    return self;
}

#pragma mark - Lifecycle

- (void)layoutSubviews {
    [super layoutSubviews];
    _webView.frame = self.bounds;
}

- (CGSize)intrinsicContentSize {
    return self.webView.bounds.size;
}

#pragma mark - IB_Designable

- (void)prepareForInterfaceBuilder {
    UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"WKWebView Container";
    [self insertSubview:label aboveSubview:_webView];
}


#pragma mark -

- (void)commonSetup {
    [self setupUI];
}

- (void)setupUI {
    _webView = [[WKWebView alloc]
                initWithFrame:self.frame
                configuration:[[WKWebViewConfiguration alloc] init]];
    [self addSubview:_webView];
}


@end
