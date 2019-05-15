历史：
|版本 |  日期 | 参与人 | 备注 |
|---|---|---|---|
| 0.1 |  2018.04.20 | 任涛、张渝 | 初版 |
| 0.1.1| 2018.04.23 | 评审：刘俊启、蔡锐、郭金、任涛、张渝  | 大纲调整、排版确定 |
| 0.1.2| 2018.04.26 | 评审：刘俊启、蔡锐、郭金、任涛、张渝  | 细节评审 |


其他建议：[Objective-C编码规范建议收集表](http://agroup.baidu.com/mobilebaidu/edit/office/1054654)

#1 前言

----------

本规范基于[Google Objective-C Style Guide](https://github.com/google/styleguide/blob/gh-pages/objcguide.md)、[Coding Guidelines for Cocoa](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CodingGuidelines/CodingGuidelines.html)，结合百度Objective-C使用习惯和实际开发情况，对其中的说明性语句及非ARC部分进行了删减。

根据约束力度，把开发规范暂时划分成两个等级，分别：[强制]、[建议]。

 - **[强制]** 必须严格按照代码规范编写代码，一旦违反极有可能引起严重后果；
 - **[建议]** 推荐执行但不强制，长期遵守这样的约定，有助于维护系统的稳定和提高合作效率；

注：本规范示例代码中的 XXX 代表前缀。
<br>

# 2 语法

----------

## 2.1 OC基本特性

#### 2.1.1 nil、Nil、NSNull

**[强制] 对一个 OC 对象判空时禁止使用 NSNull。**

解释：

[NSNull null] 生成一个单例对象，并且存在内存地址，对 OC 对象判空可以直接判断对象地址是否存在。

示例：

	NSObject *p = nil;
	// good
	if (p) {
		...
	}
	
	// good
	if (!p) {
		...
	}
	
	// bad
	if (p == [NSNull null]) {
		...
	}

<br>

**[建议] 置空一个对象使用 nil，置空一个类使用 Nil。** 

解释：

Apple 定义：nil 是指向一个 OC 对象的空指针(id)0，Nil是指向一个 OC 类的空指针(Class)0。

示例：


	// good
	Person *foo = [[Person alloc] init];
	foo = nil;
	Class fooClass = [Person class];
	fooClass = Nil;
	
	// bad
	Person *foo = [[Person alloc] init];
	foo = [NSNull null];
	
	// bad
	Class fooClass = [Person class];
	fooClass = nil;
	

<br>


#### 2.1.2 BOOL、bool、Boolean


**[强制] 在 Objective-C 中，当遇到真假值处理时使用 BOOL。** 

示例：

	// good
	BOOL person = [god buildPeople];
	
	// bad
	bool person = [god buildPeople];
	
	// bad
	Boolean person = [god buildPeople];

<br>


**[强制] 不要直接将 BOOL 值与 YES 、NO 进行比较。** 

解释：

在非64位 iPhone 平台中和非 iWatch 平台中，BOOL 的类型是8位的 signed char(-128 ~ 127)，YES 被定义为 1，NO 被定义为 0。

示例：


	// good
	BOOL great = [foo isGreat];
	if (great) {
	}
	  
	// bad
	if (great == YES) {
	}
	// bad
	BOOL boolValue = 10;
	if (boolValue == YES) {
	}
	
<br>

#### 2.1.3 Equality

**[建议] 对不明确类型的数据判等使用 isEqual: 。** 

解释：

isEqual: 会根据 hash 值判断对象的具体内容是否一致，效率低下；自定义的数据类型判等时建议重写 isEqual: 来提升效率。

示例：


	// good
	id nextValue = [self nextValue]
	if ([self.currentValue isEqual:nextValue]) {   
	}

	// bad
	@implementation XXXObject
	// 未重写 isEqual:
	@end
	XXXObject *custom = [self previousValue];
	XXXObject *next = [self nextValue];
	if ([custom isEqual:next]) {
	}
	
<br>

**[建议] 对字符串判等使用 isEqualToString: 方法。**

解释：

直接判断字符串内容是否相等，避免使用 isEqual 时产生的 hash 计算，因此性能更好。

示例：

	// good
	NSString *peopleName = [self nextName];
	if ([peopleName isEqualToString:self.name]) {   
	}
	
	// bad
	NSString *peopleName = [self nextName];
	if ([peopleName isEqual:self.name]) {
	}
	
<br>


#### 2.1.4 copy 和 mutableCopy

**[建议] 不可变字符串申明属性用 copy 。**

示例：


	// good
	@property (nonatomic, copy) NSString *name;
	
	// bad
	@property (nonatomic, strong) NSString *name;

<br>

**[建议] block 申明属性用 copy 。**

示例：


	// good
	@property (nonatomic, copy) void (^handler)(BOOL complete);
	
	// bad
	@property (nonatomic, strong) void (^handler)(BOOL complete);

<br>


**[强制] 禁止使用 copy 关键字声明可变数据对象。**

示例：


	// good
	@property (nonatomic, strong) NSMutableArray *name;
	
	// bad
	@property (nonatomic, copy) NSMutableArray *name;

<br>

#### 2.1.5 id 

**[强制] 对象初始化方法返回值使用 instancetype，而非 id 。** 

解释：

instancetype 可以返回和方法所在类相同类型的对象，id 只能返回未知类型的对象。

示例：


	// good
	@interface XXXPeople : NSObject  
	+ (instancetype)initWithName:(NSString *)name;  
	@end  
	
	// bad
	@interface XXXPeople : NSObject 
	+ (id)initWithName:(NSString *)name;  
	@end  

<br>

**[建议] 尽量不使用 id 类型作为方法的参数。**

解释：

id 类型为万能指针，当作为参数时，导致代码的可读性降低，并且容易导致编译器无法识别的错误。

示例：


	// good
	- (void)processWithEntity:(XXXFeedEntity *)entity;
	
	// bad
	- (void)processWithEntity:(id)entity;
	
<br>


#### 2.1.6 类型检测、转换 

**[建议] 对不确定类型的数据做类型检测。**

解释：

当一个被传入的数据的数据类型不确定时，做好数据类型检查，防止错误调用引起异常。

示例：


	// good
	NSNotification *notification;
	id dbName = [notification.userInfo objectForKey:XXXBaseDBNotificationNameKey];
	if (![dbName isKindOfClass:[NSString class]]) {
	    return;
	}
	[self doProcessWithName:dbName];
	
	// bad
	NSNotification *notification;
	id dbName = [notification.userInfo objectForKey:XXXBaseDBNotificationNameKey];
	[self doProcessWithName:dbName];

<br>

**[建议] 不使用强制类型转换。**

解释：

类型转换往往是异常的起点，导致编译器无法正确发现错误。

示例：

	// bad
	NSArray *originDatas = [[XXXShare sharedInstance] plateforms];
	[(NSMutableArray *)originDatas removeLastObject];
	
	// bad
	NSInteger timeMs;
	[self doProcessWithTime:(NSTimeInterval)timeMs];
	
	// bad
	CGFloat base = 0.1f;
	CGFloat result = base * 10.0f;
	NSInteger intResult = (NSInteger)result;
	// intResult 不一定等于 1
	NSLog(@"%ld", intResult);

<br>

#### 2.1.7 weak、strong 

**[强制] delegate 属性使用 weak。**

解释：

防止循环引用造成内存泄漏。

示例：


	// good
	@property (nonatomic, weak) id<UIApplicationDelegate> application;
	
	// bad
	@property (nonatomic, assign) id<UIApplicationDelegate> application;
	
<br>



## 2.2 面向对象编程

#### 2.2.1 类

**[建议] 尽量减少继承，类的继承关系不要超过3层。**
<br>

**[建议] 把一些稳定的、公共的变量或者方法抽取到父类中。子类尽量只维持父类所不具备的特性和功能。** 
<br>

**[建议] .h 文件中尽量不要声明成员变量。** 
<br>

**[建议] .h 文件中的属性尽量声明为只读。** 
<br>

**[建议] .h 文件中只暴露出一些必要的类、公开的方法、只读属性；私有类、私有方法和私有属性以及成员变量，尽量写在 .m 文件中。**
<br>

**[建议] 设计一个类应当遵循单一职责原则。**

解释：

一个类只负责一个功能领域中的相应职责，即一个类应该只有一个引起它变化的原因（变化指内部状态变化）。
<br>

#### 2.2.2 对象

**[建议] 避免在公开的接口（包含属性）中暴露可变的对象。**

解释：

对外开放可变数据对象，相当于对外开放了修改该系统内部状态的功能，会造成该系统自身的不稳定。

示例：

	// good
	@property (nonatomic, strong, readonly) NSArray *parents;
	
	// good
	- (NSArray *)allChildren;
	
	// bad
	@property (nonatomic, strong, readonly) NSMutableArray *parents;
	
	// bad
	- (NSMutableArray *)allChildren;

<br>

**[建议] 避免直接使用字符串生成的类来初始化对象。**

解释：

- 表面上解除了相关对象之间的依赖关系，实际耦合关系依然存在，当某一个对象变动时极易造成运行异常。

- 如果要调用一定要对生成的对象做 nil 判断。

示例：

	// good
	Class moduleClass = NSClassFromString(moduleClassName);
	id module = [[moduleClass alloc] init];
	if (!module) {
	    return;
	}
	[self gotoNextModule:module];
	
	// bad
	Class moduleClass = NSClassFromString(moduleClassName);
	id module = [[moduleClass alloc] init];
	[self gotoNextModule:module];

<br>

#### 2.2.3 方法和消息

**[强制] 使用 objc_msgSend 必须定义原型。**

解释：

在 arm64 上如果不定义原型会造成异常。

示例：


	// good
	- (NSInteger)doSomething:(NSInteger)x {
	}
	- (void) doSomethingElse {
	    NSInteger (*action)(id, SEL, NSInteger) = (NSInteger (*)(id, SEL, NSInteger)) objc_msgSend;
	    action(self, @selector(doSomething:), 0);
	}
	
	// bad
	- (int)doSomething:(NSInteger)x {
	}
	- (void)doSomethingElse {
		objc_msgSend(self, @selector(doSomething:), 0);
	}

<br>

**[强制] NSInvocation 设置参数从 2 开始。** 

解释：

NSInvocation 方法 setArgument: atIndex:  在设置参数是 atIndex 的 0 和 1 已经被系统占用。

示例：

	// good
	- (void)doMethod:(NSInteger)paramter {
	}
	- (void)invocationProcess {
	    SEL myMethod = @selector(doMethod:);
	    NSMethodSignature * sig  = [[self class] instanceMethodSignatureForSelector:myMethod];
	    NSInvocation * invocatin = [NSInvocation invocationWithMethodSignature:sig];
	    [invocatin setTarget:self];
	    [invocatin setSelector:myMethod];
	    NSInteger a = 1;
	    [invocatin setArgument:&a atIndex:2];
	    [invocatin invoke];
	}
	
	// bad
	- (void)doMethod:(NSInteger)paramter {
	}
	- (void)invocationProcess {
	    SEL myMethod = @selector(doMethod:);
	    NSMethodSignature * sig  = [[self class] instanceMethodSignatureForSelector:myMethod];
	    NSInvocation * invocatin = [NSInvocation invocationWithMethodSignature:sig];
	    [invocatin setTarget:self];
	    [invocatin setSelector:myMethod];
	    NSInteger a = 1;
	    [invocatin setArgument:&a atIndex:0];
	    [invocatin invoke];
	}


<br>

#### 2.2.4 分类 

**[强制] 使用前缀来区分原始类方法和 category 方法。** 

解释：

避免 category 中的方法覆盖系统方法，前缀不要仅仅使用下划线“ _ ”。

示例：


	// good
	@interface NSString (XXX_BaseCom)
	@end
	
	// bad
	@interface NSString (BaseCom)
	@end

<br>

**[建议] category 中不要声明属性。**

示例：


	// good
	@interface NSString (XXX_BaseCom)
	- (void)doProcess;
	@end
	
	// bad
	@interface NSString (BaseCom)
	@property (nonatomic, copy) NSString *comName;
	@end


<br>

**[建议] 在头文件中定义一组功能相似的方法（行为）时使用分类。**

示例：


	// good
	@interface People : NSObject
	
	- (void)learn;
	- (void)play;
	@end
	@interface People (XXX_PeopleBehavior)
	
	- (void)eat;
	- (void)drink;
	@end
	
	// bad
	@interface People : NSObject
	
	- (void)learn;
	- (void)play;
	
	- (void)eat;
	- (void)drink;
	@end

<br>

#### 2.2.5 类扩展 

**[强制] 只能声明在 .m 的实现文件内，用于定义私有属性、成员变量、私有方法。**
<br>

**[建议] 对外开放属性为 readonly 时内部使用类扩展重定义属性为 readwrite。**

示例：

	// good
	// .h
	@interface AppDelegate : UIResponder <UIApplicationDelegate>
	@property (nonatomic, readonly) UIWindow *window;
	@end
	
	// .m
	@interface AppDelegate ()
	@property (nonatomic, strong) UIWindow *window;
	@end

<br>

#### 2.2.6 协议

**[建议] 设计一个 protocol 应当遵循里氏替换原则。**
<br>

**[建议] protocol 的接口显式标注控制关键字 @required 或 @optional 。**

示例：

	// good
	@protocol MyUIViewDelegate <NSObject>
	@required
	- (void)func;
	@end
	
	// bad
	@protocol MyUIViewDelegate <NSObject>
	- (void)func;
	@end

<br>

## 2.3 高级编程


#### 2.3.1 字符串 

**[强制] 非 readonly 修饰的字符串应使用 copy 关键字声明。**

示例：

	// good
	@property (nonatomic, copy) NSString *name;
	
	// bad
	@property (nonatomic, strong) NSString *name;
	
<br>

**[建议] 截取字符串避免切断特殊字符。**

解释：

某些特殊字符的 length 可能大于 1，不能按 1 的粒度进行截取，比如 5️⃣ 的 Unicode 为 	\u0035\ufe0f\u20e3 ，length 为 3。

示例：

	// good
	NSString *operaString = @"emoji";
	NSRange range = NSMakeRange(0, 1);
	NSRange rangeCorrect = [operaString rangeOfComposedCharacterSequencesForRange:range];
	NSString *splitString = [operaString substringWithRange:rangeCorrect];
	
	// bad
	NSString *operaString = @"emoji";
	NSRange range = NSMakeRange(0, 1);
	NSString *splitString = [operaString substringWithRange:range];


<br>

#### 2.3.2 集合


**[强制] 不要用一个可能为 nil 的对象初始化集合对象。**

解释：

容器对象（Array/Set/Map）内禁止添加 nil 对象，否则会导致 crash。

示例:


	// good
	NSMutableArray *arrM = nil;
	if (obj && [obj isKindOfClass:[NSObject class]]) {
	    arrM = [NSMutableArray arrayWithObject:obj];
	} else {
	    arrM = nil;
	}
	
	// bad
	NSObject *obj = somOjbcetMaybeNil;
	NSMutableArray *arrM = [NSMutableArray arrayWithObject:obj];

<br>

**[强制] 对插入到可变集合的对象要进行判空。** 

示例：


	// good
	- (void)addDog:(Dog *)dog {
		if (!dog) {
			return;
		}
	    [dogHourse addObject:dog];
	}
	
	// bad
	- (void)addDog:(Dog *)dog {
	    [dogHourse addObject:dog];
	}

<br>

**[强制] 禁止在多线程环境下直接访问可变集合对象中的元素。**

解释：

线程安全问题，多线程下必须加上数据读写保护，推荐 dispatch_sync 配合 dispatch_barrier_async 来保证线程读写安全。

示例:


	// good
	- (id)readObjectAtIndex:(NSUInteger)index {
	    __block id result;
	    dispatch_sync(self.syncQueue, ^{
	        NSUInteger count = self.allItems.count;
	        result = index < count  ?  [self.allItems objectAtIndex:index] : nil;
	    });
	    
	    return result;
	}
	
	- (void)writeObject:(id)anObject
	{
	    if (!anObject)
	        return;
	    dispatch_barrier_async(self.syncQueue, ^{
	        [self.allItems addObject:anObject];
	    });
	}

	
	// bad
	- (void)clearInValidItems {
	    // thread 2
	    NSMutableArray *clearContainer = [NSMutableArray arrayWithCapacity:0];
	    [self.allItems enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
	        [clearContainer addObject:obj];
	    }];
	    [self.allItems removeObjectsInArray:clearContainer];
	}
	- (void)checkAllValidItems {
	    // thread 1
	    // _allItems = [[NSMutableArray alloc] initWithCapacity:0];
	    [self fillItems];
	    [self.allItems enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
	        // do something using obj
	    }];
	}

<br>

**[建议] 不推荐使用可变对象作为入参传递。** 

示例：


	// good
	NSArray *applePicked = [self applePicked];
	[container addObjectsFromArray:applePicked];
	
	// bad
	- (void)pickAppleInContainer:(NSMutableArray *)container;
	

<br>

**[建议] 推荐以 block 的方式遍历集合。**

解释：

此方法由 Apple 官方封装，特点：高效、优雅、易用。

示例：

	// good
	[iosArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
	        if ([obj isEqualToString:@"E"]) {
	            *stop = YES;
	        }
	    }];
	
	// bad
	for (NSInteger idx = 0; idx < iosArray.count; idx ++) {
		// ..
	}
<br>

**[建议] 注意在多线程环境下访问可变集合对象的问题，必要时应该加锁保护。**

解释：不可变集合(比如 NSArray )类默认是线程安全的，而可变集合类(比如 NSMutableArray )不是线程安全的。 
<br>


**[建议] 使用 NSCache 代替 NSMutableDictionary 作为缓存。** 

解释：

NSCache 是线程安全的，并且在系统内存吃紧的时候会做自动释放缓存。

<br>

**[建议] 集合类使用泛型来指定对象的类型。**

示例:


	// good
	@property (nonatomic, copy) NSArray<NSString *> *array;
	@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *dictionary;
	

<br>

#### 2.3.3 Block


**[强制] 注意 block 潜在的循环引用，正确使用 weak。**

解释：

循环引用的产生当且仅当对象之间形成了强引用环，即某两个对象之间的持有关系强连通。

示例：


	// good 如果使用强引用self造成循环引用（self已经强引用xxxblock）
	__weak typeof(self) weakSelf = self;
	self.xxxblock(^{
	    NSString *path = [weakSelf sessionFilePath];
	    if (path) {
	      // ...
	    }
	});
	
	// bad self并没有循环引用
	__weak typeof(self) weakSelf = self;
	dispatch_async(fileIOQueue_, ^{
	    NSString *path = [weakSelf sessionFilePath];
	    if (path) {
	      // ...
	    }
	});

<br>


**[建议] 调用 block 时需要对 block 判空。**

示例：


	// good
	- (void)doBlock:(void (^)(void))block {
	    [self doProcess];
	    if (block) {
	        block();
	    }   
	}
	
	// bad
	- (void)doBlock:(void (^)(void))block {
	    [self doProcess];
	    block();
	}

<br>



#### 2.3.4 IO

**[建议] 避免频繁使用 NSUserDefaults 的 synchronize 方法。**

解释：

[[NSUserDefaults standardUserDefaults] synchronize] 会 block 住当前线程，直到所有的内容都写进磁盘，如果内容过多，重复调用的话会严重影响性能。
<br>

**[建议] 对频繁访问的小数据量数据做内存缓存以避免频繁的 IO 操作。**
<br>


#### 2.3.5 KVO

**[强制] 添加 KVO 后不使用时记得移除监听键值。**

解释：

当一个对象注册成为观察者后，对象地址会被保留一个副本在通知中心，如果对象被释放，但是未移除通知中心保留的对象地址，该对象地址会成为野指针，当有注册的通知消息时会向该野指针发送通知造成崩溃。

示例：


	// good
	@implementation Man
	- (void)dealloc {
	    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"name"];
	}
	- (instancetype)init {
	    self = [super init];
	    if (self) {
	        [[NSNotificationCenter defaultCenter] addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:nil];
	    }
	    return self;
	}
	@end
	
	// bad
	- (instancetype)init {
	    self = [super init];
	    if (self) {
	        [[NSNotificationCenter defaultCenter] addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:nil];
	    }
	    return self;
	}

<br>

**[强制] 避免多次移除同一个已注册的 keyPath 造成异常。**

解释：

当一个存在继承关系的结构中，父类添加了观察某一个 keyPath，在 dealloc 时父类子类同时调用了同一个键值 removeObserver: forKeyPath: ；造成崩溃。

示例：


	// bad
	@interface People : NSObject
	@property (nonatomic, strong) NSString *name;
	@end
	
	@implementation People
	- (void)dealloc
	{ // 调用2次
	    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"name"];
	}
	- (id)init
	{
	    self = [super init];
	    if (self) {
	        [[NSNotificationCenter defaultCenter] addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:nil];
	    }
	    return self;
	}
	@end
	
	@interface Man : People
	@end
	@implementation Man
	- (void)dealloc
	{ // 调用1次
	    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"name"];
	}
	@end



<br>

#### 2.3.6 Notification

**[强制] 添加 NotificationName 后不使用时记得监听键值。**

解释：

当一个对象注册成为观察者后，对象地址会被保留一个副本在通知中心，如果对象被释放，但是未移除通知中心保留的对象地址，该对象地址会成为野指针，当有注册的通知消息时会向该野指针发送通知造成崩溃。
<br>

**[强制] 禁止遇到问题就想到通知，当需要一对多发送消息时使用通知，一对一考虑 Delegate。** 
<br>

**[强制] post 通知时，object 通常是指发出 notification 的对象，如果在发送 notification 的同时要传递一些额外的信息，请使用 userInfo，而不是 object。** 

示例：


	// good
	NSString *name = @"XXX";
	NSDictionary *notifyParamter = @{XXXNotifyParamterKey : name};
	[[NSNotificationCenter defaultCenter] postNotificationName:XXXNotificationName object:nil userInfo:notifyParamter];
	
	// bad
	NSString *name = @"XXX";
	[[NSNotificationCenter defaultCenter] postNotificationName:XXXNotificationName object:name userInfo:nil];

<br>

**[建议] 通知消息触发的方法中使用 weak 重新定义 self。**

解释：

在多线程应用中，Notification 在哪个线程中post，就在哪个线程中被转发；并且通知中心在iOS8及更老的系统有一个bug，selector 执行到一半可能会因为 self  的销毁而引起crash，解决的方案是在 selector 中使用 weak_strong。 

示例:


	// good
	- (void)onMultiThreadNotificationTrigged:(NSNotification *)notify {
	    __weak typeof(self) weakSelf = self; 
	    __strong typeof(self) strongSelf = weakSelf; 
	    if (!strongSelf) { return; }
	    [self doSomething]; 
	}
	

<br>


#### 2.3.7 多线程


**[强制] 禁止在非主线程中进行 UI 元素的操作。** 
<br>

**[强制] 在多线程下多数据/对象访问需要读写保护。** 

解释：

常见的读写保护措施包含但不限于：加锁、原子访问、信号规避、GCD栅栏、Circle Buffer。

示例：


	// good
	- (void)asynReadImageName {
		dispatch_async(dispatch_queue_create(0, 0), ^{
			[self imageName];
		});
	}
	- (void)getIamgeName {
	    NSString *imageName;
	    [lock lock];
	    if (imageNames.count > 0) {
	        imageName = [imageNames lastObject];
	        [imageNames removeObject:imageName];
	    }
	    [lock unlock];
	}
	
	// bad
	- (void)asynReadImageName {
		dispatch_async(dispatch_queue_create(0, 0), ^{
			[self imageName];
		});
	}
	- (void)getIamgeName {
	    NSString *imageName;
	    if (imageNames.count > 0) {
	        imageName = [imageNames lastObject];
	        [imageNames removeObject:imageName];
	    }
	}

<br>


**[强制] 禁止使用 GCD 的 dispatch_get_current_queue() 函数获取当前线程信息。** 

示例：


	// bad
	dispatch_async(dispatch_get_current_queue(), ^{
	    ..
	});

<br>

**[建议] 在异步线程读写文件数据和剪贴板数据。**

解释：

最新Mac和iOS里的剪贴板共享功能会导致有可能需要读取大量的内容，导致读取线程被长时间阻塞。 
<br>

**[建议] 仅当必须保证顺序执行时才使用 dispatch_sync，否则容易出现死锁，应避免使用，可使用 dispatch_async。**

示例:

	// good 主线程调用
	dispatch_block_t block = ^() {
		NSLog(@"%@", [NSThread currentThread]);
	};
	dispatch_async(dispatch_get_main_queue(), block);
	
	// bad 主线程调用
	dispatch_block_t block = ^() {
		NSLog(@"%@", [NSThread currentThread]);
	};
	dispatch_sync(dispatch_get_main_queue(), block);

<br>


#### 2.3.8 运行时


**[强制]   避免对一个类多次执行 Method Swizzling。**
示例：


	// good
	+ (void)initialize {
	    static dispatch_once_t onceToken;
	    dispatch_once(&onceToken, ^{
	        Method originalMethod = class_getInstanceMethod(self, originalSelector);
		    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
		    method_exchangeImplementations(originalMethod, swizzledMethod);
	    });
	}
	
	// load
	+ (void)initialize {
	    Method originalMethod = class_getInstanceMethod(self, originalSelector);
		Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
		method_exchangeImplementations(originalMethod, swizzledMethod);
	}
	
	// bad
	+ (void)initialize {
	    Method originalMethod = class_getInstanceMethod(self, originalSelector);
		Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
		method_exchangeImplementations(originalMethod, swizzledMethod);
	}


<br>

**[强制] 释放运行时产生的内存。**

解释：

运行时相关方法和实现均为 C 语言编写，与ARC内存管理无关，所以某些拷贝内存的相关函数（带copy） 的内存需要手动释放。

示例：


	// good
	objc_property_t *properties = class_copyPropertyList([self class], &outCount);
	for (i = 0; i < outCount; i++) {
	}
	free(properties);
	
	// bad
	objc_property_t *properties = class_copyPropertyList([self class], &outCount);
	for (i = 0; i < outCount; i++) {
	}
	// end   

<br>

**[建议] 谨慎使用运行时方法 Method Swizzling。**

解释：

当在某一个时刻交换了一个类的某一个方法后，原方法所有的实现均会被替换，其他模块或组件也可能会调用到该方法，从而造成逻辑错乱或非预期的异常。
<br>


# 3 风格/约定

------

## 3.1 缩进与格式

#### 3.1.1 缩进

**[强制] 只用空格，用4个空格表示一个缩进。**
<br>

**[强制] 大括号 { 换行后的内容缩进一个层级。**

示例：
	
	// good
	- (void)dealloc {
		_name = nil;
    }
    
	// good
	if (result) {
	    [self doProcess:result];
	}

	// good
	switch (variable) {
        case '1': {
            // do...
            break;
        }
	}
	
	// bad
	if (result) {
	[self doProcess:result];
	}

<br>

#### 3.1.2 空格

原则：

 - 如果 A 的右间距需要一个空格，B 的左间距需要一个空格，AB 之间间距为一个空格。
 
 - 如果 A 的右间距需要一个空格，B 的左间距无空格，AB 之间间距为一个空格。
 
 -  如果 A 的右间距无空格，B 的左间距无空格， AB 之间间距无空格。



**[强制] 行尾不得有多余的空格。**
<br>

**[强制] 类继承中的冒号 : 左右间距各一个空格。**

示例：


	// good
	@interface ViewController : UIViewController
	
	// bad
	@interface ViewController :    UIViewController

<br>

**[强制] 字面量定义时的冒号左边无空格，右边间距一个空格，并且大括号 { } 与内容无空格。**

示例：

	// good
	NSDictionary *dic = @{@"key": @"value"};
	
	// bad
	NSDictionary *dic = @{@"key" : @"value"};

<br>

**[强制] 方法声明中的冒号 : 左右间距无空格。**

示例：

	// good
	- (void)doProcessWithName:(NSString *)name argc:(void *)argc;
	
	// bad
	- (void)doProcessWithName: (NSString *)name argc : (void *)argc;

<br>

**[强制] 协议尖括号 < > 内间距无空格。**

示例：

	// good
	@protocol Protocol <NSObject>

	// bad
	@protocol Protocol < NSObject >

<br>

**[强制] 协议尖括号 < >  作为声明变量类型时无左空格，声明协议或者遵从协议时左外间距一个空格。**

示例：


	// good
	@protocol Protocol <NSObject>
	
	// good
	@interface ViewController : UIViewController <Delegate>
	
	// good
	@property (nonatomic, weak) id<UIAppearance> view;
	
	// bad
	@interface ViewController : UIViewController<Delegate>
	
	// bad
	@property (nonatomic, weak) id <UIAppearance> view;

<br>

**[强制] 括号 （ ） 内间距无空格。**

示例：

	// good
	@property (nonatomic, strong) UIView *view;

	// good
	@interface NSString (Category)

	// good 
	if (result) {
	}

	// bad
	@interface NSString ( Category )

	// bad
	@property ( nonatomic, strong ) UIView *view;

<br>

**[强制] 分类和扩展的声明类名与左括号 ( 间距一个空格。**

示例：


	// good
	@interface NSString (Category)

	// good
	@interface ViewController ()

	// good
	@implementation NSString (BaseCom)

	// bad
	@interface NSString(Category)
	
	// bad
	@interface ViewController()

<br>

**[强制] 属性关键字的括号 ( ) 左右间距一个空格。**

示例：

	// good
	@property (nonatomic, strong) UIView *bgView;

	// bad
	@property(nonatomic, strong)UIView *bgView;

<br>

**[强制] 作为指针的星号 * 左间距一个空格，右间距无空格。**

示例：

	// good
	@property (nonatomic, strong) UIView *window;

	// bad
	@property (nonatomic, strong) UIView* window;

<br>

**[强制] 方法声明和实现的 - 或者 + 右间距一个空格。**

示例：

	// good
	- (void)viewDidLoad;
	
	// bad
	-(void)viewDidLoad;

<br>

**[强制] 二元运算符两侧必须有一个空格，一元运算符与操作对象之间不允许有空格。**

示例：

	// good
	NSInteger x = ^(m + n >> 2 * y);
	x++;
	
	// bad
	NSInteger x =m+n;
	
	// bad
	x ++;

<br>

**[强制] 除了复合语句的大括号，其他用作代码块起始的左大括号 { 左间距一个空格。**

示例：

	// 赋值复合语句，不用空格
	self.bgView = ({
	    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	    view;
	});
	{ // 复合语句，不用空格
		view.backgroundColor = [UIColor redColor];	    
	}
	
	// good 以下 { 左间距均需要空格
	- (void)viewDidLoad {
		if (condition) {
		}
	    	
		while (condition) {
		}
	}

	// bad
	- (void)viewDidLoad 
	{
		if (condition){
		}
	    	
		while (condition) {
		}
	}

<br>

**[强制]  if / else / for / while / switch / do / try / catch / finally 关键字后间距一个空格。**

示例：

	// good
	if (condition) {
	}
	
	while (condition) {
	}
	
	// bad
	if(condition) {
	}
	else if(condition) {
	}
	
	// bad
	for(;;) {
	}

<br>

**[强制] 逗号 , 左间距无空格，右间距一个空格。**

示例：


	// good
	CGRectMake(0, 0, 100, 100)
	
	// bad
	CGRectMake(0,0,100,100)

<br>

**[强制] 分号 ; 左间距无空格，当不作为结束符时右间距一个空格。**

示例：


	// good
	for (NSInteger idx = 0; idx < 10; idx++) {   
	}
	
	// bad
	for (NSInteger idx = 0;idx < 10;idx++) {   
	}

<br>

**[强制] 方法组合调用时右中括号 ] 与方法名间距一个空格。**

示例：


	// good
	[[self view] animateWithDuration:1 animations:nil];
	
	// bad
	[[self view]animateWithDuration:1 animations:nil];

<br>

#### 3.1.3 换行


**[强制] 每个独立语句结束后必须换行。**
<br>

**[强制] 每行不得超过 120 个字符。**

解释：

超长的不可分割的代码允许例外，比如复杂的正则表达式。
<br>

**[强制] 方法实现时左大括号 { 不用换新行，与方法体同行。**

示例：

	// good
	- (void)doMethod1 {
	}
	
	// bad
	- (void)doMethod1
	{
	}

<br>

**[强制] 运算符处换行时，运算符必须在新行的行首。**

示例：

	// good
	var result = number1 + number2 + number3
	    + number4 + number5;
	// good
	UIViewAutoresizing autoreszing = UIViewAutoresizing 
	    | UIViewAutoresizingFlexibleRightMargin
	    | UIViewAutoresizingFlexibleHeight;
	
	// bad
	var result = number1 + number2 + number3 +
	    number4 + number5;

<br>

**[强制] 字面量换行时 ，逗号 , 或者冒号 :  不许出现在行首；如果存在换行，最后的囊括符必须单独提行。**

示例：

	// good
	NSArray *arr = @[@"1",
	                 @"2",
	                 @"3"
	                 ];
	// good
	NSDictionary *keyValue = @{@"key1": @"value1",
	                           @"key2": @"value2"
	                           };
	// bad
	NSArray *arr = @[@"1",
	                 @"2",
	                 @"3"];
	// bad
	NSDictionary *keyValue = @{@"key1" : @"value1"
							,@"key2" : @"value2"
							};

<br>

**[建议] 不同行为或逻辑的语句集，使用一个空行隔开。**

示例：

	// good
	NSInteger findIndex = 0;
	for (NSString *value in container) {
	    if ([value integerValue] == findIndex) {
	        break;
	    }
	}
	
	[self doProcessWithIndex:findIndex];

<br>

**[建议] 两个方法的实现体之间间隔两个空行。**

示例：

	// good
	- (void)doMethod1 {
	}
	
	
	- (void)doMethod2 {
	}

<br>

#### 3.1.4 对齐

**[建议] 连续行尾的注释以 // 对齐，左间距最长的行尾 2 个缩进。**

解释： 不推荐这种注释方式，如果使用这种注释方式，以 // 对齐。

示例：

	// good
	NSString *const mConstString = @"im a const string";                // first
	NSString *const XXXNotificationName = @"kXXXNotificationName";      // notifyname
	
	// bad
	NSString *const mConstString = @"im a const string"; // first
	NSString *const XXXNotificationName = @"kXXXNotificationName";    // notifyname

<br>

**[建议] 枚举值的赋值等号 = 对齐，左间距最长的行尾 2 个缩进。**

示例：

	// good
	typedef NS_ENUM(NSInteger, XXXEnum) {
	    XXXEnumDefault              = 0,        // 默认 value
	    XXXEnumNumber               = 1,        // 数字
	    XXXEnumStringOrArray        = 2         // 字符串或数组
	};
	
	// bad
	typedef NS_ENUM(NSInteger, XXXEnum) {
	    XXXEnumDefault = 0,        // 默认 value
	    XXXEnumNumber = 1,        // 数字
	    XXXEnumStringOrArray = 2         // 字符串或数组
	};

<br>

**[建议] 宏定义出现换行时以 \ 对齐，左间距最长的行尾 2 个缩进。**

示例：

	// good
	#define XXXMACRO        \
	@"kXXXMACROLINE1"       \
	"kXXXMACROLINE2"       

	// bad
	#define XXXMACRO\
	@"kXXXMACROLINE1"\
	"kXXXMACROLINE2" 

<br>

**[强制] 字面量定义存在换行时以第一个变量值对齐。**

示例：

	// good
	NSDictionary *keyValue = @{@"key1": @"value1",
	                           @"key11": @"value11"
	                           };
	
	// bad 以冒号对齐
	NSDictionary *keyValue = @{@"key1": @"value1",
	                          @"key11": @"value11"
	                           };

<br>

**[建议] 方法声明采用多行时每个参数按照冒号 : 进行对齐。**

解释：

例外，如果因为第一个参数太短导致换行后无法按照第一个参数的冒号 : 进行对齐。

示例：

	// good
	- (void)doSomething:(XXXFoo *)theFoo
	                   rect:(NSRect)theRect
	               interval:(CGFloat)theInterval {
	    // ...
	}
	
	// bad 
	- (void)doSomething:(XXXFoo *)theFoo rect:(NSRect)theRect
	               interval:(CGFloat)theInterval {
	    // ...
	}

<br>



#### 3.1.5 左大括号位置

**[建议] 左大括号 { 不单独占据一行，放置在上一行的末尾，在 { 前增加一个空格。**

解释：

复合语句除外。
<br>

#### 3.1.6 声明与定义

**[强制] 常量的定义使用 “ 类型 + 指针 + const + 变量名 ”。**

示例：

	// good
	NSString *const constString = @"im a const string";
	
	// bad
	const NSString *constString = @"im a const string";

<br>

**[强制] 对内私有变量（包括宏定义、常量）和方法的声明放到源文件中，非头文件中。**
<br>

**[建议] 方法声明要么所有参数一行，要么每个参数一行。**
<br>


#### 3.1.7 方法调用


**[强制] 方法调用时方法名左边与中括号 ] 间距一个空格。** 


	// good
	NSObject *foo = [[NSObject alloc] init];
	
	// bad
	NSObject *foo = [[NSObject alloc]init];


<br>

**[建议] 方法调用的格式须要与定义时的格式一致。**

解释：

当有多种格式化的样式可供选择的时候，按照惯例，采用在给定的源文件中使用过的那个方式。 

示例:

	// good
	[myObject doFooWith:arg1 name:arg2 error:arg3];
	[myObject doFooWith:arg1 
	               name:arg2
	              error:arg3];
	
	// bad
	[myObject doFooWith:arg1 name:arg2 // 这行写了两个参数
	              error:arg3];
	[myObject doFooWith:arg1
	               name:arg2 error:arg3];

<br>

#### 3.1.8 访问修饰符

**[强制] 访问修饰符 @public， @private，@protected，@package保留一个缩进。**
 
 示例：

	// good
	@interface AppDelegate : UIResponder <UIApplicationDelegate> {
	    @package
	    UIWindow *window_;
	    
	    @private
	    UIView *rootView_;
	}
	
	// bad
	@interface AppDelegate : UIResponder <UIApplicationDelegate> {
	@package
	    UIWindow *window_;
	    
	  @private
	    UIView *rootView_;
	}

<br>

#### 3.1.9 表达式

**[强制] 禁止多个条件子句的三元运算对一个变量赋值。**  

示例：


	// good
	NSInteger m = a > b ? x : y;
	
	// bad
	NSInteger m = a > b ? x = c > d ? c : d : y;

<br>

**[建议] 使用精简三元运算。** 

解释：

当三元运算符的第二个参数（if 分支）返回和条件语句中被检查的对象一样时使用精简三元符。

示例：


	// good
	if (object ? : [self createObject]) {
	}
	
	// bad
	if (object ? object : [self createObject]) {
	}

<br>

**[建议] 特殊运算符计算赋值以括号 ( ) 明确划分运算符优先级。** 

示例：


	// good
	if (width >> (height * pixel + originHeight)) {
	}
	
	// bad
	if (width >> height * pixel + originHeight) {
	}


<br>

#### 3.1.10 if 语句

**[强制] if  条件判断语句后面必须要加大括号 { }。**

示例:


	// good
	if (!error) {
	    return success;
	}
	
	// bad
	if (!error) 
	    return success;
	    
	// bad
	if (!error)  return success;

<br>

**[强制] else 或者 else if 不换行与右大括号 } 间隔一个空格。**  

解释：

Xcode 推荐并默认填充方式。

示例：

	// good
	NSInteger numberOfLines = 3;
	if (numberOfLines == 0) {
	} else if (numberOfLines == 1) {
	} else {
	}
	
	// bad
	if (numberOfLines == 0) {
	}
	else if (numberOfLines == 1) {
	}
	else {
	}

<br>

#### 3.1.11 switch语句

**[强制] 在 switch 语句中，每一个 case 分支必须使用 break 结尾，最后一个分支必须是 default 分支。**

解释：

避免漏掉 break 语句造成程序错误，同时保持程序简洁。对于多个分支相同处理的情况可以共用一个 break，但是要用注释加以说明。

示例：


	// good
	UIStatusBarStyle barStyle;
	switch (barStyle) {
	    case UIStatusBarStyleDefault: {
	        break;
	    }
	    case UIStatusBarStyleLightContent: {
	        break;
	    }
	    default:
	        break;
	}
	
	// bad
	UIStatusBarStyle barStyle;
	switch (barStyle) {
	    case UIStatusBarStyleDefault: {
	        break;
	    }
	    case UIStatusBarStyleLightContent: {
	        break;
	    }
	}

<br>

**[建议] 给每一个 case 加上大括号 { } 。**

示例：


	// good
	UIStatusBarStyle barStyle;
	switch (barStyle) {
	    case UIStatusBarStyleDefault: {
		    [self updateUI];
	        [self process];
	        break;
	    }
	    case UIStatusBarStyleLightContent: {
	        break;
	    }
	    default:
	        break;
	}


#### 3.1.12 for 语句


**[建议] 建议 for 语句的循环控制变量的取值采用“半开半闭”写法。** 

示例：


	// good 半开半闭
	for (NSInteger idx = 0; idx < apples.count; idx ++) {
	    // ..
	}
	
	// bad 闭区间
	for (NSInteger idx = 0; idx <= apples.count - 1; idx ++) {
	    // ..
	}

<br>

#### 3.1.13 while、do while语句

**[建议] while 语句或 do while 语句使用尽量少的判断条件（只是用一个条件）。** 

解释：

判断条件太多，容易导致逻辑错误，并且是代码可读性和维护性大大下降。

示例：

	// good
	BOOL feedResult;
	NSInteger feedCount = 0;
	while (feedCount < maxFeedCount) {
		// ..
	}
	
	// bad
	BOOL feedResult;
	NSInteger feedCount = 0;
	while (feedResult && feedCount < maxFeedCount) {
	    // ..
	}

<br>

## 3.2 命名规范

#### 3.2.1 通用命名

一般情况下，通用命名规则适用于变量、常量、属性、参数、方法、函数等。

**[强制] 自我描述性。**

解释：

属性/函数/参数/变量/常量/宏 的命名必须具有自我描述性。杜绝中文拼音、过度缩写、或者无意义的命名方式。 
<br>

**[强制] 禁止自我指涉。**

解释：

属性/局部变量/成员变量不要自我指涉。通知和掩码常量（通常指那些可以进行按位运算的枚举值）除外。

示例:


	// good
	NSUserDomainMask
	UIApplicationDidEnterBackgroundNotification
	
	// bad
	NSStringObject

<br>

**[强制] 一致性。**

解释：

属性/函数/参数/变量/常量/宏 的命名应该具有上下文或者全局的一致性，相同类型或者具有相同作用的变量的命名方式应该相同或者类似。

示例:

	
	// count同时定义在NSDictionary、NSArray、NSSet这三个集合类中。且这三个集合类中的count属性都代表同一个意思，即集合中对象的个数。
	@property (readonly) NSUInteger count;
	

<br>

**[强制] 清晰性。**

解释：

属性/函数/参数/变量/常量/宏 的命名应该保持清晰+简洁。

示例:


	// good
	insertObject:atIndex: 
	removeObjectAtIndex:
	
	// bad 不清晰，插入什么？at代表什么？
	insert:at: 
	
	// bad 不清晰，移除什么？
	remove: 


<br>

**[强制] 参数名、成员变量、局部变量、属性名都要采用小写字母开头的驼峰命名方式。**

解释：

如果方法名以一个众所周知的大写缩略词开始，可以不适用驼峰命名方式。比如HTTP、URL等。
<br>

**[建议] 一般情况下，不要缩写或省略单词，建议拼写出来，即使它有点长。**

解释：

当然，在保证可读性的同时，for 循环中遍历出来的对象或者某些方法的参数可以缩写。

示例:


	// good
	destinationSelection
	setBackgroundColor: 
	
	// bad  不清晰
	destSel
	setBkgdColor:
	

<br>


#### 3.2.2 缩写命名

通常，我们都不应该缩写命名，然而，下面所列举的都是一些众所周知的缩写，我们可以继续使用这些古老的缩写。

**[建议] 允许使用众所周知的缩写命名。**

解释：

那些在 C 语言时代就已经在使用的缩写、计算机行业通用的缩写，比如 alloc 和 getc 。包括但不限于HTML、URL、RTF、HTTP、TIFF、JPG、PNG、GIF、LZW、ROM、RGB、CMYK、MIDI、FTP。

示例：

	// good
	- (void)showBtn:(UIButton *)btn;
	
	// bad
	- (void)showCol:(UICollectionView *)colView;

<br>

**[建议] 我们可以在命名参数的时候使用缩写。**

示例：

	// good
	- (void)runJavascript:(NSString *)js;
	
	// good
	- (void)printOwnObject:(id)obj;

<br>

#### 3.2.3 文件命名


**[强制] 实现 Category 的文件名需包含类名，且以加号 + 连接分类名。**

示例：


	// good
	NSString+Utils.h
	NSTextView+Autocomplete.h
	
	// bad
	StringUtils.h
	// bad
	NSSStringCategory.h


<br>

**[建议] 源码文件名为内部关联类的名称，扩展名根据文件类型决定。**

解释：

常见文件后缀对应的文件名如下：

| 后缀 | 文件类型 | 
|---|---|
| .h | C/C++/Objective-C header file | 
| .m | Objective-C implementation file | 
| .mm | Objective-C++ implementation file | 
| .cc | Pure C++ implementation file | 
| .cpp | Pure C++ implementation file | 
| .c |  C implementation file | 

<br>

#### 3.2.4 类命名

**[强制] class 的名称应该由两部分组成，前缀+名称。**

解释：

即，class的名称应该包含一个前缀和一个名称。
<br>

**[强制] 类名的前缀不能使用 Apple 已经使用的前缀。** 

解释：

苹果保留对任意两个字符作为前缀的使用权。所以尽量不要使用两个字符作为前缀。禁止使用的前缀包括但不限于：NS,UI,CG,CF,CA,WK,MK,CI,NC。 


	// good
	@interface XXXStyle : NSObject
	@end
	
	// bad
	@interface NSStyle : NSObject
	@end
	
	// bad
	@interface xxStyle : NSObject
	@end


<br>

#### 3.2.5 属性命名

**[强制] 描述性地命名，避免缩写，采用小驼峰命名。** 

示例：


	// good
	@property (nonatomic, assign) CGFloat barHeight;
	@property (nonatomic, strong) NSString *name;
	
	// bad
	@property (nonatomic, assign) CGFloat bar_height;
	// bad
	@property (nonatomic, assign) CGFloat height1;
	// bad 指针位置违反"空格"约定
	@property (nonatomic, strong) NSString* name;

<br>

#### 3.2.6 局部变量命名

**[建议] 采用小驼峰命名法。**


	// good
	CGFloat barHeight = 10.f;
	NSMutableArray *container = [NSMutableArray arrayWithCapacity:0];
	
	// bad
	CGFloat BarHeight = 10.f;
	// bad
	NSMutableArray *_container = [NSMutableArray arrayWithCapacity:0];
	

<br>


#### 3.2.7 常量命名

**[建议] 常量应该以大驼峰法命名，并以相关类名作为前缀。**

解释：

推荐使用常量来代替字符串字面值和数字，这样能够方便复用，而且可以快速修改而不需要查找和替换。内部使用的常量应该用 static 声明为静态常量，外部可以访问的常量在头文件内使用extern声明。

示例:


	// good
	static NSString *const XXXCacheControllerDidClearCacheNotification = @"kXXXCacheControllerDidClearCacheNotification";
	static const CGFloat ZOCImageThumbnailHeight = 50.0f;
	
	// bad
	#define CompanyName @"Apple Inc."
	#define magicNumber 42

<br>

#### 3.2.8 enum命名

**[建议] 枚举常量和 typedef 定义的枚举类型的命名规范同类名的命名规范一致。**

示例:


	// good
	typedef NS_ENUM(NSInteger, UIInterfaceOrientation) {
	    UIInterfaceOrientationUnknown            = 0,
	    UIInterfaceOrientationPortrait           = 1
	};
	
	// bad
	typedef NS_ENUM(NSInteger, UIInterfaceOrientation) {
		InterfaceOrientationUnknown            = 0,
	    InterfaceOrientationPortrait           = 1
	};
	// bad
	typedef enum _XXXStatusbarStyle {
	    kXXXStatusbarStyleDefault    = 0,
	    kXXXStatusbarStyleWhite      = 1
	} StatusbarStyle;

<br>

#### 3.2.9 方法命名

**[强制] 方法名也要采用小写字母开头的驼峰命名方式。**

解释：

如果方法名以一个中所周知的大写缩略词开头（比如HTTP），该规则可以忽略。 

示例：

	// good
	- (void)doRequest;
	
	// bad
	- (void)DoRequest;
	
	// bad
	- (void)_doRequest;

<br>


**[强制] 杜绝中文拼音、过度缩写、或者无意义的命名方式。** 

示例：

	
	// good
	- (void)recivedNotification:(NSNotification *)notification;
	
	// bad
	- (void)recNotify:(NSNotification *)not;

<br>

**[强制] 所有参数前面都应该添加关键字，除非你能保证每个人都能意会到你的精神。**

示例:


	// good
	- (void)sendAction:(SEL)aSelector toObject:(id)anObject forAllCells:(BOOL)flag;
	
	// bad
	- (void)sendAction:(SEL)aSelector :(id)anObject :(BOOL)flag;

<br>

**[建议] 参数之前的单词尽量能描述参数的意义。**

示例:


	// good
	- (id)viewWithTag:(NSInteger)aTag;
	
	// bad
	- (id)taggedView:(int)aTag;
	
<br>


**[建议] 不推荐在非分类的方法声明中使用前缀。** 

解释：

方法命名前缀属于分类的命名空间。

示例：


	// good
	@interface XXXHome : NSObject
	- (void)goHome;
	@end
	
	// bad
	@interface XXXHome : NSObject
	- (void)xxx_goHome;
	@end

<br>

**[建议] 不推荐在方法名称前加下划线“ _ ”。**

解释：

Apple官网团队经常在方法前面加下划线”_”，为了避免方法覆盖，导致不可预知的意外，不推荐在方法前面加下划线。 

示例：

	
	// bad
	- (void)_doRequest;

<br>


#### 3.2.10 私有方法命名

大部分情况下，私有方法的命名和公有方法的命名规则是一样的。然而，通常情况下应该给私有方法添加一个前缀，目的是和公有方法区分开。尽管这样，这种给私有方法加前缀的命名方式有可能引起一些奇怪的问题。问题就是：当你从Cocoa framework（即Cocoa系统库）中的某个类派生出来一个子类时，你并不知道你的子类中定义的私有方法是否覆盖了父类的私有方法，即有可能你自己在子类中实现的私有方法和父类中的某个私有方法同名。在运行时，这极有可能导致一些莫名其妙的问题，并且调试追踪问题的难度也是相当大。 


**[建议] 使用”private_”做为私有方法的开头。**
<br>

#### 3.2.11 宏命名

**[强制] 宏由大写字母和下划线 "_" 组成。** 
<br>

**[强制] 通用常量宏以约定前缀开头，单词之间以下划线“_”连接。** 

示例：


	// good
	#define XXX_NAVIGATIONBAR_HEIGHT   64.f
	
	// bad
	#define XXXNavigationbarHeight	 64.f

<br>

**[强制] 操作宏以约定前缀开头，以下划线 “_” 连接前缀和大驼峰名词。** 


	// good
	#define XXX_MAX(A,B)                      __NSMAX_IMPL__(A, B, __COUNTER__)
	#define XXX_VIEW	                      UIView
	
	// bad
	#define Max(A,B)                      __NSMAX_IMPL__(A, B, __COUNTER__)
	
	// bad
	#define XXXView	                      UIView
	

<br>


**[建议] 不建议使用私有常量宏，使用静态常量代替。** 

示例：


	// good (该常量仅仅作为当前文件私有)
	NSString *const XXXVersion = @"3.2.1";
	
	// bad
	#define XXX_VERSION @"3.2.1"
	

<br>

#### 3.2.12 Category命名


**[强制] 分类名以前缀开头，并下划线 “_” 连接前缀和大驼峰名词。**
<br>

**[强制] 分类属性以前缀开头，并下划线 “_” 连接前缀和小驼峰名词。***

解释：

property 的本质是 ivar(实例变量) + getter + setter，但分类中不允许声明 ivar，需要重写 getter 和 setter 方法，使用 runtime 绑定 ivar


**[强制] 分类方法以前缀开头，并下划线 “_” 连接前缀和小驼峰名词。***

解释：

避免 category 中的方法覆盖其他模块或系统方法。

示例：


	@interface NSString (XXX_BaseCom)
	
	//good
	@property (nonatomic, assign) NSInteger xxx_contentWidth;
	
	// good
	- (NSString *)xxx_substringFromIndex:(NSUInteger)from;
	
	// bad
	- (NSString *)substringFromIndex:(NSUInteger)from;
	
	// bad
	- (NSString *)_substringFromIndex:(NSUInteger)from;
	
	@end

<br>


#### 3.2.13 Protocol命名

**[建议]  定义接口的 Protocol 以前缀开头连接大驼峰名称，以 Protocol 结尾命名。**

示例:

	// good
	XXXPyramidProtocol
	
	// bad 看起来像是一个类名
	NSLock

<br>

**[建议] 定义代理的 Protocol 以前缀开头连接大驼峰名称，以 Delegate 结尾命名。**

示例：

	// good
	@protocol UITableViewDelegate <NSObject, UIScrollViewDelegate>

<br>

**[建议] 定义数据源的 Protocol 以前缀开头连接大驼峰名称，以 DataSource 结尾命名。**

示例：

	// good
	@protocol UITableViewDataSource <NSObject>

<br>

#### 3.2.14 Delegate 方法命名

**[建议] 以触发消息的对象名开头，省略类名前缀并且首字母小写。**

示例:


	// good
	- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
	
<br>


**[建议] 除非 delegate 方法只有一个参数，即触发 delegate 方法调用的 delegating 对象，否则冒号是紧跟在类名后面的。**

示例:

	// good
	- (void)applicationDidBecomeActive:(UIApplication *)application;

<br>

#### 3.2.15 Accessor命名

Accessor Methods是指 set、get 方法。这些方法有一些推荐写法格式：

**[建议] 名词命名法。**

示例：

	// good
	- (NSString *)title;
	- (void)setTitle:(NSString *)aTitle;

<br>

**[建议] 形容词命名法。**

示例:


	// good
	@property (nonatomic, readonly, getter=isEditable) Bool editable;
	- (BOOL)isEditable;
	- (void)setEditable:(BOOL)flag;
	
<br>


**[建议] 普通动词命名法。**

示例:


	// good
	- (BOOL)showsAlpha;
	- (void)setShowsAlpha:(BOOL)flag;
	- (void)setAcceptsGlyphInfo:(BOOL)flag;
	- (BOOL)acceptsGlyphInfo;
	
	// bad
	- (void)setGlyphInfoAccepted:(BOOL)flag;
	- (BOOL)glyphInfoAccepted;

<br>

**[建议] 情态动词（can、should、will等）法。**

解释：

明确方法意义，但不要使用do、does这类无意义的情态动词。

示例:


	// good
	- (void)setCanHide:(BOOL)flag;
	- (BOOL)canHide;
	- (void)setShouldCloseDocument:(BOOL)flag;
	- (BOOL)shouldCloseDocument;
	
	// bad
	- (void)setDoesHide:(BOOL)flag;
	- (BOOL)doesHide;
	

<br>

**[建议] 只有方法间接的返回一个数值，或者需要多个数值需要被返回的时候，才有必要在方法名称中使用“get”。**

示例:


	// good
	 - (void)getLineDash:(float *)pattern count:(int *)count phase:(float *)phase;

<br>

#### 3.2.16 Notification命名	


**[强制] notification 的命名使用全局的 NSString 字符串进行标识。**命名方式如下： 

$$ [Name of associated class] + [Did | Will] + [UniquePartOfName] + Notification $$


示例:

	// good
	XXXApplicationDidEnterBackgroundNotification
	XXXApplicationWillEnterForegroundNotification
	
	// bad
	applicationDidEnterBackgroundNotification
	
	// bad
	DidEnterBackgroundNotification
	

<br>

## 3.3 注释规范

#### 3.3.1 注释通则

**[强制] 头文件的每个类、方法、属性、函数，必须详细注释。**  
<br>

**[建议] .m 文件内的成员变量、常量、复杂代码逻辑进行单行注释，私有方法进行单行或者多行注释。**  
<br>

**[建议] 对独立模块或组件提供注释文件来描述整个模块或组件的具体功能和简要的使用说明。**

解释：

建议使用 markdown。

<br>

**[建议] 注释无用的代码块使用批量注释。**

示例：

	// good
	//@interface ViewController ()
	//@property (nonatomic, weak) id<UIAppearance> view;
	//@property (nonatomic, strong) UIView *bgView;
	//@property (nonatomic, strong) UIButton *startBtn;
	//@end
	//- (void)viewDidLoad {
	//    [super viewDidLoad];
	//}

<br>

#### 3.3.2 单行注释

**[强制] 以双斜杠 //  开头加空格后面接所要加的说明的内容。**

示例：

	
	// good
	// 这是单行注释
	NSObject *foo = [[NSObject alloc] init];
	
	// bad
	/** 这也是单行注释 */
	
	// bad
	/*! 同样是单行注释 */

<br>

#### 3.3.3 多行注释

**[强制] 以“/*”为第一行开头，以“*/”为最后一行结尾，除了描述内容是不可分割的字符串且触发自动换行以外，中间每行以星号 * 开头且与内容描述以一个空格隔开，并且每行的第一个星号 * 缩进对齐，中间单行或多行属于注释描述内容。**  

解释：

描述内容是不可分割的字符串：比如 URL。

示例：

	// good
	/**
	 * <#Description#>
	 */
	@interface AppDelegate : UIResponder <UIApplicationDelegate>

	// good
	/**
	 * urlscheme://novel?action=openSubPage&param=%7B%22pagetype%22%3A1%2C%22title%22%3A%22%E4%B9%A6%E7%B1%8D%E8%AF%A6%E6%83%85%22%2C%22method%22%3A%22post%22%2C%22url%22%3A%22https%3A%5C%2F%5C%2Fboxnovel.baidu.com%5C%2Fboxnovel%5C%2Fdetail%3Faction%3Dnovel%26type%3Ddetail%22%2C%22args%22%3A%22data%3D%7B%5C%22gid%5C%22%3A%5C%224315647238%5C%22%2C%5C%22fromaction%5C%22%3A%5C%22reader%5C%22%7D%22%2C%22needParams%22%3A%221%22%7D&minver=5.4
	 */
	@interface AppDelegate : UIResponder <UIApplicationDelegate>

	// bad
	/** 
	  第二行会接上第一行。
	*/
	@interface AppDelegate : UIResponder <UIApplicationDelegate>

	// bad
	/** 
	 *  第一行注释，
	 第二行注释
	 */
	@interface AppDelegate : UIResponder <UIApplicationDelegate>
<br>


#### 3.3.4 类注释

**[强制] 使用多行注释。**  

示例：

	
	/**
	 * <#Description#>
	 */
	@interface AppDelegate : UIResponder <UIApplicationDelegate>

<br>

#### 3.3.5 方法注释

**[强制] 方法的注释以“/*”为第一行开头，以“*/”为最后一行结尾，中间每行以星号 * 与第一行星号 * 对齐排列，与描述间隔一个空格。**  

解释：

中间单行或多行描述方法的简介 @brief 和各个参数说明 @param（没有参数则省略）及返回值 @return（返回值为 void 则省略）。 

示例：

	// good
	/**
	 * @brief <#Description#>
	 * ...
	 * @param application <#application description#>
	 * @param launchOptions <#launchOptions description#>
	 * @return <#return value description#>
	 */
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	}

	// good 无返回值和参数
	/**
	 * @brief <#Description#>
	 */
	- (void)doGitProcess;

	// bad
	/**
	 * @brief <#Description#>
	 * @return
	 */
	- (void)doGitProcess;
<br>

#### 3.3.6 属性注释

**[建议]  以三斜杠 /// 开头加空格后面接所要加的说明内容。**

示例：


	/// <#Description#>
	@property (strong, nonatomic) UIWindow *window;

<br>

#### 3.3.7 常量注释

**[强制]  使用多行注释。**

解释：

Apple 推荐使用。

示例：

	
	/**
	 * 详细描述这个常量的标记意义以及使用方法
	 */
	 NSString *const XXXCapturedImageKey = @"kXXXCapturedImageKey";

<br>

#### 3.3.8 文件注释


**[建议] 由系统自动生成的每个文件顶部的注释必须保证信息的完整、正确。**

解释：

必须包含：

- 文件名称；
- 工程名称/组件名称；
- 创建人（必须是邮箱名称或者真实姓名）；
- 创建日期；
- 权利说明。

示例：
	
	//
	//  AppDelegate.m
	//  XXX_App
	//
	//  Created by ***(MBD) on 2018/4/6.
	//  Copyright © 2018年 ***(MBD). All rights reserved.

<br>

**[建议] 使用 #pragma mark - 对文件进行分段注释。**

示例：

	// good
	#pragma mark - Init
	
	#pragma mark - Private
	
	#pragma mark - Public
	
	#pragma mark - TableViewDelegate

<br>

#4 最佳实践

## 4.1 initialize方法和load方法区别

**[建议] 如果我们想要让 initialize 方法仅仅被调用一次，那么需要借助于 GCD 的 dispatch_once()。**

示例:

	// good
	+ (void)initialize {
	    static dispatch_once_t onceToken;
	    dispatch_once(&onceToken, ^{
	        // ..初始化
	    });
	}
	
<br>


**[建议] 如果我们想在继承体系的某个指定的类的 initialize 方法中执行一些初始化代码，可以使用类型检查和而非dispatch_once()。**

示例:


	// good
	+ (void)initialize {
	    if (self == [NSFoo class]) {
	    // the initializing code
	    }
	}

<br>

**[建议] 如无必要不推荐使用 load 方法。**
<br>


## 4.2 init 规范


**[强制] 禁止在 init（dealloc 一样）方法里面使用 accessor 方法。**

示例:

	// good
	- (instancetype)initWithURL:(NSString *)url {
	    self = [super init];
	    if (self) {
	        _url = [url copy];
	    }
	    return self;
	}
	
	// bad
	- (instancetype)initWithURL:(NSString *)url {
	        self = [super init];
	        if (self) {
	             self.url = url;
	        }
	        return self;
	}

<br>


**[强制] 局部变量不会被编译器初始化，所有局部变量使用前必须初始化。** 

示例：


	// good
	- (void)doProcess {
	    NSString *name = nil;
	    if (name.length == 0) {
	    }
	}
	
	
	// bad
	- (void)doProcess {
	    NSString *name;
	    if (name.length == 0) {
	    }
	}
	
<br>

**[强制] 所有 secondary 初始化方法都应该调用 designated 初始化方法。** 

示例：


	// good
	- (instancetype)initWithName:(NSString *)name subName:(NSString *)subName {
	    self = [super init];
	    if (self) {
	        _name = [name copy];
	        _subName = [subName copy];
	    }
	    return self;
	}
	- (instancetype)initWithName:(NSString *)name {
	    return [self initWithName:name subName:nil];
	}
	
	// bad
	- (instancetype)initWithName:(NSString *)name subName:(NSString *)subName {
	    self = [super init];
	    if (self) {
	        _name = [name copy];
	        _subName = [subName copy];
	    }
	    return self;
	}
	- (instancetype)initWithName:(NSString *)name {
	    self = [super init];
	    if (self) {
	        _name = [name copy];
	    }
	    return self;
	}

<br>

**[强制] 所有子类的 designated 初始化方法都要调用父类的 designated 初始化方法。**

解释：

使这种调用关系沿着类的继承体系形成一条链。 

示例：


	// 父类 designated 初始化方法
	- (instancetype)initWithName:(NSString *)name;
	
	// good 子类
	- (instancetype)initWithName:(NSString *)name subName:(NSString *)subName {
	    self = [super initWithName:name];
	    if (self) {
	        _subName = [subName copy];
	    }
	    return self;
	}
	
	// bad 子类
	- (instancetype)initWithName:(NSString *)name subName:(NSString *)subName {
	    self = [super init];
	    if (self) {
	        _name = [name copy];
	        _subName = [subName copy];
	    }
	    return self;
	}

<br>

**[强制] 禁止子类的 designated 初始化方法调用父类的 secondary 初始化方法。**

解释：

子类的 designated 初始化方法调用父类的 secondary 初始化方法容易陷入方法调用死循环。

示例:

	// good
	// 超类
	@interface ParentObject : NSObject
	@end
	@implementation ParentObject
	// designated initializer
	- (instancetype)initWithURL:(NSString*)url title:(NSString*)title {
	    if (self = [super init]) {
	        _url = [url copy];
	        _title = [title copy];
	    }
	    return self;
	}
	// secondary initializer
	- (instancetype)initWithURL:(NSString*)url {
	    return [self initWithURL:url title:nil];
	}
	@end
	// 子类
	@interface ChildObject : ParentObject
	@end
	@implementation ChildObject
	// designated initializer
	- (instancetype)initWithURL:(NSString*)url title:(NSString*)title {
	    // bad 在designated intializer中调用 secondary initializer
	    if (self = [super initWithURL:url]) {
	    }
	    return self;
	}
	@end
	
	@implementation ViewController
	- (void)viewDidLoad {
	    [super viewDidLoad];
	    // bad 这里会死循环
	    ChildObject* child = [[ChildObject alloc] initWithURL:@"url" title:@"title"];
	}
	@end

<br>


**[建议] 不推荐在 init 方法中，将成员变量初始化为 0 或 nil 。** 

示例：

	// good
	- (instancetype)init {
	    self = [super init];
	    if (self) {
	    }
	    return self;
	}
	
	// bad
	- (instancetype)init {
	    self = [super init];
	    if (self) {
	        self.name = nil;
	    }
	    return self;
	}
	
<br>



## 4.3 dealloc 规范

**[强制] 不要忘记在 dealloc 方法中移除通知和 KVO 。** 
<br>

**[强制] 和 init 方法一样，禁止在 dealloc 方法中使用 self.xxx 的方式访问属性。**

解释：

如果存在继承的情况下，很有可能导致崩溃。 

示例：


	// good
	- (void)dealloc {
	    [[SingleTon sharedInstance] removeTagWithName:[_name copy]];
	}
	
	// bad
	- (void)dealloc {
	    [[SingleTon sharedInstance] removeTagWithName:self.name];
	}

<br>

**[建议] 在 dealloc 方法中，禁止将 self 作为参数传递出去。** 

解释：

如果 self 被 retain 住，到下个 runloop 周期再释放，则会造成多次释放 crash。

示例：


	// bad
	- (void)dealloc {
	    [[SingleTon sharedInstance] doEndProcess:self];
	}

<br>

**[建议] dealloc 方法应该放在实现文件内所有方法的最上面。**

解释：

并且刚好在 @synthesize 和 @dynamic 语句的后面。在任何类中，init 都应该直接放在 dealloc 方法的下面。

示例：

	// good
	@implementation People
	@synthesize name = _name;
	
	- (void)dealloc {
	}
	
	- (instancetype)init {
	    self = [super init];
	    if (self) {
	    }
	    return self;
	}
	
	- (void)doProcess {
	}
	@end
	
	// bad
	@implementation People
	@synthesize name = _name;
	
	- (void)doProcess {
	}
	- (instancetype)init {
	    self = [super init];
	    if (self) {
	    }
	    return self;
	}
	- (void)dealloc {
	}
	@end


<br>

## 4.4 UIView 规范

**[强制] 禁止在 UIViewController 初始化内调用 self.view。**

解释：

由于 self.view 的调用，会导致 vc 调用 loadView、viewDidLoad，可能导致 vc 的生命周期错乱。
<br>

**[强制] 禁止对同一个视图同时进行 Frame 和 Autolayout 的混合布局。**

示例：


	// good
	self.bgView = ({
	    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
	    [self.view addSubview:view];
	    
	    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
	    NSDictionary *viewDic = [[NSDictionary alloc]initWithObjectsAndKeys:self.view, @"vSuper", view, @"bgView", nil];
	    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-100-[bgView]-100-|" options:0 metrics:nil views:viewDic]];
	    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[bgView]-100-|" options:0 metrics:nil views:viewDic]];
	    view;
	});
	
	// bad
	self.bgView = ({
	    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	    [self.view addSubview:view];
	    
	    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
	    NSDictionary *viewDic = [[NSDictionary alloc]initWithObjectsAndKeys:self.view, @"vSuper", view, @"bgView", nil];
	    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-100-[bgView]-100-|" options:0 metrics:nil views:viewDic]];
	    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[bgView]-100-|" options:0 metrics:nil views:viewDic]];
	    view;
	});

<br>


**[建议] 使用赋值复合语句（语句块）对视图属性或者视图成员变量赋值。**

示例：


	// good
	UIView *preView = ({
	    UIView *preView = [[UIView alloc] initWithFrame:CGRectZero];
	    preView.backgroundColor = [UIColor greenColor];
	    // ..config
	    [self.view addSubView:preView];
	    preView;
	});
	
	// bad
	UIView *preView = [[UIView alloc] initWithFrame:CGRectZero];
	preView.backgroundColor = [UIColor greenColor];
	// ..config
	[self.view addSubView:preView];
	self.preView = preView;

<br>


**[建议] 切换布局方式时注意视图的属性值 translatesAutoresizingMaskIntoConstraints 的正确性。** 

示例：


	// good
	self.bgView = [[UIView alloc]initWithFrame:CGRectZero];
	self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.bgView];
	NSDictionary *viewDic = [[NSDictionary alloc]initWithObjectsAndKeys:self.view, @"vSuper", self.bgView, @"bgView", nil];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-100-[bgView]-100-|" options:0 metrics:nil views:viewDic]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[bgView]-100-|" options:0 metrics:nil views:viewDic]];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
	    self.bgView.translatesAutoresizingMaskIntoConstraints = YES; // point
	    CGRect originFrame = self.bgView.frame;
	    originFrame.origin.y += 50.0f;
	    [UIView animateWithDuration:0.35f animations:^{
	        self.bgView.frame = originFrame;
	    }];
	});
	
	// bad
	self.bgView = [[UIView alloc]initWithFrame:CGRectZero];
	self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.bgView];
	NSDictionary *viewDic = [[NSDictionary alloc]initWithObjectsAndKeys:self.view, @"vSuper", self.bgView, @"bgView", nil];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-100-[bgView]-100-|" options:0 metrics:nil views:viewDic]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[bgView]-100-|" options:0 metrics:nil views:viewDic]];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
	    // self.bgView.translatesAutoresizingMaskIntoConstraints = YES; // point
	    CGRect originFrame = self.bgView.frame;
	    originFrame.origin.y += 50.0f;
	    [UIView animateWithDuration:0.35f animations:^{
	        self.bgView.frame = originFrame;
	    }];
	});


<br>

## 4.5 绘制规范

**[建议] 大量文本的排版计算并绘制放到后台线程进行。**

解释：

根据量的大小以下方法会不同程度的损耗性能：

	 [NSAttributedString boundingRectWithSize:options:context:] 
	 [NSAttributedString drawWithRect:options:context:] 

<br>

**[建议] 图片的解码放到后台线程进行。**

示例：

	// good
	- (void)display {
	    dispatch_async(backgroundQueue, ^{
	        CGContextRef ctx = CGBitmapContextCreate(...);
	        CGImageRef img = CGBitmapContextCreateImage(ctx);
	        CFRelease(ctx);
	        dispatch_async(mainQueue, ^{
	            layer.contents = img;
	        });
	    });
	}
	
	// bad
	- (void)display {
	    CGContextRef ctx = CGBitmapContextCreate(...);
		CGImageRef img = CGBitmapContextCreateImage(ctx);
		CFRelease(ctx);
		dispatch_async(mainQueue, ^{
			layer.contents = img;
		});
	}

<br>

**[建议] 减少 Border、Blended、圆角、阴影、遮罩的计算和绘制。**

解释：

会大大增加 GPU 和 CPU 的计算压力。
<br>

## 4.6 UIWindow 规范


**[强制] iOS9 启动 AppDelegate 的 window 属性必须有一个 rootViewController。**
<br>


**[建议] UIWindow 不用添加到父视图。**

解释：

默认情况新建的高 Level 的 Window 会自动添加到最顶层，并且被设置为keyWindow。

注：keyWindow 是指定的用来接收键盘以及非触摸类的消息，而且程序中每一个时刻只能有一个 window 是 keyWindow。
<br>



## 4.7 动画规范


**[强制] 视图的动画必须在所在视图控制器的 viewDidAppear: 执行之后。**

解释：

特别是使用 Autolayout 实现的动画，否则动画会不执行，或者不按照预期执行动画。
<br>

**[强制] Autolayout 动画设置 layoutIfNeeded 必须是 NSLayoutConstraint 相关视图的最近的父视图。** 

解释：

比如 NSLayoutConstraint 约定了 View1 和 View2 的相关关系，View1的父视图是 ViewS1, View2 的父视图是 ViewS2，包含 ViewS1 和 ViewS2 的父视图是 ViewSuper （可能是ViewS1、ViewS2），那么执行动画时必须设定 [ViewSuper layoutIfNeeded];

示例：


	// leftMarginCons 初始值为0.0f
	// .firstItem = View1;.secondItem = View2
	
	// good
	NSLayoutConstraint *leftMarginCons;
	leftMarginCons.constant = 10.0f;
	[UIView animateWithDuration:0.35f animations:^{
	    [ViewSuper layoutIfNeeded];
	}];
	
	// bad
	NSLayoutConstraint *leftMarginCons;
	leftMarginCons.constant = 10.0f;
	[UIView animateWithDuration:0.35f animations:^{
	    [View1 layoutIfNeeded];
	}];

<br>


## 4.8 单例实现规范


**[强制] 单例的创建使用“dispatch_once() ”。**  

解释：

单例的创建首先需要达到线程安全，dispatch_once()的优点是，速度快，而且语法上更干净，并且保证线程安全。 

示例：

	// good
	+ (instancetype)sharedInstance
	{
	   static id sharedInstance = nil;
	   static dispatch_once_t onceToken = 0;
	   dispatch_once(&onceToken, ^{
	      sharedInstance = [[self alloc] init];
	   });
	   return sharedInstance;
	}
	
	// bad
	+ (instancetype)sharedInstance
	{
	    static id sharedInstance;
	    @synchronized(self) {
	        if (sharedInstance == nil) {
	            sharedInstance = [[MyClass alloc] init];
	        }
	    }
	    return sharedInstance;
	}

<br>

**[建议] 避免一个单例类创建出非单例对象。**

解释：

覆写单例类的对象初始化方法，比如：allocWithZone: 、copyWithZone: 。

示例：
	
	// good
	static Singleton *slt = nil;
	
	+ (instancetype)sharedInstance{
	   static dispatch_once_t onceToken;
	   dispatch_once(&onceToken, ^{
	       slt = [[self alloc]init];
	   });
	   return slt;
	}
	
	+ (instancetype)allocWithZone:(struct _NSZone *)zone
	{
	   static dispatch_once_t onceToken;
	   dispatch_once(&onceToken, ^{
	       slt = [super allocWithZone:zone];
	      
	   });
	   return slt;
	}
	
	- (id)copyWithZone:(NSZone *)zone
	{
	   return slt;
	}

**[建议] 请慎重使用单例，避免产生不必要的常驻内存。**  

解释：

我们不仅应该知道单例的特点和优势，也必须要弄明白单例适合的场景。UIApplication、access database 、request network 、access userInfo这类全局仅存在一份的对象或者需要多线程访问的对象，可以使用单例。不要仅仅为了访问方便就使用单例，很多情况可以使用依赖注入代替。
<br>

**[建议] 单例初始化方法中尽量保证单一职责,尤其不要进行其他单例的调用，极端情况下，两个单例对象在各自的单例初始化方法中调用，会造成死锁。**  
<br>


## 4.9 懒加载规范


**[强制] 不要滥用懒加载，只对那些真正需要懒加载的对象采用懒加载。** 
<br>


**[建议] 懒加载中不应该有其他的不必要的逻辑性的代码。** 

解释：

懒加载本质上就是延迟初始化某个对象，懒加载仅仅是初始化一个对象，然后对这个对象的属性赋值，所以不应该有其他的不必要的逻辑性的代码，如果有，请把那些逻辑性代码放到合适的地方。

示例：

	// good
	- (UIView *)layerView {
	    if (!_layerView) {
	        _layerView = [UIView new];
	    }
	    return _layerView;
	}
	
	// bad
	- (UIView *)layerView {
	    if (!_layerView) {
	        _layerView = [UIView new];
	        [self sendParamter:_layerView];
	    }
	    return _layerView;
	}

<br>



## 4.10 延迟调用规范

**[强制] performSelector:withObject:afterDelay: 要在有 Runloop 的线程里调用，否则调用无法生效。**

解释：

异步线程默认是没有runloop的，除非手动创建；而主线程是系统会自动创建Runloop的。所以在异步线程调用是请先确保该线程是有Runloop的。
<br>

**[建议] 推荐使用 GCD 的 dispatch_after 实现延迟调用。**

解释：

- 效率更高
- 计时更准确
- 避免循环引用
- 代码简洁逻辑清晰
<br>

## 4.11 Nullablility 规范

**[建议] 对于 oc 对象属性定义，使用 nullable、nonnull 关键字修饰。**

示例:

	// good
	@property (nonatomic, copy, nonnull) NSString *bookName;
	@property (nonatomic, strong, nullable) NSArray *pages;
	

<br>

**[建议] 对于有返回值的方法，方法返回值前面需要加 nullable、nonnull 关键字修饰，方法参数前也需要。**

示例:

// good
+ (nullable NSString *)bookWithName:(nonnull NSString *)name;

<br>

**[建议] 在.h文件前加入 NS_ASSUME_NONNULL_BEGIN，在文件尾部加入NS_ASSUME_NONNULL_END。**

示例:

	// good
	NS_ASSUME_NONNULL_BEGIN
	@interface Book : NSObject
	@property (nonatomic, copy, nullable) NSString *bookName;
	@property (nonatomic, strong, nullable) NSArray *pages;
	+ (nullable NSString *)bookWithName:(nonnull NSString *)name;
	@end
	NS_ASSUME_NONNULL_END
	
<br>


## 4.12 异常处理规范

**[强制] 禁止在 Release 版本内开启断言。**
<br>

**[建议] 不要对外部不可靠的数据（用户输入，文件，网络读取等等）使用断言。**

示例：


	// good
	- (void)pushViewController:(UIViewController *)pushVC {
	    NSAssert(pushVC != nil, @"can't push a nil vc!");
	    ..
	}
	
	// bad
	- (void)loadFileData {
	    NSString *filePath;
	    NSData *serverData = [NSData dataWithContentsOfFile:filePath];
	    NSAssert(serverData.length > 0, @"Read data file error!");
	}

<br>

**[建议] 对可能出现异常的代码段需要做异常处理。**

示例：


	// good
	@try {
	    // 可能会出现异常/崩溃的代码
	} @catch (NSException *exception) {
	    // 捕获到的异常exception
	} @finally {
	    // 结果处理
	}

<br>

**[建议] 对未捕获的异常进行统一处理 （比如 NSSetUncaughtExceptionHandler）。**

示例：


	// good
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
	    return YES;
	}
	    
	void uncaughtExceptionHandler(NSException *exception) {
	    ..
	}
	

<br>

## 4.13 self 使用

**[强制]  解决由 self 造成的编译器警告。**  

解释：

self 造成的警告一般都是严重的，需要特别注意，比如在实例方法内以 self 调用了类方法造成警告，尽管在同一个类里面的使用 self ，但是 self 却指向不同的地址。
<br>

**[建议] 注意 block 内的 self ，是否造成循环引用。**  
<br>


# 5 工具支持

-------

[强制] 使用 AppStore 下载的 Xcode 作为 IDE 工具。  

## 5.1 注释工具

安装及使用说明
http://agroup.baidu.com/mobilebaidu/md/article/1045732

简单安装方法：
curl -o- http://hz01-wise-mspreview-da.hz01.baidu.com:8888/file/shellscript/BDXcodeExt/bdext_install.sh | sudo bash



## 5.2 Xcode 格式化工具插件

待定

## 5.3 git hook 工具

待定
